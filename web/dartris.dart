/*
  Copyright (C) 2014 Ryan Stolle <me@ryanstolle.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/

import 'dart:html';
import 'dart:math';
import 'dart:collection';

class Tetromino {
  List<List<int>> rotations = new List<List<int>>();
  final int size;
  Tetromino(this.size);
}

class ITetromino extends Tetromino {
  ITetromino() : super(4) {
    rotations.add([0,0,1,0,
                   0,0,1,0,
                   0,0,1,0,
                   0,0,1,0]);
    
    rotations.add([0,0,0,0,
                   1,1,1,1,
                   0,0,0,0,
                   0,0,0,0]);    
    
  }
}

class JTetromino extends Tetromino {
  JTetromino() : super(3) {
    
    rotations.add([2,0,0,
                   2,2,2,
                   0,0,0]);
    
    rotations.add([0,2,2,
                   0,2,0,
                   0,2,0]);    
    
    rotations.add([0,0,0,
                   2,2,2,
                   0,0,2]);    

    rotations.add([0,2,0,
                   0,2,0,
                   2,2,0]);    
    
  }
}

class LTetromino extends Tetromino {
  LTetromino() : super(3) {
    
    rotations.add([0,0,3,
                   3,3,3,
                   0,0,0]);
    
    rotations.add([0,3,0,
                   0,3,0,
                   0,3,3]);    
    
    rotations.add([0,0,0,
                   3,3,3,
                   3,0,0]);    

    rotations.add([3,3,0,
                   0,3,0,
                   0,3,0]);    
    
  }
}

class OTetromino extends Tetromino {
  OTetromino() : super(2) {
    rotations.add([4,4,
                   4,4]);    
  }
}

class STetromino extends Tetromino {
  STetromino() : super(3) {
    rotations.add([0,5,5,
                   5,5,0,
                   0,0,0]);    
    rotations.add([0,5,0,
                   0,5,5,
                   0,0,5]);    
  }
}

class TTetromino extends Tetromino {
  TTetromino() : super(3) {
    rotations.add([0,0,0,
                   6,6,6,
                   0,6,0]);    
    rotations.add([0,6,0,
                   6,6,0,
                   0,6,0]);    
    rotations.add([0,6,0,
                   6,6,6,
                   0,0,0]);    
    rotations.add([0,6,0,
                   0,6,6,
                   0,6,0]);    
  }
}
class ZTetromino extends Tetromino {
  ZTetromino() : super(3) {
    rotations.add([7,7,0,
                   0,7,7,
                   0,0,0]);    
    rotations.add([0,7,0,
                   7,7,0,
                   7,0,0]);    
  }
}


class Button {
  final int id;
  int framePressed = 0;
  int frameReleased = 0;
  double timePressed = 0.0;
  double timeReleased = 0.0;
  Button(this.id); 
  bool get down => framePressed > frameReleased; 
  bool get up => frameReleased > framePressed; 
}

class ButtonEvent {
  final int id;
  final bool down;
  final int frame;
  final double time;
  ButtonEvent(this.id, this.down, this.frame, this.time);
}

class InputDevice {
  final Map<int, Button> buttons = new Map<int, Button>();
  void processEvent(ButtonEvent event) {
    Button button = buttons[event.id];
    if(button == null) {
      button =  buttons[event.id] = new Button(event.id);
//      return;
    }
    
    if(event.down) {
      if(button.down == false) {
        button.framePressed = event.frame;
        button.timePressed = event.time;
      }
    } else {
      button.frameReleased = event.frame;
      button.timeReleased = event.time;
    }
  }
  
  bool isDown(int id) {
    Button button = buttons[id];  
    if(button == null) {
      return false;
    }
    return button.down;
  }
  
  bool isUp(int id) {
    Button button = buttons[id];  
    if(button == null) {
      return false;
    }
    return button.up;
  }
  
  bool pressed(int id) {
    Button button = buttons[id];
    if(button == null) {
      return false;
    }
    return button.framePressed == dartris.frame;
  }

  bool released(int id) {
    Button button = buttons[id];
    if(button == null) {
      return false;
    }
    return button.frameReleased == dartris.frame;
  }
}

class Keyboard extends InputDevice {
  Map<int,bool> _keys = new Map<int,bool>(); 

  void onKeyDown(KeyboardEvent e) {
    print("Key Down ${e.keyCode}");
    _keys[e.keyCode] = true;    
  }

  void onKeyUp(KeyboardEvent e) {
    print("Key Up ${e.keyCode}");
    _keys[e.keyCode] = false;    
  }

  bool isKeyDown(int keyCode) {
    return _keys[keyCode] == null ? false : _keys[keyCode]; 
  }
}

class Mouse extends InputDevice {
  static const LEFT = 0;
  static const MIDDLE = 1;
  static const RIGHT = 2;
}

class Dartris {
  static const double MOVE_SPEED = 0.075;
  static const double DROP_SPEED = 0.070;
  static const int BLOCK_SIZE = 19;
  
  static const int STATE_START = 0;
  static const int STATE_PLAYING = 1;
  static const int STATE_END = 2;
  static const int LINE_POINTS = 100;
  static const int DROP_POINTS = 2;
  static const int HORIZONTAL_BLOCK_COUNT = 10;
  static const int VERTICAL_BLOCK_COUNT = 20;
  static const int PLAYFIELD_WIDTH = HORIZONTAL_BLOCK_COUNT * BLOCK_SIZE;
  static const int PLAYFIELD_HEIGHT = VERTICAL_BLOCK_COUNT * BLOCK_SIZE;

  final CanvasElement _canvas;
  CanvasRenderingContext2D _ctx;
  Keyboard _keyboard;
  Mouse _mouse;
  Map<int,String> _colors = new  Map<int,String>();
  Random _random = new Random();
  Tetromino _tetromino;
  int _tetrominoId;
  int _tetrominoX = 5;
  int _tetrominoY = 0;
  int _tetrominoDropY = 0;
  int _tetrominoRotation = 0;
  int nextMove = 0;
  int frame = 0;
  int _state = STATE_START;
  double _nextMoveTick = 0.0;
  double _nextDownTick = 0.0;
  Queue<int> _tetrominoQueue = new Queue<int>();
  int _goal = 0;
  int _score = 0;
  int _level = 0;
  int _holdTetrominoId = 0;
  
  List<Tetromino> _tetrominoes = new List<Tetromino>();
  
  List<int> _playfield = new List<int>.generate(HORIZONTAL_BLOCK_COUNT *  VERTICAL_BLOCK_COUNT, (int index) => 0, growable:true);
  
  Dartris(this._canvas) {
    // List of tetrominoes to use
    _tetrominoes.add(new ITetromino());
    _tetrominoes.add(new JTetromino());
    _tetrominoes.add(new LTetromino());
    _tetrominoes.add(new OTetromino());
    _tetrominoes.add(new STetromino());
    _tetrominoes.add(new TTetromino());
    _tetrominoes.add(new ZTetromino());
    
    // Tetromino color index
    _colors[0] = 'black';
    _colors[1] = 'cyan';
    _colors[2] = 'blue';
    _colors[3] = 'orange';
    _colors[4] = 'yellow';
    _colors[5] = 'lime';
    _colors[6] = 'purple';
    _colors[7] = 'red';
    
    // Setup tetromino queue.
    _tetrominoQueue.add(_random.nextInt(_tetrominoes.length));
    _tetrominoQueue.add(_random.nextInt(_tetrominoes.length));
    _tetrominoQueue.add(_random.nextInt(_tetrominoes.length));
    _tetrominoQueue.add(_random.nextInt(_tetrominoes.length));
    _tetrominoQueue.add(_random.nextInt(_tetrominoes.length));
    _tetrominoQueue.add(_random.nextInt(_tetrominoes.length));
    _tetrominoQueue.add(_random.nextInt(_tetrominoes.length));
    _tetrominoQueue.add(_random.nextInt(_tetrominoes.length));
    
    _keyboard = new Keyboard();
    _mouse = new Mouse();
    
    _ctx = _canvas.context2D;
    
  }
  
  bool tetrominoBlocked(int posX, int posY, int rotIndex) {
    Tetromino tetromino = _tetrominoes[_tetrominoId];
    for(int y = 0; y < tetromino.size; y++) {
      for(int x = 0; x < tetromino.size; x++) {
        List<int> rotation = tetromino.rotations[rotIndex];
        if(rotation[y*tetromino.size + x] > 0) {
          int playPosX = posX + x; 
          int playPosY = posY + y; 
          if((playPosX >= HORIZONTAL_BLOCK_COUNT) ||
              (playPosX < 0) || 
              (playPosY >= VERTICAL_BLOCK_COUNT) || 
              (_playfield[playPosY * HORIZONTAL_BLOCK_COUNT + playPosX] >  0)) {
              return true;
          }
        }
      }
    }
    return false;
  }

  int getNextTetrominoId() {
    int tetrominoId = _tetrominoQueue.first;
   _tetrominoQueue.removeFirst();      
   _tetrominoQueue.addLast(_random.nextInt(_tetrominoes.length));      
   return tetrominoId;
  }
  
  void placeTetromino(int posX, int posY) {
    Tetromino tetromino = _tetrominoes[_tetrominoId];
    for(int y = 0; y < tetromino.size; y++) {
      for(int x = 0; x < tetromino.size; x++) {
        List<int> rotation = tetromino.rotations[_tetrominoRotation];
        int piece = rotation[y*tetromino.size + x];
        if(piece > 0) {
          _playfield[(posY + y) * HORIZONTAL_BLOCK_COUNT + (posX + x)] = piece;  
        }
      }
    }
    getNextTetromino();
  }
  void _transitionState(int state) {
    if(state == STATE_START) {
    } else if(state == STATE_PLAYING) {
      _score = 0;
      _goal = 5;
      _level = 1;
      // Clear playfield
      _playfield.fillRange(0, HORIZONTAL_BLOCK_COUNT * VERTICAL_BLOCK_COUNT, 0);
      _holdTetrominoId = null;
    } else if(state == STATE_END) {
      
    }
    _state = state;
  }
  void _processStartInput() {
    if(_mouse.pressed(Mouse.LEFT)) {
      _transitionState(STATE_PLAYING);      
    }
  }
  void _processPlayingInput() {
    int newX = _tetrominoX;
    int newY = _tetrominoY;
    int newRotation = _tetrominoRotation;
    
    if(_keyboard.pressed(KeyCode.SPACE)) {
      placeTetromino(_tetrominoX, _tetrominoDropY);
      _score += (_tetrominoDropY - _tetrominoY) * DROP_POINTS; 
      return;
    }

    if(_keyboard.pressed(KeyCode.RIGHT)) {
      _nextMoveTick = 0.0;
    }
    
    if(_keyboard.isDown(KeyCode.RIGHT)) {
      if(time > _nextMoveTick) {
        newX++;
        _nextMoveTick = time + MOVE_SPEED;
      }
    }

    if(_keyboard.pressed(KeyCode.LEFT)) {
      _nextMoveTick = 0.0;
    }
    
    if(_keyboard.isDown(KeyCode.LEFT)) {
      if(time > _nextMoveTick) {
        newX--;
        _nextMoveTick = time + MOVE_SPEED;
      }
    }

    if(_keyboard.pressed(KeyCode.DOWN)) {
      _nextMoveTick = 0.0;
    }
    
    if(_keyboard.isDown(KeyCode.DOWN)) {
      if(time > _nextMoveTick) {
        newY++;
        _nextMoveTick = time + MOVE_SPEED;
      }
    }

    if(_keyboard.pressed(KeyCode.C)) {
      if(_holdTetrominoId == null) {
        _holdTetrominoId = _tetrominoId;
        getNextTetromino();
      } else {
        int id = _tetrominoId;
        _tetrominoId = _holdTetrominoId;
        _holdTetrominoId = id;
        _tetrominoRotation = 0;
        
      }
      return;
    }

    if(_keyboard.pressed(KeyCode.Z)) {
      if(--newRotation < 0) {
        newRotation = _tetromino.rotations.length - 1;
      }
    }
    if(_keyboard.pressed(KeyCode.X) || _keyboard.pressed(KeyCode.UP)) {
      if(++newRotation >= _tetromino.rotations.length) {
        newRotation = 0;
      }
    }


    
    if(!tetrominoBlocked(newX, newY, newRotation)) {
      _tetrominoX = newX;
      if(_tetrominoY != newY) {
        _score++;        
      }
      _tetrominoY = newY;
      _tetrominoRotation = newRotation;
    }
    
  }
  void _processEndInput() {
    if(_mouse.pressed(Mouse.LEFT)) {
      _transitionState(STATE_START);      
    }
  }
  void _processInput() { 
    if(_state == STATE_START) {
      _processStartInput();      
    } else if(_state == STATE_PLAYING) {
      _processPlayingInput();      
    } else if(_state == STATE_END) {
      _processEndInput();      
    }
  }
  
  void getNextTetromino() {
    _tetrominoId = getNextTetrominoId();
    _tetromino = _tetrominoes[_tetrominoId];
    _tetrominoX = 3;
    _tetrominoY = 0;
    _tetrominoRotation = 0;
    if(tetrominoBlocked(_tetrominoX, _tetrominoY, _tetrominoRotation)) {
      _transitionState(STATE_END);      
    }
  }
  
  void checkLines(){
    int lineCount = 0;    
    for(int y = 0; y < VERTICAL_BLOCK_COUNT; y++) {
      bool lineComplete = true;
      for(int x = 0; x < HORIZONTAL_BLOCK_COUNT; x++) {
        int colorId = _playfield[y*HORIZONTAL_BLOCK_COUNT + x];
        if( colorId == 0) {
          lineComplete = false;
          break;  
        }
      }
      if(lineComplete) {
        //_playfield.fillRange(y*HORIZONTAL_BLOCK_COUNT, y*HORIZONTAL_BLOCK_COUNT + HORIZONTAL_BLOCK_COUNT, 0);
        List<int> shift = _playfield.sublist(0, y*HORIZONTAL_BLOCK_COUNT);
        _playfield.replaceRange(HORIZONTAL_BLOCK_COUNT, HORIZONTAL_BLOCK_COUNT+shift.length, shift);
        lineCount++;
      }
    }
    _score += lineCount * LINE_POINTS;
    _goal -= lineCount;
    if(_goal < 1) {
      _level++;
      _goal += (_level * 5);
    }
  }

  void _update() {
    if(_state == STATE_PLAYING) {
      int newY = _tetrominoY;
      if(time > _nextDownTick) {
        _nextDownTick = time + 1.0;      
        newY++;
      }
      
      if(tetrominoBlocked(_tetrominoX, newY, _tetrominoRotation)) {
        placeTetromino(_tetrominoX, _tetrominoY);
      } else {
        _tetrominoY = newY;
      }
      
      // Find the tetromino drop Y position
      _tetrominoDropY = _tetrominoY;
      for(int y = _tetrominoY; y < VERTICAL_BLOCK_COUNT; y++) {
        if(tetrominoBlocked(_tetrominoX, y, _tetrominoRotation)) {        
          break;        
        }
        _tetrominoDropY = y;
      }
      checkLines();
    }
    
  }
  void drawRoundedRect(int x, int y, int w, int h, int radius) {
    int r = x + w;
    int b = y + h;
    _ctx.beginPath();
    _ctx.lineWidth = 1;
    _ctx.moveTo(x+radius, y);
    _ctx.lineTo(r-radius, y);
    _ctx.quadraticCurveTo(x+w,  y, x+w, y+radius);
    _ctx.lineTo(r, b-radius);
    _ctx.quadraticCurveTo(r,  b, r-radius, b);
    _ctx.lineTo(x+radius, b);
    _ctx.quadraticCurveTo(x,  b, x, b-radius);
    _ctx.lineTo(x, y+radius);
    _ctx.quadraticCurveTo(x, y, x+radius, y);
    _ctx.fill();
    _ctx.stroke();
  }
  void drawRect(int x, int y, int width, int height, String fillColor, String strokeColor) {
    _ctx.fillStyle = fillColor;
    _ctx.beginPath();
    _ctx.rect(x, y, width, height);
    _ctx.closePath();
    _ctx.fill();
    _ctx.lineWidth = 1;
    _ctx.strokeStyle = strokeColor;
    _ctx.stroke();
  }
  
  void drawTetromino(int posX, int posY, int tetrominoId, int rotation, {String fillColor:null, String strokeColor:null}) {
    Tetromino tetromino = _tetrominoes[tetrominoId]; 
    for(int y = 0; y < tetromino.size; y++) {
      for(int x = 0; x < tetromino.size; x++) {
        List<int> data = tetromino.rotations[rotation];
        int colorId = data[y*tetromino.size + x];
        if(colorId > 0) {
          drawRect(
              posX + (x * BLOCK_SIZE), 
              posY + ( y * BLOCK_SIZE), 
              BLOCK_SIZE, BLOCK_SIZE, 
              fillColor == null ? _colors[colorId] : fillColor, 
              strokeColor == null ? 'black' : strokeColor);
        }
      }
    }
    
  }
  void drawCenteredTetromino(int x, int y, int tetrominoId, int rotation,{String fillColor:null, String strokeColor:null}) {
    Tetromino tetromino = _tetrominoes[tetrominoId];
    int minX;
    int maxX;
    int minY;
    int maxY;
    int centerX; 
    int centerY;
    
    List<int> data = tetromino.rotations[rotation];
    for(int y = 0; y < tetromino.size; y++) {
      for(int x = 0; x < tetromino.size; x++) {
        if(data[y*tetromino.size + x] > 0) {    
          if(minX == null) {
            minX = x;
          } else {
            minX = min(minX, x);
          }
          
          if(maxX == null) {
            maxX = x;
          } else {
            maxX = max(maxX, x);
          }
          
          if(minY == null) {
            minY = y;
          } else {
            minY = min(minY, y);
          }

          if(maxY == null) {
            maxY = y;
          } else {
            maxY = max(maxY, y);
          }
        }
      }
    }
    centerX = (minX * BLOCK_SIZE) + ((((maxX - minX) + 1) * BLOCK_SIZE) ~/ 2);
    centerY = (minY * BLOCK_SIZE) + ((((maxY - minY) + 1) * BLOCK_SIZE) ~/ 2);
    drawTetromino(x - centerX, y - centerY, tetrominoId, rotation, fillColor:fillColor, strokeColor:strokeColor);
    return;
  }

  void drawButton(int x, int y, int width, int height, String text, int size) {
    
  }
  void drawWhiteText(int x, int y, String text, int size) {
    drawText(x, y, text, size, '#FFFFFF', '#7c8fab', '#0f2235');    
  }
  
  void drawYellowText(int x, int y, String text, int size) {
    drawText(x, y, text, size, '#FFFF00', '#b8b130', '#0f2235');    
  }
  
  void drawText(int x, int y, String text, int size, String color1, String color2, String color3) {
    _ctx.save();
    _ctx.font = '${size}px Knewave';
//    _ctx.strokeStyle = color1;
    //_ctx.lineWidth = 5;
    TextMetrics tm = _ctx.measureText(text);
    num centerX = x - (tm.width / 2);
    _ctx.lineJoin = 'circle';
    _ctx.miterLimit = 2;
    _ctx.strokeStyle = color3;
    _ctx.lineWidth = 15;
    _ctx.strokeText(text, centerX, y);

    _ctx.strokeStyle = color2;
    _ctx.lineWidth = 5;
    _ctx.strokeText(text, centerX, y);

    _ctx.fillStyle = color1;
    _ctx.fillText(text, centerX, y);

    _ctx.restore();

  }

  static double timeStampToSeconds(timeStamp) => timeStamp / 1000.0;
  double get time => timeStampToSeconds(
        new DateTime.now().millisecondsSinceEpoch);
  
  void _render() {
    Tetromino tetromino = _tetrominoes[_tetrominoId];

    CanvasGradient grad= _ctx.createRadialGradient(0, 0, 5, 90, _canvas.width, _canvas.height);
    
    grad.addColorStop(0, 'white');
    grad.addColorStop(1, 'white');
    _ctx.fillStyle = 'gray';
    _ctx.fillRect(0, 0, _canvas.width, _canvas.height);

    _ctx.save();

    _ctx.translate(_canvas.width/2,10);
    drawText(0,60,'DARTRIS',35,'#FF0000', '#AA0000', '#000000');
    
    _ctx.restore();
    
    
    // Draw playfield
    _ctx.save();
    _ctx.translate(100,120);
    _ctx.strokeStyle = '#0f2235';
    _ctx.fillStyle = '#0f2235'; 
    drawRoundedRect(0, 0, PLAYFIELD_WIDTH+80, PLAYFIELD_HEIGHT+70, 10);
    
    _ctx.translate(5,5);
    _ctx.strokeStyle = '#ffffff';
    _ctx.fillStyle = '#ffffff'; 
    drawRoundedRect(0, 0, PLAYFIELD_WIDTH+70, PLAYFIELD_HEIGHT+60, 8);

    _ctx.translate(5,5);
    _ctx.strokeStyle = '#7c8fab';
    _ctx.fillStyle = '#7c8fab'; 
    drawRoundedRect(0, 0, PLAYFIELD_WIDTH+60, PLAYFIELD_HEIGHT+50, 6);

    _ctx.translate(25,25);
    _ctx.strokeStyle = '#0f2235';
    _ctx.fillStyle = '#0f2235'; 
    drawRoundedRect(0, 0, PLAYFIELD_WIDTH+10, PLAYFIELD_HEIGHT+10, 4);
    
    _ctx.translate(5,5);

    _ctx.fillStyle = 'black';
    _ctx.fillRect(0, 0, HORIZONTAL_BLOCK_COUNT * BLOCK_SIZE, VERTICAL_BLOCK_COUNT * BLOCK_SIZE);

    for(int y = 0; y < VERTICAL_BLOCK_COUNT; y++) {
      for(int x = 0; x < HORIZONTAL_BLOCK_COUNT; x++) {
        int colorId = _playfield[y*HORIZONTAL_BLOCK_COUNT + x];
        if( colorId > 0) {
          drawRect(x*BLOCK_SIZE, y*BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE, _colors[colorId], 'black');
        } else {
          _ctx.strokeStyle = 'rgb(35,35,35)';
          _ctx.fillStyle = 'rgb(35,35,35)'; 
          drawRoundedRect((x*BLOCK_SIZE)+2, (y*BLOCK_SIZE)+2, BLOCK_SIZE-4, BLOCK_SIZE-4, 3);
        }
      }
    }
    
    if(_state == STATE_PLAYING) {
      //Draw drop helper
      drawTetromino(_tetrominoX * BLOCK_SIZE, _tetrominoDropY * BLOCK_SIZE,_tetrominoId, _tetrominoRotation, fillColor:'rgb(35,35,35)', strokeColor:'white');


      //Draw tetromino    
      drawTetromino(_tetrominoX * BLOCK_SIZE, _tetrominoY * BLOCK_SIZE, _tetrominoId, _tetrominoRotation);
    }
    
    _ctx.restore();
    
    if(_state == STATE_PLAYING || _state == STATE_END) {
      // Draw Score
      _ctx.save();
      _ctx.translate(_canvas.width/2,10);
      drawYellowText(0,120,_score.toString(),35);
      _ctx.restore();
    }

    // Draw Hold box
    _ctx.save();
    _ctx.translate(5,160);
    _ctx.strokeStyle = '#0f2235';
    _ctx.fillStyle = '#0f2235'; 
    drawRoundedRect(0, 0, 120, 120, 10);
    
    _ctx.translate(5,5);
    _ctx.strokeStyle = '#7c8fab';
    _ctx.fillStyle = '#7c8fab'; 
    drawRoundedRect(0, 0, 110, 110, 8);

    _ctx.translate(5,5);
    _ctx.strokeStyle = '#ffffff';
    _ctx.fillStyle = '#ffffff'; 
    drawRoundedRect(0, 0,  100, 100, 6);

    _ctx.translate(5,5);
    _ctx.strokeStyle = '#000000';
    _ctx.fillStyle = '#000000'; 
    drawRoundedRect(0, 0, 90, 90, 4);
    _ctx.restore();    

    drawWhiteText(70,160,'HOLD',35);

    //Draw hold tetromino
    if(_holdTetrominoId != null && _state == STATE_PLAYING) {
      drawCenteredTetromino(65, 220, _holdTetrominoId, 0);
    }

    // Draw Next box
    _ctx.save();
    _ctx.translate(345,160);
    _ctx.strokeStyle = '#0f2235';
    _ctx.fillStyle = '#0f2235'; 
    drawRoundedRect(0, 0, 120, 400, 10);
    
    _ctx.translate(5,5);
    _ctx.strokeStyle = '#7c8fab';
    _ctx.fillStyle = '#7c8fab'; 
    drawRoundedRect(0, 0, 110, 390, 8);

    _ctx.translate(5,5);
    _ctx.strokeStyle = '#ffffff';
    _ctx.fillStyle = '#ffffff'; 
    drawRoundedRect(0, 0,  100, 100, 6);

    _ctx.translate(5,5);
    _ctx.strokeStyle = '#000000';
    _ctx.fillStyle = '#000000'; 
    drawRoundedRect(0, 0, 90, 90, 4);

    _ctx.translate(-5,105);
    _ctx.strokeStyle = '#ffffff';
    _ctx.fillStyle = '#ffffff'; 
    drawRoundedRect(0, 0,  100, 270, 6);

    _ctx.translate(5,5);
    _ctx.strokeStyle = '#000000';
    _ctx.fillStyle = '#000000'; 
    drawRoundedRect(0, 0, 90, 260, 4);
    
   
    _ctx.restore();
    
    if(_state == STATE_PLAYING) {
      // Draw Next Tetrominos
      drawCenteredTetromino(405, 220, _tetrominoQueue.elementAt(0), 0);

      _ctx.save();
      _ctx.translate(405, 330);
      for(int i=1; i<4; i++) {
        int id = _tetrominoQueue.elementAt(i);
        drawCenteredTetromino(0, 0, id, 0);
        _ctx.translate(0, 85 );
      }
      _ctx.restore();
    }

    drawWhiteText(405,160,'NEXT',35);

    drawWhiteText(80,350,'LEVEL',35);
    if(_state == STATE_PLAYING) {
      drawYellowText(80, 405, _level.toString(), 45);
    }
    
    drawWhiteText(80,470,'GOAL',35);
    if(_state == STATE_PLAYING) {
      drawYellowText(80, 525, _goal.toString(), 45);
    }
    
    if(_state == STATE_START) {
      // Draw Start button
      _ctx.save();
      _ctx.translate((_canvas.width - 100)*0.5, 300);
      /*
      _ctx.lineJoin = "round";
      _ctx.lineWidth = 50;

      _ctx.fillStyle = 'black';
      _ctx.strokeStyle = 'black';
      _ctx.beginPath();
      _ctx.moveTo(0, 0);
      _ctx.lineTo(100, 0);
      _ctx.lineTo(100, 25);
      _ctx.lineTo(0, 25);
      _ctx.closePath();
      _ctx.stroke();
      _ctx.fill();

      _ctx.lineWidth = 40;
      _ctx.fillStyle = 'yellow';
      _ctx.strokeStyle = 'yellow';
      _ctx.beginPath();
      _ctx.moveTo(0, 0);
      _ctx.lineTo(100, 0);
      _ctx.lineTo(100, 25);
      _ctx.lineTo(0, 25);
      _ctx.closePath();
      _ctx.stroke();
      _ctx.fill();

      _ctx.lineWidth = 30;
      _ctx.fillStyle = '#000';
      _ctx.strokeStyle = '#000';
      _ctx.beginPath();
      _ctx.moveTo(0, 0);
      _ctx.lineTo(100, 0);
      _ctx.lineTo(100, 25);
      _ctx.lineTo(0, 25);
      _ctx.closePath();
      _ctx.stroke();
      _ctx.fill();
*/
      drawYellowText(50,25,'CLICK TO START',35);
      
      _ctx.restore();
    }

    if(_state == STATE_END) {
      _ctx.save();
      _ctx.translate((_canvas.width - 100)*0.5, 300);
      drawYellowText(50,25,'GAME OVER',35);
      drawYellowText(50,75,'CLICK TO CONTINUE',15);
      _ctx.restore();
    }
    
    // Draw Controls
    _ctx.save();
    _ctx.translate(70, 590);
    _ctx.font = '15px Knewave';
    _ctx.lineJoin = 'circle';
    _ctx.miterLimit = 2;
    _ctx.fillStyle  = '#000';
    _ctx.fillText('MOVE LEFT = LEFT ARROW',0,0);
    _ctx.translate(0, 20);
    _ctx.fillText('MOVE LEFT = RIGHT ARROW',0,0);
    _ctx.translate(0, 20);
    _ctx.fillText('MOVE DOWN = DOWN ARROW',0,0);
    _ctx.translate(220, -40);
    _ctx.fillText('ROTATE LEFT = Z',0,0);
    _ctx.translate(0, 20);
    _ctx.fillText('ROTATE RIGHT = X',0,0);
    _ctx.translate(0, 20);
    _ctx.fillText('DROP = SPACEBAR',0,0);
    _ctx.translate(-65, 20);
    _ctx.fillText('HOLD = C',0,0);
     _ctx.restore();
  }

  void _requestAnimationFrame(num _) {
    window.requestAnimationFrame(_requestAnimationFrame);
    _processInput();
    _update();
    _render();
    frame++;
  }
  void run() {
    window.onKeyDown.listen((KeyboardEvent e){
      _keyboard.processEvent(new ButtonEvent(e.keyCode, true, this.frame, e.timeStamp / 1000.0));
    });
    window.onKeyUp.listen((KeyboardEvent e){
      _keyboard.processEvent(new ButtonEvent(e.keyCode, false, this.frame, e.timeStamp / 1000.0));
    });
    _canvas.width = ((HORIZONTAL_BLOCK_COUNT * BLOCK_SIZE) * 2.50).toInt(); 
    _canvas.height = ((VERTICAL_BLOCK_COUNT * BLOCK_SIZE) * 1.75).toInt(); 

    _canvas.onMouseDown.listen((MouseEvent e){
      _mouse.processEvent(new ButtonEvent(e.button, true, this.frame, e.timeStamp / 1000.0));      
    });
    _canvas.onMouseUp.listen((MouseEvent e){
      _mouse.processEvent(new ButtonEvent(e.button, false, this.frame, e.timeStamp / 1000.0));      
    });
    
    getNextTetromino();
    window.requestAnimationFrame(_requestAnimationFrame);
  }
}
Dartris dartris;

void main() {
  Element e = querySelector("#playfield");
  dartris = new Dartris(e);
  dartris.run();
}

