Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbZCSIRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbZCSIRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbZCSIQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 04:16:59 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50246 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZCSIQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 04:16:58 -0400
Date: Thu, 19 Mar 2009 09:16:45 +0100
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Patrick Mochel <mochel@digitalimplant.org>
Subject: [PATCH][RESEND] drivers/base/platform.c: Add
	platform_get_irq_flags()
Message-ID: <20090319081645.GB30293@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For drivers using platform_get_irq(), a function to get the irq flags
supplied by the platform_device definition would be helpful. This patch
adds it.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Patrick Mochel <mochel@digitalimplant.org>
---
 Resending this patch with the original author of that file Cc'ed, and
 hoping that someone cares now :)

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
