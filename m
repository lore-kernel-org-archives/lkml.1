Return-Path: <linux-kernel-owner+w=401wt.eu-S935084AbYDNSvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935084AbYDNSvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934753AbYDNSp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:45:26 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42725 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934749AbYDNSpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:45:24 -0400
Date: Mon, 14 Apr 2008 21:41:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove dm_create_error_table()
Message-ID: <20080414184144.GV6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dm_create_error_table() was added in kernel 2.6.18 and never used...

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008

 drivers/md/dm-table.c         |   38 ----------------------------------
 include/linux/device-mapper.h |    6 -----
 2 files changed, 44 deletions(-)

644f0b957bf64a4c86b944166a48fe7bad3d1724 diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e75b143..a999211 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -245,44 +245,6 @@ int dm_table_create(struct dm_table **result, int mode,
 	return 0;
 }
 
-int dm_create_error_table(struct dm_table **result, struct mapped_device *md)
-{
-	struct dm_table *t;
-	sector_t dev_size = 1;
-	int r;
-
-	/*
-	 * Find current size of device.
-	 * Default to 1 sector if inactive.
-	 */
-	t = dm_get_table(md);
-	if (t) {
-		dev_size = dm_table_get_size(t);
-		dm_table_put(t);
-	}
-
-	r = dm_table_create(&t, FMODE_READ, 1, md);
-	if (r)
-		return r;
-
-	r = dm_table_add_target(t, "error", 0, dev_size, NULL);
-	if (r)
-		goto out;
-
-	r = dm_table_complete(t);
-	if (r)
-		goto out;
-
-	*result = t;
-
-out:
-	if (r)
-		dm_table_put(t);
-
-	return r;
-}
-EXPORT_SYMBOL_GPL(dm_create_error_table);
-
 static void free_devices(struct list_head *devices)
 {
 	struct list_head *tmp, *next;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index cb78457..8fc199b 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -250,11 +250,5 @@ void dm_table_event(struct dm_table *t);
  */
 int dm_swap_table(struct mapped_device *md, struct dm_table *t);
 
-/*
- * Prepare a table for a device that will error all I/O.
- * To make it active, call dm_suspend(), dm_swap_table() then dm_resume().
- */
-int dm_create_error_table(struct dm_table **result, struct mapped_device *md);
-
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DEVICE_MAPPER_H */

