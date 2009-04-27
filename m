Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbZD0AiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbZD0AiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 20:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZD0AiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 20:38:19 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64517 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZD0AiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 20:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=G065fkZcdKYAzIbKc/t7LHJ0ecraf9ZKRWuTu0BrmNvxnT+yQ3GOi1EwxtXsxQdPN9
         BGiJOljM7jYH/ll00VAG2rcDgQLU2clGyFGwnzAwIPBVpWY0u2/mOBiaXVAN7sJuBiMQ
         IY5MtiDZ08q/mOR6E4cwuRPU2xo9yeYtnd2Cs=
MIME-Version: 1.0
Date: Mon, 27 Apr 2009 02:38:16 +0200
Message-ID: <63386a3d0904261738y1a2ac4e6of42fcb3cd6b5707b@mail.gmail.com>
Subject: [PATCH] Const-correct platform getbyname functions
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts resource and IRQ getbyname functions for the platform
bus to use const char *, I ran into compiler moanings when I tried
using a const char * for looking up a certain resource.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/base/platform.c         |    4 ++--
 include/linux/platform_device.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index b5b6c97..09d23f8 100644
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

@@ -88,7 +88,7 @@ EXPORT_SYMBOL_GPL(platform_get_resource_byname);
  * @dev: platform device
  * @name: IRQ name
  */
-int platform_get_irq_byname(struct platform_device *dev, char *name)
+int platform_get_irq_byname(struct platform_device *dev, const char *name)
 {
 	struct resource *r = platform_get_resource_byname(dev, IORESOURCE_IRQ,
 							  name);
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 72736fd..c36f33f 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -37,8 +37,8 @@ extern struct device platform_bus;

 extern struct resource *platform_get_resource(struct platform_device
*, unsigned int, unsigned int);
 extern int platform_get_irq(struct platform_device *, unsigned int);
-extern struct resource *platform_get_resource_byname(struct
platform_device *, unsigned int, char *);
-extern int platform_get_irq_byname(struct platform_device *, char *);
+extern struct resource *platform_get_resource_byname(struct
platform_device *, unsigned int, const char *);
+extern int platform_get_irq_byname(struct platform_device *, const char *);
 extern int platform_add_devices(struct platform_device **, int);

 extern struct platform_device *platform_device_register_simple(const
char *, int id,
-- 
1.6.0.6
