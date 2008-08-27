Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYH0UYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYH0UYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYH0UY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:24:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:31080 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYH0UY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:24:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=nTkLgV4Ln5FAlWhc/OsyyKbccxwS8GGeQk0TF2OBt0M6zN18oFeP5CFmJv7ptbdtWk
         2Ia9Gi0N338c9BpD/lYR/Net4EkaJFdd/BS2cl2HLv3H3vz0Dsmem0iMPvrKmC5qLc9z
         FrGWQjSnYl2h3aheeJn+doZqE18Wb6ZthjC/w=
Subject: [PATCH] block: kmalloc args reversed, small function definition
	fixes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 13:24:29 -0700
Message-Id: <1219868669.6069.53.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by sparse:
block/blk-softirq.c:156:12: warning: symbol 'blk_softirq_init' was not declared. Should it be static?
block/genhd.c:583:28: warning: function 'bdget_disk' with external linkage has definition
block/genhd.c:659:17: warning: incorrect type in argument 1 (different base types)
block/genhd.c:659:17:    expected unsigned int [unsigned] [usertype] size
block/genhd.c:659:17:    got restricted gfp_t
block/genhd.c:659:29: warning: incorrect type in argument 2 (different base types)
block/genhd.c:659:29:    expected restricted gfp_t [usertype] flags
block/genhd.c:659:29:    got unsigned int
block: kmalloc args reversed

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
new in next-20080827

 block/blk-settings.c |    2 +-
 block/genhd.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a60e959..d70692b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -443,7 +443,7 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
-int __init blk_settings_init(void)
+static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
 	blk_max_pfn = max_pfn - 1;
diff --git a/block/genhd.c b/block/genhd.c
index a189358..e2eaaa3 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -580,7 +580,7 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
  * RETURNS:
  * Resulting block_device on success, NULL on failure.
  */
-extern struct block_device *bdget_disk(struct gendisk *disk, int partno)
+struct block_device *bdget_disk(struct gendisk *disk, int partno)
 {
 	struct hd_struct *part;
 	struct block_device *bdev = NULL;
@@ -656,7 +656,7 @@ static void *disk_seqf_start(struct seq_file *seqf, loff_t *pos)
 	struct class_dev_iter *iter;
 	struct device *dev;
 
-	iter = kmalloc(GFP_KERNEL, sizeof(*iter));
+	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.6.0.366.gf9ffa8



