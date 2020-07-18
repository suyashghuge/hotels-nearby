// import 'package:flutter/material.dart';
// import 'package:location/location.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Nearby Hotels',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Hotels Nearby'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Location location = new Location();

//   Map<String, double> userLocation;

//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _getLocation().then((value) {
//         setState(() {
//           userLocation = value;
//         });
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Container(
//           child: Row(
//         children: <Widget>[
//           Text(
//             userLocation["latitude"].toString() +
//                 " " +
//                 userLocation["longitude"].toString(),
//           )
//         ],
//       )),
//     );
//   }

//   Future<Map<String, double>> _getLocation() async {
//     var currentLocation = <String, double>{};
//     try {
//       currentLocation = await location.getLocation();
//     } catch (e) {
//       currentLocation = null;
//     }
//     return currentLocation;
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Position _currentPosition;

//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _getCurrentLocation();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Location"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_currentPosition != null)
//               Text(
//                   "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"),
//             FlatButton(
//               child: Text("Get location"),
//               onPressed: () {
//                 // _getCurrentLocation();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _getCurrentLocation() {
//     final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

//     geolocator
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//         .then((Position position) {
//       setState(() {
//         _currentPosition = position;
//       });
//     }).catchError((e) {
//       print(e);
//     });
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Geolocation',
      home: GeolocationExample(),
    );
  }
}

class GeolocationExampleState extends State {
  Geolocator _geolocator;
  Position _position;

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  @override
  void initState() {
    super.initState();

    _geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    checkPermission();
    //    updateLocation();

    StreamSubscription positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      _position = position;
    });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));

      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: Center(
          child: Text(
              'Latitude: ${_position != null ? _position.latitude.toString() : '0'},'
              ' Longitude: ${_position != null ? _position.longitude.toString() : '0'}')),
    );
  }
}

class GeolocationExample extends StatefulWidget {
  @override
  GeolocationExampleState createState() => new GeolocationExampleState();
}
