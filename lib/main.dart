import 'dart:convert'; // Import yang berfungsi untuk mengonversi data JSON ke dart.
import 'package:flutter/material.dart'; // Import yang berfungsi untuk membangun interface pengguna.
import 'package:http/http.dart'
    as http; // Import library http dari package http untuk menjalankan permintaan HTTP.

void main() {
  runApp(
      MyApp()); // Fungsi void main yang digunakan untuk menjalankan aplikasi Flutter.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Universitas Indonesia', // Menampilkan judul dari aplikasi.

      home:
          UniversityList(), // Tampilan awal aplikasi yang berfungsi dalam menampilkan daftar universitas.
    );
  }
}

class UniversityList extends StatefulWidget {
  @override
  _UniversityListState createState() =>
      _UniversityListState(); // Membuat stateful widget yang bernama UniversityList.
}

class _UniversityListState extends State<UniversityList> {
  List _universities =
      []; // Membuat list untuk menampung daftar data universitas.
  bool _isLoading = false; // Membuat variabel untuk menampilkan status loading.
  String _errorMessage =
      ''; // Membuat variabel untuk menampung pesan kesalahan jika terjadi.

  @override
  void initState() {
    super.initState();
    _fetchUniversities(); // Menjalankan fungsi untuk melakukan GET data universitas saat widget pertama kali dibuat.
  }

  Future<void> _fetchUniversities() async {
    setState(() {
      _isLoading =
          true; // Set isLoading menjadi true saat melakukan permintaan HTTP.
      _errorMessage =
          ''; // Mengosongkan variabel pesan kesalahan sebelum permintaan HTTP dijalankan.
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://universities.hipolabs.com/search?country=Indonesia'), // Melakukan permintaan GET ke URL sumber sata yang berisi daftar data universitas Indonesia.
      );

      if (response.statusCode == 200) {
        // Melakukan pengecekan tehadap permintaan apakah berhasil atau tidak.
        setState(() {
          _universities = json.decode(response
              .body); // Melakukan decode data JSON dari respons dan menyimpannya ke dalam daftar list _universities.
          _isLoading =
              false; // Set isLoading menjadi false setelah mendapatkan data.
        });
      } else {
        throw Exception(
            'Failed to load universities: ${response.reasonPhrase}'); // Menampilkan pesan kesalahan apabila permintaan gagal dijalankan.
      }
    } catch (error) {
      setState(() {
        _errorMessage =
            'Error: $error'; // Menampung pesan kesalahan apabila terdapat kesalahan selama pemrosesan data.
        _isLoading =
            false; // Set isLoading menjadi false setelah terjadi kesalahan.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Universitas Indonesia'), // Judul AppBar.
        centerTitle:
            true, // Membuat agar tampilan judul AppBar menjadi berada di tengah.
      ),
      body:
          _isLoading // Menjalankan fungsi untuk menampilkan indikator loading apabila isLoading true.
              ? Center(
                  child:
                      CircularProgressIndicator(), // Menampilkan CircularProgressIndicator di tengah layar.
                )
              : _errorMessage
                      .isNotEmpty // Menampilkan pesan kesalahan apabila ada.
                  ? Center(
                      child: Text(
                        _errorMessage, // Menampilkan pesan kesalahan.
                        style: TextStyle(
                            color: Colors
                                .red), // Mengubah warna teks menjadi berwarna merah.
                      ),
                    )
                  : ListView.builder(
                      itemCount: _universities
                          .length, // Jumlah konten di dalam ListView.
                      itemBuilder: (context, index) {
                        return Card(
                          elevation:
                              4, // Membuat kartu yang menjadi latar setiap konten.
                          margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal:
                                  16), // Memberi jarak di antara konten listview.
                          child: ListTile(
                            title: Text(_universities[index]['name'],
                                style: TextStyle(
                                    fontSize:
                                        18)), // Membuat tampilan nama universitas menjadi berukuran font 18.
                            subtitle: Text(_universities[index]['web_pages'][
                                0]), // Menampilkan URL halaman web universitas.
                          ),
                        );
                      },
                    ),
    );
  }
}
