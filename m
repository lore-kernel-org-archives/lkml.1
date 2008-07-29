Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbYG2C2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbYG2C2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYG2C23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:28:29 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:58131 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYG2C22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:28:28 -0400
Date: Mon, 28 Jul 2008 21:28:08 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 27/30] W1: ds2490.c magic number work
Message-ID: <20080729022808.GA24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tArtifyz9D3PkaxN"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:28:08 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tArtifyz9D3PkaxN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This replaces some magic numbers with marcos and corrects one marco.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 754a4bb..d9e07d6 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -88,7 +88,7 @@
 #define COMM_DT				0x2000
 #define COMM_SPU			0x1000
 #define COMM_F				0x0800
-#define COMM_NTP			0x0400
+#define COMM_NTF			0x0400
 #define COMM_ICP			0x0200
 #define COMM_RST			0x0100
=20
@@ -440,7 +440,7 @@ static int ds_wait_status(struct ds_device *dev, struct=
 ds_status *st)
 			printk("\n");
 		}
 #endif
-	} while(!(buf[0x08] & 0x20) && !(err < 0) && ++count < 100);
+	} while (!(buf[0x08] & ST_IDLE) && !(err < 0) && ++count < 100);
=20
 	if (err >=3D 16 && st->status & ST_EPOF) {
 		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
@@ -470,8 +470,16 @@ static int ds_reset(struct ds_device *dev)
 {
 	int err;
=20
-	//err =3D ds_send_control(dev, COMM_1_WIRE_RESET | COMM_F | COMM_IM | COM=
M_SE, SPEED_FLEXIBLE);
-	err =3D ds_send_control(dev, 0x43, SPEED_NORMAL);
+	/* Other potentionally interesting flags for reset.
+	 *
+	 * COMM_NTF: Return result register feedback.  This could be used to
+	 * detect some conditions such as short, alarming presence, or
+	 * detect if a new device was detected.
+	 *
+	 * COMM_SE which allows SPEED_NORMAL, SPEED_FLEXIBLE, SPEED_OVERDRIVE:
+	 * Select the data transfer rate.
+	 */
+	err =3D ds_send_control(dev, COMM_1_WIRE_RESET | COMM_IM, SPEED_NORMAL);
 	if (err)
 		return err;
=20
--=20
1.4.4.4

--tArtifyz9D3PkaxN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjoA4AI852cse6PARAk8DAJoCKbdWo9jFH34vLK0JG5v2ew3TuwCeMzeF
WZlHwtBcSCDkAJLjnZ8wWJM=
=sPpH
-----END PGP SIGNATURE-----

--tArtifyz9D3PkaxN--
