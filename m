Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbYCAQUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbYCAQUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762286AbYCAQTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:19:33 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38952 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762263AbYCAQTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:19:32 -0500
Date: Sat, 1 Mar 2008 18:18:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] block/genhd.c: cleanups
Message-ID: <20080301161806.GG25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the needlessly global struct disk_type static
- #if 0 the unused genhd_media_change_notify()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 block/genhd.c         |    6 +++++-
 include/linux/genhd.h |    2 --
 2 files changed, 5 insertions(+), 3 deletions(-)

4dba52ebe4db9b21daa39812a4aa0d5867e6d38a foobar
diff --git a/block/genhd.c b/block/genhd.c
index abc6fed..c44527d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -24,6 +24,8 @@ static DEFINE_MUTEX(block_class_lock);
 struct kobject *block_depr;
 #endif
 
+static struct device_type disk_type;
+
 /*
  * Can be deleted altogether. Later.
  *
@@ -502,7 +504,7 @@ struct class block_class = {
 	.name		= "block",
 };
 
-struct device_type disk_type = {
+static struct device_type disk_type = {
 	.name		= "disk",
 	.groups		= disk_attr_groups,
 	.release	= disk_release,
@@ -632,12 +634,14 @@ static void media_change_notify_thread(struct work_struct *work)
 	put_device(gd->driverfs_dev);
 }
 
+#if 0
 void genhd_media_change_notify(struct gendisk *disk)
 {
 	get_device(disk->driverfs_dev);
 	schedule_work(&disk->async_notify);
 }
 EXPORT_SYMBOL_GPL(genhd_media_change_notify);
+#endif  /*  0  */
 
 dev_t blk_lookup_devt(const char *name)
 {
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 09a3b18..cd048e3 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -18,7 +18,6 @@
 #define dev_to_disk(device) container_of(device, struct gendisk, dev)
 #define dev_to_part(device) container_of(device, struct hd_struct, dev)
 
-extern struct device_type disk_type;
 extern struct device_type part_type;
 extern struct kobject *block_depr;
 extern struct class block_class;
@@ -556,7 +555,6 @@ extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
 extern struct kobject *get_disk(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
-extern void genhd_media_change_notify(struct gendisk *disk);
 extern void blk_register_region(dev_t devt, unsigned long range,
 			struct module *module,
 			struct kobject *(*probe)(dev_t, int *, void *),

