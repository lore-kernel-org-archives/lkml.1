Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYD3EAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYD3EAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 00:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYD3EAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 00:00:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39776 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbYD3EAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 00:00:34 -0400
Date: Wed, 30 Apr 2008 14:00:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <dgc@sgi.com>
Cc: linux-next@vger.kernel.org, xfs-masters@oss.sgi.com,
       Christoph Hellwig <hch@infradead.org>,
       Lachlan McIlroy <lachlan@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: xfs build failure
Message-Id: <20080430140027.6cd83fd0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Apr_2008_14_00_27_+1000_3VhS6R1lHf85y9YT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Apr_2008_14_00_27_+1000_3VhS6R1lHf85y9YT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) fails like this:

fs/xfs/xfs_ialloc.c: In function 'xfs_ialloc_ag_alloc':
fs/xfs/xfs_ialloc.c:301: error: implicit declaration of function 'random32'

I added

#include <linux/random.h>

after the other includes in fs/xfs/xfs_ialloc.c, but there is probably a
better fix.

The commit that seems to have caused this
6309a0720469beb77e0ab75f403a98a0aba4140c ("XFS] Don't initialise new
inode generation numbers to zero") in the xfs tree that I have seems to
have just gone into Linus' tree as commit
359346a9655c8800408ed3ca44517ac7ea95c197.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Apr_2008_14_00_27_+1000_3VhS6R1lHf85y9YT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIF+7fTgG2atn1QN8RApK6AJ9P8vULctuJEO3cHl8AZV7cjklLqwCgiTP4
yLhTbYjTCF9Z6ZyAnyV3gIA=
=WovH
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Apr_2008_14_00_27_+1000_3VhS6R1lHf85y9YT--
