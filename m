Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZCMOaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZCMOaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZCMO34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:29:56 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:53281 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZCMO34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:29:56 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>
Subject: [PATCH] drivers/base/platform.c: Add platform_get_irq_flags()
Date: Fri, 13 Mar 2009 15:29:42 +0100
Message-Id: <1236954582-10143-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For drivers using platform_get_irq(), a function to get the irq flags
supplied by the platform_device definition would be helpful. This patch
adds it.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/base/platform.c         |   13 +++++++++++++
 include/linux/platform_device.h |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 349a101..3d6a9f4 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -63,6 +63,19 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
 EXPORT_SYMBOL_GPL(platform_get_irq);
 
 /**
+ * platform_get_irq_flags - get flags of an IRQ for a device
+ * @dev: platform device
+ * @num: IRQ number index
+ */
+int platform_get_irq_flags(struct platform_device *dev, unsigned int num)
+{
+	struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);
+
+	return r ? r->flags : -ENXIO;
+}
+EXPORT_SYMBOL_GPL(platform_get_irq_flags);
+
+/**
  * platform_get_resource_byname - get a resource for a device by name
  * @dev: platform device
  * @type: resource type
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 9a34269..a2c6c2c 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -31,6 +31,7 @@ extern struct device platform_bus;
 
 extern struct resource *platform_get_resource(struct platform_device *, unsigned int, unsigned int);
 extern int platform_get_irq(struct platform_device *, unsigned int);
+extern int platform_get_irq_flags(struct platform_device *, unsigned int);
 extern struct resource *platform_get_resource_byname(struct platform_device *, unsigned int, char *);
 extern int platform_get_irq_byname(struct platform_device *, char *);
 extern int platform_add_devices(struct platform_device **, int);
-- 
1.6.2

