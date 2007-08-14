Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbXHNMKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbXHNMKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 08:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbXHNMJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 08:09:56 -0400
Received: from jonsy.dit.upm.es ([138.4.5.106]:53329 "EHLO jonsy.dit.upm.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbXHNMJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 08:09:54 -0400
X-Greylist: delayed 3101 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 08:09:54 EDT
Subject: RV: ppdev - libieee1284.so  conflicts with 2.6.2{0,1,2}
From: Jonsito <jonsito@teleline.es>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <1183550290.30882.8.camel@jonsy.dit.upm.es>
References: <1183443365.3006.10.camel@drake.micasa.es>
	 <468AC017.2000300@redhat.com>  <1183550290.30882.8.camel@jonsy.dit.upm.es>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-u9chlK+gPyNESmK66b65"
Organization: Teleline
Date: Tue, 14 Aug 2007 13:15:50 +0200
Message-Id: <1187090150.24874.45.camel@jonsy.dit.upm.es>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-2.fc5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-u9chlK+gPyNESmK66b65
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

El mi=E9, 04-07-2007 a las 13:58 +0200, Jonsito escribi=F3:
[...]

from libieee1284 bug tracker:
http://sourceforge.net/tracker/index.php?func=3Ddetail&aid=3D1739643&group_=
id=3D29314&atid=3D395778

---------------------------
/proc on on 2.6.22.1=20

# ls -la /proc/sys/dev/parport
total 0
dr-xr-xr-x 0 root root 0 2007-08-03 08:21 .
dr-xr-xr-x 0 root root 0 2007-08-03 08:19 ..
dr-xr-xr-x 0 root root 0 2007-08-03 08:25 default
dr-xr-xr-x 0 root root 0 2007-08-03 08:25 parport0

on 2.6.18
# ls -la /proc/sys/dev/parport/
total 0
dr-xr-xr-x 4 root root 0 Aug  3 08:29 .
dr-xr-xr-x 7 root root 0 Aug  3 08:29 ..
dr-xr-xr-x 2 root root 0 Aug  3 08:29 default
dr-xr-xr-x 3 root root 0 Aug  3 08:29 parport0

-----------------------------------

the offending and failing code was at libieee1284 sources:

libieee1284/src/detect.c, function check_proc_type (void)
....
  if (stat ("/proc/sys/dev/parport", &st) =3D=3D 0 &&
      S_ISDIR (st.st_mode) &&
      st.st_nlink > 2)
....
This test fail on st.st_nlink > 2 for kernels with new proc interface for
parport.=20

patch:

% diff -u detect.c.orig detect.c
--- detect.c.orig       2007-08-03 09:27:29.000000000 +0200
+++ detect.c    2007-08-03 09:27:46.000000000 +0200
@@ -69,8 +69,7 @@
   int which =3D 0;
   struct stat st;
   if (stat ("/proc/sys/dev/parport", &st) =3D=3D 0 &&
-      S_ISDIR (st.st_mode) &&
-      st.st_nlink > 2)
+      S_ISDIR (st.st_mode))
     {
       which =3D PROC_SYS_DEV_PARPORT_CAPABLE;
       debugprintf ("This system has /proc/sys/dev/parport\n");

-------------------------------------------------------

The above patch to libieee1284 library sources solves the ppdev=20
problem w/o need to patch kernel, but i'm unsure what is the
exact meaning of "0" as inode link count on procfs directory
entries, and when this change was made (=BFit's a bug or a feature? :)
=BFany link?

Thanks in advance
Juan Antonio

--=-u9chlK+gPyNESmK66b65
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIKkDCCBUQw
ggStoAMCAQICBDx9KH8wDQYJKoZIhvcNAQEFBQAwNjELMAkGA1UEBhMCRVMxDTALBgNVBAoTBEZO
TVQxGDAWBgNVBAsTD0ZOTVQgQ2xhc2UgMiBDQTAeFw0wNDEwMTkxMzM2MjdaFw0wNzEwMTkxMzM2
MjdaMIGJMQswCQYDVQQGEwJFUzENMAsGA1UEChMERk5NVDEYMBYGA1UECxMPRk5NVCBDbGFzZSAy
IENBMRIwEAYDVQQLEwk1MDAwNTE0ODMxPTA7BgNVBAMUNE5PTUJSRSBNQVJUSU5FWiBDQVNUQfFP
IEpVQU4gQU5UT05JTyAtIE5JRiA1MDQzMTEzOEcwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGB
ANFa4JHJtYmpy9g5l8FVepaJpTiNE3Lovlq3xC7gPzgHIiF0ltY9O+r1TcbmdRRrxNo2az+bRlw8
/SyYXQ0Vk+WYEoLfbMFMDdUu40sFeynEogv4jjWDFD21llsW+8Xm3AzRQGkOEZuRrV/GQFWjockf
uUtazWSTnevdTcuGEK5LAgMBAAGjggMJMIIDBTCBiAYDVR0RBIGAMH6BEEpPTlNJVE9AVEVSUkEu
RVOkajBoMRgwFgYJKwYBBAGsZgEEEwk1MDQzMTEzOEcxFjAUBgkrBgEEAaxmAQMUB0NBU1RB8U8x
FzAVBgkrBgEEAaxmAQITCE1BUlRJTkVaMRswGQYJKwYBBAGsZgEBEwxKVUFOIEFOVE9OSU8wCQYD
VR0TBAIwADArBgNVHRAEJDAigA8yMDA0MTAxOTEzMzYyN1qBDzIwMDcxMDE5MTMzNjI3WjALBgNV
HQ8EBAMCBaAwEQYJYIZIAYb4QgEBBAQDAgWgMB0GA1UdDgQWBBQQ5VIj7JvbBBsq6Wxx3t6vHPji
vjAfBgNVHSMEGDAWgBRAmnZEl3QHxKwUyx6NTzpFfDDXYTCCATEGA1UdIASCASgwggEkMIIBIAYJ
KwYBBAGsZgMFMIIBETA0BggrBgEFBQcCARYoaHR0cDovL3d3dy5jZXJ0LmZubXQuZXMvY29udmVu
aW8vZHBjLnBkZjCB2AYIKwYBBQUHAgIwgcsagchDZXJ0aWZpY2FkbyBSZWNvbm9jaWRvIGV4cGVk
aWRvIHNlZ/puIGxlZ2lzbGFjafNuIHZpZ2VudGUuVXNvIGxpbWl0YWRvIGEgbGEgQ29tdW5pZGFk
IEVsZWN0cvNuaWNhIHBvciB2YWxvciBt4XhpbW8gZGUgMTAwIGUgc2Fsdm8gZXhjZXBjaW9uZXMg
ZW4gRFBDLkNvbnRhY3RvIEZOTVQ6Qy9Kb3JnZSBKdWFuIDEwNi0yODAwOS1NYWRyaWQtRXNwYfFh
LjAdBgkrBgEEAaxmASEEEBYOUEVSU09OQSBGSVNJQ0EwLwYIKwYBBQUHAQMEIzAhMAgGBgQAjkYB
ATAVBgYEAI5GAQIwCxMDRVVSAgFkAgEAMFsGA1UdHwRUMFIwUKBOoEykSjBIMQswCQYDVQQGEwJF
UzENMAsGA1UEChMERk5NVDEYMBYGA1UECxMPRk5NVCBDbGFzZSAyIENBMRAwDgYDVQQDEwdDUkwx
NTU2MA0GCSqGSIb3DQEBBQUAA4GBAI6lP0og4o0zVQOr7/QPPg5lC+5BhSFNsXBiyP5j7xNrCkim
7zgCsqIUvZLjYGlL1ChiXniD1VUaylMAdX/p0uMe6ZIkxnA1KOGiMyGMaAk9MiXNnSX5mg3Q5/6H
eTqRFpwVfC4FGNRowKVjrU8iFt6rBAUdA+65F95NnLSAPI6gMIIFRDCCBK2gAwIBAgIEPH0ofzAN
BgkqhkiG9w0BAQUFADA2MQswCQYDVQQGEwJFUzENMAsGA1UEChMERk5NVDEYMBYGA1UECxMPRk5N
VCBDbGFzZSAyIENBMB4XDTA0MTAxOTEzMzYyN1oXDTA3MTAxOTEzMzYyN1owgYkxCzAJBgNVBAYT
AkVTMQ0wCwYDVQQKEwRGTk1UMRgwFgYDVQQLEw9GTk1UIENsYXNlIDIgQ0ExEjAQBgNVBAsTCTUw
MDA1MTQ4MzE9MDsGA1UEAxQ0Tk9NQlJFIE1BUlRJTkVaIENBU1RB8U8gSlVBTiBBTlRPTklPIC0g
TklGIDUwNDMxMTM4RzCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA0Vrgkcm1ianL2DmXwVV6
lomlOI0Tcui+WrfELuA/OAciIXSW1j076vVNxuZ1FGvE2jZrP5tGXDz9LJhdDRWT5ZgSgt9swUwN
1S7jSwV7KcSiC/iONYMUPbWWWxb7xebcDNFAaQ4Rm5GtX8ZAVaOhyR+5S1rNZJOd691Ny4YQrksC
AwEAAaOCAwkwggMFMIGIBgNVHREEgYAwfoEQSk9OU0lUT0BURVJSQS5FU6RqMGgxGDAWBgkrBgEE
AaxmAQQTCTUwNDMxMTM4RzEWMBQGCSsGAQQBrGYBAxQHQ0FTVEHxTzEXMBUGCSsGAQQBrGYBAhMI
TUFSVElORVoxGzAZBgkrBgEEAaxmAQETDEpVQU4gQU5UT05JTzAJBgNVHRMEAjAAMCsGA1UdEAQk
MCKADzIwMDQxMDE5MTMzNjI3WoEPMjAwNzEwMTkxMzM2MjdaMAsGA1UdDwQEAwIFoDARBglghkgB
hvhCAQEEBAMCBaAwHQYDVR0OBBYEFBDlUiPsm9sEGyrpbHHe3q8c+OK+MB8GA1UdIwQYMBaAFECa
dkSXdAfErBTLHo1POkV8MNdhMIIBMQYDVR0gBIIBKDCCASQwggEgBgkrBgEEAaxmAwUwggERMDQG
CCsGAQUFBwIBFihodHRwOi8vd3d3LmNlcnQuZm5tdC5lcy9jb252ZW5pby9kcGMucGRmMIHYBggr
BgEFBQcCAjCByxqByENlcnRpZmljYWRvIFJlY29ub2NpZG8gZXhwZWRpZG8gc2Vn+m4gbGVnaXNs
YWNp824gdmlnZW50ZS5Vc28gbGltaXRhZG8gYSBsYSBDb211bmlkYWQgRWxlY3Ry825pY2EgcG9y
IHZhbG9yIG3heGltbyBkZSAxMDAgZSBzYWx2byBleGNlcGNpb25lcyBlbiBEUEMuQ29udGFjdG8g
Rk5NVDpDL0pvcmdlIEp1YW4gMTA2LTI4MDA5LU1hZHJpZC1Fc3Bh8WEuMB0GCSsGAQQBrGYBIQQQ
Fg5QRVJTT05BIEZJU0lDQTAvBggrBgEFBQcBAwQjMCEwCAYGBACORgEBMBUGBgQAjkYBAjALEwNF
VVICAWQCAQAwWwYDVR0fBFQwUjBQoE6gTKRKMEgxCzAJBgNVBAYTAkVTMQ0wCwYDVQQKEwRGTk1U
MRgwFgYDVQQLEw9GTk1UIENsYXNlIDIgQ0ExEDAOBgNVBAMTB0NSTDE1NTYwDQYJKoZIhvcNAQEF
BQADgYEAjqU/SiDijTNVA6vv9A8+DmUL7kGFIU2xcGLI/mPvE2sKSKbvOAKyohS9kuNgaUvUKGJe
eIPVVRrKUwB1f+nS4x7pkiTGcDUo4aIzIYxoCT0yJc2dJfmaDdDn/od5OpEWnBV8LgUY1GjApWOt
TyIW3qsEBR0D7rkX3k2ctIA8jqAxggHkMIIB4AIBATA+MDYxCzAJBgNVBAYTAkVTMQ0wCwYDVQQK
EwRGTk1UMRgwFgYDVQQLEw9GTk1UIENsYXNlIDIgQ0ECBDx9KH8wCQYFKw4DAhoFAKCB/TAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNzA4MTQxMTE1NTBaMCMGCSqG
SIb3DQEJBDEWBBS+LW+PfQBWMHBpCLDgE5lxn/I4izBNBgkrBgEEAYI3EAQxQDA+MDYxCzAJBgNV
BAYTAkVTMQ0wCwYDVQQKEwRGTk1UMRgwFgYDVQQLEw9GTk1UIENsYXNlIDIgQ0ECBDx9KH8wTwYL
KoZIhvcNAQkQAgsxQKA+MDYxCzAJBgNVBAYTAkVTMQ0wCwYDVQQKEwRGTk1UMRgwFgYDVQQLEw9G
Tk1UIENsYXNlIDIgQ0ECBDx9KH8wDQYJKoZIhvcNAQEBBQAEgYBiAwXdx742z5MGGrzuurkoMrpS
iBaF23h5auVKaCxlRuTqwLEBOqnQxSmFmY3G5LZwTjm2/7M+Q6qNE7jlLM0hoSmCYCkBl7vJ/pNJ
AHiwTcwmH5Ax6dE80aRrwWNPW4RXFQ2OBTguVUb26Q2L6CZ5U9adudkOl2r4tJNsv6GG3gAAAAAA
AA==


--=-u9chlK+gPyNESmK66b65--
