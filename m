Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYDXKe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYDXKe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYDXKeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:34:46 -0400
Received: from araneidae.co.uk ([62.3.233.233]:4865 "EHLO mail.araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYDXKep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:34:45 -0400
X-Greylist: delayed 1289 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 06:34:44 EDT
Date: Thu, 24 Apr 2008 10:13:09 +0000 (GMT)
From: Michael Abbott <michael@araneidae.co.uk>
To: Daniel Mack <daniel@caiaq.org>, linux-arm@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Colibri: Fix support for DM9000 ethernet device.
Message-ID: <20080424095917.Q51356@saturn.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Abbott <michael.abbott@diamond.ac.uk>

Colibri: Fix support for DM9000 ethernet device.

Two changes are necessary to enable proper operation of the DM9000 device
with the Colibri PXA 270 board: firstly, the IRQ type needs to be
configured for rising edge interrupts, and secondly this configuration needs
to be communicated through to the DM9000.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
---
  arch/arm/mach-pxa/colibri.c |    4 ++--
  1 files changed, 2 insertions(+), 2 deletions(-)

Patch applied against v2.6.25

Proper operation of this device also depends on the DM9000 timer patch 
submitted separately.

diff --git a/arch/arm/mach-pxa/colibri.c b/arch/arm/mach-pxa/colibri.c
index 6db54e3..a76f95a 100644
--- a/arch/arm/mach-pxa/colibri.c
+++ b/arch/arm/mach-pxa/colibri.c
@@ -97,7 +97,7 @@ static struct resource dm9000_resources[] = {
  	[2] = {
  		.start	= COLIBRI_ETH_IRQ,
  		.end	= COLIBRI_ETH_IRQ,
-		.flags	= IORESOURCE_IRQ,
+		.flags	= IORESOURCE_IRQ | IRQF_TRIGGER_RISING,
  	},
  };

@@ -118,7 +118,7 @@ static void __init colibri_init(void)
  	/* DM9000 LAN */
  	pxa_gpio_mode(GPIO78_nCS_2_MD);
  	pxa_gpio_mode(GPIO_DM9000 | GPIO_IN);
-	set_irq_type(COLIBRI_ETH_IRQ, IRQT_FALLING);
+	set_irq_type(COLIBRI_ETH_IRQ, IRQT_RISING);

  	platform_add_devices(colibri_devices, ARRAY_SIZE(colibri_devices));
  }
-- 
1.5.5

