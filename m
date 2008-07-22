Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYGVFbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYGVFbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbYGVFXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565AbYGVFXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/79] device create: convert device_create_drvdata to device_create
Date: Mon, 21 Jul 2008 22:18:54 -0700
Message-Id: <1216703983-21448-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Keep the device_create_drvdata macro around to make merges easier.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |   11 ++++-------
 include/linux/device.h |    9 ++++-----
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4dc0d27..9ae28aa 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1236,7 +1236,7 @@ error:
 EXPORT_SYMBOL_GPL(device_create_vargs);
 
 /**
- * device_create_drvdata - creates a device and registers it with sysfs
+ * device_create - creates a device and registers it with sysfs
  * @class: pointer to the struct class that this device should be registered to
  * @parent: pointer to the parent struct device of this new device, if any
  * @devt: the dev_t for the char device to be added
@@ -1257,11 +1257,8 @@ EXPORT_SYMBOL_GPL(device_create_vargs);
  * Note: the struct class passed to this function must have previously
  * been created with a call to class_create().
  */
-struct device *device_create_drvdata(struct class *class,
-				     struct device *parent,
-				     dev_t devt,
-				     void *drvdata,
-				     const char *fmt, ...)
+struct device *device_create(struct class *class, struct device *parent,
+			     dev_t devt, void *drvdata, const char *fmt, ...)
 {
 	va_list vargs;
 	struct device *dev;
@@ -1271,7 +1268,7 @@ struct device *device_create_drvdata(struct class *class,
 	va_end(vargs);
 	return dev;
 }
-EXPORT_SYMBOL_GPL(device_create_drvdata);
+EXPORT_SYMBOL_GPL(device_create);
 
 static int __match_devt(struct device *dev, void *data)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index a3ef5a2..de17871 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -470,12 +470,11 @@ extern struct device *device_create_vargs(struct class *cls,
 					  void *drvdata,
 					  const char *fmt,
 					  va_list vargs);
-extern struct device *device_create_drvdata(struct class *cls,
-					    struct device *parent,
-					    dev_t devt,
-					    void *drvdata,
-					    const char *fmt, ...)
+extern struct device *device_create(struct class *cls, struct device *parent,
+				    dev_t devt, void *drvdata,
+				    const char *fmt, ...)
 				    __attribute__((format(printf, 5, 6)));
+#define device_create_drvdata	device_create
 extern void device_destroy(struct class *cls, dev_t devt);
 
 /*
-- 
1.5.6.3

