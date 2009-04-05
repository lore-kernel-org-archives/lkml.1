Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbZDEKPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbZDEKPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 06:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbZDEKOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 06:14:51 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:37339 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758831AbZDEKOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 06:14:50 -0400
Date: Sun, 5 Apr 2009 12:14:44 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] platform: Make platform resources input parameters const
Message-ID: <Pine.LNX.4.64.0904051214110.31394@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the platform resources input parameters of platform_device_add_resources()
and platform_device_register_simple() const, as the resources are copied and
never modified.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/base/platform.c         |    4 ++--
 include/linux/platform_device.h |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index d2198f6..25e23f9 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -184,7 +184,7 @@ EXPORT_SYMBOL_GPL(platform_device_alloc);
  * released.
  */
 int platform_device_add_resources(struct platform_device *pdev,
-				  struct resource *res, unsigned int num)
+				  const struct resource *res, unsigned int num)
 {
 	struct resource *r;
 
@@ -379,7 +379,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregister);
  */
 struct platform_device *platform_device_register_simple(const char *name,
 							int id,
-							struct resource *res,
+							const struct resource *res,
 							unsigned int num)
 {
 	struct platform_device *pdev;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 76e470a..e5c2b64 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -42,12 +42,14 @@ extern int platform_get_irq_byname(struct platform_device *, char *);
 extern int platform_add_devices(struct platform_device **, int);
 
 extern struct platform_device *platform_device_register_simple(const char *, int id,
-					struct resource *, unsigned int);
+					const struct resource *, unsigned int);
 extern struct platform_device *platform_device_register_data(struct device *,
 		const char *, int, const void *, size_t);
 
 extern struct platform_device *platform_device_alloc(const char *name, int id);
-extern int platform_device_add_resources(struct platform_device *pdev, struct resource *res, unsigned int num);
+extern int platform_device_add_resources(struct platform_device *pdev,
+					 const struct resource *res,
+					 unsigned int num);
 extern int platform_device_add_data(struct platform_device *pdev, const void *data, size_t size);
 extern int platform_device_add(struct platform_device *pdev);
 extern void platform_device_del(struct platform_device *pdev);
-- 
1.6.2.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
