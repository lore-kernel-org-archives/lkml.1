Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbYG2C0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbYG2C0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbYG2CZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:25:37 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:50137 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580AbYG2CZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:25:36 -0400
Date: Mon, 28 Jul 2008 21:25:31 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 21/30] W1: ds2490.c ds_write_bit, grouping error, disable readback
Message-ID: <20080729022531.GU24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nZJAkgcjPzQrJB+u"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:25:31 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nZJAkgcjPzQrJB+u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds_write_bit doesn't read the input buffer, so add COMM_ICP and a
comment that it will no longer generate a read back data byte.  If
there is an extra data byte later on then it will cause an error and
discard what data was there.  Corrected operator ordering for
ds_send_control.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 8ab2c86..7acf6d2 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -525,7 +525,12 @@ static int ds_write_bit(struct ds_device *dev, u8 bit)
 	int err;
 	struct ds_status st;
=20
-	err =3D ds_send_control(dev, COMM_BIT_IO | COMM_IM | (bit) ? COMM_D : 0, =
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

--nZJAkgcjPzQrJB+u
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn+bAI852cse6PARAoClAJ9ZgwPlxswm8xjeXjvZNs6qCpxqrQCbBfWw
7LQLCzFlxBI5mMG3PSql43o=
=YJ7P
-----END PGP SIGNATURE-----

--nZJAkgcjPzQrJB+u--
