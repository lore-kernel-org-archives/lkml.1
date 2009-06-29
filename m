Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbZF2NYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbZF2NYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZF2NYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:24:24 -0400
Received: from recombinator.qemfd.net ([216.27.165.184]:50990 "EHLO qemfd.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751226AbZF2NYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:24:24 -0400
Date: Mon, 29 Jun 2009 09:24:27 -0400
From: nick black <dank@qemfd.net>
To: William Irwin <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org, man-pages <mtk.manpages@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] hugetlbfs: publish HUGETLBFS_MAGIC via linux/magic.h
 (updated)
Message-ID: <20090629132427.GA2677@qemfd.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

statfs(2)'s man page (release 3.21) lists HUGETLBFS_MAGIC among other
constants of its type (these #define's really ought perhaps become an enum,
but that's another patch). It isn't actually exported, though; it's buried
within inode.c in fs/hugetlbfs/. This patch updates the interface against
documentation and expectation, bringing hugetlbfs support to statfs(2).=20
Thanks to Pekka Enberg for feedback!

Signed-off-by: Nick Black <dank@qemfd.net>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31=
-rc1-pristine/fs/hugetlbfs/inode.c linux-2.6.31-rc1/fs/hugetlbfs/inode.c
--- linux-2.6.31-rc1-pristine/fs/hugetlbfs/inode.c	2009-06-24 19:25:37.0000=
00000 -0400
+++ linux-2.6.31-rc1/fs/hugetlbfs/inode.c	2009-06-29 07:52:43.000000000 -04=
00
@@ -31,12 +31,10 @@
 #include <linux/statfs.h>
 #include <linux/security.h>
 #include <linux/ima.h>
+#include <linux/magic.h>
=20
 #include <asm/uaccess.h>
=20
-/* some random number */
-#define HUGETLBFS_MAGIC	0x958458f6
-
 static const struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
 const struct file_operations hugetlbfs_file_operations;
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31=
-rc1-pristine/include/linux/magic.h linux-2.6.31-rc1/include/linux/magic.h
--- linux-2.6.31-rc1-pristine/include/linux/magic.h	2009-06-24 19:25:37.000=
000000 -0400
+++ linux-2.6.31-rc1/include/linux/magic.h	2009-06-29 08:55:57.000000000 -0=
400
@@ -13,6 +13,7 @@
 #define SECURITYFS_MAGIC	0x73636673
 #define SELINUX_MAGIC		0xf97cff8c
 #define TMPFS_MAGIC		0x01021994
+#define HUGETLBFS_MAGIC 	0x958458f6	/* some random number */
 #define SQUASHFS_MAGIC		0x73717368
 #define EFS_SUPER_MAGIC		0x414A53
 #define EXT2_SUPER_MAGIC	0xEF53
--=20
                                      Nick Black <dankamongmen@acm.org>
                                             Principal Engineer, McAfee
                                  Grad student, GT College of Computing
                    "np: the class of dashed hopes, and idle dreams..."

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpIwIsACgkQzjCRTpolKGtnnQCgm+ptHf4nwaUVTg9ygXxd+Zuo
S8sAoKE4LuMMwIz9hBrbfQkVXpOazhuZ
=R91u
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
