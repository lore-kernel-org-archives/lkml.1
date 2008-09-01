Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbYIAJlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbYIAJlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYIAJky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:40:54 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54140 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbYIAJkx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:40:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc5-mmotm0829 - CONFIG_HID_COMPAT causes hangs at boot
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1220261347_4797P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 01 Sep 2008 05:29:07 -0400
Message-ID: <7419.1220261347@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1220261347_4797P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

I built a rc5-mmotm kernel, and set CONFIG_HID_COMPAT=3Dy, but then found=

that I didn't actually *need* any of quirks files that tries to load, so
those all got set to 'n'.

The resulting kernel would get this far (using a HID_COMPAT=3Dn kernel's =
dmesg
and annotating, I couldn't get netconsole) and then hang while still runn=
ing
off the initrd:

=5B    1.665167=5D usb 1-8: New USB device found, idVendor=3D413c, idProd=
uct=3D0058
=5B    1.678083=5D usb 1-8: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
=5B    1.753101=5D usb 1-8.1: new low speed USB device using ehci_hcd and=
 address 5
=5B    1.842008=5D usb 1-8.1: configuration =231 chosen from 1 choice
=5B    1.869343=5D usb 1-8.1: New USB device found, idVendor=3D045e, idPr=
oduct=3D0023
=5B    1.882267=5D usb 1-8.1: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D0
=5B    1.895189=5D usb 1-8.1: Product: Microsoft Trackball Optical=C2=AE
=5B    1.908056=5D usb 1-8.1: Manufacturer: Microsoft

(the next line would make it to the console)

=5B    1.926685=5D input: Microsoft Microsoft Trackball Optical=C2=AE as =
/devices/pci000:00/0000:00:1d.7/usb1/1-8/1-8.1/1-8.1:1.0/input/input1
=5B    1.945217=5D generic-usb 0003:045E:0023.0001: input,hidraw0: USB HI=
D v1.00 Mouse =5BMicrosoft Microsoft Trackball Optical=C2=AE=5D on usb-00=
00:00:1d.7-8.1/input0
=5B    1.959193=5D usbcore: registered new interface driver usbhid
=5B    1.973037=5D usbhid: v2.6:USB HID core driver

(the following line would not)
=5B    1.987014=5D Advanced Linux Sound Architecture Driver Version 1.0.1=
8rc1.

Poking around with sysrq-T would show a modprobe process running and not
making any progress, just hung waiting for something.  I can go get the
traceback if needed.

This ring any bells?

--==_Exmh_1220261347_4797P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIu7XjcC3lWbTT17ARAhbUAJ9+TSEYS7ug4eMunejtNfoHV+T6wQCfcp+B
tny2WzWtAs1WEVNDzqq4zoY=
=qDnz
-----END PGP SIGNATURE-----

--==_Exmh_1220261347_4797P--
