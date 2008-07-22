Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYGVFbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYGVFbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbYGVFX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:28 -0400
Received: from mail.suse.de ([195.135.220.2]:53865 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522AbYGVFX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/79] driver core: remove device_create()
Date: Mon, 21 Jul 2008 22:18:53 -0700
Message-Id: <1216703983-21448-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more users of this, and it is racy.  Use
device_create_drvdata() or device_create_vargs() instead.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |   34 ----------------------------------
 include/linux/device.h |    3 ---
 2 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index be9aba4..4dc0d27 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1273,40 +1273,6 @@ struct device *device_create_drvdata(struct class *class,
 }
 EXPORT_SYMBOL_GPL(device_create_drvdata);
 
-/**
- * device_create - creates a device and registers it with sysfs
- * @class: pointer to the struct class that this device should be registered to
- * @parent: pointer to the parent struct device of this new device, if any
- * @devt: the dev_t for the char device to be added
- * @fmt: string for the device's name
- *
- * This function can be used by char device classes.  A struct device
- * will be created in sysfs, registered to the specified class.
- *
- * A "dev" file will be created, showing the dev_t for the device, if
- * the dev_t is not 0,0.
- * If a pointer to a parent struct device is passed in, the newly created
- * struct device will be a child of that device in sysfs.
- * The pointer to the struct device will be returned from the call.
- * Any further sysfs files that might be required can be created using this
- * pointer.
- *
- * Note: the struct class passed to this function must have previously
- * been created with a call to class_create().
- */
-struct device *device_create(struct class *class, struct device *parent,
-			     dev_t devt, const char *fmt, ...)
-{
-	va_list vargs;
-	struct device *dev;
-
-	va_start(vargs, fmt);
-	dev = device_create_vargs(class, parent, devt, NULL, fmt, vargs);
-	va_end(vargs);
-	return dev;
-}
-EXPORT_SYMBOL_GPL(device_create);
-
 static int __match_devt(struct device *dev, void *data)
 {
 	dev_t *devt = data;
diff --git a/include/linux/device.h b/include/linux/device.h
index e49aa74..a3ef5a2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -470,9 +470,6 @@ extern struct device *device_create_vargs(struct class *cls,
 					  void *drvdata,
 					  const char *fmt,
 					  va_list vargs);
-extern struct device *device_create(struct class *cls, struct device *parent,
-				    dev_t devt, const char *fmt, ...)
-				    __attribute__((format(printf, 4, 5)));
 extern struct device *device_create_drvdata(struct class *cls,
 					    struct device *parent,
 					    dev_t devt,
-- 
1.5.6.3

