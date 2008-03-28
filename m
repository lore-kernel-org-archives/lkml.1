Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYC1Mud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYC1Mud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYC1MuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:50:16 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56308 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbYC1MuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:50:15 -0400
Date: Fri, 28 Mar 2008 07:27:15 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 25/35] W1: ds2490.c fix grouping error in ds_write_bit
Message-ID: <20080328122715.GZ3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L4xCDQ7GT+ph8Lmk"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:15 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L4xCDQ7GT+ph8Lmk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds2490.c 1.10

Bad grouping, fixed order of operations.  It would previously always
return COMM_D.
=66rom
COMM_BIT_IO | COMM_IM | (bit) ? COMM_D : 0
to
COMM_BIT_IO | COMM_IM | (bit ? COMM_D : 0)

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index ac27f89..6778bd3 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -525,7 +525,7 @@ static int ds_write_bit(struct ds_device *dev, u8 bit)
 	int err;
 	struct ds_status st;
=20
-	err =3D ds_send_control(dev, COMM_BIT_IO | COMM_IM | (bit) ? COMM_D : 0, =
0);
+	err =3D ds_send_control(dev, COMM_BIT_IO | COMM_IM | (bit ? COMM_D : 0), =
0);
 	if (err)
 		return err;
=20
--=20
1.4.4.4

--L4xCDQ7GT+ph8Lmk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQjAI852cse6PARAlsOAJ9HIWDlvq6DpKCkreEtqwZSjb3RYwCeKva2
CoCpA5byvRSt4UPbXpDbz+E=
=GMeQ
-----END PGP SIGNATURE-----

--L4xCDQ7GT+ph8Lmk--
