Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYG2CZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYG2CZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755480AbYG2CZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:25:07 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:50131 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151AbYG2CZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:25:05 -0400
Date: Mon, 28 Jul 2008 21:25:00 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 19/30] W1: ds2490.c correct print message
Message-ID: <20080729022500.GS24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/KohU7xR/z4Rz7fl"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:25:01 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/KohU7xR/z4Rz7fl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Corrected print message, it was writing not reading, this also prints
the endpoint used for the write instead of hardcoding it.
        Failed to write 1-wire data to ep0x%x: err=3D%d.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index b63b5e0..c8365fb 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -341,7 +341,8 @@ static int ds_send_data(struct ds_device *dev, unsigned=
 char *buf, int len)
 	count =3D 0;
 	err =3D usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, dev->ep[EP_DAT=
A_OUT]), buf, len, &count, 1000);
 	if (err < 0) {
-		printk(KERN_ERR "Failed to read 1-wire data from 0x02: err=3D%d.\n", err=
);
+		printk(KERN_ERR "Failed to write 1-wire data to ep0x%x: "
+			"err=3D%d.\n", dev->ep[EP_DATA_OUT], err);
 		return err;
 	}
=20
--=20
1.4.4.4

--/KohU7xR/z4Rz7fl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn98AI852cse6PARAvM4AKCyotHZ7mtMQCNTmckJoGvIv7iP3wCeIXqe
auL1MdV2979LKgpb08HG/vw=
=nfle
-----END PGP SIGNATURE-----

--/KohU7xR/z4Rz7fl--
