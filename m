Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbZGaVkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbZGaVkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZGaVkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:40:52 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:15373 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751800AbZGaVkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:40:51 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/base: cosmetic move of EXPORT* after functions
Date: Fri, 31 Jul 2009 14:40:47 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907311440.47934.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation/CodingStyle, the EXPORT* macro should be used
right after the exported function.  This fixes all the source files in drivers/base
and cleans up some whitespace issues.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/base/class.c b/drivers/base/class.c
index eb85e43..41389fd 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -85,12 +85,14 @@ int class_create_file(struct class *cls, const struct class_attribute *attr)
 		error = -EINVAL;
 	return error;
 }
+EXPORT_SYMBOL_GPL(class_create_file);
 
 void class_remove_file(struct class *cls, const struct class_attribute *attr)
 {
 	if (cls)
 		sysfs_remove_file(&cls->p->class_subsys.kobj, &attr->attr);
 }
+EXPORT_SYMBOL_GPL(class_remove_file);
 
 static struct class *class_get(struct class *cls)
 {
@@ -201,6 +203,7 @@ void class_unregister(struct class *cls)
 	remove_class_attrs(cls);
 	kset_unregister(&cls->p->class_subsys);
 }
+EXPORT_SYMBOL_GPL(class_unregister);
 
 static void class_create_release(struct class *cls)
 {
@@ -262,6 +265,7 @@ void class_destroy(struct class *cls)
 
 	class_unregister(cls);
 }
+EXPORT_SYMBOL_GPL(class_destroy);
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 char *make_class_name(const char *name, struct kobject *kobj)
@@ -465,6 +469,7 @@ int class_interface_register(struct class_interface *class_intf)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(class_interface_register);
 
 void class_interface_unregister(struct class_interface *class_intf)
 {
@@ -487,6 +492,7 @@ void class_interface_unregister(struct class_interface *class_intf)
 
 	class_put(parent);
 }
+EXPORT_SYMBOL_GPL(class_interface_unregister);
 
 int __init classes_init(void)
 {
@@ -495,11 +501,3 @@ int __init classes_init(void)
 		return -ENOMEM;
 	return 0;
 }
-
-EXPORT_SYMBOL_GPL(class_create_file);
-EXPORT_SYMBOL_GPL(class_remove_file);
-EXPORT_SYMBOL_GPL(class_unregister);
-EXPORT_SYMBOL_GPL(class_destroy);
-
-EXPORT_SYMBOL_GPL(class_interface_register);
-EXPORT_SYMBOL_GPL(class_interface_unregister);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7ecb193..07dd0b5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -443,6 +443,7 @@ int device_create_file(struct device *dev, struct device_attribute *attr)
 		error = sysfs_create_file(&dev->kobj, &attr->attr);
 	return error;
 }
+EXPORT_SYMBOL_GPL(device_create_file);
 
 /**
  * device_remove_file - remove sysfs attribute file.
@@ -454,6 +455,7 @@ void device_remove_file(struct device *dev, struct device_attribute *attr)
 	if (dev)
 		sysfs_remove_file(&dev->kobj, &attr->attr);
 }
+EXPORT_SYMBOL_GPL(device_remove_file);
 
 /**
  * device_create_bin_file - create sysfs binary attribute file for device.
@@ -557,6 +559,7 @@ void device_initialize(struct device *dev)
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 }
+EXPORT_SYMBOL_GPL(device_initialize);
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 static struct kobject *get_device_parent(struct device *dev,
@@ -992,6 +995,7 @@ name_error:
 	dev->p = NULL;
 	goto done;
 }
+EXPORT_SYMBOL_GPL(device_add);
 
 /**
  * device_register - register a device with the system.
@@ -1013,6 +1017,7 @@ int device_register(struct device *dev)
 	device_initialize(dev);
 	return device_add(dev);
 }
+EXPORT_SYMBOL_GPL(device_register);
 
 /**
  * get_device - increment reference count for device.
@@ -1026,6 +1031,7 @@ struct device *get_device(struct device *dev)
 {
 	return dev ? to_dev(kobject_get(&dev->kobj)) : NULL;
 }
+EXPORT_SYMBOL_GPL(get_device);
 
 /**
  * put_device - decrement reference count.
@@ -1037,6 +1043,7 @@ void put_device(struct device *dev)
 	if (dev)
 		kobject_put(&dev->kobj);
 }
+EXPORT_SYMBOL_GPL(put_device);
 
 /**
  * device_del - delete device from system.
@@ -1104,6 +1111,7 @@ void device_del(struct device *dev)
 	kobject_del(&dev->kobj);
 	put_device(parent);
 }
+EXPORT_SYMBOL_GPL(device_del);
 
 /**
  * device_unregister - unregister device from system.
@@ -1122,6 +1130,7 @@ void device_unregister(struct device *dev)
 	device_del(dev);
 	put_device(dev);
 }
+EXPORT_SYMBOL_GPL(device_unregister);
 
 static struct device *next_device(struct klist_iter *i)
 {
@@ -1205,6 +1214,7 @@ int device_for_each_child(struct device *parent, void *data,
 	klist_iter_exit(&i);
 	return error;
 }
+EXPORT_SYMBOL_GPL(device_for_each_child);
 
 /**
  * device_find_child - device iterator for locating a particular device.
@@ -1237,6 +1247,7 @@ struct device *device_find_child(struct device *parent, void *data,
 	klist_iter_exit(&i);
 	return child;
 }
+EXPORT_SYMBOL_GPL(device_find_child);
 
 int __init devices_init(void)
 {
@@ -1264,21 +1275,6 @@ int __init devices_init(void)
 	return -ENOMEM;
 }
 
-EXPORT_SYMBOL_GPL(device_for_each_child);
-EXPORT_SYMBOL_GPL(device_find_child);
-
-EXPORT_SYMBOL_GPL(device_initialize);
-EXPORT_SYMBOL_GPL(device_add);
-EXPORT_SYMBOL_GPL(device_register);
-
-EXPORT_SYMBOL_GPL(device_del);
-EXPORT_SYMBOL_GPL(device_unregister);
-EXPORT_SYMBOL_GPL(get_device);
-EXPORT_SYMBOL_GPL(put_device);
-
-EXPORT_SYMBOL_GPL(device_create_file);
-EXPORT_SYMBOL_GPL(device_remove_file);
-
 struct root_device
 {
 	struct device dev;
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7376367..371ea67 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -556,6 +556,7 @@ request_firmware(const struct firmware **firmware_p, const char *name,
         int uevent = 1;
         return _request_firmware(firmware_p, name, device, uevent);
 }
+EXPORT_SYMBOL(request_firmware);
 
 /**
  * release_firmware: - release the resource associated with a firmware image
@@ -577,6 +578,7 @@ release_firmware(const struct firmware *fw)
 		kfree(fw);
 	}
 }
+EXPORT_SYMBOL(release_firmware);
 
 /* Async support */
 struct firmware_work {
@@ -665,6 +667,7 @@ request_firmware_nowait(
 	}
 	return 0;
 }
+EXPORT_SYMBOL(request_firmware_nowait);
 
 static int __init
 firmware_class_init(void)
@@ -692,7 +695,3 @@ firmware_class_exit(void)
 
 fs_initcall(firmware_class_init);
 module_exit(firmware_class_exit);
-
-EXPORT_SYMBOL(release_firmware);
-EXPORT_SYMBOL(request_firmware);
-EXPORT_SYMBOL(request_firmware_nowait);
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 0d90390..216e6f3 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -29,7 +29,6 @@
 #define to_sysdev(k) container_of(k, struct sys_device, kobj)
 #define to_sysdev_attr(a) container_of(a, struct sysdev_attribute, attr)
 
-
 static ssize_t
 sysdev_show(struct kobject *kobj, struct attribute *attr, char *buffer)
 {
@@ -41,7 +40,6 @@ sysdev_show(struct kobject *kobj, struct attribute *attr, char *buffer)
 	return -EIO;
 }
 
-
 static ssize_t
 sysdev_store(struct kobject *kobj, struct attribute *attr,
 	     const char *buffer, size_t count)
@@ -63,19 +61,16 @@ static struct kobj_type ktype_sysdev = {
 	.sysfs_ops	= &sysfs_ops,
 };
 
-
 int sysdev_create_file(struct sys_device *s, struct sysdev_attribute *a)
 {
 	return sysfs_create_file(&s->kobj, &a->attr);
 }
-
+EXPORT_SYMBOL_GPL(sysdev_create_file);
 
 void sysdev_remove_file(struct sys_device *s, struct sysdev_attribute *a)
 {
 	sysfs_remove_file(&s->kobj, &a->attr);
 }
-
-EXPORT_SYMBOL_GPL(sysdev_create_file);
 EXPORT_SYMBOL_GPL(sysdev_remove_file);
 
 #define to_sysdev_class(k) container_of(k, struct sysdev_class, kset.kobj)
@@ -147,6 +142,7 @@ int sysdev_class_register(struct sysdev_class *cls)
 
 	return kset_register(&cls->kset);
 }
+EXPORT_SYMBOL_GPL(sysdev_class_register);
 
 void sysdev_class_unregister(struct sysdev_class *cls)
 {
@@ -154,8 +150,6 @@ void sysdev_class_unregister(struct sysdev_class *cls)
 		 kobject_name(&cls->kset.kobj));
 	kset_unregister(&cls->kset);
 }
-
-EXPORT_SYMBOL_GPL(sysdev_class_register);
 EXPORT_SYMBOL_GPL(sysdev_class_unregister);
 
 static DEFINE_MUTEX(sysdev_drivers_lock);
@@ -169,7 +163,6 @@ static DEFINE_MUTEX(sysdev_drivers_lock);
  *	called on each operation on devices of that class. The refcount
  *	of @cls is incremented.
  */
-
 int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 {
 	int err = 0;
@@ -203,7 +196,7 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 	mutex_unlock(&sysdev_drivers_lock);
 	return err;
 }
-
+EXPORT_SYMBOL_GPL(sysdev_driver_register);
 
 /**
  *	sysdev_driver_unregister - Remove an auxillary driver.
@@ -225,12 +218,8 @@ void sysdev_driver_unregister(struct sysdev_class *cls,
 	}
 	mutex_unlock(&sysdev_drivers_lock);
 }
-
-EXPORT_SYMBOL_GPL(sysdev_driver_register);
 EXPORT_SYMBOL_GPL(sysdev_driver_unregister);
 
-
-
 /**
  *	sysdev_register - add a system device to the tree
  *	@sysdev:	device in question
@@ -280,6 +269,7 @@ int sysdev_register(struct sys_device *sysdev)
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(sysdev_register);
 
 void sysdev_unregister(struct sys_device *sysdev)
 {
@@ -294,8 +284,7 @@ void sysdev_unregister(struct sys_device *sysdev)
 
 	kobject_put(&sysdev->kobj);
 }
-
-
+EXPORT_SYMBOL_GPL(sysdev_unregister);
 
 /**
  *	sysdev_shutdown - Shut down all system devices.
@@ -500,9 +489,6 @@ int __init system_bus_init(void)
 	return 0;
 }
 
-EXPORT_SYMBOL_GPL(sysdev_register);
-EXPORT_SYMBOL_GPL(sysdev_unregister);
-
 #define to_ext_attr(x) container_of(x, struct sysdev_ext_attribute, attr)
 
 ssize_t sysdev_store_ulong(struct sys_device *sysdev,
