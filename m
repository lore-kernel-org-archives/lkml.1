Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZKNGuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZKNGuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZKNGun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:50:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33628 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZKNGum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:50:42 -0500
Date: Sat, 14 Nov 2009 17:50:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: linux-next: net tree build failure
Message-Id: <20091114175041.61bdb27f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__14_Nov_2009_17_50_41_+1100_ERW5mjh5EutBZl8d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__14_Nov_2009_17_50_41_+1100_ERW5mjh5EutBZl8d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (alpha defconfig) failed like this:

arch/alpha/kernel/systbls.S:507: Error: .err encountered

Caused by commit a2e2725541fad72416326798c2d7fa4dafb7d337 ("net:
Introduce recvmmsg socket syscall") which added a syscall to the alpha
syscall table but forgot to update NR_SYSCALLS in
arch/alpha/include/asm/unistd.h (it also didn't add the __NR_ constant
thee either).

I suspect that this is true for a few other architectures as well
(including sparc?).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__14_Nov_2009_17_50_41_+1100_ERW5mjh5EutBZl8d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr+U0EACgkQjjKRsyhoI8z01gCeIneT74DfWNzY3nPUG2ClAYLA
AJgAn0TYwRWVm69Ej2UFV3WiFuAHGP2E
=f0b+
-----END PGP SIGNATURE-----

--Signature=_Sat__14_Nov_2009_17_50_41_+1100_ERW5mjh5EutBZl8d--
