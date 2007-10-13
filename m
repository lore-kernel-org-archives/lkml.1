Return-Path: <linux-kernel-owner+w=401wt.eu-S1762620AbXJMSSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762620AbXJMSSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXJMSSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:18:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:36688 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbXJMSSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:content-type:date:message-id:mime-version:x-mailer:sender;
        b=fuJBNnGced48kG9f3OgelIx7zRRKM4X8PYKIKDDw0yZy+E9L+5+fJSj5bLpXBcTrZLCBfSJyuynV5mkkljAyv4aU3nkW/3IBVwe5L38E/mnZvALKn1hJJEqhtPUvrJz+/cErMKpQtSlDyqBrqvFO7w8STY7WgC4ftbZMSYomRTQ=
Subject: regression(?): starting with 2.6.21 sending packets became broken.
From: Peter Volkov <pva@gentoo.org>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pXxx+tOrzKsX4rankjau"
Date: Sat, 13 Oct 2007 22:16:25 +0400
Message-Id: <1192299385.31908.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pXxx+tOrzKsX4rankjau
Content-Type: multipart/mixed; boundary="=-rRMR6Xk/g54HVGki4B4P"


--=-rRMR6Xk/g54HVGki4B4P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello, all on the list.

Please CC me in answers, I'm not subscribed. Please, if this is wrong
list tell me what is correct.

Starting with 2.6.21 (or may be 2.6.20 as I have not tried it) kernel I
have problem that most tcp based services freeze at some point of
operation. I've noticed this first on ssh but then found out that at
lease one other service became similarly. The problem sites somewhere in
the kernel as I've compiled 2.6.19, 2.6.21, and 2.6.22 with the
similar .config options (of course not exact, as some options does not
exist in some kernels, but seems that enabled options are all the same)
but I have this problem only with the 21 and 22. I've tried to debug the
problem a bit, but not a lot as that is production box working as linux
based firewall/router.

First I took tcpdump. Although ssh connection to the router is not
always possible as it often hangs before I get into router, after some
attempts ssh connection was established. On client computer I've started
tcpdump and worked a bit until hang. tcpdump output showed me that when
I press any keys the packets are sent to the server and proper ack are
received. Later I found that all commands I enter blindly are executed
on router but I receive no reply packets with some data in them (pure
ack). That's why nothing happens on the screen and it looks like
hanging.

Now I've got to the router started ssh connection from router to some
other server. It hanged too. I attached strace and found that ssh
receive keyboard pressings (read() calls in the output) and writes them
further to the kernel (write() calls) but tcpdump on the router shows no
packets. So packets enter kernel and lost somewhere inside.

Now a information about my system. That's a pentium4 system with
hyper-threading enabled. cpuinfo and lspci output attached. kernel built
with "gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)" and binutils version
2.17. My .config file for all kernels I've mentioned is available here:

http://theor.ran.gpi.ru/linux-2.6.19-gentoo-r5-config (works)
http://theor.ran.gpi.ru/linux-2.6.21-gentoo-r4-config (not works)
http://theor.ran.gpi.ru/linux-2.6.22-gentoo-r8-config (not works)

Besides standard gentoo patchsets all kernels have IMQ and IPSET's
patches.

Does anybody have any idea what's going on with the latest kernels? How
to debug it further?

--=20
Peter.

--=-rRMR6Xk/g54HVGki4B4P
Content-Disposition: attachment; filename=router-lspci.txt
Content-Type: text/plain; name=router-lspci.txt; charset=UTF-8
Content-Transfer-Encoding: base64

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4NjVHL1BFL1AgRFJBTSBD
b250cm9sbGVyL0hvc3QtSHViIEludGVyZmFjZSAocmV2IDAyKQ0KMDA6MDEuMCBQQ0kgYnJpZGdl
OiBJbnRlbCBDb3Jwb3JhdGlvbiA4Mjg2NUcvUEUvUCBQQ0kgdG8gQUdQIENvbnRyb2xsZXIgKHJl
diAwMikNCjAwOjFlLjAgUENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gODI4MDEgUENJIEJy
aWRnZSAocmV2IGMyKQ0KMDA6MWYuMCBJU0EgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA4Mjgw
MUVCL0VSIChJQ0g1L0lDSDVSKSBMUEMgSW50ZXJmYWNlIEJyaWRnZSAocmV2IDAyKQ0KMDA6MWYu
MSBJREUgaW50ZXJmYWNlOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjgwMUVCL0VSIChJQ0g1L0lDSDVS
KSBJREUgQ29udHJvbGxlciAocmV2IDAyKQ0KMDA6MWYuMiBJREUgaW50ZXJmYWNlOiBJbnRlbCBD
b3Jwb3JhdGlvbiA4MjgwMUVCIChJQ0g1KSBTQVRBIENvbnRyb2xsZXIgKHJldiAwMikNCjAwOjFm
LjMgU01CdXM6IEludGVsIENvcnBvcmF0aW9uIDgyODAxRUIvRVIgKElDSDUvSUNINVIpIFNNQnVz
IENvbnRyb2xsZXIgKHJldiAwMikNCjAxOjAwLjAgVkdBIGNvbXBhdGlibGUgY29udHJvbGxlcjog
blZpZGlhIENvcnBvcmF0aW9uIE5WMTUgW0dlRm9yY2UyIEdUUy9Qcm9dIChyZXYgYTQpDQowMjow
YS4wIFBDSSBicmlkZ2U6IERpZ2l0YWwgRXF1aXBtZW50IENvcnBvcmF0aW9uIERFQ2NoaXAgMjEx
NTIgKHJldiAwMykNCjAyOjBiLjAgUENJIGJyaWRnZTogRGlnaXRhbCBFcXVpcG1lbnQgQ29ycG9y
YXRpb24gREVDY2hpcCAyMTE1MiAocmV2IDAzKQ0KMDM6MDQuMCBFdGhlcm5ldCBjb250cm9sbGVy
OiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjU1Ny84LzkgW0V0aGVybmV0IFBybyAxMDBdIChyZXYgMDUp
DQowMzowNS4wIEV0aGVybmV0IGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIDgyNTU3Lzgv
OSBbRXRoZXJuZXQgUHJvIDEwMF0gKHJldiAwNSkNCjA0OjA0LjAgRXRoZXJuZXQgY29udHJvbGxl
cjogSW50ZWwgQ29ycG9yYXRpb24gODI1NTcvOC85IFtFdGhlcm5ldCBQcm8gMTAwXSAocmV2IDA1
KQ0KMDQ6MDUuMCBFdGhlcm5ldCBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiA4MjU1Ny84
LzkgW0V0aGVybmV0IFBybyAxMDBdIChyZXYgMDUpDQoNCg==


--=-rRMR6Xk/g54HVGki4B4P
Content-Disposition: attachment; filename=routers-cpuinfo.txt
Content-Type: text/plain; name=routers-cpuinfo.txt; charset=UTF-8
Content-Transfer-Encoding: base64

cHJvY2Vzc29yICAgICAgIDogMA0KdmVuZG9yX2lkICAgICAgIDogR2VudWluZUludGVsDQpjcHUg
ZmFtaWx5ICAgICAgOiAxNQ0KbW9kZWwgICAgICAgICAgIDogNA0KbW9kZWwgbmFtZSAgICAgIDog
SW50ZWwoUikgUGVudGl1bShSKSA0IENQVSAzLjIwR0h6DQpzdGVwcGluZyAgICAgICAgOiA5DQpj
cHUgTUh6ICAgICAgICAgOiAzMTk4Ljc4NA0KY2FjaGUgc2l6ZSAgICAgIDogMTAyNCBLQg0KcGh5
c2ljYWwgaWQgICAgIDogMA0Kc2libGluZ3MgICAgICAgIDogMg0KY29yZSBpZCAgICAgICAgIDog
MA0KY3B1IGNvcmVzICAgICAgIDogMQ0KZmRpdl9idWcgICAgICAgIDogbm8NCmhsdF9idWcgICAg
ICAgICA6IG5vDQpmMDBmX2J1ZyAgICAgICAgOiBubw0KY29tYV9idWcgICAgICAgIDogbm8NCmZw
dSAgICAgICAgICAgICA6IHllcw0KZnB1X2V4Y2VwdGlvbiAgIDogeWVzDQpjcHVpZCBsZXZlbCAg
ICAgOiA1DQp3cCAgICAgICAgICAgICAgOiB5ZXMNCmZsYWdzICAgICAgICAgICA6IGZwdSB2bWUg
ZGUgcHNlIHRzYyBtc3IgcGFlIG1jZSBjeDggYXBpYyBzZXAgbXRyciBwZ2UgbWNhDQpjbW92IHBh
dCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0IHRtIHBiZSBj
b25zdGFudF90c2MNCnBuaSBtb25pdG9yIGRzX2NwbCBjaWQgeHRwcg0KYm9nb21pcHMgICAgICAg
IDogNjQwMS41OQ0KDQpwcm9jZXNzb3IgICAgICAgOiAxDQp2ZW5kb3JfaWQgICAgICAgOiBHZW51
aW5lSW50ZWwNCmNwdSBmYW1pbHkgICAgICA6IDE1DQptb2RlbCAgICAgICAgICAgOiA0DQptb2Rl
bCBuYW1lICAgICAgOiBJbnRlbChSKSBQZW50aXVtKFIpIDQgQ1BVIDMuMjBHSHoNCnN0ZXBwaW5n
ICAgICAgICA6IDkNCmNwdSBNSHogICAgICAgICA6IDMxOTguNzg0DQpjYWNoZSBzaXplICAgICAg
OiAxMDI0IEtCDQpwaHlzaWNhbCBpZCAgICAgOiAwDQpzaWJsaW5ncyAgICAgICAgOiAyDQpjb3Jl
IGlkICAgICAgICAgOiAwDQpjcHUgY29yZXMgICAgICAgOiAxDQpmZGl2X2J1ZyAgICAgICAgOiBu
bw0KaGx0X2J1ZyAgICAgICAgIDogbm8NCmYwMGZfYnVnICAgICAgICA6IG5vDQpjb21hX2J1ZyAg
ICAgICAgOiBubw0KZnB1ICAgICAgICAgICAgIDogeWVzDQpmcHVfZXhjZXB0aW9uICAgOiB5ZXMN
CmNwdWlkIGxldmVsICAgICA6IDUNCndwICAgICAgICAgICAgICA6IHllcw0KZmxhZ3MgICAgICAg
ICAgIDogZnB1IHZtZSBkZSBwc2UgdHNjIG1zciBwYWUgbWNlIGN4OCBhcGljIHNlcCBtdHJyIHBn
ZSBtY2ENCmNtb3YgcGF0IHBzZTM2IGNsZmx1c2ggZHRzIGFjcGkgbW14IGZ4c3Igc3NlIHNzZTIg
c3MgaHQgdG0gcGJlIGNvbnN0YW50X3RzYw0KcG5pIG1vbml0b3IgZHNfY3BsIGNpZCB4dHByDQpi
b2dvbWlwcyAgICAgICAgOiA2Mzk3LjQzDQoNCg==


--=-rRMR6Xk/g54HVGki4B4P--

--=-pXxx+tOrzKsX4rankjau
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: =?UTF-8?Q?=D0=AD=D1=82=D0=B0?=
	=?UTF-8?Q?_=D1=87=D0=B0=D1=81=D1=82=D1=8C?=
	=?UTF-8?Q?_=D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D1=8F?=
	=?UTF-8?Q?_=D0=BF=D0=BE=D0=B4=D0=BF=D0=B8=D1=81=D0=B0=D0=BD=D0=B0?=
	=?UTF-8?Q?_=D1=86=D0=B8=D1=84=D1=80=D0=BE=D0=B2=D0=BE=D0=B9?=
	=?UTF-8?Q?_=D0=BF=D0=BE=D0=B4=D0=BF=D0=B8=D1=81=D1=8C=D1=8E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHEQtyz6tlgEWSarMRArl/AKCPpJ+19Ltr75oLzrHn/3DjlQfVhwCfQ6HF
2M0XdfTqaK9QxkRtBIYA9A0=
=Ot73
-----END PGP SIGNATURE-----

--=-pXxx+tOrzKsX4rankjau--

