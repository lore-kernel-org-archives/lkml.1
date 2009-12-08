Return-Path: <linux-kernel-owner+w=401wt.eu-S966189AbZLHU6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966189AbZLHU6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:58:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966148AbZLHU5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:57:36 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:43984 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966125AbZLHU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:57:28 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] vbus-enet: fix sparse warnings
Date: Tue,  8 Dec 2009 12:57:32 -0800
Message-Id: <1260305854-31472-4-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.6.0.rc1.71.gfba5.dirty
In-Reply-To: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
References: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 08 Dec 2009 12:57:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:
drivers/net/vbus-enet.c:411:9: warning: Using plain integer as NULL pointer
drivers/net/vbus-enet.c:1250:24: warning: Using plain integer as NULL pointer
drivers/net/vbus-enet.c:1326:24: warning: Using plain integer as NULL pointer

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/net/vbus-enet.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vbus-enet.c b/drivers/net/vbus-enet.c
index 4e9ecac..8232215 100644
--- a/drivers/net/vbus-enet.c
+++ b/drivers/net/vbus-enet.c
@@ -408,7 +408,7 @@ tx_setup(struct vbus_enet_priv *priv)
 		priv->pmtd.pool = pool;
 
 		ret = dev->ops->shm(dev, NULL, shmid, 0, pool, poollen,
-				    0, NULL, 0);
+				    NULL, NULL, 0);
 		BUG_ON(ret < 0);
 	}
 
@@ -1239,7 +1239,7 @@ vbus_enet_evq_negcap(struct vbus_enet_priv *priv, unsigned long count)
 		priv->evq.pool = pool;
 
 		ret = dev->ops->shm(dev, NULL, query.dpid, 0,
-				    pool, poollen, 0, NULL, 0);
+				    pool, poollen, NULL, NULL, 0);
 		if (ret < 0)
 			return ret;
 
@@ -1315,7 +1315,7 @@ vbus_enet_l4ro_negcap(struct vbus_enet_priv *priv, unsigned long count)
 		 * pre-mapped descriptor pool
 		 */
 		ret = dev->ops->shm(dev, NULL, query.dpid, 0,
-				    pool, poollen, 0, NULL, 0);
+				    pool, poollen, NULL, NULL, 0);
 		if (ret < 0) {
 			printk(KERN_ERR "Error registering L4RO pool: %d\n",
 			       ret);
-- 
1.5.4.3

