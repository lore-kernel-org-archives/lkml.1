Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbYDMXPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbYDMXPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbYDMXPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:15:12 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:49155 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbYDMXPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:15:10 -0400
Date: Sun, 13 Apr 2008 18:15:08 -0500
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/33 replaces 12/35] W1: new module parameter search_count
Message-ID: <20080413231508.GD15213@spacedout.fries.net>
References: <20080413225632.GA14058@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0IvGJv3f9h+YhkrH"
Content-Disposition: inline
In-Reply-To: <20080413225632.GA14058@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 13 Apr 2008 18:15:08 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0IvGJv3f9h+YhkrH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This is an update to the previous set of patches, don't merge them
yet.  Some of the context was messed up and I don't expect patch to
apply the updates with the previous set cleanly.  I'll resubmit the
entire set if these updates look good.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

w1_int.c 1.6 1.10
Added a new module parameter search_count which allows overriding the
default search count.  -1 continual, 0 disabled, N that many times.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1_int.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 8deb76c..47e27f5 100644
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

--0IvGJv3f9h+YhkrH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIApP8AI852cse6PARAmD1AKCxHZcDZW+yRA3/iWGsFfCfY6brwgCgtHnq
TnX4qtWNLeDs4vPFFNgh+nE=
=X9ne
-----END PGP SIGNATURE-----

--0IvGJv3f9h+YhkrH--
