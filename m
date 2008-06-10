Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbYFJBI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbYFJBI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 21:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbYFJBIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 21:08:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45500 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbYFJBIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 21:08:51 -0400
Date: Tue, 10 Jun 2008 11:08:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: kbuild-current build failure
Message-Id: <20080610110842.30c90c61.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Jun_2008_11_08_42_+1000_TMSC/sktkEUTUSra"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jun_2008_11_08_42_+1000_TMSC/sktkEUTUSra
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

Today's linux-next build (powerpc ppc64_deconfig) failed like this:

  LD      vmlinux.o
/scratch/sfr/next/scripts/Makefile.modpost:44: scripts/Kbuild.include: No s=
uch file or directory
/scratch/sfr/next/scripts/Makefile.modpost:58: scripts/Makefile.lib: No suc=
h file or directory
make[2]: *** No rule to make target `scripts/Makefile.lib'.  Stop.
make[1]: *** [vmlinux] Error 2
make: *** [sub-make] Error 2

This is Linus' tree with just the net-current, arm-current and
kbuild-current trees merged i.e. just bug fixes queued for Linus' current
tree.  The build was done with "O=3D../powerpc_ppc64_defconfig -j24 -s"
i.e. separate object tree and parallel.

Reverting commit 68e9b79c8dad5245f28ab4f3527481b730dbdb61 ("kbuild:
simplify vmlinux link stage") makes the build work again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Jun_2008_11_08_42_+1000_TMSC/sktkEUTUSra
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhN1BoACgkQTgG2atn1QN/cjACghkfPGli08Rlha57BOzGTxt9f
ZVYAn3nSetNS1NuZP3MUaUrlTJM1hJGR
=Nzv1
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jun_2008_11_08_42_+1000_TMSC/sktkEUTUSra--
