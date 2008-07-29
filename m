Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbYG2CWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbYG2CWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYG2CWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:22:43 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:50116 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYG2CWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:22:42 -0400
Date: Mon, 28 Jul 2008 21:22:38 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 14/30] W1: w1_therm consistent mutex access code cleanup
Message-ID: <20080729022238.GN24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XBg9NAhDNArbJUtw"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:22:38 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XBg9NAhDNArbJUtw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

sl->master->mutex and dev->mutex refer to the same mutex variable, but
be consistent and use the same set of pointers for the lock and unlock
calls.  It is less confusing (and one less pointer dereference this
way).

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/slaves/w1_therm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 7de99df..2c8dff9 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -171,7 +171,7 @@ static ssize_t w1_therm_read(struct device *device,
 	int i, max_trying =3D 10;
 	ssize_t c =3D PAGE_SIZE;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&dev->mutex);
=20
 	memset(rom, 0, sizeof(rom));
=20
--=20
1.4.4.4

--XBg9NAhDNArbJUtw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn7uAI852cse6PARAoN4AKCxu9OONg0zAdMxjE2ewoV04zv96QCfSl4r
48zhFeFHbEZx/Rny+ng4SAg=
=IieM
-----END PGP SIGNATURE-----

--XBg9NAhDNArbJUtw--
