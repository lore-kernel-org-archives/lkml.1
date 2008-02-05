Return-Path: <linux-kernel-owner+w=401wt.eu-S1761770AbYBEWio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770AbYBEWio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbYBEWii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:38:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36055 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbYBEWih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:38:37 -0500
Date: Wed, 6 Feb 2008 09:38:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>
Subject: Ordering of commits and breaking bisecting
Message-Id: <20080206093817.60091256.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Feb_2008_09_38_17_+1100_qcvXW_Dt3wt6/Law"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Feb_2008_09_38_17_+1100_qcvXW_Dt3wt6/Law
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Can we be a bit more careful with the ordering of commits, please?
Commit d22a6966b8029913fac37d078ab2403898d94c63 (iommu sg merging: add
accessors for segment_boundary_mask in device_dma_parameters())
introduces the dma_get_seg_boundary accessor which is used in the
*preceding* commits fb3475e9b6bfa666107512fbd6006c26014f04b8 (for
powerpc), and 1b39b077789955c8389488d53d075518fdcd582e and
fde9a1094ddf2892188a8a0eccda527de47cba8e (for x86).

Thus we have another set of commits that will break bisection.  This one
was easily avoidable.

A little more care is needed.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Feb_2008_09_38_17_+1100_qcvXW_Dt3wt6/Law
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHqOVfTgG2atn1QN8RApnhAJ9JDaqyzpZRgFr9CWlH6iW3iHVznQCeOnQq
L8OdujKvKg7ZcdXImyxeJL0=
=shtE
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Feb_2008_09_38_17_+1100_qcvXW_Dt3wt6/Law--
