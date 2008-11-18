Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYKRWNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYKRWNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 17:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYKRWNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 17:13:06 -0500
Received: from zbr.yandex.ru ([213.180.219.33]:34068 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752687AbYKRWND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 17:13:03 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] MX2 pcm038: add 1-wire master support
Date: Wed, 19 Nov 2008 01:16:16 +0300
Message-Id: <1227046577789-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12270465772346-git-send-email-zbr@ioremap.net>
References: <1227046577988-git-send-email-zbr@ioremap.net>
 <1227046577498-git-send-email-zbr@ioremap.net>
 <12270465772346-git-send-email-zbr@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 arch/arm/mach-mx2/pcm038.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx2/pcm038.c b/arch/arm/mach-mx2/pcm038.c
index 7f55746..ac516b1 100644
--- a/arch/arm/mach-mx2/pcm038.c
+++ b/arch/arm/mach-mx2/pcm038.c
@@ -168,6 +168,7 @@ static void gpio_fec_inactive(void)
 
 static struct platform_device *platform_devices[] __initdata = {
 	&pcm038_nor_mtd_device,
+	&mxc_w1_master_device,
 };
 
 static void __init pcm038_init(void)
@@ -177,6 +178,7 @@ static void __init pcm038_init(void)
 	mxc_register_device(&mxc_uart_device0, &uart_pdata[0]);
 	mxc_register_device(&mxc_uart_device1, &uart_pdata[1]);
 	mxc_register_device(&mxc_uart_device2, &uart_pdata[2]);
+	mxc_gpio_mode(PE16_AF_RTCK); /* OWIRE */
 
 	platform_add_devices(platform_devices, ARRAY_SIZE(platform_devices));
 
-- 
1.5.2.5

