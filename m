Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZBIIaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZBIIaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbZBIIaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:30:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38868 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZBIIaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:30:06 -0500
Date: Mon, 9 Feb 2009 19:29:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next:  Linus' tree build failure
Message-Id: <20090209192958.f7dc3b92.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Feb_2009_19_29_58_+1100_8toOEbzmCGTNF0eV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Feb_2009_19_29_58_+1100_8toOEbzmCGTNF0eV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next build (powerpc allyesconfig) failed like this:

fs/btrfs/locking.c: In function 'btrfs_path_lock_waiting':
fs/btrfs/locking.c:254: error: implicit declaration of function '__raw_spin=
_is_contended'

CONFIG_PREEMPT is not set (since CONFIG_PREEMPT_NONE takes precedence
over it) which means that CONFIG_GENERIC_LOCKBREAK is not set (since it
depends on CONFIG_PREEMPT - at least on powerpc). So spin_is_contended()
is __raw_spin_is_contended().

__raw_spin_is_contended is only defined for UP, MIPS and X86.

Commit b4ce94de9b4d64e8ab3cf155d13653c666e22b9b ("Btrfs: Change btree
locking to use explicit blocking points") from Linus' tree added the
first generic non CONFIG_PREEMPT usage via a call to spin_is_contended().

I got past this for today by building the PowerPC allyesconfig without
btrfs.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Feb_2009_19_29_58_+1100_8toOEbzmCGTNF0eV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmP6YYACgkQjjKRsyhoI8xxEgCfUrDbNS8EI6BhzGaId6qwQnpN
f4MAnivtlLVJ8B+G58KspL4rrWTTVzoo
=u0mT
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Feb_2009_19_29_58_+1100_8toOEbzmCGTNF0eV--
