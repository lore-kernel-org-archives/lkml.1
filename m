Return-Path: <linux-kernel-owner+w=401wt.eu-S934852AbYDNSsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852AbYDNSsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934348AbYDNSnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:43:17 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35423 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934345AbYDNSnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:43:15 -0400
Date: Mon, 14 Apr 2008 21:41:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make dm_set_device_limits() static
Message-ID: <20080414184147.GW6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global dm_set_device_limits() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008

 drivers/md/dm-table.c         |    4 ++--
 include/linux/device-mapper.h |    5 -----
 2 files changed, 2 insertions(+), 7 deletions(-)

bb081f9ddde6ca766b8c1cd1077f203d0a082cdb diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a999211..ce27283 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -491,7 +491,8 @@ static int __table_get_device(struct dm_table *t, struct dm_target *ti,
 	return 0;
 }
 
-void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
+static void dm_set_device_limits(struct dm_target *ti,
+				 struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 	struct io_restrictions *rs = &ti->limits;
@@ -541,7 +542,6 @@ void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
 
 	rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 }
-EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
 int dm_get_device(struct dm_target *ti, const char *path, sector_t start,
 		  sector_t len, int mode, struct dm_dev **result)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 8fc199b..4c4b3a6 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -75,11 +75,6 @@ typedef int (*dm_ioctl_fn) (struct dm_target *ti, struct inode *inode,
 void dm_error(const char *message);
 
 /*
- * Combine device limits.
- */
-void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev);
-
-/*
  * Constructors should call these functions to ensure destination devices
  * are opened/closed correctly.
  * FIXME: too many arguments.


