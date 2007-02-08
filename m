Return-Path: <linux-kernel-owner+w=401wt.eu-S1161463AbXBHHqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161463AbXBHHqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 02:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161461AbXBHHqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 02:46:25 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56464 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161451AbXBHHqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 02:46:24 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: dushistov@mail.ru
Subject: [patch] export ufs_fs.h to userspace
Date: Thu, 8 Feb 2007 02:46:16 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, sparc@gentoo.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart61654907.Qbpgro14ry";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702080246.16996.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart61654907.Qbpgro14ry
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

was ufs_fs.h purposefully not exported to userspace or did it just slip=20
through the cracks ?  assuming the latter scenario, the attached patch=20
touches up the relationship between ufs_fs.h and its sub headers (like=20
ufs_fs_sb.h) so that we can export it ... the silo bootloader takes advanta=
ge=20
of this header for example

Signed-off-by: Mike Frysinger <vapier@gentoo.org>

=2D--
=2D-- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -324,6 +324,7 @@ unifdef-y +=3D tty.h
 unifdef-y +=3D types.h
 unifdef-y +=3D udf_fs_i.h
 unifdef-y +=3D udp.h
+unifdef-y +=3D ufs_fs.h
 unifdef-y +=3D uinput.h
 unifdef-y +=3D uio.h
 unifdef-y +=3D unistd.h
=2D-- a/include/linux/ufs_fs.h
+++ b/include/linux/ufs_fs.h
@@ -45,8 +45,10 @@ typedef __u32 __bitwise __fs32;
 typedef __u16 __bitwise __fs16;
 #endif
=20
+#ifdef __KERNEL__
 #include <linux/ufs_fs_i.h>
 #include <linux/ufs_fs_sb.h>
+#endif
=20
 #define UFS_BBLOCK 0
 #define UFS_BBSIZE 8192
@@ -303,7 +305,7 @@ typedef __u16 __bitwise __fs16;
 #define UFS_MAXMNTLEN 512
 #define UFS2_MAXMNTLEN 468
 #define UFS2_MAXVOLLEN 32
=2D/* #define UFS_MAXCSBUFS 31 */
+#define UFS_MAXCSBUFS 31
 #define UFS_LINK_MAX 32000
 /*
 #define	UFS2_NOCSPTRS	((128 / sizeof(void *)) - 4)
=2D-- a/include/linux/ufs_fs_sb.h
+++ b/include/linux/ufs_fs_sb.h
@@ -21,7 +21,6 @@
 struct ufs_sb_private_info;
 struct ufs_cg_private_info;
 struct ufs_csum;
=2D#define UFS_MAXCSBUFS 31
=20
 struct ufs_sb_info {
 	struct ufs_sb_private_info * s_uspi;=09

--nextPart61654907.Qbpgro14ry
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)

iQIVAwUARcrVSEFjO5/oN/WBAQJ9lw//W7JDub8NOPR5eT7y77YbVXlO+m3gqcJe
UTNdr13LyyA9fhxb3SW8Q2EvCpDBzsm1TWjt5VlQQIBlO1XWqcSG9RQeNZspE56g
msep2OrDjxs+pr6dq3NMQozqvtS/ZiVHXU/4FBJT2fIxz87HkiqjDUHZ1LpEQxca
YvbGPzetp/cyx1VESzk6+UQ+2chItgsO0XzA3difLvrBKXhes95f7/2P8D9VltZo
BkLNYLAB6Ga0Ps1Ox6syZrhZyxxfZgDknw8i9gnVeFT1pq8DXOGI4iHl8E/FQN2I
RMm5+GTrwbvQCDbOeBWFV6wifmREngAWy9eweKbxDvGJZGCUo7pGYs/4znLcE7eg
By6bUA1Kbtfr7iPlVTbQ2snxGUnFgwmZnV/L0HjEsUs+MOm2T78qfrdhsjKDeflS
iFTcyFSZP0yDhO2eEsbVjTcEubd1Tq07K6iw6A1ZhfubM4AoweTBHB8BWLD5ZAM9
NGjJoBXK5yEkyi4ql6iYOmiiSSeGVCFbRVfNFO9gkvQ6HamOvuPSi6PdAbQTARuS
2BnbneooK5Waim9amzzeQcQY2280aagmbboHlGtL+ja96U9csymsqltZK9BhBdSv
7CucXt803HYuO1vKvJ0JbjmNGg5xMzJqdsbblgWo/BJUka58SWrn3YV5pmMmmid0
lybxOPjS0yM=
=t1Sk
-----END PGP SIGNATURE-----

--nextPart61654907.Qbpgro14ry--
