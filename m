Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbXJaFM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbXJaFM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbXJaFMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:12:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:34751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbXJaFMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:12:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/6] Driver core: remove class_device_*_bin_file
Date: Tue, 30 Oct 2007 22:11:40 -0700
Message-Id: <1193807505-3821-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071031050954.GA3791@kroah.com>
References: <20071031050954.GA3791@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are not used by anyone, so remove them from the tree.

The class_device code will be removed soon anyway, so no future users
will ever be possible.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c   |   18 ------------------
 include/linux/device.h |    4 ----
 2 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index a863bb0..f6ebe6a 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -257,22 +257,6 @@ void class_device_remove_file(struct class_device * class_dev,
 		sysfs_remove_file(&class_dev->kobj, &attr->attr);
 }
 
-int class_device_create_bin_file(struct class_device *class_dev,
-				 struct bin_attribute *attr)
-{
-	int error = -EINVAL;
-	if (class_dev)
-		error = sysfs_create_bin_file(&class_dev->kobj, attr);
-	return error;
-}
-
-void class_device_remove_bin_file(struct class_device *class_dev,
-				  struct bin_attribute *attr)
-{
-	if (class_dev)
-		sysfs_remove_bin_file(&class_dev->kobj, attr);
-}
-
 static ssize_t
 class_device_attr_show(struct kobject * kobj, struct attribute * attr,
 		       char * buf)
@@ -885,8 +869,6 @@ EXPORT_SYMBOL_GPL(class_device_create);
 EXPORT_SYMBOL_GPL(class_device_destroy);
 EXPORT_SYMBOL_GPL(class_device_create_file);
 EXPORT_SYMBOL_GPL(class_device_remove_file);
-EXPORT_SYMBOL_GPL(class_device_create_bin_file);
-EXPORT_SYMBOL_GPL(class_device_remove_bin_file);
 
 EXPORT_SYMBOL_GPL(class_interface_register);
 EXPORT_SYMBOL_GPL(class_interface_unregister);
diff --git a/include/linux/device.h b/include/linux/device.h
index 2e15822..2c5e49d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -291,10 +291,6 @@ extern void class_device_put(struct class_device *);
 
 extern void class_device_remove_file(struct class_device *, 
 				     const struct class_device_attribute *);
-extern int __must_check class_device_create_bin_file(struct class_device *,
-					struct bin_attribute *);
-extern void class_device_remove_bin_file(struct class_device *,
-					 struct bin_attribute *);
 
 struct class_interface {
 	struct list_head	node;
-- 
1.5.3.4

