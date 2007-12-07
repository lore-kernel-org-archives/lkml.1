Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbXLGRxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbXLGRxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbXLGRu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:50:27 -0500
Received: from ns1.co-raid.com ([65.14.39.133]:21124 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756449AbXLGRuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:50:25 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>, Greg KH <greg@kroah.com>
Subject: [PATCH 12/13] the aoeminor doesn't need a long format
Date: Fri,  7 Dec 2007 12:48:10 -0500
Message-Id: <1197049691-27462-12-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
References: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aoedev aoeminor member doesn't need a long format.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |    7 ++++---
 drivers/block/aoe/aoecmd.c |    5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 98ab170..b78a8ef 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -203,7 +203,7 @@ aoeblk_make_request(struct request_queue *q, struct bio *bio)
 	spin_lock_irqsave(&d->lock, flags);
 
 	if ((d->flags & DEVFL_UP) == 0) {
-		printk(KERN_INFO "aoe: device %ld.%ld is not up\n",
+		printk(KERN_INFO "aoe: device %ld.%d is not up\n",
 			d->aoemajor, d->aoeminor);
 		spin_unlock_irqrestore(&d->lock, flags);
 		mempool_free(buf, d->bufpool);
@@ -256,14 +256,15 @@ aoeblk_gdalloc(void *vp)
 
 	gd = alloc_disk(AOE_PARTITIONS);
 	if (gd == NULL) {
-		printk(KERN_ERR "aoe: cannot allocate disk structure for %ld.%ld\n",
+		printk(KERN_ERR
+			"aoe: cannot allocate disk structure for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
 		goto err;
 	}
 
 	d->bufpool = mempool_create_slab_pool(MIN_BUFS, buf_pool_cache);
 	if (d->bufpool == NULL) {
-		printk(KERN_ERR "aoe: cannot allocate bufpool for %ld.%ld\n",
+		printk(KERN_ERR "aoe: cannot allocate bufpool for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
 		goto err_disk;
 	}
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index e92d885..bcea36c 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -697,7 +697,8 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 	}
 
 	if (d->ssize != ssize)
-		printk(KERN_INFO "aoe: %012llx e%lu.%lu v%04x has %llu sectors\n",
+		printk(KERN_INFO
+			"aoe: %012llx e%ld.%d v%04x has %llu sectors\n",
 			mac_addr(t->addr),
 			d->aoemajor, d->aoeminor,
 			d->fw_ver, (long long)ssize);
@@ -822,7 +823,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	if (ahin->cmdstat & 0xa9) {	/* these bits cleared on success */
 		printk(KERN_ERR
-			"aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%ld\n",
+			"aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%d\n",
 			ahout->cmdstat, ahin->cmdstat,
 			d->aoemajor, d->aoeminor);
 		if (buf)
-- 
1.5.3.4

