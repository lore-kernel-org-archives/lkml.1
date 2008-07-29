Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYG2CNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYG2CNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYG2CNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:13:41 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:33304 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYG2CNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:13:40 -0400
Date: Mon, 28 Jul 2008 21:12:11 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 2/30] W1: abort search early on on exit
Message-ID: <20080729021211.GB24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:12:12 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Early abort if the master driver or the hardware goes away in the
middle of a bus search operation.  The alternative is to spam the
print buffer up to 64*64 times with read errors in the case of USB.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 25640f6..aac03f1 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -772,6 +772,11 @@ void w1_search(struct w1_master *dev, u8 search_type, =
w1_slave_found_callback cb
 			/* extract the direction taken & update the device number */
 			tmp64 =3D (triplet_ret >> 2);
 			rn |=3D (tmp64 << i);
+
+			if (test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+				printk(KERN_INFO "Abort w1_search (exiting)\n");
+				return;
+			}
 		}
=20
 		if ( (triplet_ret & 0x03) !=3D 0x03 ) {
--=20
1.4.4.4

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjnx7AI852cse6PARAhhsAJ4sscM0g7WlGQiV5/QaOMH7IE9gSgCeLNCI
p1w9Am+R9ykW63YW2Z4UqDw=
=HIOE
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
