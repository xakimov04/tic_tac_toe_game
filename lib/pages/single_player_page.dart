import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac/pages/home_page.dart';

const String player1 = 'X';
const String player2 = 'O';

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: Image.asset(
              "images/tic_tac.jpg",
              fit: BoxFit.fill,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF001C32),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_left,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              centerTitle: true,
            ),
            body: const TicTacToeGame(),
          ),
        ],
      ),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String>> _board;
  late bool _isPlayer1Turn;
  late int _moves;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _board =
          List.generate(3, (_) => List.filled(3, '')); // Initializing the board
      _isPlayer1Turn = true;
      _moves = 0;
    });
  }

  void _onTileTap(int row, int col) {
    if (_board[row][col] == '' && _moves < 9) {
      setState(() {
        _board[row][col] = _isPlayer1Turn ? player1 : player2;
        _isPlayer1Turn = !_isPlayer1Turn;
        _moves++;
      });
      _checkWinner(row, col);
    }
  }

  bool _isWinner(List<String> line, String player) {
    return line.every((element) => element == player);
  }

  bool _isDraw() {
    return _moves == 9;
  }

  bool _checkDiagonals(String player) {
    return (_board[0][0] == player &&
            _board[1][1] == player &&
            _board[2][2] == player) ||
        (_board[0][2] == player &&
            _board[1][1] == player &&
            _board[2][0] == player);
  }

  bool _checkColumns(String player) {
    for (int i = 0; i < 3; i++) {
      if (_isWinner(_board.map((row) => row[i]).toList(), player)) {
        return true;
      }
    }
    return false;
  }

  bool _checkRows(String player) {
    for (int i = 0; i < 3; i++) {
      if (_isWinner(_board[i], player)) {
        return true;
      }
    }
    return false;
  }

  void _checkWinner(int row, int col) {
    String player = _board[row][col];

    if (_checkRows(player) ||
        _checkColumns(player) ||
        _checkDiagonals(player)) {
      _showWinnerDialog(player);
    } else if (_isDraw()) {
      _showDrawDialog();
    }
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$winner wins!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
                _resetGame();
              },
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void _showDrawDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Draw!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
                _resetGame();
              },
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isPlayer1Turn ? "Player 1 => X" : "Player 2 => O",
            style: TextStyle(
                fontFamily: GoogleFonts.rubikDistressed().fontFamily,
                fontSize: 20,
                color: Colors.white),
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (j) {
                  return GestureDetector(
                    onTap: () {
                      _onTileTap(i, j);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            _board[i][j],
                            style: TextStyle(
                                fontSize: 45,
                                color: _board[i][j] == "X"
                                    ? Colors.blue
                                    : Colors.redAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
            onPressed: _resetGame,
            child: const Text(
              'Reset Game',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
