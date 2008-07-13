Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbYGNAcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbYGNAcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 20:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYGNAcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 20:32:17 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51178 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbYGNAcQ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 20:32:16 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Michael Halcrow <mhalcrow@us.ibm.com>
cc: linux-kernel@vger.kernel.org
Subject: [mmotm] ecryptfs-do-not-try-to-open-device-files-on-mknod.patch build error
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215937644_19658P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Jul 2008 04:27:24 -0400
Message-ID: <31734.1215937644@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215937644_19658P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Patch ecryptfs-do-not-try-to-open-device-files-on-mknod.patch in mmotm 07=
/11
causes a build error:

  CC =5BM=5D  fs/ecryptfs/file.o
fs/ecryptfs/file.c: In function =E2=80=98ecryptfs_open=E2=80=99:
fs/ecryptfs/file.c:207: error: implicit declaration of function =E2=80=98=
ecryptfs_initersistent_file=E2=80=99
make=5B2=5D: *** =5Bfs/ecryptfs/file.o=5D Error 1
make=5B1=5D: *** =5Bfs/ecryptfs=5D Error 2
make: *** =5Bfs=5D Error 2

Here's what I did to work around it:

--- linux-2.6.26-rc9-mmotd0711/fs/ecryptfs/ecryptfs_kernel.h.dist	2008-07=
-13 03:57:30.000000000 -0400
+++ linux-2.6.26-rc9-mmotd0711/fs/ecryptfs/ecryptfs_kernel.h	2008-07-13 0=
4:21:03.000000000 -0400
=40=40 -712,5 +712,6 =40=40 void ecryptfs_destroy_kthread(void);
 int ecryptfs_privileged_open(struct file **lower_file,
 			     struct dentry *lower_dentry,
 			     struct vfsmount *lower_mnt);
+int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry);
=20
 =23endif /* =23ifndef ECRYPTFS_KERNEL_H */



--==_Exmh_1215937644_19658P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIebxscC3lWbTT17ARAq2LAKD+kw5m/reJluKVb0MKkbzrVamYswCgigTt
vEa6fNr4pV+d06mbSzdaRpg=
=EfSY
-----END PGP SIGNATURE-----

--==_Exmh_1215937644_19658P--
