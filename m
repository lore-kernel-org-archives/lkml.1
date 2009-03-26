Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbZCZOtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbZCZOtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbZCZOs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:48:29 -0400
Received: from mx1.emlix.com ([193.175.82.87]:57275 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759017AbZCZOs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:48:27 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>
Subject: [patch 4/5] xtensa: add resources for canonical data port modes to s6105 platform
Date: Thu, 26 Mar 2009 15:49:33 +0100
Message-Id: <1238078974-26040-4-git-send-email-dg@emlix.com>
In-Reply-To: <1238078974-26040-1-git-send-email-dg@emlix.com>
References: <1238078974-26040-1-git-send-email-dg@emlix.com>
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oskar Schirmer <os@emlix.com>

Signed-off-by: Oskar Schirmer <os@emlix.com>
---
 arch/xtensa/platforms/s6105/device.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/device.c b/arch/xtensa/platforms/s6105/device.c
index ff047fc..dec1d88 100644
--- a/arch/xtensa/platforms/s6105/device.c
+++ b/arch/xtensa/platforms/s6105/device.c
@@ -59,6 +59,10 @@ static const signed char dp_irq_mappings[] = {
 	S6_INTC_DMA_DPTERMCNT(1),
 	S6_INTC_DMA_DPTERMCNT(2),
 	S6_INTC_DMA_DPTERMCNT(3),
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	S6_INTC_DMA_LMSPENDCNT(9),
+	S6_INTC_DMA_LMSPENDCNT(10),
+#endif
 	-1
 };
 
@@ -421,6 +425,15 @@ static struct resource s6_dp_resource[] = {
 		.start	= (resource_size_t)DP_INTNUM,
 		.flags	= IORESOURCE_IRQ,
 	},
+#ifdef CONFIG_VIDEO_S6000_CANONICAL
+	{
+		.start	= (resource_size_t)
+			  DMA_CHNL(S6_REG_LMSDMA, 9),
+		.end	= (resource_size_t)
+			  DMA_CHNL(S6_REG_LMSDMA, 10) + 0x100 - 1,
+		.flags	= IORESOURCE_DMA,
+	},
+#endif
 };
 
 static struct platform_device platform_devices[] = {
-- 
1.6.2.107.ge47ee

