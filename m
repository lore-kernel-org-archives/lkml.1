Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYKRWOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYKRWOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYKRWNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:13:08 -0500
Received: from zbr.yandex.ru ([213.180.219.33]:34060 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752697AbYKRWND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:13:03 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] MX2: Add W1 device/resources
Date: Wed, 19 Nov 2008 01:16:14 +0300
Message-Id: <1227046577498-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <1227046577988-git-send-email-zbr@ioremap.net>
References: <1227046577988-git-send-email-zbr@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 arch/arm/mach-mx2/devices.c |   15 +++++++++++++++
 arch/arm/mach-mx2/devices.h |    2 +-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mx2/devices.c b/arch/arm/mach-mx2/devices.c
index bd0559d..092e09b 100644
--- a/arch/arm/mach-mx2/devices.c
+++ b/arch/arm/mach-mx2/devices.c
@@ -190,6 +190,21 @@ struct platform_device mxc_wdt = {
 	.resource = mxc_wdt_resources,
 };
 
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
+
 /* GPIO port description */
 static struct mxc_gpio_port imx_gpio_ports[] = {
 	[0] = {
diff --git a/arch/arm/mach-mx2/devices.h b/arch/arm/mach-mx2/devices.h
index c77a4b8..5683c45 100644
--- a/arch/arm/mach-mx2/devices.h
+++ b/arch/arm/mach-mx2/devices.h
@@ -12,4 +12,4 @@ extern struct platform_device mxc_uart_device2;
 extern struct platform_device mxc_uart_device3;
 extern struct platform_device mxc_uart_device4;
 extern struct platform_device mxc_uart_device5;
-
+extern struct platform_device mxc_w1_master_device;
-- 
1.5.2.5

