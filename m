Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZF2NJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZF2NJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF2NJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:09:31 -0400
Received: from recombinator.qemfd.net ([216.27.165.184]:46809 "EHLO qemfd.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751307AbZF2NJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:09:31 -0400
Date: Mon, 29 Jun 2009 09:09:34 -0400
From: nick black <dank@qemfd.net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       man-pages <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       jmorris@namei.org
Subject: Re: [PATCH] hugetlbfs: publish HUGETLBFS_MAGIC via linux/magic.h
Message-ID: <20090629130934.GA835@qemfd.net>
References: <20090629121657.GA9848@qemfd.net>
 <84144f020906290539m3d24af6ap37f9da9371b786dd@mail.gmail.com>
 <20090629130023.GA16674@qemfd.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20090629130023.GA16674@qemfd.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

nick black left as an exercise for the reader:
> Pekka Enberg left as an exercise for the reader:
> > Hi Nick,
> > This looks good to me as well but it should be a separate patch as the
> > change has nothing to do with hugetlbfs. While at it, you should
> > probably move SOCKFS_MAGIC and DEVPTS_SUPER_MAGIC to <linux/magic.h>
> > and remove the definitions from smack.
>=20
> Thanks for the review, Pekka, and I couldn't agree more. Here's a second
> version of the patch, a rather more equal-opportunity unification
> of magic numbers (I'll resend with a new Subject if that's preferred):

Ahh, I realize you want two patches. Here's the minimal hugetlbfs patch;
I'll send the magic number unification as another thread. My worry there is
whether SOCKFS_MAGIC and DEVPTS_SUPER_MAGIC ought be exposed to userspace --
[f]statfs(2)'s manpage makes it clear that HUGETLBFS_MAGIC is to be visible.

[f]statfs(2) *does* refer to DEVFS_SUPER_MAGIC, which doesn't exist anywhere
in the 2.6.31-rc1 tree. A typo, or legacy cruft from the devfs of yesteryea=
r?
Either way, that doesn't answer whether SOCKFS_ ought be exported.

Thanks very much for the feedback!

Signed-off-by: Nick Black <dank@qemfd.net>
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

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpIvQ4ACgkQzjCRTpolKGsjwgCfW5v5XUbee9m7MW6Hokubi4hT
VY4An0a6a76r0CAAFwDRhfinJa6x8Gpi
=ShoN
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
