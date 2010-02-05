Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab0BEFQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 00:16:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54050 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab0BEFQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 00:16:56 -0500
Date: Fri, 5 Feb 2010 16:16:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: upcoming percpu changes
Message-Id: <20100205161648.086375b9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__5_Feb_2010_16_16_48_+1100_8K0PUPa9no.xJJ6a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Feb_2010_16_16_48_+1100_8K0PUPa9no.xJJ6a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The percpu tree currently in linux-next
(git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git#for-next)
contains a patch to remove the "per_cpu_" prefix from percpu variables
followed by  a set of patches to annotate all the percpu variables (and
accessing variables) with a __percpu tag to put them into a separate
sparse name space.  These latter patches are causing some merge conflicts
with a couple of trees (and will most likely cause more before the merge
window).  A solution to this is for you to accept the patch below into
your tree now and then the annotating patches can be sent to the
respective maintainers directly.

Of course, this assumes that you will accept the percpu changes during
the next merge window (and they are not completely without controversy)
and the proponents actually submit them :-).

What do you think?

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 5 Feb 2010 16:09:11 +1100
Subject: [PATCH] percpu: add __percpu for sparse

This is to make the annotation of percpu variables during the next merge
window less painfull.

Extracted from a patch by Rusty Russell.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/compiler.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 5be3dab..188fcae 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -15,6 +15,7 @@
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
+# define __percpu	__attribute__((noderef, address_space(3)))
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
 #else
@@ -32,6 +33,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __acquire(x) (void)0
 # define __release(x) (void)0
 # define __cond_lock(x,c) (c)
+# define __percpu
 #endif
=20
 #ifdef __KERNEL__
--=20
1.6.6.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__5_Feb_2010_16_16_48_+1100_8K0PUPa9no.xJJ6a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktrqcAACgkQjjKRsyhoI8xP1ACeKorj+6KLAt7vuLZZNxJcGPHq
M80AoKU/iJbHMujGAeoG2G9wLRIbbcBM
=FE9I
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Feb_2010_16_16_48_+1100_8K0PUPa9no.xJJ6a--
