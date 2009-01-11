Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbZAKXtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbZAKXtI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 18:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZAKXsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 18:48:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47010 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbZAKXsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 18:48:52 -0500
Date: Mon, 12 Jan 2009 10:48:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
Subject: linux-next: origin tree build failure
Message-Id: <20090112104837.69feedec.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_Jan_2009_10_48_37_+1100_XIVE0LGEI43ZezO6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Jan_2009_10_48_37_+1100_XIVE0LGEI43ZezO6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

arch/powerpc/platforms/pasemi/cpufreq.c: In function 'pas_cpufreq_cpu_init':
arch/powerpc/platforms/pasemi/cpufreq.c:216: error: incompatible types in a=
ssignment
arch/powerpc/platforms/powermac/cpufreq_64.c: In function 'g5_cpufreq_cpu_i=
nit':
arch/powerpc/platforms/powermac/cpufreq_64.c:365: error: incompatible types=
 in assignment
arch/powerpc/platforms/cell/cbe_cpufreq.c: In function 'cbe_cpufreq_cpu_ini=
t':
arch/powerpc/platforms/cell/cbe_cpufreq.c:121: error: incompatible types in=
 assignment

Caused by commit 835481d9bcd65720b473db6b38746a74a3964218 ("cpumask:
convert struct cpufreq_policy to cpumask_var_t") which missed updating
all the powerpc (at least) cpufreq drivers.

Reverting that one commit required fixups, so I reverted merge commit
4e9b1c184cadbece3694603de5f880b6e35bd7a7 ("Merge branch 'cpus4096-for-linus'
of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip")
instead.

I am hoping that this will be fixed soon and that revert doesn't
propagate more pain through today's linux-next.

This branch was last committed to in the tip tree on Jan 7 (the patch
above was committed on Jan 6) but was never propagated to linux-next
before being merged into your tree yesterday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Jan_2009_10_48_37_+1100_XIVE0LGEI43ZezO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklqhVUACgkQjjKRsyhoI8wnagCeJqHvFLMK409R5XLtEldF0dBY
aRcAnij8+jRXEfuQjByOla7llQ/pCSd+
=ZPEf
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Jan_2009_10_48_37_+1100_XIVE0LGEI43ZezO6--
