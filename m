Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbYC1M7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbYC1M7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbYC1Mzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:42 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbYC1Mzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:39 -0400
Date: Fri, 28 Mar 2008 07:27:00 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 22/35] W1: ds1wm.c msleep for reset
Message-ID: <20080328122700.GW3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cf1qy2gtPj5yoBMh"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:00 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cf1qy2gtPj5yoBMh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

masters/ds1wm.c 1.4
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

--Cf1qy2gtPj5yoBMh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OQUAI852cse6PARAl9cAKDMgTHFYccFTiry12adD87ApJwsBACfSvon
2ulY9xkzp+HT66kpTNf0iYI=
=jsLx
-----END PGP SIGNATURE-----

--Cf1qy2gtPj5yoBMh--
