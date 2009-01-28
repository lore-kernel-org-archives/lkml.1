Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZA1TWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZA1TWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZA1TV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:21:58 -0500
Received: from smtp.nokia.com ([192.100.122.230]:28472 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZA1TV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:21:57 -0500
Date: Wed, 28 Jan 2009 21:21:22 +0200 (EET)
Message-Id: <20090128.212122.193700100.Hiroshi.DOYU@nokia.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 05/10] omap mailbox: fix empty struct device for omap1
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <20090128175043.GB23301@n2100.arm.linux.org.uk>
References: <20090128144955.GA23089@n2100.arm.linux.org.uk>
	<20090128.172951.193700554.Hiroshi.DOYU@nokia.com>
	<20090128175043.GB23301@n2100.arm.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Wed_Jan_28_21_21_22_2009_542)--"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2009 19:21:24.0336 (UTC) FILETIME=[9BE85700:01C9817D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Wed_Jan_28_21_21_22_2009_542)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: ext Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 05/10] omap mailbox: fix empty struct device for omap1
Date: Wed, 28 Jan 2009 18:50:43 +0100

> On Wed, Jan 28, 2009 at 05:29:51PM +0200, Hiroshi DOYU wrote:
> > diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
> > index 44e9101..af32db0 100644
> > --- a/arch/arm/mach-omap2/mailbox.c
> > +++ b/arch/arm/mach-omap2/mailbox.c
> > @@ -14,7 +14,9 @@
> >  #include <linux/clk.h>
> >  #include <linux/err.h>
> >  #include <linux/platform_device.h>
> > -#include <linux/io.h>
> > +
> > +#include <asm/io.h>
> > +
> 
> NAK.
> 
> > diff --git a/arch/arm/mach-omap1/mailbox.c b/arch/arm/mach-omap1/mailbox.c
> > index 59abbf3..92a90be 100644
> > --- a/arch/arm/mach-omap1/mailbox.c
> > +++ b/arch/arm/mach-omap1/mailbox.c
> > @@ -1,7 +1,7 @@
> >  /*
> >   * Mailbox reservation modules for DSP
> >   *
> > - * Copyright (C) 2006 Nokia Corporation
> > + * Copyright (C) 2006-2009 Nokia Corporation
> >   * Written by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> >   *
> >   * This file is subject to the terms and conditions of the GNU General Public
> > @@ -13,7 +13,9 @@
> >  #include <linux/resource.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/platform_device.h>
> > -#include <linux/io.h>
> > +
> > +#include <asm/io.h>
> > +
> 
> NAK.
> 
> See fced80c735941fa518ac67c0b61bbe153fb8c050.
> 
> The above can not be explained by a mis-merge - they are not a mere
> reversion of the above change.  They look like a purposeful change
> back to the wrong include file.

It seems that I misunderstood your comment in the following mail.

http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00610.html

Reverted both header file changes. Update attached patches.

----Next_Part(Wed_Jan_28_21_21_22_2009_542)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0006-omap-mailbox-fix-empty-struct-device-for-omap2.patch"

>From f0bd423fbd7401bbd491a0ebc6393eec230e6b14 Mon Sep 17 00:00:00 2001
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Date: Wed, 28 Jan 2009 21:19:02 +0200
Subject: [PATCH 06/10] omap mailbox: fix empty struct device for omap2

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 arch/arm/mach-omap2/devices.c |    2 +-
 arch/arm/mach-omap2/mailbox.c |   13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

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
index 44e9101..0b8476b 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -234,7 +234,7 @@ static struct omap_mbox mbox_iva_info = {
 };
 #endif
 
-static int __init omap2_mbox_probe(struct platform_device *pdev)
+static int __devinit omap2_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	int ret;
@@ -257,7 +257,7 @@ static int __init omap2_mbox_probe(struct platform_device *pdev)
 		goto err_dsp;
 	}
 
-	ret = omap_mbox_register(&mbox_dsp_info);
+	ret = omap_mbox_register(&pdev->dev, &mbox_dsp_info);
 	if (ret)
 		goto err_dsp;
 
@@ -271,7 +271,7 @@ static int __init omap2_mbox_probe(struct platform_device *pdev)
 			goto err_iva1;
 		}
 		mbox_iva_info.irq = res->start;
-		ret = omap_mbox_register(&mbox_iva_info);
+		ret = omap_mbox_register(&pdev->dev, &mbox_iva_info);
 		if (ret)
 			goto err_iva1;
 	}
@@ -285,7 +285,7 @@ err_dsp:
 	return ret;
 }
 
-static int omap2_mbox_remove(struct platform_device *pdev)
+static int __devexit omap2_mbox_remove(struct platform_device *pdev)
 {
 #if defined(CONFIG_ARCH_OMAP2420)
 	omap_mbox_unregister(&mbox_iva_info);
@@ -297,9 +297,9 @@ static int omap2_mbox_remove(struct platform_device *pdev)
 
 static struct platform_driver omap2_mbox_driver = {
 	.probe = omap2_mbox_probe,
-	.remove = omap2_mbox_remove,
+	.remove = __devexit_p(omap2_mbox_remove),
 	.driver = {
-		.name = "mailbox",
+		.name = "omap2-mailbox",
 	},
 };
 
@@ -319,3 +319,4 @@ module_exit(omap2_mbox_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("omap mailbox: omap2/3 architecture specific functions");
 MODULE_AUTHOR("Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Paul Mundt");
+MODULE_ALIAS("platform:omap2-mailbox");
-- 
1.6.1.rc4


----Next_Part(Wed_Jan_28_21_21_22_2009_542)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0005-omap-mailbox-fix-empty-struct-device-for-omap1.patch"

>From f6efca787d09564c0cfd8ad1cb21d29213df8862 Mon Sep 17 00:00:00 2001
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Date: Wed, 28 Jan 2009 21:18:07 +0200
Subject: [PATCH 05/10] omap mailbox: fix empty struct device for omap1

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---
 arch/arm/mach-omap1/devices.c |    2 +-
 arch/arm/mach-omap1/mailbox.c |   29 +++++++++++++++--------------
 2 files changed, 16 insertions(+), 15 deletions(-)

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
index 59abbf3..0af4d6c 100644
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
@@ -27,7 +27,7 @@
 #define MAILBOX_DSP2ARM1_Flag		0x1c
 #define MAILBOX_DSP2ARM2_Flag		0x20
 
-unsigned long mbox_base;
+static void __iomem *mbox_base;
 
 struct omap_mbox1_fifo {
 	unsigned long cmd;
@@ -40,14 +40,14 @@ struct omap_mbox1_priv {
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
@@ -143,7 +143,7 @@ struct omap_mbox mbox_dsp_info = {
 };
 EXPORT_SYMBOL(mbox_dsp_info);
 
-static int __init omap1_mbox_probe(struct platform_device *pdev)
+static int __devinit omap1_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	int ret = 0;
@@ -170,12 +170,10 @@ static int __init omap1_mbox_probe(struct platform_device *pdev)
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
 
@@ -184,9 +182,9 @@ static int omap1_mbox_remove(struct platform_device *pdev)
 
 static struct platform_driver omap1_mbox_driver = {
 	.probe	= omap1_mbox_probe,
-	.remove	= omap1_mbox_remove,
+	.remove	= __devexit_p(omap1_mbox_remove),
 	.driver	= {
-		.name	= "mailbox",
+		.name	= "omap1-mailbox",
 	},
 };
 
@@ -203,4 +201,7 @@ static void __exit omap1_mbox_exit(void)
 module_init(omap1_mbox_init);
 module_exit(omap1_mbox_exit);
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("omap mailbox: omap1 architecture specific functions");
+MODULE_AUTHOR("Hiroshi DOYU" <Hiroshi.DOYU@nokia.com>);
+MODULE_ALIAS("platform:omap1-mailbox");
-- 
1.6.1.rc4


----Next_Part(Wed_Jan_28_21_21_22_2009_542)----
