Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYC1Mwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYC1Mwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbYC1MvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:51:25 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56320 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbYC1MvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:51:24 -0400
Date: Fri, 28 Mar 2008 07:27:38 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 30/35] W1: ds2490.c ds_reset remove ds_wait_status
Message-ID: <20080328122738.GE3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zljh9u/ceMLi+8mf"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:39 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zljh9u/ceMLi+8mf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds_2490.c 1.16
ds_reset no longer calls ds_wait_status, the result wasn't used and it
would only delay the following data operations.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 1e04ee4..1a87979 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -456,23 +456,15 @@ static int ds_wait_status(struct ds_device *dev, stru=
ct ds_status *st)
 		return 0;
 }
=20
-static int ds_reset(struct ds_device *dev, struct ds_status *st)
+static int ds_reset(struct ds_device *dev)
 {
 	int err;
=20
-	//err =3D ds_send_control(dev, COMM_1_WIRE_RESET | COMM_F | COMM_IM | COM=
M_SE, SPEED_FLEXIBLE);
+	/*err =3D ds_send_control(dev, COMM_1_WIRE_RESET | COMM_F | COMM_IM | COM=
M_SE, SPEED_FLEXIBLE); */
 	err =3D ds_send_control(dev, 0x43, SPEED_NORMAL);
 	if (err)
 		return err;
=20
-	ds_wait_status(dev, st);
-#if 0
-	if (st->command_buffer_status) {
-		printk(KERN_INFO "Short circuit.\n");
-		return -EIO;
-	}
-#endif
-
 	return 0;
 }
=20
@@ -808,12 +800,9 @@ static u8 ds9490r_read_block(void *data, u8 *buf, int =
len)
 static u8 ds9490r_reset(void *data)
 {
 	struct ds_device *dev =3D data;
-	struct ds_status st;
 	int err;
=20
-	memset(&st, 0, sizeof(st));
-
-	err =3D ds_reset(dev, &st);
+	err =3D ds_reset(dev);
 	if (err)
 		return 1;
=20
--=20
1.4.4.4

--Zljh9u/ceMLi+8mf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQ6AI852cse6PARAvxsAKDTf2FRz4sPvlasBnF42LL0OWJjtQCgj+Bl
BzSamXqF+McyPMAG3BH8NXs=
=BojO
-----END PGP SIGNATURE-----

--Zljh9u/ceMLi+8mf--
