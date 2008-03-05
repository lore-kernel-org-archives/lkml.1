Return-Path: <linux-kernel-owner+w=401wt.eu-S1763867AbYCEAlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763867AbYCEAlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbYCEAl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:41:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:65203 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbYCEAl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pe46t3yG6ghuKNE8xoinyQksnRth9YGAImMM3wCg42Y7AHiB7AMh6fTNTNxfT6PMwwWXrEsOvO0fLsmHoyCof1JsR2mGkMU6eqN9dUXs7gDLUqDov1MEutaKoVJpXRk+gfWTebiV+XaG9Wld4D9bOyuygMz9si0IL6Me29w5M7Y=
Subject: [PATCH] drivers/base: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 16:41:05 -0800
Message-Id: <1204677665.5698.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Sorry for the slip-up Greg, this is the correct patch against:
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-2.6.git

 drivers/base/bus.c            |    8 ++++----
 drivers/base/class.c          |    8 ++++----
 drivers/base/core.c           |   18 +++++++++---------
 drivers/base/dd.c             |   14 +++++++-------
 drivers/base/firmware_class.c |   18 +++++++++---------
 drivers/base/memory.c         |    4 ++--
 drivers/base/sys.c            |    2 +-
 7 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 2d207ad..706e680 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -79,7 +79,7 @@ static void driver_release(struct kobject *kobj)
 {
 	struct driver_private *drv_priv = to_driver(kobj);
 
-	pr_debug("driver: '%s': %s\n", kobject_name(kobj), __FUNCTION__);
+	pr_debug("driver: '%s': %s\n", kobject_name(kobj), __func__);
 	kfree(drv_priv);
 }
 
@@ -682,19 +682,19 @@ int bus_add_driver(struct device_driver *drv)
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
index 7de543d..6a015ad 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -202,7 +202,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		retval = dev->bus->uevent(dev, env);
 		if (retval)
 			pr_debug("device: '%s': %s: bus uevent() returned %d\n",
-				 dev->bus_id, __FUNCTION__, retval);
+				 dev->bus_id, __func__, retval);
 	}
 
 	/* have the class specific function add its stuff */
@@ -211,7 +211,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		if (retval)
 			pr_debug("device: '%s': %s: class uevent() "
 				 "returned %d\n", dev->bus_id,
-				 __FUNCTION__, retval);
+				 __func__, retval);
 	}
 
 	/* have the device type specific fuction add its stuff */
@@ -220,7 +220,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		if (retval)
 			pr_debug("device: '%s': %s: dev_type uevent() "
 				 "returned %d\n", dev->bus_id,
-				 __FUNCTION__, retval);
+				 __func__, retval);
 	}
 
 	return retval;
@@ -777,7 +777,7 @@ int device_add(struct device *dev)
 		goto Done;
 	}
 
-	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
 
 	parent = get_device(dev->parent);
 	setup_parent(dev, parent);
@@ -976,7 +976,7 @@ void device_del(struct device *dev)
  */
 void device_unregister(struct device *dev)
 {
-	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
 	device_del(dev);
 	put_device(dev);
 }
@@ -1071,7 +1071,7 @@ EXPORT_SYMBOL_GPL(device_remove_file);
 
 static void device_create_release(struct device *dev)
 {
-	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
+	pr_debug("device: '%s': %s\n", dev->bus_id, __func__);
 	kfree(dev);
 }
 
@@ -1205,7 +1205,7 @@ int device_rename(struct device *dev, char *new_name)
 		return -EINVAL;
 
 	pr_debug("device: '%s': %s: renaming to '%s'\n", dev->bus_id,
-		 __FUNCTION__, new_name);
+		 __func__, new_name);
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	if ((dev->class) && (dev->parent))
@@ -1244,7 +1244,7 @@ int device_rename(struct device *dev, char *new_name)
 					  dev->bus_id);
 		if (error) {
 			dev_err(dev, "%s: sysfs_create_symlink failed (%d)\n",
-				__FUNCTION__, error);
+				__func__, error);
 		}
 	}
 #endif
@@ -1320,7 +1320,7 @@ int device_move(struct device *dev, struct device *new_parent)
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
index 7ae413f..d7505c1 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -193,7 +193,7 @@ memory_block_action(struct memory_block *mem, unsigned long action)
 			break;
 		default:
 			printk(KERN_WARNING "%s(%p, %ld) unknown action: %ld\n",
-					__FUNCTION__, mem, action, action);
+					__func__, mem, action, action);
 			WARN_ON(1);
 			ret = -EINVAL;
 	}
@@ -451,6 +451,6 @@ int __init memory_dev_init(void)
 		ret = err;
 out:
 	if (ret)
-		printk(KERN_ERR "%s() failed: %d\n", __FUNCTION__, ret);
+		printk(KERN_ERR "%s() failed: %d\n", __func__, ret);
 	return ret;
 }
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 2f79c55..8140e2d 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -178,7 +178,7 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 		}
 	} else {
 		err = -EINVAL;
-		printk(KERN_ERR "%s: invalid device class\n", __FUNCTION__);
+		printk(KERN_ERR "%s: invalid device class\n", __func__);
 		WARN_ON(1);
 	}
 	mutex_unlock(&sysdev_drivers_lock);
-- 
1.5.4.3.500.g83a2c



