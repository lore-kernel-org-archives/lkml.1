Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbYC1M6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbYC1M6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbYC1Mzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:38 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494AbYC1Mze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:34 -0400
Date: Fri, 28 Mar 2008 07:26:37 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 18/35] W1: w1_therm consistent mutex access code cleanup
Message-ID: <20080328122637.GS3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dQ2XShfnd5GHxhN7"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:26:37 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dQ2XShfnd5GHxhN7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1_therm.c 1.7
sl->master->mutex and dev->mutex refer to the same mutex variable, but
be consistent and use the same set of pointers for the lock and unlock
calls.  It is less confusing (and one less pointer dereference this
way).

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/slaves/w1_therm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index ca47421..284acac 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -163,7 +163,7 @@ static ssize_t w1_therm_read(struct device *device,
 	int i, max_trying =3D 10;
 	ssize_t c=3DPAGE_SIZE;
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&dev->mutex);
=20
 	memset(rom, 0, sizeof(rom));
=20
--=20
1.4.4.4

--dQ2XShfnd5GHxhN7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OP9AI852cse6PARAsTzAJ9nBO44Dml9MJYppmfY8hsg6LvfRgCgkkfa
8eykTvpo8VRkv2ExcVXScng=
=31wG
-----END PGP SIGNATURE-----

--dQ2XShfnd5GHxhN7--
