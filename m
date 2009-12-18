Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbZLRNeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbZLRNeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZLRNeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:34:19 -0500
Received: from smtp.nokia.com ([192.100.122.233]:53475 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZLRNeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:34:15 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Driver core: driver_attribute parameters can often be const*
Date: Fri, 18 Dec 2009 15:34:21 +0200
Message-Id: <1261143261-399-4-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261143261-399-3-git-send-email-ext-phil.2.carmody@nokia.com>
References: <20091218042007.GA6314@suse.de>
 <1261143261-399-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261143261-399-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261143261-399-3-git-send-email-ext-phil.2.carmody@nokia.com>
X-OriginalArrivalTime: 18 Dec 2009 13:33:54.0731 (UTC) FILETIME=[BE6A17B0:01CA7FE6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many struct driver_attribute descriptors are purely read-only
structures, and there's no need to change them. Therefore make
the promise not to, which will let those descriptors be put in
a ro section.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
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
index 0823a29..d07f90f 100644
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
1.6.0.4

