Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYIRAZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYIRAZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 20:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYIRAZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 20:25:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:41339 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYIRAZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 20:25:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i2GyuDNgaQaHINO3MSkCTTusMnrjY2L/TN1Ota71hL7B+maSa7L1Nn++6QgwfShDxF
         jr6V4DnZwzYJTd5+UoYviaRQtK6zK1F02DMjpFrvunxnJ7vitLMjW9pUsZr7pIWNGEb5
         H9eQORKHN4Xjoq+D96j7t2N8o7K59cx0o1a4A=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 7/7] pci: add KERN_PCI
Date: Wed, 17 Sep 2008 17:18:31 -0700
Message-Id: <1221697112-21814-8-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1221697112-21814-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221697112-21814-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use DEFINE_LOGLEVEL_SETUP to set loglevel for dev

so could use loglevel=4,dev:8 it will only print out info with dev_printk

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/base/core.c    |    2 ++
 include/linux/device.h |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -26,6 +26,8 @@
 #include "base.h"
 #include "power/power.h"
 
+DEFINE_LOGLEVEL_SETUP(dev, KERN_DEV, "dev:");
+
 int (*platform_notify)(struct device *dev) = NULL;
 int (*platform_notify_remove)(struct device *dev) = NULL;
 static struct kobject *dev_kobj;
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -518,10 +518,12 @@ extern void device_shutdown(void);
 /* drivers/base/sys.c */
 extern void sysdev_shutdown(void);
 
+#define KERN_DEV "<dev>"
+
 /* debugging and troubleshooting/diagnostic helpers. */
 extern const char *dev_driver_string(const struct device *dev);
 #define dev_printk(level, dev, format, arg...)	\
-	printk(level "%s %s: " format , dev_driver_string(dev) , \
+	printk(level KERN_DEV "%s %s: " format , dev_driver_string(dev) , \
 	       dev_name(dev) , ## arg)
 
 #define dev_emerg(dev, format, arg...)		\
@@ -538,6 +540,8 @@ extern const char *dev_driver_string(con
 	dev_printk(KERN_NOTICE , dev , format , ## arg)
 #define dev_info(dev, format, arg...)		\
 	dev_printk(KERN_INFO , dev , format , ## arg)
+#define dev_debug(dev, format, arg...)		\
+	dev_printk(KERN_DEBUG , dev , format , ## arg)
 
 #ifdef DEBUG
 #define dev_dbg(dev, format, arg...)		\
