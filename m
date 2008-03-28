Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbYC1NAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbYC1NAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbYC1Mzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:43 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbYC1Mzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:41 -0400
Date: Fri, 28 Mar 2008 07:26:32 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 17/35] W1: w1_family, remove unused variable need_exit
Message-ID: <20080328122632.GR3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VdnGiXwuH6t1Tqzo"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:26:32 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VdnGiXwuH6t1Tqzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1_family.c 1.2
w1_family.h 1.2
Removed the w1_family structure member variable need_exit.  It was
only being set and never used.  Even if it were to be used it is a
polling type operation.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1_family.c |    7 +------
 drivers/w1/w1_family.h |    1 -
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/w1/w1_family.c b/drivers/w1/w1_family.c
index 8c35f9c..4a09904 100644
--- a/drivers/w1/w1_family.c
+++ b/drivers/w1/w1_family.c
@@ -48,7 +48,6 @@ int w1_register_family(struct w1_family *newf)
=20
 	if (!ret) {
 		atomic_set(&newf->refcnt, 0);
-		newf->need_exit =3D 0;
 		list_add_tail(&newf->family_entry, &w1_families);
 	}
 	spin_unlock(&w1_flock);
@@ -73,9 +72,6 @@ void w1_unregister_family(struct w1_family *fent)
 			break;
 		}
 	}
-
-	fent->need_exit =3D 1;
-
 	spin_unlock(&w1_flock);
=20
 	/* deatch devices using this family code */
@@ -113,8 +109,7 @@ struct w1_family * w1_family_registered(u8 fid)
=20
 static void __w1_family_put(struct w1_family *f)
 {
-	if (atomic_dec_and_test(&f->refcnt))
-		f->need_exit =3D 1;
+	atomic_dec(&f->refcnt);
 }
=20
 void w1_family_put(struct w1_family *f)
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 296a87e..3053133 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -53,7 +53,6 @@ struct w1_family
 	struct w1_family_ops	*fops;
=20
 	atomic_t		refcnt;
-	u8			need_exit;
 };
=20
 extern spinlock_t w1_flock;
--=20
1.4.4.4

--VdnGiXwuH6t1Tqzo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OP4AI852cse6PARAsW1AKC+5lMWPgktqVFb7ykTm4KXER07rACcDJjw
3MB0/GGKBv4iRZNRjpgacYY=
=jj/6
-----END PGP SIGNATURE-----

--VdnGiXwuH6t1Tqzo--
