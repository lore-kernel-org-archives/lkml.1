Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbZDSHYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbZDSHYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 03:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZDSHYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 03:24:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42317 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZDSHYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 03:24:46 -0400
Date: Sun, 19 Apr 2009 17:24:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>
Subject: mips build failure
Message-Id: <20090419172436.6d0e741a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__19_Apr_2009_17_24_36_+1000_P.qBmo6YX6D.ipq0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__19_Apr_2009_17_24_36_+1000_P.qBmo6YX6D.ipq0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

You probably already now about this, but our build (mips ip32_defconfig)
of Linus' tree (commit aefe6475720bd5eb8aacbc881488f3aa65618562 "Merge
branch 'upstream-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev") gets
these errors (we have actually been getting these errors since 2.6.30-rc1):

In file included from arch/mips/include/asm/compat.h:7,
                 from include/linux/compat.h:15,
                 from arch/mips/kernel/asm-offsets.c:12:
include/linux/seccomp.h: In function 'prctl_get_seccomp':
include/linux/seccomp.h:30: error: 'EINVAL' undeclared (first use in this f=
unction)
include/linux/seccomp.h:30: error: (Each undeclared identifier is reported =
only once
include/linux/seccomp.h:30: error: for each function it appears in.)
include/linux/seccomp.h: In function 'prctl_set_seccomp':
include/linux/seccomp.h:35: error: 'EINVAL' undeclared (first use in this f=
unction)

Bisected down to commit ac44021fccd8f1f2b267b004f23a2e8d7ef05f7b
"kmemtrace, rcu: don't include unnecessary headers, allow kmemtrace w/
tracepoints".

http://kisskb.ellerman.id.au/kisskb/buildresult/330240/
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__19_Apr_2009_17_24_36_+1000_P.qBmo6YX6D.ipq0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknq0bQACgkQjjKRsyhoI8yPyACgvM2RG8LekwRKKrz1issoqozl
rzwAoJH3Zo9zZpFTraxbCIvFPO+pfJJw
=AUJx
-----END PGP SIGNATURE-----

--Signature=_Sun__19_Apr_2009_17_24_36_+1000_P.qBmo6YX6D.ipq0--
