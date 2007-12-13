Return-Path: <linux-kernel-owner+w=401wt.eu-S1762949AbXLMQVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762949AbXLMQVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762820AbXLMQTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:19:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762814AbXLMQTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:19:11 -0500
Message-ID: <47615B42.20205@redhat.com>
Date: Thu, 13 Dec 2007 17:18:10 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk
Subject: [Patch 8/8] Enhanced partition statistics: remove old partition statistics
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the now unused old partition statistic code.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 block/ll_rw_blk.c     |    4 ----
 fs/partitions/check.c |    2 --
 include/linux/genhd.h |    1 -
 3 files changed, 7 deletions(-)
diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/block/ll_rw_blk.c linux-2.6/block/ll_rw_blk.c
--- linux-2.6.orig/block/ll_rw_blk.c	2007-12-05 13:43:49.000000000 +0100
+++ linux-2.6/block/ll_rw_blk.c	2007-12-05 13:54:21.000000000 +0100
@@ -3117,10 +3117,6 @@ static inline void blk_partition_remap(s
 
 	if (bio_sectors(bio) && bdev != bdev->bd_contains) {
 		struct hd_struct *p = bdev->bd_part;
-		const int rw = bio_data_dir(bio);
-
-		p->sectors[rw] += bio_sectors(bio);
-		p->ios[rw]++;
 
 		bio->bi_sector += p->start_sect;
 		bio->bi_bdev = bdev->bd_contains;
diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/fs/partitions/check.c linux-2.6/fs/partitions/check.c
--- linux-2.6.orig/fs/partitions/check.c	2007-12-05 13:52:36.000000000 +0100
+++ linux-2.6/fs/partitions/check.c	2007-12-05 13:54:21.000000000 +0100
@@ -377,8 +377,6 @@ void delete_partition(struct gendisk *di
 	disk->part[part-1] = NULL;
 	p->start_sect = 0;
 	p->nr_sects = 0;
-	p->ios[0] = p->ios[1] = 0;
-	p->sectors[0] = p->sectors[1] = 0;
 	part_stat_set_all(p, 0);
 	sysfs_remove_link(&p->kobj, "subsystem");
 	kobject_unregister(p->holder_dir);
diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/include/linux/genhd.h linux-2.6/include/linux/genhd.h
--- linux-2.6.orig/include/linux/genhd.h	2007-12-05 13:43:49.000000000 +0100
+++ linux-2.6/include/linux/genhd.h	2007-12-05 13:54:21.000000000 +0100
@@ -86,7 +86,6 @@ struct hd_struct {
 	sector_t nr_sects;
 	struct kobject kobj;
 	struct kobject *holder_dir;
-	unsigned ios[2], sectors[2];	/* READs and WRITEs */
 	int policy, partno;
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	int make_it_fail;

