Return-Path: <linux-kernel-owner+w=401wt.eu-S1764345AbXKCARr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764345AbXKCARr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762312AbXKCADl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:03:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:41253 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762311AbXKCADk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:03:40 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 52/54] firmware: remove firmware_(un)register()
Date: Fri,  2 Nov 2007 16:59:30 -0700
Message-Id: <1194047972-9850-52-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are no longer called or needed, so we can remove them.

As I rewrote the whole firmware.c file, add my copyright.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware.c |   19 ++-----------------
 include/linux/device.h  |    5 -----
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/base/firmware.c b/drivers/base/firmware.c
index d225059..75e3049 100644
--- a/drivers/base/firmware.c
+++ b/drivers/base/firmware.c
@@ -3,11 +3,11 @@
  *
  * Copyright (c) 2002-3 Patrick Mochel
  * Copyright (c) 2002-3 Open Source Development Labs
+ * Copyright (c) 2007 Greg Kroah-Hartman <gregkh@suse.de>
+ * Copyright (c) 2007 Novell Inc.
  *
  * This file is released under the GPLv2
- *
  */
-
 #include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -19,18 +19,6 @@
 struct kset *firmware_kset;
 EXPORT_SYMBOL_GPL(firmware_kset);
 
-int firmware_register(struct kset *s)
-{
-	s->kobj.kset = firmware_kset;
-	s->kobj.ktype = NULL;
-	return subsystem_register(s);
-}
-
-void firmware_unregister(struct kset *s)
-{
-	subsystem_unregister(s);
-}
-
 int __init firmware_init(void)
 {
 	firmware_kset = kset_create_and_register("firmware", NULL, NULL, NULL);
@@ -38,6 +26,3 @@ int __init firmware_init(void)
 		return PTR_ERR(firmware_kset);
 	return 0;
 }
-
-EXPORT_SYMBOL_GPL(firmware_register);
-EXPORT_SYMBOL_GPL(firmware_unregister);
diff --git a/include/linux/device.h b/include/linux/device.h
index 3701269..cb71907 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -541,11 +541,6 @@ extern void device_shutdown(void);
 /* drivers/base/sys.c */
 extern void sysdev_shutdown(void);
 
-
-/* drivers/base/firmware.c */
-extern int __must_check firmware_register(struct kset *);
-extern void firmware_unregister(struct kset *);
-
 /* debugging and troubleshooting/diagnostic helpers. */
 extern const char *dev_driver_string(struct device *dev);
 #define dev_printk(level, dev, format, arg...)	\
-- 
1.5.3.4

