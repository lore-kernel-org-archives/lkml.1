Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbXLESZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbXLESZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 13:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbXLESZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 13:25:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:21623 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXLESZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 13:25:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=lVex04zXYDcoG008ErfRevbdsSZPWksKlsqa3lnwa5GixQJAd9Ssb9XspnwEw3Au+cGfs0G6xeCfrL5FP7LLPwJZ1NFZeRYJb4xH0td2OsGQtd1Pb2gZv58wgAZWr9x7+4aBxbmqM6Q35ZDBmHX6TIPAXnFNSV92D8jBeqhqa/I=
From: Denis Cheng <crquan@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/base: use LIST_HEAD instead of call to INIT_LIST_HEAD in __init
Date: Thu,  6 Dec 2007 02:24:40 +0800
Message-Id: <1196879080-13408-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LIST_HEAD has been widely used, so switch to this simpler method.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/base/attribute_container.c |    9 +--------
 drivers/base/base.h                |    1 -
 drivers/base/init.c                |    1 -
 3 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 7370d7c..d4dfb97 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -61,7 +61,7 @@ attribute_container_classdev_to_container(struct class_device *classdev)
 }
 EXPORT_SYMBOL_GPL(attribute_container_classdev_to_container);
 
-static struct list_head attribute_container_list;
+static LIST_HEAD(attribute_container_list);
 
 static DEFINE_MUTEX(attribute_container_mutex);
 
@@ -429,10 +429,3 @@ attribute_container_find_class_device(struct attribute_container *cont,
 	return cdev;
 }
 EXPORT_SYMBOL_GPL(attribute_container_find_class_device);
-
-int __init
-attribute_container_init(void)
-{
-	INIT_LIST_HEAD(&attribute_container_list);
-	return 0;
-}
diff --git a/drivers/base/base.h b/drivers/base/base.h
index 10b2fb6..8bddd74 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -13,7 +13,6 @@ static inline int hypervisor_init(void) { return 0; }
 extern int platform_bus_init(void);
 extern int system_bus_init(void);
 extern int cpu_dev_init(void);
-extern int attribute_container_init(void);
 
 extern int bus_add_device(struct device * dev);
 extern void bus_attach_device(struct device * dev);
diff --git a/drivers/base/init.c b/drivers/base/init.c
index 3713815..1da88a1 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -36,5 +36,4 @@ void __init driver_init(void)
 	system_bus_init();
 	cpu_dev_init();
 	memory_dev_init();
-	attribute_container_init();
 }
-- 
1.5.3.4

