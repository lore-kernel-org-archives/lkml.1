Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbXHONm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbXHONm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbXHONmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 09:42:49 -0400
Received: from iucha.net ([209.98.146.184]:53768 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbXHONms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 09:42:48 -0400
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 09:42:47 EDT
Date: Wed, 15 Aug 2007 08:31:47 -0500
From: Florin Iucha <florin@iucha.net>
To: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Greg KH <gregkh@suse.de>
Subject: USB-related oops in sysfs with linux v2.6.23-rc3-50-g28e8351
Message-ID: <20070815133147.GA7124@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Today my USB keyboard stopped working in the middle of composing and
e-mail.  I unplugged it and plugged it back, with no success.  I
logged in remotely and found this lovely message:

[ 1301.567351] usb 1-4: USB disconnect, address 3
[ 1301.567356] usb 1-4.2: USB disconnect, address 5
[ 1301.567599] sysfs_remove_bin_file: bad dentry or inode or no such file: =
"descriptors"
[ 1301.567604]=20
[ 1301.567605] Call Trace:
[ 1301.567614]  [<ffffffff802b89a6>] sysfs_remove_bin_file+0x39/0x3d
[ 1301.567619]  [<ffffffff803f1d24>] device_remove_bin_file+0x15/0x17
[ 1301.567623]  [<ffffffff8045ea0d>] usb_remove_sysfs_dev_files+0x89/0x9d
[ 1301.567627]  [<ffffffff804625cc>] generic_disconnect+0x2e/0x32
[ 1301.567630]  [<ffffffff8045b58d>] usb_unbind_device+0x15/0x19
[ 1301.567634]  [<ffffffff803f4161>] __device_release_driver+0x93/0xb3
[ 1301.567637]  [<ffffffff803f45af>] device_release_driver+0x31/0x49
[ 1301.567640]  [<ffffffff803f39f1>] bus_remove_device+0x76/0x87
[ 1301.567644]  [<ffffffff803f2014>] device_del+0x216/0x297
[ 1301.567648]  [<ffffffff80455c8f>] usb_disconnect+0xc8/0x151
[ 1301.567651]  [<ffffffff80455c56>] usb_disconnect+0x8f/0x151
[ 1301.567655]  [<ffffffff804564c8>] hub_thread+0x442/0xc47
[ 1301.567659]  [<ffffffff80553cdb>] _spin_unlock_irq+0x9/0xc
[ 1301.567664]  [<ffffffff80244ad7>] autoremove_wake_function+0x0/0x38
[ 1301.567668]  [<ffffffff80456086>] hub_thread+0x0/0xc47
[ 1301.567671]  [<ffffffff802449cb>] kthread+0x49/0x76
[ 1301.567674]  [<ffffffff8020c618>] child_rip+0xa/0x12
[ 1301.567679]  [<ffffffff80244982>] kthread+0x0/0x76
[ 1301.567682]  [<ffffffff8020c60e>] child_rip+0x0/0x12
[ 1301.567684]=20

I have rebooted, and while composing this message, I thought useful to
include the output from 'lsusb'.  Funny enough, lsusb does not list any
devices.  A 'cat /proc/bus/usb/devices' yields the following:

T:  Bus=3D02 Lev=3D00 Prnt=3D00 Port=3D00 Cnt=3D00 Dev#=3D  1 Spd=3D12  MxC=
h=3D10
B:  Alloc=3D 25/900 us ( 3%), #Int=3D  5, #Iso=3D  0
D:  Ver=3D 1.10 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  1
P:  Vendor=3D0000 ProdID=3D0000 Rev=3D 2.06
S:  Manufacturer=3DLinux 2.6.23-rc3-1 ohci_hcd
S:  Product=3DOHCI Host Controller
S:  SerialNumber=3D0000:00:02.0
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3De0 MxPwr=3D  0mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 Driver=
=3Dhub
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   2 Ivl=3D255ms

T:  Bus=3D02 Lev=3D01 Prnt=3D01 Port=3D02 Cnt=3D01 Dev#=3D  2 Spd=3D12  MxC=
h=3D 4
D:  Ver=3D 1.10 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  1
P:  Vendor=3D05f3 ProdID=3D0081 Rev=3D 3.10
S:  Manufacturer=3DPI Engineering
S:  Product=3DKinesis Keyboard Hub
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3Da0 MxPwr=3D 50mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 Driver=
=3Dhub
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   1 Ivl=3D255ms

T:  Bus=3D02 Lev=3D02 Prnt=3D02 Port=3D01 Cnt=3D01 Dev#=3D  3 Spd=3D12  MxC=
h=3D 0
D:  Ver=3D 1.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  1
P:  Vendor=3D05f3 ProdID=3D0007 Rev=3D 3.10
C:* #Ifs=3D 2 Cfg#=3D 1 Atr=3Da0 MxPwr=3D 64mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D01 Prot=3D01 Driver=
=3Dusbhid
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   8 Ivl=3D8ms
I:* If#=3D 1 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D00 Prot=3D00 Driver=
=3Dusbhid
E:  Ad=3D82(I) Atr=3D03(Int.) MxPS=3D   4 Ivl=3D8ms

T:  Bus=3D02 Lev=3D02 Prnt=3D02 Port=3D02 Cnt=3D02 Dev#=3D  4 Spd=3D1.5 MxC=
h=3D 0
D:  Ver=3D 1.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  1
P:  Vendor=3D05bc ProdID=3D0102 Rev=3D 2.00
S:  Manufacturer=3DForward
S:  Product=3DUSB Optical Mouse
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3Da0 MxPwr=3D100mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D01 Prot=3D02 Driver=
=3Dusbhid
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   4 Ivl=3D10ms

T:  Bus=3D02 Lev=3D02 Prnt=3D02 Port=3D03 Cnt=3D03 Dev#=3D  5 Spd=3D1.5 MxC=
h=3D 0
D:  Ver=3D 1.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  1
P:  Vendor=3D045e ProdID=3D0039 Rev=3D 1.21
S:  Manufacturer=3DMicrosoft
S:  Product=3DMicrosoft IntelliMouse=AE Optical
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3Da0 MxPwr=3D100mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D01 Prot=3D02 Driver=
=3Dusbhid
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   4 Ivl=3D10ms

T:  Bus=3D01 Lev=3D00 Prnt=3D00 Port=3D00 Cnt=3D00 Dev#=3D  1 Spd=3D480 MxC=
h=3D10
B:  Alloc=3D  0/800 us ( 0%), #Int=3D  1, #Iso=3D  0
D:  Ver=3D 2.00 Cls=3D09(hub  ) Sub=3D00 Prot=3D01 MxPS=3D64 #Cfgs=3D  1
P:  Vendor=3D0000 ProdID=3D0000 Rev=3D 2.06
S:  Manufacturer=3DLinux 2.6.23-rc3-1 ehci_hcd
S:  Product=3DEHCI Host Controller
S:  SerialNumber=3D0000:00:02.1
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3De0 MxPwr=3D  0mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 Driver=
=3Dhub
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   4 Ivl=3D256ms

T:  Bus=3D01 Lev=3D01 Prnt=3D01 Port=3D03 Cnt=3D01 Dev#=3D  3 Spd=3D480 MxC=
h=3D 4
D:  Ver=3D 2.00 Cls=3D09(hub  ) Sub=3D00 Prot=3D01 MxPS=3D64 #Cfgs=3D  1
P:  Vendor=3D0409 ProdID=3D0058 Rev=3D 1.00
S:  Manufacturer=3DNEC Corporation
S:  Product=3DUSB2.0 Hub Controller
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3De0 MxPwr=3D100mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D09(hub  ) Sub=3D00 Prot=3D00 Driver=
=3Dhub
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   1 Ivl=3D256ms

T:  Bus=3D01 Lev=3D02 Prnt=3D03 Port=3D01 Cnt=3D01 Dev#=3D  5 Spd=3D1.5 MxC=
h=3D 0
D:  Ver=3D 1.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  1
P:  Vendor=3D0fe9 ProdID=3D9010 Rev=3D 1.00
S:  Manufacturer=3DDVICO
S:  Product=3DDVICO USB HID Remocon V1.00
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3D80 MxPwr=3D100mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 2 Cls=3D03(HID  ) Sub=3D00 Prot=3D00 Driver=
=3Dusbhid
E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   3 Ivl=3D32ms
E:  Ad=3D02(O) Atr=3D03(Int.) MxPS=3D   1 Ivl=3D32ms

T:  Bus=3D01 Lev=3D01 Prnt=3D01 Port=3D08 Cnt=3D02 Dev#=3D  4 Spd=3D480 MxC=
h=3D 0
D:  Ver=3D 2.00 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  1
P:  Vendor=3D07cc ProdID=3D0501 Rev=3D91.44
S:  Manufacturer=3DUSB2.0
S:  Product=3DCardReader
S:  SerialNumber=3D1234609=20
C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3D80 MxPwr=3D500mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 2 Cls=3D08(stor.) Sub=3D06 Prot=3D50 Driver=
=3Dusb-storage
E:  Ad=3D81(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
E:  Ad=3D02(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms

I am testing each rcX kernel, and I did not see this problem so far.
Smells like a new regression.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGwwBDND0rFCN2b1sRAoP3AJ9BvxzcjxZk8p2cLIOZ69R9p00e4wCgpOQI
/AfL+7ixqgbvtahCe4hPzzY=
=7bZz
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
