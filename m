Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbZAFWdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbZAFWdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZAFWOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:21 -0500
Received: from kroah.org ([198.145.64.141]:48768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755612AbZAFWOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Russell King <rmk@arm.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 55/60] arm: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:14 -0800
Message-Id: <1231279939-32728-55-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/kernel/ecard.c                  |    2 +-
 arch/arm/mach-aaec2000/core.c            |    2 +-
 arch/arm/mach-ep93xx/core.c              |    6 +++---
 arch/arm/mach-integrator/core.c          |   10 +++++-----
 arch/arm/mach-integrator/integrator_cp.c |    6 +++---
 arch/arm/mach-lh7a40x/clcd.c             |    2 +-
 arch/arm/mach-netx/fb.c                  |    2 +-
 arch/arm/mach-realview/core.h            |    2 +-
 arch/arm/mach-versatile/core.h           |    2 +-
 arch/arm/plat-omap/include/mach/memory.h |    2 +-
 10 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/ecard.c b/arch/arm/kernel/ecard.c
index 60c079d..eed2f79 100644
--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -817,7 +817,7 @@ static struct expansion_card *__init ecard_alloc_card(int type, int slot)
 	ec->dma = NO_DMA;
 	ec->ops = &ecard_default_ops;
 
-	snprintf(ec->dev.bus_id, sizeof(ec->dev.bus_id), "ecard%d", slot);
+	dev_set_name(&ec->dev, "ecard%d", slot);
 	ec->dev.parent = NULL;
 	ec->dev.bus = &ecard_bus_type;
 	ec->dev.dma_mask = &ec->dma_mask;
diff --git a/arch/arm/mach-aaec2000/core.c b/arch/arm/mach-aaec2000/core.c
index 50e1396..b5c5fc6 100644
--- a/arch/arm/mach-aaec2000/core.c
+++ b/arch/arm/mach-aaec2000/core.c
@@ -212,7 +212,7 @@ static struct clcd_board clcd_plat_data = {
 
 static struct amba_device clcd_device = {
 	.dev		= {
-		.bus_id			= "mb:16",
+		.init_name		= "mb:16",
 		.coherent_dma_mask	= ~0,
 		.platform_data		= &clcd_plat_data,
 	},
diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index 4781f32..6d9152d 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -409,7 +409,7 @@ static struct amba_pl010_data ep93xx_uart_data = {
 
 static struct amba_device uart1_device = {
 	.dev		= {
-		.bus_id		= "apb:uart1",
+		.init_name	= "apb:uart1",
 		.platform_data	= &ep93xx_uart_data,
 	},
 	.res		= {
@@ -423,7 +423,7 @@ static struct amba_device uart1_device = {
 
 static struct amba_device uart2_device = {
 	.dev		= {
-		.bus_id		= "apb:uart2",
+		.init_name	= "apb:uart2",
 		.platform_data	= &ep93xx_uart_data,
 	},
 	.res		= {
@@ -437,7 +437,7 @@ static struct amba_device uart2_device = {
 
 static struct amba_device uart3_device = {
 	.dev		= {
-		.bus_id		= "apb:uart3",
+		.init_name	= "apb:uart3",
 		.platform_data	= &ep93xx_uart_data,
 	},
 	.res		= {
diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index c89c949..6f88729 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -37,7 +37,7 @@ static struct amba_pl010_data integrator_uart_data;
 
 static struct amba_device rtc_device = {
 	.dev		= {
-		.bus_id	= "mb:15",
+		.init_name = "mb:15",
 	},
 	.res		= {
 		.start	= INTEGRATOR_RTC_BASE,
@@ -50,7 +50,7 @@ static struct amba_device rtc_device = {
 
 static struct amba_device uart0_device = {
 	.dev		= {
-		.bus_id	= "mb:16",
+		.init_name = "mb:16",
 		.platform_data = &integrator_uart_data,
 	},
 	.res		= {
@@ -64,7 +64,7 @@ static struct amba_device uart0_device = {
 
 static struct amba_device uart1_device = {
 	.dev		= {
-		.bus_id	= "mb:17",
+		.init_name = "mb:17",
 		.platform_data = &integrator_uart_data,
 	},
 	.res		= {
@@ -78,7 +78,7 @@ static struct amba_device uart1_device = {
 
 static struct amba_device kmi0_device = {
 	.dev		= {
-		.bus_id	= "mb:18",
+		.init_name = "mb:18",
 	},
 	.res		= {
 		.start	= KMI0_BASE,
@@ -91,7 +91,7 @@ static struct amba_device kmi0_device = {
 
 static struct amba_device kmi1_device = {
 	.dev		= {
-		.bus_id	= "mb:19",
+		.init_name = "mb:19",
 	},
 	.res		= {
 		.start	= KMI1_BASE,
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index 427c2d8..4ac0405 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -407,7 +407,7 @@ static struct mmc_platform_data mmc_data = {
 
 static struct amba_device mmc_device = {
 	.dev		= {
-		.bus_id	= "mb:1c",
+		.init_name = "mb:1c",
 		.platform_data = &mmc_data,
 	},
 	.res		= {
@@ -421,7 +421,7 @@ static struct amba_device mmc_device = {
 
 static struct amba_device aaci_device = {
 	.dev		= {
-		.bus_id	= "mb:1d",
+		.init_name = "mb:1d",
 	},
 	.res		= {
 		.start	= INTCP_PA_AACI_BASE,
@@ -532,7 +532,7 @@ static struct clcd_board clcd_data = {
 
 static struct amba_device clcd_device = {
 	.dev		= {
-		.bus_id	= "mb:c0",
+		.init_name = "mb:c0",
 		.coherent_dma_mask = ~0,
 		.platform_data = &clcd_data,
 	},
diff --git a/arch/arm/mach-lh7a40x/clcd.c b/arch/arm/mach-lh7a40x/clcd.c
index a2a5432..c472b9e 100644
--- a/arch/arm/mach-lh7a40x/clcd.c
+++ b/arch/arm/mach-lh7a40x/clcd.c
@@ -207,7 +207,7 @@ static struct clcd_board clcd_platform_data = {
 static struct amba_device name##_device = {			\
 	.dev = {						\
 		.coherent_dma_mask = ~0,			\
-		.bus_id	= busid,				\
+		.init_name = busid,				\
 		.platform_data = plat,				\
 		},						\
 	.res = {						\
diff --git a/arch/arm/mach-netx/fb.c b/arch/arm/mach-netx/fb.c
index 8f1f992..ea8fa88 100644
--- a/arch/arm/mach-netx/fb.c
+++ b/arch/arm/mach-netx/fb.c
@@ -91,7 +91,7 @@ void clk_put(struct clk *clk)
 
 static struct amba_device fb_device = {
 	.dev		= {
-		.bus_id	= "fb",
+		.init_name = "fb",
 		.coherent_dma_mask = ~0,
 	},
 	.res		= {
diff --git a/arch/arm/mach-realview/core.h b/arch/arm/mach-realview/core.h
index 63be2ab..44269b1 100644
--- a/arch/arm/mach-realview/core.h
+++ b/arch/arm/mach-realview/core.h
@@ -31,7 +31,7 @@
 static struct amba_device name##_device = {			\
 	.dev		= {					\
 		.coherent_dma_mask = ~0,			\
-		.bus_id	= busid,				\
+		.init_name = busid,				\
 		.platform_data = plat,				\
 	},							\
 	.res		= {					\
diff --git a/arch/arm/mach-versatile/core.h b/arch/arm/mach-versatile/core.h
index afcaa85..9d39886 100644
--- a/arch/arm/mach-versatile/core.h
+++ b/arch/arm/mach-versatile/core.h
@@ -34,7 +34,7 @@ extern unsigned int mmc_status(struct device *dev);
 static struct amba_device name##_device = {			\
 	.dev		= {					\
 		.coherent_dma_mask = ~0,			\
-		.bus_id	= busid,				\
+		.init_name = busid,				\
 		.platform_data = plat,				\
 	},							\
 	.res		= {					\
diff --git a/arch/arm/plat-omap/include/mach/memory.h b/arch/arm/plat-omap/include/mach/memory.h
index 211c9f6..d6b5ca6 100644
--- a/arch/arm/plat-omap/include/mach/memory.h
+++ b/arch/arm/plat-omap/include/mach/memory.h
@@ -59,7 +59,7 @@
 
 #define virt_to_lbus(x)		((x) - PAGE_OFFSET + OMAP1510_LB_OFFSET)
 #define lbus_to_virt(x)		((x) - OMAP1510_LB_OFFSET + PAGE_OFFSET)
-#define is_lbus_device(dev)	(cpu_is_omap15xx() && dev && (strncmp(dev->bus_id, "ohci", 4) == 0))
+#define is_lbus_device(dev)	(cpu_is_omap15xx() && dev && (strncmp(dev_name(dev), "ohci", 4) == 0))
 
 #define __arch_page_to_dma(dev, page)	({is_lbus_device(dev) ? \
 					(dma_addr_t)virt_to_lbus(page_address(page)) : \
-- 
1.6.0.4

