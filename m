Return-Path: <linux-kernel-owner+w=401wt.eu-S936085AbZFPFwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936085AbZFPFwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZFPFu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:50:56 -0400
Received: from kroah.org ([198.145.64.141]:48304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbZFPFuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/64] driver core: Const-correct platform getbyname functions
Date: Mon, 15 Jun 2009 22:45:56 -0700
Message-Id: <1245131213-24168-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.ml.walleij@gmail.com>

This converts resource and IRQ getbyname functions for the platform
bus to use const char *, I ran into compiler moanings when I tried
using a const char * for looking up a certain resource.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |    5 +++--
 include/linux/platform_device.h |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ead3f64..59df629 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -69,7 +69,8 @@ EXPORT_SYMBOL_GPL(platform_get_irq);
  * @name: resource name
  */
 struct resource *platform_get_resource_byname(struct platform_device *dev,
-					      unsigned int type, char *name)
+					      unsigned int type,
+					      const char *name)
 {
 	int i;
 
@@ -88,7 +89,7 @@ EXPORT_SYMBOL_GPL(platform_get_resource_byname);
  * @dev: platform device
  * @name: IRQ name
  */
-int platform_get_irq_byname(struct platform_device *dev, char *name)
+int platform_get_irq_byname(struct platform_device *dev, const char *name)
 {
 	struct resource *r = platform_get_resource_byname(dev, IORESOURCE_IRQ,
 							  name);
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index b67bb5d..8dc5123 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -36,8 +36,8 @@ extern struct device platform_bus;
 
 extern struct resource *platform_get_resource(struct platform_device *, unsigned int, unsigned int);
 extern int platform_get_irq(struct platform_device *, unsigned int);
-extern struct resource *platform_get_resource_byname(struct platform_device *, unsigned int, char *);
-extern int platform_get_irq_byname(struct platform_device *, char *);
+extern struct resource *platform_get_resource_byname(struct platform_device *, unsigned int, const char *);
+extern int platform_get_irq_byname(struct platform_device *, const char *);
 extern int platform_add_devices(struct platform_device **, int);
 
 extern struct platform_device *platform_device_register_simple(const char *, int id,
-- 
1.6.3.2

