Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbZA1Ped@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbZA1Ped (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 10:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZA1PeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 10:34:20 -0500
Received: from smtp.nokia.com ([192.100.122.233]:53290 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbZA1PeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:34:19 -0500
Date: Wed, 28 Jan 2009 17:29:51 +0200 (EET)
Message-Id: <20090128.172951.193700554.Hiroshi.DOYU@nokia.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 05/10] omap mailbox: fix empty struct device for omap1
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <20090128144955.GA23089@n2100.arm.linux.org.uk>
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
	<20090116082727.17571.87307.stgit@oreo.research.nokia.com>
	<20090128144955.GA23089@n2100.arm.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Wed_Jan_28_17_29_51_2009_186)--"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2009 15:29:52.0878 (UTC) FILETIME=[43F410E0:01C9815D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Wed_Jan_28_17_29_51_2009_186)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Russell,

From: ext Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 05/10] omap mailbox: fix empty struct device for omap1
Date: Wed, 28 Jan 2009 15:49:55 +0100

> On Fri, Jan 16, 2009 at 10:27:27AM +0200, Hiroshi DOYU wrote:
> > @@ -17,6 +17,8 @@
> >  #include <mach/mailbox.h>
> >  #include <mach/irqs.h>
> >
> > +#define DRV_NAME "omap1-mailbox"
> 
> I don't see any need for this define - it just adds an additional level of
> indirection when trying to find out the name of the driver.  It's only
> used in two places as is, so it's value is rather limited:

I fixed this along with the patch 06/10 as well. A whole patchset is available as:

The following changes since commit 1de9e8e70f5acc441550ca75433563d91b269bbe:
  Linus Torvalds (1):
        Linux 2.6.29-rc2

are available in the git repository at:

  http://git.gitorious.org/lk/mainline.git mailbox

Hiroshi DOYU (10):
      omap mailbox: cleanup omap2 register definition with macro
      omap mailbox: add initial omap3 support
      omap mailbox: print hardware revision at startup
      omap mailbox: fix empty struct device for omap_mbox
      omap mailbox: fix empty struct device for omap1
      omap mailbox: fix empty struct device for omap2
      omap mailbox: add save_/restore_ctx() for PM
      omap mailbox: move mailbox.h into mailbox.c
      omap mailbox: convert sequence bit checking to module paramter
      omap mailbox: remove unnecessary header file inclusion

 arch/arm/mach-omap1/devices.c              |    2 +-
 arch/arm/mach-omap1/mailbox.c              |   33 +++--
 arch/arm/mach-omap2/devices.c              |   39 ++++--
 arch/arm/mach-omap2/mailbox.c              |  199 ++++++++++++++++------------
 arch/arm/plat-omap/Kconfig                 |    8 +
 arch/arm/plat-omap/include/mach/mailbox.h  |   27 ++++-
 arch/arm/plat-omap/include/mach/omap34xx.h |    1 +
 arch/arm/plat-omap/mailbox.c               |  152 ++++++++++++++++------
 arch/arm/plat-omap/mailbox.h               |  100 --------------
 9 files changed, 313 insertions(+), 248 deletions(-)
 delete mode 100644 arch/arm/plat-omap/mailbox.h

----Next_Part(Wed_Jan_28_17_29_51_2009_186)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0006-omap-mailbox-fix-empty-struct-device-for-omap2.patch"

>From 200f6c53d6d297690616d2b348b0ac01a969e795 Mon Sep 17 00:00:00 2001
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Date: Sun, 18 Jan 2009 01:04:08 +0200
Subject: [PATCH 06/10] omap mailbox: fix empty struct device for omap2

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 arch/arm/mach-omap2/devices.c |    2 +-
 arch/arm/mach-omap2/mailbox.c |   17 ++++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 0da2640..2a14084 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -61,7 +61,7 @@ static struct resource omap3_mbox_resources[] = {
 };
 
 static struct platform_device mbox_device = {
-	.name		= "mailbox",
+	.name		= "omap2-mailbox",
 	.id		= -1,
 };
 
diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 44e9101..af32db0 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -14,7 +14,9 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
-#include <linux/io.h>
+
+#include <asm/io.h>
+
 #include <mach/mailbox.h>
 #include <mach/irqs.h>
 
@@ -234,7 +236,7 @@ static struct omap_mbox mbox_iva_info = {
 };
 #endif
 
-static int __init omap2_mbox_probe(struct platform_device *pdev)
+static int __devinit omap2_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	int ret;
@@ -257,7 +259,7 @@ static int __init omap2_mbox_probe(struct platform_device *pdev)
 		goto err_dsp;
 	}
 
-	ret = omap_mbox_register(&mbox_dsp_info);
+	ret = omap_mbox_register(&pdev->dev, &mbox_dsp_info);
 	if (ret)
 		goto err_dsp;
 
@@ -271,7 +273,7 @@ static int __init omap2_mbox_probe(struct platform_device *pdev)
 			goto err_iva1;
 		}
 		mbox_iva_info.irq = res->start;
-		ret = omap_mbox_register(&mbox_iva_info);
+		ret = omap_mbox_register(&pdev->dev, &mbox_iva_info);
 		if (ret)
 			goto err_iva1;
 	}
@@ -285,7 +287,7 @@ err_dsp:
 	return ret;
 }
 
-static int omap2_mbox_remove(struct platform_device *pdev)
+static int __devexit omap2_mbox_remove(struct platform_device *pdev)
 {
 #if defined(CONFIG_ARCH_OMAP2420)
 	omap_mbox_unregister(&mbox_iva_info);
@@ -297,9 +299,9 @@ static int omap2_mbox_remove(struct platform_device *pdev)
 
 static struct platform_driver omap2_mbox_driver = {
 	.probe = omap2_mbox_probe,
-	.remove = omap2_mbox_remove,
+	.remove = __devexit_p(omap2_mbox_remove),
 	.driver = {
-		.name = "mailbox",
+		.name = "omap2-mailbox",
 	},
 };
 
@@ -319,3 +321,4 @@ module_exit(omap2_mbox_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("omap mailbox: omap2/3 architecture specific functions");
 MODULE_AUTHOR("Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Paul Mundt");
+MODULE_ALIAS("platform:omap2-mailbox");
-- 
1.6.1.rc4


----Next_Part(Wed_Jan_28_17_29_51_2009_186)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0005-omap-mailbox-fix-empty-struct-device-for-omap1.patch"

>From 6f215301eab1e20c83d4e55e0de5faec62b17ae7 Mon Sep 17 00:00:00 2001
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Date: Sun, 18 Jan 2009 01:04:07 +0200
Subject: [PATCH 05/10] omap mailbox: fix empty struct device for omap1

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 arch/arm/mach-omap1/devices.c |    2 +-
 arch/arm/mach-omap1/mailbox.c |   33 ++++++++++++++++++---------------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-omap1/devices.c b/arch/arm/mach-omap1/devices.c
index 77382d8..b4b6106 100644
--- a/arch/arm/mach-omap1/devices.c
+++ b/arch/arm/mach-omap1/devices.c
@@ -86,7 +86,7 @@ static struct resource mbox_resources[] = {
 };
 
 static struct platform_device mbox_device = {
-	.name		= "mailbox",
+	.name		= "omap1-mailbox",
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(mbox_resources),
 	.resource	= mbox_resources,
diff --git a/arch/arm/mach-omap1/mailbox.c b/arch/arm/mach-omap1/mailbox.c
index 59abbf3..92a90be 100644
--- a/arch/arm/mach-omap1/mailbox.c
+++ b/arch/arm/mach-omap1/mailbox.c
@@ -1,7 +1,7 @@
 /*
  * Mailbox reservation modules for DSP
  *
- * Copyright (C) 2006 Nokia Corporation
+ * Copyright (C) 2006-2009 Nokia Corporation
  * Written by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -13,7 +13,9 @@
 #include <linux/resource.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <linux/io.h>
+
+#include <asm/io.h>
+
 #include <mach/mailbox.h>
 #include <mach/irqs.h>
 
@@ -27,7 +29,7 @@
 #define MAILBOX_DSP2ARM1_Flag		0x1c
 #define MAILBOX_DSP2ARM2_Flag		0x20
 
-unsigned long mbox_base;
+static void __iomem *mbox_base;
 
 struct omap_mbox1_fifo {
 	unsigned long cmd;
@@ -40,14 +42,14 @@ struct omap_mbox1_priv {
 	struct omap_mbox1_fifo rx_fifo;
 };
 
-static inline int mbox_read_reg(unsigned int reg)
+static inline int mbox_read_reg(size_t ofs)
 {
-	return __raw_readw(mbox_base + reg);
+	return __raw_readw(mbox_base + ofs);
 }
 
-static inline void mbox_write_reg(unsigned int val, unsigned int reg)
+static inline void mbox_write_reg(u32 val, size_t ofs)
 {
-	__raw_writew(val, mbox_base + reg);
+	__raw_writew(val, mbox_base + ofs);
 }
 
 /* msg */
@@ -143,7 +145,7 @@ struct omap_mbox mbox_dsp_info = {
 };
 EXPORT_SYMBOL(mbox_dsp_info);
 
-static int __init omap1_mbox_probe(struct platform_device *pdev)
+static int __devinit omap1_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	int ret = 0;
@@ -170,12 +172,10 @@ static int __init omap1_mbox_probe(struct platform_device *pdev)
 	}
 	mbox_dsp_info.irq = res->start;
 
-	ret = omap_mbox_register(&mbox_dsp_info);
-
-	return ret;
+	return omap_mbox_register(&pdev->dev, &mbox_dsp_info);
 }
 
-static int omap1_mbox_remove(struct platform_device *pdev)
+static int __devexit omap1_mbox_remove(struct platform_device *pdev)
 {
 	omap_mbox_unregister(&mbox_dsp_info);
 
@@ -184,9 +184,9 @@ static int omap1_mbox_remove(struct platform_device *pdev)
 
 static struct platform_driver omap1_mbox_driver = {
 	.probe	= omap1_mbox_probe,
-	.remove	= omap1_mbox_remove,
+	.remove	= __devexit_p(omap1_mbox_remove),
 	.driver	= {
-		.name	= "mailbox",
+		.name	= "omap1-mailbox",
 	},
 };
 
@@ -203,4 +203,7 @@ static void __exit omap1_mbox_exit(void)
 module_init(omap1_mbox_init);
 module_exit(omap1_mbox_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("omap mailbox: omap1 architecture specific functions");
+MODULE_AUTHOR("Hiroshi DOYU" <Hiroshi.DOYU@nokia.com>);
+MODULE_ALIAS("platform:omap1-mailbox");
-- 
1.6.1.rc4


----Next_Part(Wed_Jan_28_17_29_51_2009_186)----
