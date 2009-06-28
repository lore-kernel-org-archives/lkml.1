Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZF1RDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZF1RDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZF1RDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:03:07 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:60049 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZF1RDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:03:04 -0400
Date: Sun, 28 Jun 2009 13:03:07 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Woody Suwalski <woodys@xandros.com>,
       =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] drivers/staging/vt6656/main_usb.c: Drop obsolete
	fsuid/fsgid accesses.
Message-ID: <20090628170307.GG9143@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eyYj78xbwv+yMvU1"
Content-Disposition: inline
In-Reply-To: <200906281759.46152.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eyYj78xbwv+yMvU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Greg: This patch series does not differ from that which you already have.]

drivers/staging/vt6656/main_usb.c: Drop obsolete fsuid/fsgid accesses.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6656/main_usb.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/mai=
n_usb.c
index 3368e83..f181d23 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1655,15 +1655,17 @@ static UCHAR *Config_FileOperation(PSDevice pDevice=
) {
     UCHAR    *buffer=3DNULL;
     struct file   *filp=3DNULL;
     mm_segment_t old_fs =3D get_fs();
-    int oldfsuid=3D0,oldfsgid=3D0;
+    //int oldfsuid=3D0,oldfsgid=3D0;
     int result=3D0;
=20
     set_fs (KERNEL_DS);
-//Make sure a caller can read or write power as root
-   oldfsuid=3Dcurrent->fsuid;
-   oldfsgid=3Dcurrent->fsgid;
+    /* Can't do this anymore, so we rely on correct filesystem permissions:
+    //Make sure a caller can read or write power as root
+    oldfsuid=3Dcurrent->fsuid;
+    oldfsgid=3Dcurrent->fsgid;
     current->fsuid =3D 0;
     current->fsgid =3D 0;
+    */
=20
     //open file
       filp =3D filp_open(config_path, O_RDWR, 0);
@@ -1697,8 +1699,11 @@ error1:
=20
 error2:
   set_fs (old_fs);
+
+  /*
   current->fsuid=3Doldfsuid;
   current->fsgid=3Doldfsgid;
+  */
=20
 if(result!=3D0) {
     if(buffer)
--=20
1.5.6.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--eyYj78xbwv+yMvU1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKR6JLRO4fQQdv5AwRAm8pAKCmldRAXr9DpdCPSZw1Zi2r08CXdwCdFbdg
DTmuYDqvMS8muSeud2Dv6fs=
=0/5e
-----END PGP SIGNATURE-----

--eyYj78xbwv+yMvU1--
