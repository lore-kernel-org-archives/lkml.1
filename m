Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbYC1MxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbYC1MxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbYC1Mvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:51:35 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56322 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbYC1Mve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:51:34 -0400
Date: Fri, 28 Mar 2008 07:27:49 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 32/35] W1: ds2490.c magic number work
Message-ID: <20080328122749.GG3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M8g8Xvd1npd+rU3W"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:50 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M8g8Xvd1npd+rU3W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ds2490.c 1.16
macro name typo
s/COMM_NTP/COMM_NTF/

ds2490.c 1.7
specify the commands in ds_reset
s/0x43/COMM_1_WIRE_RESET | COMM_IM/

ds2490.c 1.18
replace magic bitmask in ds_wait_status
s/0x20/ST_IDLE/

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds2490.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 2d1bdbc..1468077 100644
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
@@ -439,7 +439,7 @@ static int ds_wait_status(struct ds_device *dev, struct=
 ds_status *st)
 			printk("\n");
 		}
 #endif
-	} while(!(buf[0x08] & 0x20) && !(err < 0) && ++count < 100);
+	} while(!(buf[0x08] & ST_IDLE) && !(err < 0) && ++count < 100);
=20
 	if(err>=3D16 && st->status & ST_EPOF) {
 		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
@@ -470,7 +470,11 @@ static int ds_reset(struct ds_device *dev)
 	int err;
=20
 	/*err =3D ds_send_control(dev, COMM_1_WIRE_RESET | COMM_F | COMM_IM | COM=
M_SE, SPEED_FLEXIBLE); */
-	err =3D ds_send_control(dev, 0x43, SPEED_NORMAL);
+	/* Add COMM_NTF to return result status.  This could initiate
+	 * a bus search if a new presense is detected, but that isn't
+	 * supported.
+	 */
+	err =3D ds_send_control(dev, COMM_1_WIRE_RESET | COMM_IM, SPEED_NORMAL);
 	if (err)
 		return err;
=20
--=20
1.4.4.4

--M8g8Xvd1npd+rU3W
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7ORFAI852cse6PARApj0AJ4p4+GqWyH7dayGb0fhAAT2kvD8oACgj5vb
DeKD+m+qFLp/eJh6uNictAs=
=FlKb
-----END PGP SIGNATURE-----

--M8g8Xvd1npd+rU3W--
