import Foundation

class SnakesAndLadders {
    let boardSize: Int
    var snakes: [Int: Int] = [:]
    var ladders: [Int: Int] = [:]
    var players: [String]
    var playerPositions: [String: Int] = [:]
    var currentPlayerIndex = 0
    let NumberofSnakes = Int.random(in: 1...8)
    let NumberofLadders = Int.random(in: 1...8)
    
    init(playerNames: [String]) {
        self.players = playerNames
        self.boardSize = 25
        initializeGame()
    }
    
    private func initializeGame() {
        
        generateSnakesAndLadders()
        
       
        for player in players {
            playerPositions[player] = 0
        }
    }
    
    private func generateSnakesAndLadders() {

        for _ in (1...NumberofLadders) {
            var start = 0
            var end = 0
            repeat {
                start = Int.random(in: 1...boardSize-2)
                end = Int.random(in: start+1...boardSize-1)
            } while snakes[start] != nil && ladders[start] != nil && snakes[end] != nil || ladders[end] != nil
            
            ladders[start] = end
        }
        
       
        for _ in 1...NumberofSnakes {
            var head = 0
            var tail = 0
            repeat {
                head = Int.random(in: 1...boardSize-1)
                tail = Int.random(in: 0...head-1)
            } while snakes[head] != nil && ladders[head] != nil && snakes[tail] != nil || ladders[tail] != nil
            
            snakes[head] = tail
        }
    }
    
    private func rollDice() -> Int {
        return Int.random(in: 1...6)
    }
    
    private func movePlayer(_ player: String, steps: Int) {
        guard var currentPosition = playerPositions[player] else { return }
        
        let newPosition = currentPosition + steps
        
        if newPosition <= boardSize {
            currentPosition = newPosition
            
           
            if let ladderEnd = ladders[currentPosition] {
                print(" \(player) нашел лестницу! Поднимается с \(currentPosition) на \(ladderEnd)")
                currentPosition = ladderEnd
            }
          
            else if let snakeTail = snakes[currentPosition] {
                print(" \(player) попал на змею! Спускается с \(currentPosition) на \(snakeTail)")
                currentPosition = snakeTail
            }
            
            playerPositions[player] = currentPosition
        }
    }
    
    private func printBoard() {
        print("\nТЕКУЩИЕ ПОЗИЦИИ")
        for player in players {
            let position = playerPositions[player]!
            print("\(player): клетка \(position)")
        }
        print("\n")
    }
    
    private func printSnakesAndLadders() {
        print("\nЛЕСТНИЦЫ")
        for (start, end) in ladders {
            print("\(start) переместился в \(end)")
        }
        
        print("\nЗМЕИ")
        for (head, tail) in snakes {
            print("\(head) переместился в \(tail)")
        }
        print()
    }
    
    func startGame() {
        print("Добро пожаловать в игру")
        print("Игроки: \(players.joined(separator: ", "))")
        printSnakesAndLadders()
        
        while true {
            let currentPlayer = players[currentPlayerIndex]
            print("Ходит игрок: \(currentPlayer)")
            
            print("Нажмите Enter чтобы бросить кубик...", terminator: "")
            _ = readLine()
            
            let diceRoll = rollDice()
            print(" \(currentPlayer) выбросил(а): \(diceRoll)")
            
            movePlayer(currentPlayer, steps: diceRoll)
            printBoard()
            
          
            if playerPositions[currentPlayer] == boardSize {
                print(" ПОЗДРАВЛЯЕМ! \(currentPlayer) выиграл(а) игру!")
                break
            }
            
           
            currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        }
    }
}

func setupGame() {
    print("Введите количество игроков (2-6):")
    
    guard let input = readLine(), let playerCount = Int(input),
          playerCount >= 2 && playerCount <= 6 else {
        print("Некорректное количество игроков!")
        return
    }
    
    var playerNames: [String] = []
    for i in 1...playerCount {
        print("Введите имя игрока \(i):")
        if let name = readLine(), !name.isEmpty {
            playerNames.append(name)
        } else {
            playerNames.append("Игрок \(i)")
        }
    }
    
    let game = SnakesAndLadders(playerNames: playerNames)
    game.startGame()
}

setupGame()


