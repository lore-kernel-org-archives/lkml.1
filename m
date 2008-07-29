Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYG2CZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYG2CZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYG2CYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:24:52 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:50128 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYG2CYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:24:51 -0400
Date: Mon, 28 Jul 2008 21:24:46 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 18/30] W1: ds1wm.c msleep for reset
Message-ID: <20080729022446.GR24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3XZQkxCYp0f/VEFS"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:24:47 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3XZQkxCYp0f/VEFS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Like the previous w1_io.c reset coments and msleep patch, I don't have
the hardware to verify the change, but I think it is safe.  It also
helps to see a comment like this in the code.
"We'll wait a bit longer just to be sure."
If they are going to calculate delaying 324.9us, but actually delay
500us, why not just give up the CPU and sleep?  This is designed for a
battery powered ARM system, avoiding busywaiting has to be good for
battery life.

I sent a request for testers March 7, 2008 to the Linux kernel mailing
list and two developers who have patches for ds1wm.c, but I didn't get
any respons.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds1wm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index ea894bf..29e144f 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -160,8 +160,10 @@ static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
 	 *     625 us - 60 us - 240 us - 100 ns =3D 324.9 us
 	 *
 	 * We'll wait a bit longer just to be sure.
+	 * Was udelay(500), but if it is going to busywait the cpu that long,
+	 * might as well come back later.
 	 */
-	udelay(500);
+	msleep(1);
=20
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
 		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
--=20
1.4.4.4

--3XZQkxCYp0f/VEFS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn9uAI852cse6PARAsOlAJ9mJCnO5108nPwa4fTaWLNUJr/0fgCgouS+
Ym4RTXlO1OUl3rTwOb0+wT4=
=eZL8
-----END PGP SIGNATURE-----

--3XZQkxCYp0f/VEFS--
