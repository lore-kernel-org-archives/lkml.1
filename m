Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbYG2C1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbYG2C1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbYG2C1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:27:04 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:58125 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbYG2C1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:27:00 -0400
Date: Mon, 28 Jul 2008 21:26:55 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 25/30] W1: ds2490.c ds_reset remove ds_wait_status
Message-ID: <20080729022655.GY24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qwWC3uIwaXcGNtT+"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:26:56 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qwWC3uIwaXcGNtT+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds_reset no longer calls ds_wait_status, the result wasn't used and it
would only delay the following data operations.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 0bcdd3f..eb902ab 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -457,7 +457,7 @@ static int ds_wait_status(struct ds_device *dev, struct=
 ds_status *st)
 		return 0;
 }
=20
-static int ds_reset(struct ds_device *dev, struct ds_status *st)
+static int ds_reset(struct ds_device *dev)
 {
 	int err;
=20
@@ -466,14 +466,6 @@ static int ds_reset(struct ds_device *dev, struct ds_s=
tatus *st)
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
@@ -809,12 +801,9 @@ static u8 ds9490r_read_block(void *data, u8 *buf, int =
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

--qwWC3uIwaXcGNtT+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn/vAI852cse6PARArspAKC8DUD0jO/JyPkNW4oAHiVG9vU3DACgyXIl
9EFntL7bwoa/lfpV2q3WXgI=
=GMpg
-----END PGP SIGNATURE-----

--qwWC3uIwaXcGNtT+--
