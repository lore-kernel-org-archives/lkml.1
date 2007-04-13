Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbXDMMSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbXDMMSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbXDMMSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:18:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49969 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbXDMMSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:18:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: greg@uclinux.org
Subject: [patch] dont force uclinux mtd map to be root dev
Date: Fri, 13 Apr 2007 08:19:31 -0400
User-Agent: KMail/1.9.6
Cc: michele.damico@fitre.it, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1243165.ftno1yTx3V";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704130819.32657.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1243165.ftno1yTx3V
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

the cheesy uclinux mtd maps can be used for more than just the root device,=
 so=20
i think we should drop the forcing.  also, i feel like this is a policy=20
decision that shouldnt be in the kernel in the first place.  people who hav=
e=20
been lazy and boot with uclinux mtd maps and dont put root=3D into their=20
commandline can simply add the appropriate root=3D line either into their=20
bootloader or into the compiled in bootargs

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
=2D--
diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
index 389fea2..14ffb1a 100644
=2D-- a/drivers/mtd/maps/uclinux.c
+++ b/drivers/mtd/maps/uclinux.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/major.h>
=2D#include <linux/root_dev.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>
 #include <linux/mtd/partitions.h>
@@ -89,10 +88,6 @@ int __init uclinux_mtd_init(void)
 	uclinux_ram_mtdinfo =3D mtd;
 	add_mtd_partitions(mtd, uclinux_romfs, NUM_PARTITIONS);
=20
=2D	printk("uclinux[mtd]: set %s to be root filesystem\n",
=2D	     	uclinux_romfs[0].name);
=2D	ROOT_DEV =3D MKDEV(MTD_BLOCK_MAJOR, 0);
=2D
 	return(0);
 }
=20

--nextPart1243165.ftno1yTx3V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iQIVAwUARh91VEFjO5/oN/WBAQL5ExAAplSQ+wLMsRxlJPBq4hPC1xyQGLmmgryy
oc+j337+dk1vBxOSFNwF1e8DjLF3+07A1s/A9071z1oWeh+Dyw6B7rTOTzRW1EGv
xGBXgY8hBto1UBSZa4TESJZzwDFjuP8YHIth5sUxsitxvWREA31YusMok6sygX0m
ujApooOqj3udJkMa86rvzPs383vhwKRhLQFyEVQdcVVB5C5vQ8397NWxrrheQf91
0IXSugBcAUAzYcB6DOWyrImIkXWAaONVMg+tX5F84bGVxXHVNR1CHo3sWXWypc+Y
HQ6VVyHpkuSMVg89JvOAcSdFF8lQOEBCZQIxPBR2pKHzy2K4sficndV7iFK/bZEF
GaJvJ7C4NHqMVHl0SgdOuXHs1/+YUwz1o2EJCdz7vGxA0StOtVLRnHLVgcAZMKkS
UOJuGkwC3v2uNQV5NIVcIoE3ZKV/Nb+krbqs3GUwz9NYiG48sZxoUHqNvi+6xwYO
v2o6dtFndtVlAZ8Sf99LIHdl/Qqg3kNMqS+b/fy8ozf1haZ7cdSTtahQuTeYw6e0
lZaCrcbHQSmloDfUSdAOhLGgR6KN1qnkeCy1NUipihaoEmeYXfO28yKSsEBASejA
5Ed+57O1WttAkPIT2ITNiKV/q6k0DQqjBjA0amHJbnOICM+QG8mZQcj8qoIylpRc
bRXP8aDQk3g=
=llhC
-----END PGP SIGNATURE-----

--nextPart1243165.ftno1yTx3V--
