Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbYC1M7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbYC1M7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758536AbYC1Mzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:41 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbYC1Mzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:38 -0400
Date: Fri, 28 Mar 2008 07:25:39 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 12/35] W1: new module parameter search_count
Message-ID: <20080328122539.GM3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dp9QYJgVRVEW2bsm"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:25:39 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dp9QYJgVRVEW2bsm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1_int.c 1.6
Added a new module parameter search_count which allows overriding the
default search count.  -1 continual, 0 disabled, N that many times.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1_int.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 932a242..f1806e2 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -30,6 +30,8 @@
 #include "w1_int.h"
=20
 static u32 w1_ids =3D 1;
+static int w1_search_count =3D -1; /* Default is continual scan */
+module_param_named(search_count, w1_search_count, int, 0);
=20
 static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_=
ttl,
 				       struct device_driver *driver,
@@ -59,7 +61,7 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_=
count, int slave_ttl,
 	dev->initialized	=3D 0;
 	dev->id			=3D id;
 	dev->slave_ttl		=3D slave_ttl;
-        dev->search_count	=3D -1; /* continual scan */
+        dev->search_count	=3D w1_search_count;
=20
 	/* 1 for w1_process to decrement
 	 * 1 for __w1_remove_master_device to decrement
--=20
1.4.4.4

--dp9QYJgVRVEW2bsm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OPDAI852cse6PARAmOvAKDTHiMd5zLSLIHbygK2Zry4/KzvrACfcAvE
9F8vCpPhCRx3p0JI6GLh8pA=
=RZWn
-----END PGP SIGNATURE-----

--dp9QYJgVRVEW2bsm--
