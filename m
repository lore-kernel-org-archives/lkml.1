Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYBASRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYBASRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbYBASQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:16:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbYBASQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:16:18 -0500
Message-ID: <47A36183.2020901@redhat.com>
Date: Fri, 01 Feb 2008 19:14:27 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, "Ed L. Cashin" <ecashin@coraid.com>
Subject: [Patch 6/6] Enhanced partition statistics: remove old partition statistics
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the now unused old partition statistic code.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 block/blk-core.c      |    4 ----
 fs/partitions/check.c |    2 --
 include/linux/genhd.h |    1 -
 3 files changed, 7 deletions(-)
diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6.orig/block/blk-core.c linux-2.6/block/blk-core.c
--- linux-2.6.orig/block/blk-core.c	2008-01-31 17:38:43.000000000 +0100
+++ linux-2.6/block/blk-core.c	2008-01-31 18:05:08.000000000 +0100
@@ -1214,10 +1214,6 @@ static inline void blk_partition_remap(s
 
 	if (bio_sectors(bio) && bdev != bdev->bd_contains) {
 		struct hd_struct *p = bdev->bd_part;
-		const int rw = bio_data_dir(bio);
-
-		p->sectors[rw] += bio_sectors(bio);
-		p->ios[rw]++;
 
 		bio->bi_sector += p->start_sect;
 		bio->bi_bdev = bdev->bd_contains;
diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6.orig/fs/partitions/check.c linux-2.6/fs/partitions/check.c
--- linux-2.6.orig/fs/partitions/check.c	2008-01-31 17:58:31.000000000 +0100
+++ linux-2.6/fs/partitions/check.c	2008-01-31 18:05:08.000000000 +0100
@@ -330,8 +330,6 @@ void delete_partition(struct gendisk *di
 	disk->part[part-1] = NULL;
 	p->start_sect = 0;
 	p->nr_sects = 0;
-	p->ios[0] = p->ios[1] = 0;
-	p->sectors[0] = p->sectors[1] = 0;
 	part_stat_set_all(p, 0);
 	kobject_put(p->holder_dir);
 	device_del(&p->dev);
diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6.orig/include/linux/genhd.h linux-2.6/include/linux/genhd.h
--- linux-2.6.orig/include/linux/genhd.h	2008-01-31 17:38:43.000000000 +0100
+++ linux-2.6/include/linux/genhd.h	2008-01-31 18:05:08.000000000 +0100
@@ -96,7 +96,6 @@ struct hd_struct {
 	sector_t nr_sects;
 	struct device dev;
 	struct kobject *holder_dir;
-	unsigned ios[2], sectors[2];	/* READs and WRITEs */
 	int policy, partno;
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	int make_it_fail;

