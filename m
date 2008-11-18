Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYKRWNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYKRWNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYKRWNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:13:04 -0500
Received: from zbr.yandex.ru ([213.180.219.33]:34063 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752676AbYKRWND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:13:03 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] MX31: add w1 platform_device and resources
Date: Wed, 19 Nov 2008 01:16:15 +0300
Message-Id: <12270465772346-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <1227046577498-git-send-email-zbr@ioremap.net>
References: <1227046577988-git-send-email-zbr@ioremap.net>
 <1227046577498-git-send-email-zbr@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 arch/arm/mach-mx3/devices.c |   15 +++++++++++++++
 arch/arm/mach-mx3/devices.h |    1 +
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx3/devices.c b/arch/arm/mach-mx3/devices.c
index a6bdcc0..12b3e3c 100644
--- a/arch/arm/mach-mx3/devices.c
+++ b/arch/arm/mach-mx3/devices.c
@@ -145,3 +145,18 @@ int __init mxc_register_gpios(void)
 {
 	return mxc_gpio_init(imx_gpio_ports, ARRAY_SIZE(imx_gpio_ports));
 }
+
+static struct resource mxc_w1_master_resources[] = {
+	{
+		.start = OWIRE_BASE_ADDR,
+		.end   = OWIRE_BASE_ADDR + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+struct platform_device mxc_w1_master_device = {
+	.name = "mxc_w1",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(mxc_w1_master_resources),
+	.resource = mxc_w1_master_resources,
+};
diff --git a/arch/arm/mach-mx3/devices.h b/arch/arm/mach-mx3/devices.h
index 4dc03f9..cb1459c 100644
--- a/arch/arm/mach-mx3/devices.h
+++ b/arch/arm/mach-mx3/devices.h
@@ -4,3 +4,4 @@ extern struct platform_device mxc_uart_device1;
 extern struct platform_device mxc_uart_device2;
 extern struct platform_device mxc_uart_device3;
 extern struct platform_device mxc_uart_device4;
+extern struct platform_device mxc_w1_master_device;
-- 
1.5.2.5

