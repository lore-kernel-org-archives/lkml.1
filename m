Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbZF2NAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbZF2NAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759195AbZF2NAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:00:23 -0400
Received: from recombinator.qemfd.net ([216.27.165.184]:52759 "EHLO qemfd.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758953AbZF2NAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:00:20 -0400
Date: Mon, 29 Jun 2009 09:00:23 -0400
From: nick black <dank@qemfd.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       man-pages <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       jmorris@namei.org
Subject: Re: [PATCH] hugetlbfs: publish HUGETLBFS_MAGIC via linux/magic.h
Message-ID: <20090629130023.GA16674@qemfd.net>
References: <20090629121657.GA9848@qemfd.net>
 <84144f020906290539m3d24af6ap37f9da9371b786dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <84144f020906290539m3d24af6ap37f9da9371b786dd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Pekka Enberg left as an exercise for the reader:
> Hi Nick,
> This looks good to me as well but it should be a separate patch as the
> change has nothing to do with hugetlbfs. While at it, you should
> probably move SOCKFS_MAGIC and DEVPTS_SUPER_MAGIC to <linux/magic.h>
> and remove the definitions from smack.

Thanks for the review, Pekka, and I couldn't agree more. Here's a second
version of the patch, a rather more equal-opportunity unification
of magic numbers (I'll resend with a new Subject if that's preferred):

Signed-off-by: Nick Black <dank@qemfd.net>
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31=
-rc1-pristine/fs/devpts/inode.c linux-2.6.31-rc1/fs/devpts/inode.c
--- linux-2.6.31-rc1-pristine/fs/devpts/inode.c	2009-06-24 19:25:37.0000000=
00 -0400
+++ linux-2.6.31-rc1/fs/devpts/inode.c	2009-06-29 08:56:14.000000000 -0400
@@ -18,14 +18,13 @@
 #include <linux/mount.h>
 #include <linux/tty.h>
 #include <linux/mutex.h>
+#include <linux/magic.h>
 #include <linux/idr.h>
 #include <linux/devpts_fs.h>
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
=20
-#define DEVPTS_SUPER_MAGIC 0x1cd1
-
 #define DEVPTS_DEFAULT_MODE 0600
 /*
  * ptmx is a new node in /dev/pts and will be unused in legacy (single-
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
@@ -53,4 +54,8 @@
 #define INOTIFYFS_SUPER_MAGIC	0x2BAD1DEA
=20
 #define STACK_END_MAGIC		0x57AC6E9D
+
+#define DEVPTS_SUPER_MAGIC	0x1cd1
+#define SOCKFS_MAGIC		0x534F434B
+
 #endif /* __LINUX_MAGIC_H__ */
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31=
-rc1-pristine/net/socket.c linux-2.6.31-rc1/net/socket.c
--- linux-2.6.31-rc1-pristine/net/socket.c	2009-06-24 19:25:37.000000000 -0=
400
+++ linux-2.6.31-rc1/net/socket.c	2009-06-29 08:55:49.000000000 -0400
@@ -86,6 +86,7 @@
 #include <linux/audit.h>
 #include <linux/wireless.h>
 #include <linux/nsproxy.h>
+#include <linux/magic.h>
=20
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -235,8 +236,6 @@ int move_addr_to_user(struct sockaddr *k
 	return __put_user(klen, ulen);
 }
=20
-#define SOCKFS_MAGIC 0x534F434B
-
 static struct kmem_cache *sock_inode_cachep __read_mostly;
=20
 static struct inode *sock_alloc_inode(struct super_block *sb)
Binary files linux-2.6.31-rc1-pristine/scripts/basic/hash and linux-2.6.31-=
rc1/scripts/basic/hash differ
diff -uprN -X linux-2.6.31-rc1-pristine/Documentation/dontdiff linux-2.6.31=
-rc1-pristine/security/smack/smack_lsm.c linux-2.6.31-rc1/security/smack/sm=
ack_lsm.c
--- linux-2.6.31-rc1-pristine/security/smack/smack_lsm.c	2009-06-24 19:25:3=
7.000000000 -0400
+++ linux-2.6.31-rc1/security/smack/smack_lsm.c	2009-06-29 08:54:50.0000000=
00 -0400
@@ -30,17 +30,11 @@
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <linux/audit.h>
+#include <linux/magic.h>
 #include "smack.h"
=20
 #define task_security(task)	(task_cred_xxx((task), security))
=20
-/*
- * I hope these are the hokeyist lines of code in the module. Casey.
- */
-#define DEVPTS_SUPER_MAGIC	0x1cd1
-#define SOCKFS_MAGIC		0x534F434B
-#define TMPFS_MAGIC		0x01021994
-
 /**
  * smk_fetch - Fetch the smack label from a file.
  * @ip: a pointer to the inode

--=20
                                      Nick Black <dankamongmen@acm.org>
                                             Principal Engineer, McAfee
                                  Grad student, GT College of Computing
                    "np: the class of dashed hopes, and idle dreams..."

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpIuuQACgkQzjCRTpolKGsRWQCeM/UocmNnkren8LoC8KW/swIF
XWcAmgLPEX6D3Ksnol23BUUT4vFhz2pK
=WfM5
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
