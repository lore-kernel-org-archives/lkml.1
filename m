Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYAYIPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYAYIPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763894AbYAYIAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:39 -0500
Received: from mail.suse.de ([195.135.220.2]:59429 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763893AbYAYH7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Denis Cheng <crquan@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 181/196] Driver core: use LIST_HEAD instead of call to INIT_LIST_HEAD in __init
Date: Thu, 24 Jan 2008 23:33:30 -0800
Message-Id: <1201246425-5058-102-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

LIST_HEAD has been widely used, so switch to this simpler method.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
index 3b0f395..a74ceda 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -49,7 +49,6 @@ static inline int hypervisor_init(void) { return 0; }
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
1.5.3.8

