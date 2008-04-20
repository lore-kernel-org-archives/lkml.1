Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbYDTKvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbYDTKvE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760147AbYDTKlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:41:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56363 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347AbYDTKlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:41:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/36] driver core: replace remaining __FUNCTION__ occurrences
Date: Sun, 20 Apr 2008 03:46:01 -0700
Message-Id: <1208688366-9252-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c            |    8 ++++----
 drivers/base/class.c          |    8 ++++----
 drivers/base/core.c           |   18 +++++++++---------
 drivers/base/dd.c             |   14 +++++++-------
 drivers/base/firmware_class.c |   18 +++++++++---------
 drivers/base/memory.c         |    4 ++--
 drivers/base/sys.c            |    2 +-
 7 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 450942a..be1cc51 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -79,7 +79,7 @@ static void driver_release(struct kobject *kobj)
 {
 	struct driver_private *drv_priv = to_driver(kobj);
 
-	pr_debug("driver: '%s': %s\n", kobject_name(kobj), __FUNCTION__);
+	pr_debug("driver: '%s': %s\n", kobject_name(kobj), __func__);
 	kfree(drv_priv);
 }
 
@@ -677,19 +677,19 @@ int bus_add_driver(struct device_driver *drv)
 	error = driver_create_file(drv, &driver_attr_uevent);
 	if (error) {
 		printk(KERN_ERR "%s: uevent attr (%s) failed\n",
-			__FUNCTION__, drv->name);
+			__func__, drv->name);
 	}
 	error = driver_add_attrs(bus, drv);
 	if (error) {
 		/* How the hell do we get out of this pickle? Give up */
 		printk(KERN_ERR "%s: driver_add_attrs(%s) failed\n",
-			__FUNCTION__, drv->name);
+			__func__, drv->name);
 	}
 	error = add_bind_files(drv);
 	if (error) {
 		/* Ditto */
 		printk(KERN_ERR "%s: add_bind_files(%s) failed\n",
-			__FUNCTION__, drv->name);
+			__func__, drv->name);
 	}
 
 	kobject_uevent(&priv->kobj, KOBJ_ADD);
diff --git a/drivers/base/class.c b/drivers/base/class.c
index 9d91537..b490179 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -175,13 +175,13 @@ void class_unregister(struct class *cls)
 
 static void class_create_release(struct class *cls)
 {
-	pr_debug("%s called for %s\n", __FUNCTION__, cls->name);
+	pr_debug("%s called for %s\n", __func__, cls->name);
 	kfree(cls);
 }
 
 static void class_device_create_release(struct class_device *class_dev)
 {
-	pr_debug("%s called for %s\n", __FUNCTION__, class_dev->class_id);
+	pr_debug("%s called for %s\n", __func__, class_dev->class_id);
 	kfree(class_dev);
 }
 
@@ -189,7 +189,7 @@ static void class_device_create_release(struct class_device *class_dev)
 static int class_device_create_uevent(struct class_device *class_dev,
 				      struct kobj_uevent_env *env)
 {
-	pr_debug("%s called for %s\n", __FUNCTION__, class_dev->class_id);
+	pr_debug("%s called for %s\n", __func__, class_dev->class_id);
 	return 0;
 }
 
@@ -415,7 +415,7 @@ static int class_uevent(struct kset *kset, struct kobject *kobj,
 	struct device *dev = class_dev->dev;
 	int retval = 0;
 
-	pr_debug("%s - name = %s\n", __FUNCTION__, class_dev->class_id);
+	pr_debug("%s - name = %s\n", __func__, class_dev->class_id);
 
 	if (MAJOR(class_dev->devt)) {
 		add_uevent_var(env, "MAJOR=%u", MAJOR(class_dev->devt));
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 0262fc7..0737fe5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -207,7 +207,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		retval = dev->bus->uevent(dev, env);
 		if (retval)
 			pr_debug("device: '%s': %s: bus uevent() returned %d\n",
-				 dev->bus_id, __FUNCTION__, retval);
+				 dev->bus_id, __func__, retval);
 	}
 
 	/* have the class specific function add its stuff */
@@ -216,7 +216,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		if (retval)
 			pr_debug("device: '%s': %s: class uevent() "
 				 "returned %d\n", dev->bus_id,
-				 __FUNCTION__, retval);
+				 __func__, retval);
 	}
 
 	/* have the device type specific fuction add its stuff */
@@ -225,7 +225,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		if (retval)
 			pr_debug("device: '%s': %s: dev_type uevent() "
 				 "returned %d\n", dev->bus_id,
-				 __FUNCTION__, retval);
+				 __func__, retval);
 	}
 
 	return retval;
@@ -782,7 +782,7 @@ int device_add(struct device *dev)
 		goto Done;
 	}
 
-	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
 
 	parent = get_device(dev->parent);
 	setup_parent(dev, parent);
@@ -980,7 +980,7 @@ void device_del(struct device *dev)
  */
 void device_unregister(struct device *dev)
 {
-	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
 	device_del(dev);
 	put_device(dev);
 }
@@ -1075,7 +1075,7 @@ EXPORT_SYMBOL_GPL(device_remove_file);
 
 static void device_create_release(struct device *dev)
 {
-	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
 	kfree(dev);
 }
 
@@ -1180,7 +1180,7 @@ int device_rename(struct device *dev, char *new_name)
 		return -EINVAL;
 
 	pr_debug("device: '%s': %s: renaming to '%s'\n", dev->bus_id,
-		 __FUNCTION__, new_name);
+		 __func__, new_name);
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	if ((dev->class) && (dev->parent))
@@ -1219,7 +1219,7 @@ int device_rename(struct device *dev, char *new_name)
 					  dev->bus_id);
 		if (error) {
 			dev_err(dev, "%s: sysfs_create_symlink failed (%d)\n",
-				__FUNCTION__, error);
+				__func__, error);
 		}
 	}
 #endif
@@ -1295,7 +1295,7 @@ int device_move(struct device *dev, struct device *new_parent)
 	new_parent_kobj = get_device_parent(dev, new_parent);
 
 	pr_debug("device: '%s': %s: moving to '%s'\n", dev->bus_id,
-		 __FUNCTION__, new_parent ? new_parent->bus_id : "<NULL>");
+		 __func__, new_parent ? new_parent->bus_id : "<NULL>");
 	error = kobject_move(&dev->kobj, new_parent_kobj);
 	if (error) {
 		cleanup_glue_dir(dev, new_parent_kobj);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index a5cde94..3ac443b 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -30,12 +30,12 @@ static void driver_bound(struct device *dev)
 {
 	if (klist_node_attached(&dev->knode_driver)) {
 		printk(KERN_WARNING "%s: device %s already bound\n",
-			__FUNCTION__, kobject_name(&dev->kobj));
+			__func__, kobject_name(&dev->kobj));
 		return;
 	}
 
 	pr_debug("driver: '%s': %s: bound to device '%s'\n", dev->bus_id,
-		 __FUNCTION__, dev->driver->name);
+		 __func__, dev->driver->name);
 
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
@@ -104,13 +104,13 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 	atomic_inc(&probe_count);
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
-		 drv->bus->name, __FUNCTION__, drv->name, dev->bus_id);
+		 drv->bus->name, __func__, drv->name, dev->bus_id);
 	WARN_ON(!list_empty(&dev->devres_head));
 
 	dev->driver = drv;
 	if (driver_sysfs_add(dev)) {
 		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
-			__FUNCTION__, dev->bus_id);
+			__func__, dev->bus_id);
 		goto probe_failed;
 	}
 
@@ -127,7 +127,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	driver_bound(dev);
 	ret = 1;
 	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
-		 drv->bus->name, __FUNCTION__, dev->bus_id, drv->name);
+		 drv->bus->name, __func__, dev->bus_id, drv->name);
 	goto done;
 
 probe_failed:
@@ -160,7 +160,7 @@ done:
  */
 int driver_probe_done(void)
 {
-	pr_debug("%s: probe_count = %d\n", __FUNCTION__,
+	pr_debug("%s: probe_count = %d\n", __func__,
 		 atomic_read(&probe_count));
 	if (atomic_read(&probe_count))
 		return -EBUSY;
@@ -194,7 +194,7 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 		goto done;
 
 	pr_debug("bus: '%s': %s: matched device %s with driver %s\n",
-		 drv->bus->name, __FUNCTION__, dev->bus_id, drv->name);
+		 drv->bus->name, __func__, dev->bus_id, drv->name);
 
 	ret = really_probe(dev, drv);
 
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4a1b9bf..1fef7df 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -156,7 +156,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		}
 		/* fallthrough */
 	default:
-		printk(KERN_ERR "%s: unexpected value (%d)\n", __FUNCTION__,
+		printk(KERN_ERR "%s: unexpected value (%d)\n", __func__,
 		       loading);
 		/* fallthrough */
 	case -1:
@@ -209,7 +209,7 @@ fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
 	new_size = ALIGN(min_size, PAGE_SIZE);
 	new_data = vmalloc(new_size);
 	if (!new_data) {
-		printk(KERN_ERR "%s: unable to alloc buffer\n", __FUNCTION__);
+		printk(KERN_ERR "%s: unable to alloc buffer\n", __func__);
 		/* Make sure that we don't keep incomplete data */
 		fw_load_abort(fw_priv);
 		return -ENOMEM;
@@ -307,7 +307,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	*dev_p = NULL;
 
 	if (!fw_priv || !f_dev) {
-		printk(KERN_ERR "%s: kmalloc failed\n", __FUNCTION__);
+		printk(KERN_ERR "%s: kmalloc failed\n", __func__);
 		retval = -ENOMEM;
 		goto error_kfree;
 	}
@@ -328,7 +328,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	retval = device_register(f_dev);
 	if (retval) {
 		printk(KERN_ERR "%s: device_register failed\n",
-		       __FUNCTION__);
+		       __func__);
 		goto error_kfree;
 	}
 	*dev_p = f_dev;
@@ -362,14 +362,14 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 	retval = sysfs_create_bin_file(&f_dev->kobj, &fw_priv->attr_data);
 	if (retval) {
 		printk(KERN_ERR "%s: sysfs_create_bin_file failed\n",
-		       __FUNCTION__);
+		       __func__);
 		goto error_unreg;
 	}
 
 	retval = device_create_file(f_dev, &dev_attr_loading);
 	if (retval) {
 		printk(KERN_ERR "%s: device_create_file failed\n",
-		       __FUNCTION__);
+		       __func__);
 		goto error_unreg;
 	}
 
@@ -399,7 +399,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
-		       __FUNCTION__);
+		       __func__);
 		retval = -ENOMEM;
 		goto out;
 	}
@@ -570,13 +570,13 @@ firmware_class_init(void)
 	int error;
 	error = class_register(&firmware_class);
 	if (error) {
-		printk(KERN_ERR "%s: class_register failed\n", __FUNCTION__);
+		printk(KERN_ERR "%s: class_register failed\n", __func__);
 		return error;
 	}
 	error = class_create_file(&firmware_class, &class_attr_timeout);
 	if (error) {
 		printk(KERN_ERR "%s: class_create_file failed\n",
-		       __FUNCTION__);
+		       __func__);
 		class_unregister(&firmware_class);
 	}
 	return error;
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 7891f7c..8ce6de5 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -186,7 +186,7 @@ memory_block_action(struct memory_block *mem, unsigned long action)
 			break;
 		default:
 			printk(KERN_WARNING "%s(%p, %ld) unknown action: %ld\n",
-					__FUNCTION__, mem, action, action);
+					__func__, mem, action, action);
 			WARN_ON(1);
 			ret = -EINVAL;
 	}
@@ -444,6 +444,6 @@ int __init memory_dev_init(void)
 		ret = err;
 out:
 	if (ret)
-		printk(KERN_ERR "%s() failed: %d\n", __FUNCTION__, ret);
+		printk(KERN_ERR "%s() failed: %d\n", __func__, ret);
 	return ret;
 }
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 1a06c23..4fbb56b 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -195,7 +195,7 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 		}
 	} else {
 		err = -EINVAL;
-		printk(KERN_ERR "%s: invalid device class\n", __FUNCTION__);
+		printk(KERN_ERR "%s: invalid device class\n", __func__);
 		WARN_ON(1);
 	}
 	mutex_unlock(&sysdev_drivers_lock);
-- 
1.5.4.5

