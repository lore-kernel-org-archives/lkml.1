Return-Path: <linux-kernel-owner+w=401wt.eu-S932161AbZDRS4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbZDRS4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZDRSw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:52:29 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:46994 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbZDRSw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:52:27 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH/RFC 01/16] platform: Make platform resources input parameters const
Date: Sat, 18 Apr 2009 20:52:09 +0200
Message-Id: <1240080744-14995-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the platform resources input parameters of platform_device_add_resources()
and platform_device_register_simple() const, as the resources are copied and
never modified.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |    4 ++--
 include/linux/platform_device.h |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index b5b6c97..2c83e21 100644
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
index 72736fd..1391a5d 100644
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
1.6.2.3

