Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYIGCpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYIGCpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 22:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYIGCpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 22:45:11 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:43933 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYIGCpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 22:45:09 -0400
X-Greylist: delayed 856 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Sep 2008 22:45:09 EDT
Subject: Request for MCE decode (AMD Barcelona, fam 10h)
From: Tony Vroon <tony@vroon.org>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8CABu2hVQwLkh0zFpS5a"
Date: Sun, 07 Sep 2008 03:32:22 +0100
Message-Id: <1220754742.8530.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8CABu2hVQwLkh0zFpS5a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On a Tyan-based system with intermittent but persistent instability, I
have finally received a message that something might actually be wrong
in hardware. Could you decode:

MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 BANK 4 MISC c000000001000000=20
STATUS fa00002000020c0f MCGSTATUS 0
MCE 1
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 4 BANK 4 MISC c000000001000000=20
STATUS fa00000000070f0f MCGSTATUS 0

This appeared while the 3Ware 9550SXU-8LP RAID controller reported a
disk corruption:
3w-9xxx: scsi0: AEN: INFO (0x04:0x0029): Verify started:unit=3D0.
Machine check events logged
3w-9xxx: scsi0: AEN: WARNING (0x04:0x0023): Sector repair
completed:port=3D2, LBA=3D0x74907F9.

This is on:
Linux prometheus 2.6.27-rc5-00283-g70bb089 #1 SMP Sat Sep 6 13:52:51 BST
2008 x86_64 Quad-Core AMD Opteron(tm) Processor 2354 AuthenticAMD
GNU/Linux

This is a 2x Opteron 2354 (so 8 core) system, on a Tyan S2915-E
mainboard with the v2.07 BIOS. The system is equipped with 16GB RAM,
populated as 8x Kingston KVR667D2D4P5/2G.

Configuration for the RAID controller, in case it is relevant:
/c0 Driver Version =3D 2.26.02.011
/c0 Model =3D 9550SXU-8LP
/c0 Available Memory =3D 112MB
/c0 Firmware Version =3D FE9X 3.08.00.029
/c0 Bios Version =3D BE9X 3.10.00.003
/c0 Boot Loader Version =3D BL9X 3.02.00.001
/c0 Serial Number =3D [scrubbed]
/c0 PCB Version =3D Rev 032
/c0 PCHIP Version =3D 1.60
/c0 ACHIP Version =3D 1.90
/c0 Number of Ports =3D 8
/c0 Number of Drives =3D 6
/c0 Number of Units =3D 1
/c0 Total Optimal Units =3D 1
/c0 Not Optimal Units =3D 0=20
/c0 JBOD Export Policy =3D off
/c0 Disk Spinup Policy =3D 2
/c0 Spinup Stagger Time Policy (sec) =3D 1
/c0 Auto-Carving Policy =3D off
/c0 Auto-Carving Size =3D 2048 GB
/c0 Auto-Rebuild Policy =3D on
/c0 Controller Bus Type =3D PCIX
/c0 Controller Bus Width =3D 64 bits
/c0 Controller Bus Speed =3D 133 Mhz

Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache
AVrfy
---------------------------------------------------------------------------=
---
u0    RAID-5    VERIFYING      -       12      256K    3492.41   ON
OFF   =20

Port   Status           Unit   Size        Blocks        Serial
---------------------------------------------------------------
p0     OK               u0     698.63 GB   1465149168   [scrubbed]     =20
p1     OK               u0     698.63 GB   1465149168   [scrubbed]=20
p2     OK               u0     698.63 GB   1465149168   [scrubbed]=20
p3     OK               u0     698.63 GB   1465149168   [scrubbed]=20
p4     OK               u0     698.63 GB   1465149168   [scrubbed]=20
p5     OK               u0     698.63 GB   1465149168   [scrubbed]=20
p6     NOT-PRESENT      -      -           -             -
p7     NOT-PRESENT      -      -           -             -

Name  OnlineState  BBUReady  Status    Volt     Temp     Hours
LastCapTest
---------------------------------------------------------------------------
bbu   On           Yes       OK        OK       OK       255
04-Jun-2008 =20

I have stripped the machine down to its bare minimum configuration, but
the instability continues. On an older BIOS, enabling the IOMMU option
in the BIOS seemed to cause hard crashes with an alarming frequency.
However, this all but disappeared in in v2.05 and upwards.
As disabling the IOMMU option costs me RAM, I have not yet done so.
However, I will happily flip BIOS settings and run further tests for
you. I'm not getting any work done on this workstation and that needs to
stop.
I realize that the linux kernel may be entirely blameless in this
situation, but I'd like to have some peer insight before I run after
vendors.

Regards,
Tony V.

--=-8CABu2hVQwLkh0zFpS5a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjDPTYACgkQp5vW4rUFj5o1qQCgqNbVEfGzkpDASQghwiBICLaa
YXkAn0/Uo9eWxN/P+lCZSo1gc+x8dw0q
=0ECy
-----END PGP SIGNATURE-----

--=-8CABu2hVQwLkh0zFpS5a--

