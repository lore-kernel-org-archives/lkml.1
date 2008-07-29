Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYG2CYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYG2CYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYG2CYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:24:03 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:50122 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbYG2CYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:24:01 -0400
Date: Mon, 28 Jul 2008 21:23:56 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 16/30] W1: w1.c s/printk/dev_dbg/
Message-ID: <20080729022356.GP24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eAnxKwVhzStH6fSc"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:23:57 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eAnxKwVhzStH6fSc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

s/printk/dev_dbg/

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/w1.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 67b4b99..0084619 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -81,10 +81,10 @@ static void w1_slave_release(struct device *dev)
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
@@ -911,7 +911,7 @@ void w1_search(struct w1_master *dev, u8 search_type, w=
1_slave_found_callback cb
 			rn |=3D (tmp64 << i);
=20
 			if (kthread_should_stop()) {
-				printk(KERN_INFO "Abort w1_search (exiting)\n");
+				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
 			}
 		}
--=20
1.4.4.4

--eAnxKwVhzStH6fSc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjn88AI852cse6PARAviXAJ0Smln0ofPDobD8Ih/Myt0hZukNYwCgkTXL
IKgUmwias2Oy1BNnTZz+VUg=
=ZxCV
-----END PGP SIGNATURE-----

--eAnxKwVhzStH6fSc--
