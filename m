Return-Path: <linux-kernel-owner+w=401wt.eu-S932712AbYAYIfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbYAYIfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764143AbYAYIBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:53707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763691AbYAYH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 166/196] Kobject: rename kobject_init_ng() to kobject_init()
Date: Thu, 24 Jan 2008 23:33:15 -0800
Message-Id: <1201246425-5058-87-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the old kobject_init() function is gone, rename
kobject_init_ng() to kobject_init() to clean up the namespace.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/elevator.c           |    2 +-
 block/ll_rw_blk.c          |    2 +-
 drivers/base/class.c       |    2 +-
 drivers/base/core.c        |    2 +-
 drivers/md/md.c            |    2 +-
 drivers/net/iseries_veth.c |    4 ++--
 drivers/uio/uio.c          |    2 +-
 fs/char_dev.c              |    4 ++--
 include/linux/kobject.h    |    2 +-
 lib/kobject.c              |   14 +++++++-------
 10 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 645469a..f9736fb 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -185,7 +185,7 @@ static elevator_t *elevator_alloc(struct request_queue *q,
 
 	eq->ops = &e->ops;
 	eq->elevator_type = e;
-	kobject_init_ng(&eq->kobj, &elv_ktype);
+	kobject_init(&eq->kobj, &elv_ktype);
 	mutex_init(&eq->sysfs_lock);
 
 	eq->hash = kmalloc_node(sizeof(struct hlist_head) * ELV_HASH_ENTRIES,
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 234dd3d..5ccec8a 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1862,7 +1862,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	init_timer(&q->unplug_timer);
 
-	kobject_init_ng(&q->kobj, &queue_ktype);
+	kobject_init(&q->kobj, &queue_ktype);
 
 	mutex_init(&q->sysfs_lock);
 
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 8e3cba2..61fd26c 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -553,7 +553,7 @@ static struct class_device_attribute class_uevent_attr =
 void class_device_initialize(struct class_device *class_dev)
 {
 	class_dev->kobj.kset = &class_obj_subsys;
-	kobject_init_ng(&class_dev->kobj, &class_device_ktype);
+	kobject_init(&class_dev->kobj, &class_device_ktype);
 	INIT_LIST_HEAD(&class_dev->node);
 }
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index e881702..675a719 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -525,7 +525,7 @@ static void klist_children_put(struct klist_node *n)
 void device_initialize(struct device *dev)
 {
 	dev->kobj.kset = devices_kset;
-	kobject_init_ng(&dev->kobj, &device_ktype);
+	kobject_init(&dev->kobj, &device_ktype);
 	klist_init(&dev->klist_children, klist_children_get,
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->dma_pools);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 989d854..ae800ba 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2033,7 +2033,7 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
 	if (err)
 		goto abort_free;
 
-	kobject_init_ng(&rdev->kobj, &rdev_ktype);
+	kobject_init(&rdev->kobj, &rdev_ktype);
 
 	rdev->desc_nr = -1;
 	rdev->saved_raid_disk = -1;
diff --git a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
index ee15667..419861c 100644
--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -844,7 +844,7 @@ static int veth_init_connection(u8 rlp)
 
 	/* This gets us 1 reference, which is held on behalf of the driver
 	 * infrastructure. It's released at module unload. */
-	kobject_init_ng(&cnx->kobject, &veth_lpar_connection_ktype);
+	kobject_init(&cnx->kobject, &veth_lpar_connection_ktype);
 
 	msgs = kcalloc(VETH_NUMBUFFERS, sizeof(struct veth_msg), GFP_KERNEL);
 	if (! msgs) {
@@ -1083,7 +1083,7 @@ static struct net_device * __init veth_probe_one(int vlan,
 		return NULL;
 	}
 
-	kobject_init_ng(&port->kobject, &veth_port_ktype);
+	kobject_init(&port->kobject, &veth_port_ktype);
 	if (0 != kobject_add(&port->kobject, &dev->dev.kobj, "veth_port"))
 		veth_error("Failed adding port for %s to sysfs.\n", dev->name);
 
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 1ec2d31..f352731 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -169,7 +169,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		map = kzalloc(sizeof(*map), GFP_KERNEL);
 		if (!map)
 			goto err;
-		kobject_init_ng(&map->kobj, &map_attr_type);
+		kobject_init(&map->kobj, &map_attr_type);
 		map->mem = mem;
 		mem->map = map;
 		ret = kobject_add(&map->kobj, idev->map_dir, "map%d", mi);
diff --git a/fs/char_dev.c b/fs/char_dev.c
index b2dd5a0..2c7a8b5 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -511,7 +511,7 @@ struct cdev *cdev_alloc(void)
 	struct cdev *p = kzalloc(sizeof(struct cdev), GFP_KERNEL);
 	if (p) {
 		INIT_LIST_HEAD(&p->list);
-		kobject_init_ng(&p->kobj, &ktype_cdev_dynamic);
+		kobject_init(&p->kobj, &ktype_cdev_dynamic);
 	}
 	return p;
 }
@@ -528,7 +528,7 @@ void cdev_init(struct cdev *cdev, const struct file_operations *fops)
 {
 	memset(cdev, 0, sizeof *cdev);
 	INIT_LIST_HEAD(&cdev->list);
-	kobject_init_ng(&cdev->kobj, &ktype_cdev_default);
+	kobject_init(&cdev->kobj, &ktype_cdev_default);
 	cdev->ops = fops;
 }
 
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 53458b6..d9d8c36 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -78,7 +78,7 @@ static inline const char * kobject_name(const struct kobject * kobj)
 	return kobj->k_name;
 }
 
-extern void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype);
+extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
 extern int __must_check kobject_add(struct kobject *kobj,
 				    struct kobject *parent,
 				    const char *fmt, ...);
diff --git a/lib/kobject.c b/lib/kobject.c
index 10d977b..4cc231c 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -287,7 +287,7 @@ int kobject_set_name(struct kobject *kobj, const char *fmt, ...)
 EXPORT_SYMBOL(kobject_set_name);
 
 /**
- * kobject_init_ng - initialize a kobject structure
+ * kobject_init - initialize a kobject structure
  * @kobj: pointer to the kobject to initialize
  * @ktype: pointer to the ktype for this kobject.
  *
@@ -298,7 +298,7 @@ EXPORT_SYMBOL(kobject_set_name);
  * to kobject_put(), not by a call to kfree directly to ensure that all of
  * the memory is cleaned up properly.
  */
-void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype)
+void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
 {
 	char *err_str;
 
@@ -326,7 +326,7 @@ error:
 	printk(KERN_ERR "kobject: %s\n", err_str);
 	dump_stack();
 }
-EXPORT_SYMBOL(kobject_init_ng);
+EXPORT_SYMBOL(kobject_init);
 
 static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
 			    const char *fmt, va_list vargs)
@@ -401,7 +401,7 @@ EXPORT_SYMBOL(kobject_add);
  * @parent: pointer to the parent of this kobject.
  * @fmt: the name of the kobject.
  *
- * This function combines the call to kobject_init_ng() and
+ * This function combines the call to kobject_init() and
  * kobject_add().  The same type of error handling after a call to
  * kobject_add() and kobject lifetime rules are the same here.
  */
@@ -411,7 +411,7 @@ int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
 	va_list args;
 	int retval;
 
-	kobject_init_ng(kobj, ktype);
+	kobject_init(kobj, ktype);
 
 	va_start(args, fmt);
 	retval = kobject_add_varg(kobj, parent, fmt, args);
@@ -636,7 +636,7 @@ static struct kobj_type dynamic_kobj_ktype = {
  *
  * If the kobject was not able to be created, NULL will be returned.
  * The kobject structure returned from here must be cleaned up with a
- * call to kobject_put() and not kfree(), as kobject_init_ng() has
+ * call to kobject_put() and not kfree(), as kobject_init() has
  * already been called on this structure.
  */
 struct kobject *kobject_create(void)
@@ -647,7 +647,7 @@ struct kobject *kobject_create(void)
 	if (!kobj)
 		return NULL;
 
-	kobject_init_ng(kobj, &dynamic_kobj_ktype);
+	kobject_init(kobj, &dynamic_kobj_ktype);
 	return kobj;
 }
 
-- 
1.5.3.8

