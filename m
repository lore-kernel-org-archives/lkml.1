Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYGRHll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYGRHll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbYGRHkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:40:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:50116 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbYGRHkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:40:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ud8nlbSHdJHvWjHU/WcoN3cOwx3zCfpd/xecoX9s5IXYAeJ5r6+7L9atrmk/1SDKeH
         BLFUjBptz7qgdJM5Vd2StbRg9xWj50PyG/uM0Nx891TgwmpIj8EYgLM81zgUk944bVeG
         NpP8Mo2jon5jA89bQMljNRQ9TRsdiXfZkoUk4=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, gregkh@suse.de, lethal@linux-sh.org,
       i2c@lm-sensors.org, Magnus Damm <magnus.damm@gmail.com>,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 16:40:44 +0900
Message-Id: <20080718074044.32713.83039.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
Subject: [PATCH 05/05] sh: add IORESOURCE_CLK to SuperH Mobile I2C platform data
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch passes processor specific IORESOURCE_CLK information to the
i2c-sh_mobile driver. With this change the clock to the IIC block will
be disabled while the I2C bus is inactive. Without this patch the clock
is always on.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Applies to 6b4b0121a22649640e997b17dd00bb40e97e254d of sh-2.6 git

 arch/sh/kernel/cpu/sh4a/setup-sh7343.c |   14 ++++++++++----
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c |    7 +++++--
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    7 +++++--
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |    7 +++++--
 4 files changed, 25 insertions(+), 10 deletions(-)

--- 0001/arch/sh/kernel/cpu/sh4a/setup-sh7343.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7343.c	2008-07-18 14:37:33.000000000 +0900
@@ -25,7 +25,11 @@ static struct resource iic0_resources[] 
 		.start  = 96,
 		.end    = 99,
 		.flags  = IORESOURCE_IRQ,
-       },
+	},
+	[2] = {
+		.name   = "mstp109",
+		.flags  = IORESOURCE_CLK,
+	},
 };
 
 static struct platform_device iic0_device = {
@@ -45,7 +49,11 @@ static struct resource iic1_resources[] 
 		.start  = 44,
 		.end    = 47,
 		.flags  = IORESOURCE_IRQ,
-       },
+	},
+	[2] = {
+		.name   = "mstp108",
+		.flags  = IORESOURCE_CLK,
+	},
 };
 
 static struct platform_device iic1_device = {
@@ -147,8 +155,6 @@ static int __init sh7343_devices_setup(v
 	clk_always_enable("mstp023"); /* INTC3 */
 	clk_always_enable("mstp022"); /* INTC */
 	clk_always_enable("mstp020"); /* SuperHyway */
-	clk_always_enable("mstp109"); /* I2C0 */
-	clk_always_enable("mstp108"); /* I2C1 */
 	clk_always_enable("mstp202"); /* VEU */
 	clk_always_enable("mstp201"); /* VPU */
 
--- 0001/arch/sh/kernel/cpu/sh4a/setup-sh7366.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7366.c	2008-07-18 14:37:06.000000000 +0900
@@ -27,7 +27,11 @@ static struct resource iic_resources[] =
 		.start  = 96,
 		.end    = 99,
 		.flags  = IORESOURCE_IRQ,
-       },
+	},
+	[2] = {
+		.name   = "mstp109",
+		.flags  = IORESOURCE_CLK,
+	},
 };
 
 static struct platform_device iic_device = {
@@ -157,7 +161,6 @@ static int __init sh7366_devices_setup(v
 	clk_always_enable("mstp023"); /* INTC3 */
 	clk_always_enable("mstp022"); /* INTC */
 	clk_always_enable("mstp020"); /* SuperHyway */
-	clk_always_enable("mstp109"); /* I2C */
 	clk_always_enable("mstp207"); /* VEU-2 */
 	clk_always_enable("mstp202"); /* VEU-1 */
 	clk_always_enable("mstp201"); /* VPU */
--- 0001/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7722.c	2008-07-18 14:35:43.000000000 +0900
@@ -52,7 +52,11 @@ static struct resource iic_resources[] =
 		.start  = 96,
 		.end    = 99,
 		.flags  = IORESOURCE_IRQ,
-       },
+	},
+	[2] = {
+		.name   = "mstp109",
+		.flags  = IORESOURCE_CLK,
+	},
 };
 
 static struct platform_device iic_device = {
@@ -166,7 +170,6 @@ static int __init sh7722_devices_setup(v
 	clk_always_enable("mstp026"); /* XYMEM */
 	clk_always_enable("mstp022"); /* INTC */
 	clk_always_enable("mstp020"); /* SuperHyway */
-	clk_always_enable("mstp109"); /* I2C */
 	clk_always_enable("mstp211"); /* USB */
 	clk_always_enable("mstp202"); /* VEU */
 	clk_always_enable("mstp201"); /* VPU */
--- 0001/arch/sh/kernel/cpu/sh4a/setup-sh7723.c
+++ work/arch/sh/kernel/cpu/sh4a/setup-sh7723.c	2008-07-18 14:36:23.000000000 +0900
@@ -210,7 +210,11 @@ static struct resource iic_resources[] =
 		.start  = 96,
 		.end    = 99,
 		.flags  = IORESOURCE_IRQ,
-       },
+	},
+	[2] = {
+		.name   = "mstp109",
+		.flags  = IORESOURCE_CLK,
+	},
 };
 
 static struct platform_device iic_device = {
@@ -238,7 +242,6 @@ static int __init sh7723_devices_setup(v
 	clk_always_enable("mstp022"); /* INTC */
 	clk_always_enable("mstp020"); /* SuperHyway */
 	clk_always_enable("mstp000"); /* MERAM */
-	clk_always_enable("mstp109"); /* I2C */
 	clk_always_enable("mstp108"); /* RTC */
 	clk_always_enable("mstp211"); /* USB */
 	clk_always_enable("mstp206"); /* VEU2H1 */
