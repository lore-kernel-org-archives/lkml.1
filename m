Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbYC1M7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbYC1M7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504AbYC1Mzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:40 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbYC1Mzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:37 -0400
Date: Fri, 28 Mar 2008 07:26:50 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 20/35] W1: w1.c s/printk/dev_dbg/
Message-ID: <20080328122650.GU3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FfX2iGK5t5ehHnsE"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:26:50 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FfX2iGK5t5ehHnsE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

w1.c 1.18
Code cleanup, more of a just because.
s/printk/dev_dbg/

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/w1.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 32cfb6a..189b60b 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -82,10 +82,10 @@ static void w1_slave_release(struct device *dev)
 {
 	struct w1_slave *sl =3D dev_to_w1_slave(dev);
=20
-	printk("%s: Releasing %s.\n", __func__, sl->name);
+	dev_dbg(dev, "%s: Releasing %s.\n", __func__, sl->name);
=20
 	while (atomic_read(&sl->refcnt)) {
-		printk("Waiting for %s to become free: refcnt=3D%d.\n",
+		dev_dbg(dev, "Waiting for %s to become free: refcnt=3D%d.\n",
 				sl->name, atomic_read(&sl->refcnt));
 		if (msleep_interruptible(1000))
 			flush_signals(current);
@@ -881,7 +881,7 @@ void w1_search(struct w1_master *dev, u8 search_type, w=
1_slave_found_callback cb
 			rn |=3D (tmp64 << i);
=20
 			if(kthread_should_stop()) {
-				printk(KERN_INFO "Abort w1_search (exiting)\n");
+				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
 			}
 		}
--=20
1.4.4.4

--FfX2iGK5t5ehHnsE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD4DBQFH7OQKAI852cse6PARAqb2AJYz6h6wd7B5WgMjrfsMvjGSZeoZAKDIUJQW
hzNwjzNMJmwT5JvNSPQZoA==
=2PzM
-----END PGP SIGNATURE-----

--FfX2iGK5t5ehHnsE--
