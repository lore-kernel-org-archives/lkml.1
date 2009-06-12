Return-Path: <linux-kernel-owner+w=401wt.eu-S1761568AbZFLGbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568AbZFLGbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 02:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759018AbZFLGbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 02:31:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56696 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZFLGbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 02:31:03 -0400
Date: Fri, 12 Jun 2009 16:30:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: linux-next: tip tree build failure
Message-Id: <20090612163054.96bff723.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Jun_2009_16_30_54_+1000_0/PcVxAoTQ5SJpxJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jun_2009_16_30_54_+1000_0/PcVxAoTQ5SJpxJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 allmodconfig) failed like this:

arch/x86/kernel/irqinit.c: In function 'apic_intr_init':
arch/x86/kernel/irqinit.c:191: error: 'MCE_SELF_VECTOR' undeclared (first u=
se in this function)
arch/x86/kernel/irqinit.c:191: error: 'mce_self_interrupt' undeclared (firs=
t use in this function)

This code was introduced in a merge
(940010c5a314a7bd9b498593bc6ba1718ac5aec5) in the perfcounters tree that
is now in Linus' tree.  The CONFIG variable that allows it to be enabled
was introduced in commit 4efc0670baf4b14bc95502e54a83ccf639146125 ("x86,
mce: use 64bit machine check code on 32bit") in the tip/x86 tree.

The necessary define and function are introduced in commit
ccc3c3192ae78dd56dcdf5353fd1a9ef5f9a3e2b ("x86, mce: implement
bootstrapping for machine check wakeups") in the tip/x86/mce3 (mce4)
branch which is not included in Linus' tree or tip/auto-latest.

I just commented the code out for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Jun_2009_16_30_54_+1000_0/PcVxAoTQ5SJpxJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkox9h8ACgkQjjKRsyhoI8yvOACgpCsIMbdhEZxoUsSntQfScxww
9cUAn0m9sDT+9qKLWE8AwDY6b9J0sb42
=h2Ae
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jun_2009_16_30_54_+1000_0/PcVxAoTQ5SJpxJ--
