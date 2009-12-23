Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbZLWT4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbZLWT4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZLWTxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:53:15 -0500
Received: from kroah.org ([198.145.64.141]:52951 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbZLWTxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:53:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/10] Driver core: driver_attribute parameters can often be const*
Date: Wed, 23 Dec 2009 11:52:39 -0800
Message-Id: <1261597963-18323-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.6
In-Reply-To: <20091223194955.GB18101@kroah.com>
References: <20091223194955.GB18101@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Many struct driver_attribute descriptors are purely read-only
structures, and there's no need to change them. Therefore make
the promise not to, which will let those descriptors be put in
a ro section.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/driver-model/driver.txt |    4 ++--
 Documentation/filesystems/sysfs.txt   |    4 ++--
 drivers/base/driver.c                 |    4 ++--
 include/linux/device.h                |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/driver-model/driver.txt b/Documentation/driver-model/driver.txt
index 60120fb..d2cd6fb 100644
--- a/Documentation/driver-model/driver.txt
+++ b/Documentation/driver-model/driver.txt
@@ -226,5 +226,5 @@ struct driver_attribute driver_attr_debug;
 This can then be used to add and remove the attribute from the
 driver's directory using:
 
-int driver_create_file(struct device_driver *, struct driver_attribute *);
-void driver_remove_file(struct device_driver *, struct driver_attribute *);
+int driver_create_file(struct device_driver *, const struct driver_attribute *);
+void driver_remove_file(struct device_driver *, const struct driver_attribute *);
diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index a4ac2b9..931c806 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -358,7 +358,7 @@ DRIVER_ATTR(_name, _mode, _show, _store)
 
 Creation/Removal:
 
-int driver_create_file(struct device_driver *, struct driver_attribute *);
-void driver_remove_file(struct device_driver *, struct driver_attribute *);
+int driver_create_file(struct device_driver *, const struct driver_attribute *);
+void driver_remove_file(struct device_driver *, const struct driver_attribute *);
 
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index f367885..90c9fff 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -98,7 +98,7 @@ EXPORT_SYMBOL_GPL(driver_find_device);
  * @attr: driver attribute descriptor.
  */
 int driver_create_file(struct device_driver *drv,
-		       struct driver_attribute *attr)
+		       const struct driver_attribute *attr)
 {
 	int error;
 	if (drv)
@@ -115,7 +115,7 @@ EXPORT_SYMBOL_GPL(driver_create_file);
  * @attr: driver attribute descriptor.
  */
 void driver_remove_file(struct device_driver *drv,
-			struct driver_attribute *attr)
+			const struct driver_attribute *attr)
 {
 	if (drv)
 		sysfs_remove_file(&drv->p->kobj, &attr->attr);
diff --git a/include/linux/device.h b/include/linux/device.h
index 10d74ce..a62799f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -166,9 +166,9 @@ struct driver_attribute driver_attr_##_name =		\
 	__ATTR(_name, _mode, _show, _store)
 
 extern int __must_check driver_create_file(struct device_driver *driver,
-					   struct driver_attribute *attr);
+					const struct driver_attribute *attr);
 extern void driver_remove_file(struct device_driver *driver,
-			       struct driver_attribute *attr);
+			       const struct driver_attribute *attr);
 
 extern int __must_check driver_add_kobj(struct device_driver *drv,
 					struct kobject *kobj,
-- 
1.6.5.7

