Return-Path: <linux-kernel-owner+w=401wt.eu-S966030AbXDIVci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966030AbXDIVci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966024AbXDIVcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:32:36 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33910 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966022AbXDIVc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:32:29 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Jarkko Nikula <jarkko.nikula@nokia.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 17/18] ARM: OMAP: Device init for OMAP24xx Enhanced Audio Controller
Date: Mon,  9 Apr 2007 17:31:00 -0400
Message-Id: <1176154331925-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761543231102-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com> <1176154277435-git-send-email-tony@atomide.com> <11761542841909-git-send-email-tony@atomide.com> <1176154286590-git-send-email-tony@atomide.com> <11761542912185-git-send-email-tony@atomide.com> <1176154294883-git-send-email-tony@atomide.com> <11761542981742-git-send-email-tony@atomide.com> <1176154302614-git-send-email-tony@atomide.com> <11761543041751-git-send-email-tony@atomide.com> <1176154308509-git-send-email-tony@atomide.com> <1176154311389-git-send-email-tony@atomide.com> <11761543144181-git-send-email-tony@atomide.com> <11761543231102-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@nokia.com>

Device init for OMAP24xx Enhanced Audio Controller

Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/devices.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

Index: linux-2.6/arch/arm/mach-omap2/devices.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/devices.c	2007-04-09 16:36:48.000000000 -0400
+++ linux-2.6/arch/arm/mach-omap2/devices.c	2007-04-09 16:37:04.000000000 -0400
@@ -23,6 +23,7 @@
 #include <asm/arch/board.h>
 #include <asm/arch/mux.h>
 #include <asm/arch/gpio.h>
+#include <asm/arch/eac.h>
 
 #if	defined(CONFIG_I2C_OMAP) || defined(CONFIG_I2C_OMAP_MODULE)
 
@@ -201,6 +202,38 @@ static void omap_init_mcspi(void)
 static inline void omap_init_mcspi(void) {}
 #endif
 
+#ifdef CONFIG_SND_OMAP24XX_EAC
+
+#define OMAP2_EAC_BASE			0x48090000
+
+static struct resource omap2_eac_resources[] = {
+	{
+		.start		= OMAP2_EAC_BASE,
+		.end		= OMAP2_EAC_BASE + 0x109,
+		.flags		= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device omap2_eac_device = {
+	.name		= "omap24xx-eac",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(omap2_eac_resources),
+	.resource	= omap2_eac_resources,
+	.dev = {
+		.platform_data = NULL,
+	},
+};
+
+void omap_init_eac(struct eac_platform_data *pdata)
+{
+	omap2_eac_device.dev.platform_data = pdata;
+	platform_device_register(&omap2_eac_device);
+}
+
+#else
+void omap_init_eac(struct eac_platform_data *pdata) {}
+#endif
+
 /*-------------------------------------------------------------------------*/
 
 static int __init omap2_init_devices(void)
