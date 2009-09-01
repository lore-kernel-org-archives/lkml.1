Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbZIAE74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbZIAE74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 00:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZIAE74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 00:59:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55087 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZIAE7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 00:59:55 -0400
Date: Tue, 1 Sep 2009 14:59:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: block tree build failure
Message-Id: <20090901145949.58610c23.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Sep_2009_14_59_49_+1000_DXM84W4B5dk9oATB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Sep_2009_14_59_49_+1000_DXM84W4B5dk9oATB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next build (x86_64 allmodconfig) failed like this:

fs/ubifs/budget.c: In function 'shrink_liability':
fs/ubifs/budget.c:74: warning: passing argument 1 of 'generic_sync_sb_inode=
s' from incompatible pointer type
include/linux/fs.h:2085: note: expected 'struct writeback_control *' but ar=
gument is of type 'struct super_block *'
fs/ubifs/budget.c:74: error: too many arguments to function 'generic_sync_s=
b_inodes'
fs/ubifs/budget.c:86: warning: passing argument 1 of 'generic_sync_sb_inode=
s' from incompatible pointer type
include/linux/fs.h:2085: note: expected 'struct writeback_control *' but ar=
gument is of type 'struct super_block *'
fs/ubifs/budget.c:86: error: too many arguments to function 'generic_sync_s=
b_inodes'

Caused by commit 2fa24dd6ef3c67be20fde192f67fe519ea8a4b91 ("writeback:
switch to per-bdi threads for flushing data").

I have used the version of the block tree from next-20090831 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Sep_2009_14_59_49_+1000_DXM84W4B5dk9oATB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqcqkUACgkQjjKRsyhoI8yjNACfdO838YFpU8wszVavYhM3OWp+
ytUAnA5l1P6Man2+Qt2DhHKSzgQV5Pdc
=N4La
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Sep_2009_14_59_49_+1000_DXM84W4B5dk9oATB--
