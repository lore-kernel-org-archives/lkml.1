Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYG2CT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYG2CT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbYG2CTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:19:06 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:48739 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbYG2CTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:19:05 -0400
Date: Mon, 28 Jul 2008 21:19:00 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 9/30] W1: new module parameter search_count
Message-ID: <20080729021900.GI24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aFi3jz1oiPowsTUB"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:19:01 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aFi3jz1oiPowsTUB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Added a new module parameter search_count which allows overriding the
default search count.  -1 continual, 0 disabled, N that many times.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1_int.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 9d723ef..3fd6e66 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -30,6 +30,8 @@
 #include "w1_int.h"
=20
 static u32 w1_ids =3D 1;
+static int w1_search_count =3D -1; /* Default is continual scan */
+module_param_named(search_count, w1_search_count, int, 0);
=20
 static int w1_enable_pullup =3D 1;
 module_param_named(enable_pullup, w1_enable_pullup, int, 0);
@@ -62,8 +64,8 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_=
count, int slave_ttl,
 	dev->initialized	=3D 0;
 	dev->id			=3D id;
 	dev->slave_ttl		=3D slave_ttl;
+	dev->search_count	=3D w1_search_count;
 	dev->enable_pullup	=3D w1_enable_pullup;
-        dev->search_count	=3D -1; /* continual scan */
=20
 	/* 1 for w1_process to decrement
 	 * 1 for __w1_remove_master_device to decrement
--=20
1.4.4.4

--aFi3jz1oiPowsTUB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn4UAI852cse6PARAqNPAKDQ5c/g0tUZz+pDBXrYXqhEyJYGdQCgrKn5
lnyaRLWWGP6ZibXoeeJU/0U=
=0jU5
-----END PGP SIGNATURE-----

--aFi3jz1oiPowsTUB--
