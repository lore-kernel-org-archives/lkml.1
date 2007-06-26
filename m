Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbXFZTIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbXFZTIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbXFZTFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:05:53 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25151 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759557AbXFZTFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:05:52 -0400
Message-Id: <e4b5ee94f03480b4801b4a1ddce2d5b71073e258.1182883861.git.ecashin@coraid.com>
In-Reply-To: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:12 -0400
Subject: [PATCH 12/12] the aoeminor doesn't need a long format
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The aoedev aoeminor member doesn't need a long format.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoeblk.c |    6 +++---
 drivers/block/aoe/aoecmd.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index ccadd9a..e216fe0 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -203,7 +203,7 @@ aoeblk_make_request(request_queue_t *q, struct bio *bio)
 	spin_lock_irqsave(&d->lock, flags);
 
 	if ((d->flags & DEVFL_UP) == 0) {
-		printk(KERN_INFO "aoe: device %ld.%ld is not up\n",
+		printk(KERN_INFO "aoe: device %ld.%d is not up\n",
 			d->aoemajor, d->aoeminor);
 		spin_unlock_irqrestore(&d->lock, flags);
 		mempool_free(buf, d->bufpool);
@@ -256,7 +256,7 @@ aoeblk_gdalloc(void *vp)
 
 	gd = alloc_disk(AOE_PARTITIONS);
 	if (gd == NULL) {
-		printk(KERN_ERR "aoe: cannot allocate disk structure for %ld.%ld\n",
+		printk(KERN_ERR "aoe: cannot allocate disk structure for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
 		spin_lock_irqsave(&d->lock, flags);
 		d->flags &= ~DEVFL_GDALLOC;
@@ -266,7 +266,7 @@ aoeblk_gdalloc(void *vp)
 
 	d->bufpool = mempool_create_slab_pool(MIN_BUFS, buf_pool_cache);
 	if (d->bufpool == NULL) {
-		printk(KERN_ERR "aoe: cannot allocate bufpool for %ld.%ld\n",
+		printk(KERN_ERR "aoe: cannot allocate bufpool for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
 		put_disk(gd);
 		spin_lock_irqsave(&d->lock, flags);
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 9de0024..dfb1184 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -680,7 +680,7 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
 	}
 
 	if (d->ssize != ssize)
-		printk(KERN_INFO "aoe: %012llx e%lu.%lu v%04x has %llu sectors\n",
+		printk(KERN_INFO "aoe: %012llx e%ld.%d v%04x has %llu sectors\n",
 			mac_addr(t->addr),
 			d->aoemajor, d->aoeminor,
 			d->fw_ver, (long long)ssize);
@@ -805,7 +805,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 
 	if (ahin->cmdstat & 0xa9) {	/* these bits cleared on success */
 		printk(KERN_ERR
-			"aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%ld\n",
+			"aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%d\n",
 			ahout->cmdstat, ahin->cmdstat,
 			d->aoemajor, d->aoeminor);
 		if (buf)
-- 
1.5.2.1

