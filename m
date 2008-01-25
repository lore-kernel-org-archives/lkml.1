Return-Path: <linux-kernel-owner+w=401wt.eu-S1763215AbYAYHvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763215AbYAYHvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbYAYHf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:35:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761948AbYAYHf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:35:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 091/196] firmware: remove firmware_(un)register()
Date: Thu, 24 Jan 2008 23:32:00 -0800
Message-Id: <1201246425-5058-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
index c7f635b..9efff48 100644
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
@@ -18,18 +18,6 @@
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
 	firmware_kset = kset_create_and_add("firmware", NULL, NULL);
@@ -37,6 +25,3 @@ int __init firmware_init(void)
 		return -ENOMEM;
 	return 0;
 }
-
-EXPORT_SYMBOL_GPL(firmware_register);
-EXPORT_SYMBOL_GPL(firmware_unregister);
diff --git a/include/linux/device.h b/include/linux/device.h
index 110ace0..a3b3ff1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -555,11 +555,6 @@ extern void device_shutdown(void);
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
1.5.3.8

