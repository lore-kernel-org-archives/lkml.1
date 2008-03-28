Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbYC1MuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbYC1MuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbYC1Mty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:49:54 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56306 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbYC1Mty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:49:54 -0400
Date: Fri, 28 Mar 2008 07:27:54 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 33/35] W1: ds2490.c ds_write_block remove extra ds_wait_status
Message-ID: <20080328122754.GH3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zVyz+SkbhTrRQGHt"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:55 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zVyz+SkbhTrRQGHt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds_wait_status isn't needed between writing data to ds2490 and issuing
the block I/O command to use the data.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 1468077..cde99b7 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -643,8 +643,6 @@ static int ds_write_block(struct ds_device *dev, u8 *bu=
f, int len)
 	if (err < 0)
 		return err;
=20
-	ds_wait_status(dev, &st);
-
 	err =3D ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | COMM_SPU, len);
 	if (err)
 		return err;
--=20
1.4.4.4

--zVyz+SkbhTrRQGHt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7ORKAI852cse6PARAmEWAJ45dAOlzH0GVuw3UUAAjlqVMwiMtACgotTe
8vhyrechl4CfDpoXNqh3UKA=
=WKah
-----END PGP SIGNATURE-----

--zVyz+SkbhTrRQGHt--
