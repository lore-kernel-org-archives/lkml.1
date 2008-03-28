Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYC1Mvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYC1Mvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbYC1Mu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:50:58 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56316 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbYC1Mu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:50:57 -0400
Date: Fri, 28 Mar 2008 07:27:20 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 26/35] W1: ds2490.c ds_write_bit disable readback
Message-ID: <20080328122720.GA3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LG5jgFgJbJFFiAfj"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:20 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LG5jgFgJbJFFiAfj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds2490.c 1.11
ds_write_bit doesn't read the input buffer, so add COMM_ICP and a
comment that it will no longer generate a read back data byte.  If
there is an extra data byte later on then it will cause an error and
discard what data was there.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 6778bd3..e0e9325 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -525,7 +525,12 @@ static int ds_write_bit(struct ds_device *dev, u8 bit)
 	int err;
 	struct ds_status st;
=20
-	err =3D ds_send_control(dev, COMM_BIT_IO | COMM_IM | (bit ? COMM_D : 0), =
0);
+	/* Set COMM_ICP to write without a readback.  Note, this will
+	 * produce one time slot, a down followed by an up with COMM_D
+	 * only determing the timing.
+	 */
+	err =3D ds_send_control(dev, COMM_BIT_IO | COMM_IM | COMM_ICP |
+		(bit ? COMM_D : 0), 0);
 	if (err)
 		return err;
=20
--=20
1.4.4.4

--LG5jgFgJbJFFiAfj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQoAI852cse6PARAo3SAJ9XKJhmehuuhSiYperq/wA0Vw+b0QCfdI+V
c6V3oiJUR9CRYuMmeCdv600=
=szUm
-----END PGP SIGNATURE-----

--LG5jgFgJbJFFiAfj--
