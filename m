Return-Path: <linux-kernel-owner+w=401wt.eu-S933784AbXJLWjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbXJLWjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932536AbXJLWUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:53330 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932591AbXJLWU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/75] sysdev: remove global sysdev drivers list
Date: Fri, 12 Oct 2007 15:16:40 -0700
Message-Id: <1192227611369-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227603335-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

No one uses sysdev_drivers. Because no one calls sysdev_driver_register
with NULL class.

And it is difficult to imagine that someone want to implement a global
sysdev driver which is called with all sys_device on any kind of
sysdev_class.

So this patch removes global sysdev_drivers list and update comments
for this change.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |   71 ++++++++++-----------------------------------------
 1 files changed, 14 insertions(+), 57 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 7ad8931..ac7ff6d 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -153,25 +153,22 @@ void sysdev_class_unregister(struct sysdev_class * cls)
 EXPORT_SYMBOL_GPL(sysdev_class_register);
 EXPORT_SYMBOL_GPL(sysdev_class_unregister);
 
-
-static LIST_HEAD(sysdev_drivers);
 static DEFINE_MUTEX(sysdev_drivers_lock);
 
 /**
  *	sysdev_driver_register - Register auxillary driver
- * 	@cls:	Device class driver belongs to.
+ *	@cls:	Device class driver belongs to.
  *	@drv:	Driver.
  *
- *	If @cls is valid, then @drv is inserted into @cls->drivers to be
+ *	@drv is inserted into @cls->drivers to be
  *	called on each operation on devices of that class. The refcount
  *	of @cls is incremented.
- *	Otherwise, @drv is inserted into sysdev_drivers, and called for
- *	each device.
  */
 
-int sysdev_driver_register(struct sysdev_class * cls,
-			   struct sysdev_driver * drv)
+int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 {
+	int err = 0;
+
 	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
 		list_add_tail(&drv->entry, &cls->drivers);
@@ -182,10 +179,13 @@ int sysdev_driver_register(struct sysdev_class * cls,
 			list_for_each_entry(dev, &cls->kset.list, kobj.entry)
 				drv->add(dev);
 		}
-	} else
-		list_add_tail(&drv->entry, &sysdev_drivers);
+	} else {
+		err = -EINVAL;
+		printk(KERN_ERR "%s: invalid device class\n", __FUNCTION__);
+		WARN_ON(1);
+	}
 	mutex_unlock(&sysdev_drivers_lock);
-	return 0;
+	return err;
 }
 
 
@@ -251,12 +251,6 @@ int sysdev_register(struct sys_device * sysdev)
 		 * code that should have called us.
 		 */
 
-		/* Notify global drivers */
-		list_for_each_entry(drv, &sysdev_drivers, entry) {
-			if (drv->add)
-				drv->add(sysdev);
-		}
-
 		/* Notify class auxillary drivers */
 		list_for_each_entry(drv, &cls->drivers, entry) {
 			if (drv->add)
@@ -272,11 +266,6 @@ void sysdev_unregister(struct sys_device * sysdev)
 	struct sysdev_driver * drv;
 
 	mutex_lock(&sysdev_drivers_lock);
-	list_for_each_entry(drv, &sysdev_drivers, entry) {
-		if (drv->remove)
-			drv->remove(sysdev);
-	}
-
 	list_for_each_entry(drv, &sysdev->cls->drivers, entry) {
 		if (drv->remove)
 			drv->remove(sysdev);
@@ -293,7 +282,7 @@ void sysdev_unregister(struct sys_device * sysdev)
  *
  *	Loop over each class of system devices, and the devices in each
  *	of those classes. For each device, we call the shutdown method for
- *	each driver registered for the device - the globals, the auxillaries,
+ *	each driver registered for the device - the auxillaries,
  *	and the class driver.
  *
  *	Note: The list is iterated in reverse order, so that we shut down
@@ -320,13 +309,7 @@ void sysdev_shutdown(void)
 			struct sysdev_driver * drv;
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
-			/* Call global drivers first. */
-			list_for_each_entry(drv, &sysdev_drivers, entry) {
-				if (drv->shutdown)
-					drv->shutdown(sysdev);
-			}
-
-			/* Call auxillary drivers next. */
+			/* Call auxillary drivers first */
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->shutdown)
 					drv->shutdown(sysdev);
@@ -354,12 +337,6 @@ static void __sysdev_resume(struct sys_device *dev)
 		if (drv->resume)
 			drv->resume(dev);
 	}
-
-	/* Call global drivers. */
-	list_for_each_entry(drv, &sysdev_drivers, entry) {
-		if (drv->resume)
-			drv->resume(dev);
-	}
 }
 
 /**
@@ -393,16 +370,7 @@ int sysdev_suspend(pm_message_t state)
 		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
-			/* Call global drivers first. */
-			list_for_each_entry(drv, &sysdev_drivers, entry) {
-				if (drv->suspend) {
-					ret = drv->suspend(sysdev, state);
-					if (ret)
-						goto gbl_driver;
-				}
-			}
-
-			/* Call auxillary drivers next. */
+			/* Call auxillary drivers first */
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->suspend) {
 					ret = drv->suspend(sysdev, state);
@@ -436,18 +404,7 @@ aux_driver:
 		if (err_drv->resume)
 			err_drv->resume(sysdev);
 	}
-	drv = NULL;
 
-gbl_driver:
-	if (drv)
-		printk(KERN_ERR "sysdev driver suspend failed for %s\n",
-				kobject_name(&sysdev->kobj));
-	list_for_each_entry(err_drv, &sysdev_drivers, entry) {
-		if (err_drv == drv)
-			break;
-		if (err_drv->resume)
-			err_drv->resume(sysdev);
-	}
 	/* resume other sysdevs in current class */
 	list_for_each_entry(err_dev, &cls->kset.list, kobj.entry) {
 		if (err_dev == sysdev)
-- 
1.5.3.4

