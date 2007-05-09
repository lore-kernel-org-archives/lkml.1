Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbXEIRkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbXEIRkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbXEIRkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:40:05 -0400
Received: from zigzag.lvk.cs.msu.su ([158.250.17.23]:50426 "EHLO
	zigzag.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbXEIRkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:40:02 -0400
X-Greylist: delayed 1527 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2007 13:40:01 EDT
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: linux-kernel@vger.kernel.org
Subject: Please assist in locating NFS race in old vendor kernel
Date: Wed, 9 May 2007 21:14:23 +0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1663897.KOGxUYzEDp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705092114.29041@sercond.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1663897.KOGxUYzEDp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello.

I'm currently working with an embedded system based on very old,=20
2.4.17-based, vendor kernel.

Among other issues, there is a race in NFS code, that I'm currently trying=
=20
to understand and fix.

The race is the following.
Some i/o is done on a file located on NFS-mounted filesystem. At some=20
moment, ftruncate() is called. And in very rare but still reproducable=20
cases:
=2D first inode->i_size is set to the new value, in process context
=2D then inode->i_size is restored to old value, in rpciod context.
I was able to catch this by adding some logging to the point where=20
__nfs_refresh_inode() updates inode->i_size.

Looks like inode size is being broken (by restore of old value) by=20
completeion handler of RPC operation that was started before ftruncate().

The test on which the race is reproduced more or less reliably,=20
is "fsx-linux" from LTP suite.

System in question is SMP - thus making race happen more often.

I guess the race is long fixed in more modern kernels.
But I'm not familiar with NFS code, and after some attempts to find=20
something I feel lost.

Could someone more familiar with NFS implementaion please point me where to=
=20
look?

Nikita

--nextPart1663897.KOGxUYzEDp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGQgF0v3x5OskTLdsRAvP2AKCROhqQxDxemRTy01Ej+Ab8PZuX+wCfevp7
v+Xvs4pX6LBI6vQwQTlApzM=
=Jdrw
-----END PGP SIGNATURE-----

--nextPart1663897.KOGxUYzEDp--
