Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYIBQLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYIBQLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYIBQLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:11:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40819 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYIBQLX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:11:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5-mmotm0829 - CONFIG_HID_COMPAT causes hangs at boot
In-Reply-To: Your message of "Tue, 02 Sep 2008 16:26:40 +0200."
             <48BD4D20.5020704@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <7419.1220261347@turing-police.cc.vt.edu>
            <48BD4D20.5020704@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1220371878_3112P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Sep 2008 12:11:18 -0400
Message-ID: <13476.1220371878@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1220371878_3112P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Sep 2008 16:26:40 +0200, Jiri Slaby said:

OK, I'll annotate line-by-line.  This is a console from a boot of a kerne=
l
built with HID_COMPAT=3Dn (which works just fine).  I couldn't get a netc=
onsole
of a COMPAT=3Dy boot for other reasons, and it doesn't live long enough t=
o get a
dmesg.

Both kernels are OK here.
> > =5B    1.665167=5D usb 1-8: New USB device found, idVendor=3D413c, id=
Product=3D0058
> > =5B    1.678083=5D usb 1-8: New USB device strings: Mfr=3D0, Product=
=3D0, SerialNumber=3D0
> > =5B    1.753101=5D usb 1-8.1: new low speed USB device using ehci_hcd=
 and address 5
> > =5B    1.842008=5D usb 1-8.1: configuration =231 chosen from 1 choice=

> > =5B    1.869343=5D usb 1-8.1: New USB device found, idVendor=3D045e, =
idProduct=3D0023
> > =5B    1.882267=5D usb 1-8.1: New USB device strings: Mfr=3D1, Produc=
t=3D2, SerialNumber=3D0
> > =5B    1.895189=5D usb 1-8.1: Product: Microsoft Trackball Optical=C2=
=AE
> > =5B    1.908056=5D usb 1-8.1: Manufacturer: Microsoft

The next line would make it to the console in both cases.
> > =5B    1.926685=5D input: Microsoft Microsoft Trackball Optical=C2=AE=
 as /devices/pci000:00/0000:00:1d.7/usb1/1-8/1-8.1/1-8.1:1.0/input/input1=


The following 3 lines don't go to console by default due to loglevel sett=
ing.
So I'm not sure exactly where it hangs. But it's somewhere in here.
> > =5B    1.945217=5D generic-usb 0003:045E:0023.0001: input,hidraw0: US=
B HID v1.00 Mouse =5BMicrosoft Microsoft Trackball Optical=C2=AE=5D on us=
b-0000:00:1d.7-8.1/input0
> > =5B    1.959193=5D usbcore: registered new interface driver usbhid
> > =5B    1.973037=5D usbhid: v2.6:USB HID core driver

This line *should* make it to the console, but doesn't. So the failure is=

before this point.
> > =5B    1.987014=5D Advanced Linux Sound Architecture Driver Version 1=
.0.18rc1.

I'll go back and instrument it more heavily so there's more info availabl=
e.

--==_Exmh_1220371878_3112P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIvWWmcC3lWbTT17ARAqv0AKDerHLq37fckzpfOhU/vvaKBljMagCgxGfn
M1BQ9cnIYIJJ8mYehn1lO6k=
=RVwY
-----END PGP SIGNATURE-----

--==_Exmh_1220371878_3112P--
