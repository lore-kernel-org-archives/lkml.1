Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0CDATo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:19:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43740 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab0CDATh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:19:37 -0500
Date: Thu, 4 Mar 2010 11:19:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the xfs tree
Message-Id: <20100304111930.86f7cc62.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Mar_2010_11_19_30_+1100_6ihG1sh=QK944ARd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Mar_2010_11_19_30_+1100_6ihG1sh=QK944ARd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the xfs tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

fs/xfs/linux-2.6/xfs_aops.c: In function 'xfs_end_io':
fs/xfs/linux-2.6/xfs_aops.c:232: warning: 'error' may be used uninitialized=
 in this function

Introduced by commit 77d7a0c2eeb285c9069e15396703d0cb9690ac50 ("xfs:
Non-blocking inode locking in IO completion").

I can't tell if this is a false positive.  If the first two "if"
statement bodies are skipped, then error is tested uninitialised.  It is
possible that at least one of them has to be executed.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Mar_2010_11_19_30_+1100_6ihG1sh=QK944ARd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuO/JMACgkQjjKRsyhoI8wpoACgoa9CTghmVHeH2QnVMO+CS3ig
N4UAoLxVvvQpltR5R19OrPubd/yz3eiB
=tzWo
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Mar_2010_11_19_30_+1100_6ihG1sh=QK944ARd--
