Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbYAYIj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbYAYIj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759262AbYAYIBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:59427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761174AbYAYH7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 164/196] Kobject: rename kobject_add_ng() to kobject_add()
Date: Thu, 24 Jan 2008 23:33:13 -0800
Message-Id: <1201246425-5058-85-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the old kobject_add() function is gone, rename kobject_add_ng()
to kobject_add() to clean up the namespace.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/elevator.c           |    2 +-
 block/ll_rw_blk.c          |    4 ++--
 drivers/base/class.c       |    4 ++--
 drivers/base/core.c        |    6 +++---
 drivers/base/driver.c      |    2 +-
 drivers/md/md.c            |    2 +-
 drivers/net/iseries_veth.c |    2 +-
 drivers/uio/uio.c          |    2 +-
 include/linux/kobject.h    |    6 +++---
 lib/kobject.c              |   14 +++++++-------
 10 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 5445c3c..645469a 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -929,7 +929,7 @@ int elv_register_queue(struct request_queue *q)
 	elevator_t *e = q->elevator;
 	int error;
 
-	error = kobject_add_ng(&e->kobj, &q->kobj, "%s", "iosched");
+	error = kobject_add(&e->kobj, &q->kobj, "%s", "iosched");
 	if (!error) {
 		struct elv_fs_entry *attr = e->elevator_type->elevator_attrs;
 		if (attr) {
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 8054b7d..234dd3d 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -4180,8 +4180,8 @@ int blk_register_queue(struct gendisk *disk)
 	if (!q || !q->request_fn)
 		return -ENXIO;
 
-	ret = kobject_add_ng(&q->kobj, kobject_get(&disk->dev.kobj),
-			     "%s", "queue");
+	ret = kobject_add(&q->kobj, kobject_get(&disk->dev.kobj),
+			  "%s", "queue");
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 624b331..8e3cba2 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -586,8 +586,8 @@ int class_device_add(struct class_device *class_dev)
 	else
 		class_dev->kobj.parent = &parent_class->subsys.kobj;
 
-	error = kobject_add_ng(&class_dev->kobj, class_dev->kobj.parent,
-			       "%s", class_dev->class_id);
+	error = kobject_add(&class_dev->kobj, class_dev->kobj.parent,
+			    "%s", class_dev->class_id);
 	if (error)
 		goto out2;
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 06e8738..e881702 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -602,7 +602,7 @@ static struct kobject *get_device_parent(struct device *dev,
 		if (!k)
 			return NULL;
 		k->kset = &dev->class->class_dirs;
-		retval = kobject_add_ng(k, parent_kobj, "%s", dev->class->name);
+		retval = kobject_add(k, parent_kobj, "%s", dev->class->name);
 		if (retval < 0) {
 			kobject_put(k);
 			return NULL;
@@ -776,7 +776,7 @@ static void device_remove_class_symlinks(struct device *dev)
  *	This is part 2 of device_register(), though may be called
  *	separately _iff_ device_initialize() has been called separately.
  *
- *	This adds it to the kobject hierarchy via kobject_add_ng(), adds it
+ *	This adds it to the kobject hierarchy via kobject_add(), adds it
  *	to the global and sibling lists for the device, then
  *	adds it to the other relevant subsystems of the driver model.
  */
@@ -807,7 +807,7 @@ int device_add(struct device *dev)
 		goto Error;
 
 	/* first, register with generic layer. */
-	error = kobject_add_ng(&dev->kobj, dev->kobj.parent, "%s", dev->bus_id);
+	error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev->bus_id);
 	if (error)
 		goto Error;
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 5aacff2..94b697a 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -144,7 +144,7 @@ int driver_add_kobj(struct device_driver *drv, struct kobject *kobj,
 	if (!name)
 		return -ENOMEM;
 
-	return kobject_add_ng(kobj, &drv->p->kobj, "%s", name);
+	return kobject_add(kobj, &drv->p->kobj, "%s", name);
 }
 EXPORT_SYMBOL_GPL(driver_add_kobj);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7ae9740..989d854 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1389,7 +1389,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", b);
 
-	if ((err = kobject_add_ng(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
+	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
 		goto fail;
 
 	if (rdev->bdev->bd_part)
diff --git a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
index 1a8299a..ee15667 100644
--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -1084,7 +1084,7 @@ static struct net_device * __init veth_probe_one(int vlan,
 	}
 
 	kobject_init_ng(&port->kobject, &veth_port_ktype);
-	if (0 != kobject_add_ng(&port->kobject, &dev->dev.kobj, "veth_port"))
+	if (0 != kobject_add(&port->kobject, &dev->dev.kobj, "veth_port"))
 		veth_error("Failed adding port for %s to sysfs.\n", dev->name);
 
 	veth_info("%s attached to iSeries vlan %d (LPAR map = 0x%.4X)\n",
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index acc387d..1ec2d31 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -172,7 +172,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		kobject_init_ng(&map->kobj, &map_attr_type);
 		map->mem = mem;
 		mem->map = map;
-		ret = kobject_add_ng(&map->kobj, idev->map_dir, "map%d", mi);
+		ret = kobject_add(&map->kobj, idev->map_dir, "map%d", mi);
 		if (ret)
 			goto err;
 		ret = kobject_uevent(&map->kobj, KOBJ_ADD);
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 8b0aa71..84c5afd 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -80,9 +80,9 @@ static inline const char * kobject_name(const struct kobject * kobj)
 
 extern void kobject_init(struct kobject *);
 extern void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype);
-extern int __must_check kobject_add_ng(struct kobject *kobj,
-				       struct kobject *parent,
-				       const char *fmt, ...);
+extern int __must_check kobject_add(struct kobject *kobj,
+				    struct kobject *parent,
+				    const char *fmt, ...);
 extern int __must_check kobject_init_and_add(struct kobject *kobj,
 					     struct kobj_type *ktype,
 					     struct kobject *parent,
diff --git a/lib/kobject.c b/lib/kobject.c
index d04789f..359e114 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -350,7 +350,7 @@ static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
 }
 
 /**
- * kobject_add_ng - the main kobject add function
+ * kobject_add - the main kobject add function
  * @kobj: the kobject to add
  * @parent: pointer to the parent of the kobject.
  * @fmt: format to name the kobject with.
@@ -381,8 +381,8 @@ static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
  * kobject_uevent() with the UEVENT_ADD parameter to ensure that
  * userspace is properly notified of this kobject's creation.
  */
-int kobject_add_ng(struct kobject *kobj, struct kobject *parent,
-		   const char *fmt, ...)
+int kobject_add(struct kobject *kobj, struct kobject *parent,
+		const char *fmt, ...)
 {
 	va_list args;
 	int retval;
@@ -396,7 +396,7 @@ int kobject_add_ng(struct kobject *kobj, struct kobject *parent,
 
 	return retval;
 }
-EXPORT_SYMBOL(kobject_add_ng);
+EXPORT_SYMBOL(kobject_add);
 
 /**
  * kobject_init_and_add - initialize a kobject structure and add it to the kobject hierarchy
@@ -406,8 +406,8 @@ EXPORT_SYMBOL(kobject_add_ng);
  * @fmt: the name of the kobject.
  *
  * This function combines the call to kobject_init_ng() and
- * kobject_add_ng().  The same type of error handling after a call to
- * kobject_add_ng() and kobject lifetime rules are the same here.
+ * kobject_add().  The same type of error handling after a call to
+ * kobject_add() and kobject lifetime rules are the same here.
  */
 int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
 			 struct kobject *parent, const char *fmt, ...)
@@ -677,7 +677,7 @@ struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
 	if (!kobj)
 		return NULL;
 
-	retval = kobject_add_ng(kobj, parent, "%s", name);
+	retval = kobject_add(kobj, parent, "%s", name);
 	if (retval) {
 		printk(KERN_WARNING "%s: kobject_add error: %d\n",
 		       __FUNCTION__, retval);
-- 
1.5.3.8

