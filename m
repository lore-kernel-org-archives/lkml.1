Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbXD2DWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbXD2DWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbXD2DWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:22:32 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36229 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbXD2DWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:22:30 -0400
X-IronPort-AV: i="4.14,465,1170651600"; 
   d="scan'208"; a="28603020:sNHT22239658"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/7] blackfin arch: fix coding style in ints-priority-sc C file
Date: Sun, 29 Apr 2007 11:23:07 +0800
Message-Id: <11778169952438-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11778169933996-git-send-email-bryan.wu@analog.com>
References: <11778169933996-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-common/ints-priority-sc.c |   77 +++++++++++--------------
 1 files changed, 34 insertions(+), 43 deletions(-)

diff --git a/arch/blackfin/mach-common/ints-priority-sc.c b/arch/blackfin/mach-common/ints-priority-sc.c
index c30726b..34b6228 100644
--- a/arch/blackfin/mach-common/ints-priority-sc.c
+++ b/arch/blackfin/mach-common/ints-priority-sc.c
@@ -329,11 +329,9 @@ static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 	u16 gpionr = irq - IRQ_PF0;
 
 	if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-
 		ret = gpio_request(gpionr, NULL);
-		if(ret)
+		if (ret)
 			return ret;
-
 	}
 
 	gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
@@ -355,55 +353,49 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 	unsigned int ret;
 	u16 gpionr = irq - IRQ_PF0;
 
+	if (type == IRQ_TYPE_PROBE) {
+		/* only probe unenabled GPIO interrupt lines */
+		if (gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))
+			return 0;
+		type = IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING;
+	}
 
-		if (type == IRQ_TYPE_PROBE) {
-			/* only probe unenabled GPIO interrupt lines */
-			if (gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))
-				return 0;
-			type = IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING;
-
-		}
-
-		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
-			    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
-
+	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
+	            IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
+	{
 		if (!(gpio_enabled[gpio_bank(gpionr)] & gpio_bit(gpionr))) {
-
 			ret = gpio_request(gpionr, NULL);
-			if(ret)
+			if (ret)
 				return ret;
-
-		}
-
-			gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
-		} else {
-			gpio_enabled[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
-			return 0;
 		}
 
+		gpio_enabled[gpio_bank(gpionr)] |= gpio_bit(gpionr);
+	} else {
+		gpio_enabled[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
+		return 0;
+	}
 
-		set_gpio_dir(gpionr, 0);
-		set_gpio_inen(gpionr, 1);
-
+	set_gpio_dir(gpionr, 0);
+	set_gpio_inen(gpionr, 1);
 
-		if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
-			gpio_edge_triggered[gpio_bank(gpionr)] |= gpio_bit(gpionr);
-			set_gpio_edge(gpionr, 1);
-		} else {
-			set_gpio_edge(gpionr, 0);
-			gpio_edge_triggered[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
-		}
+	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
+		gpio_edge_triggered[gpio_bank(gpionr)] |= gpio_bit(gpionr);
+		set_gpio_edge(gpionr, 1);
+	} else {
+		set_gpio_edge(gpionr, 0);
+		gpio_edge_triggered[gpio_bank(gpionr)] &= ~gpio_bit(gpionr);
+	}
 
-		if ((type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
-		    == (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
-			set_gpio_both(gpionr, 1);
-		else
-			set_gpio_both(gpionr, 0);
+	if ((type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
+	    == (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING))
+		set_gpio_both(gpionr, 1);
+	else
+		set_gpio_both(gpionr, 0);
 
-		if ((type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_LEVEL_LOW)))
-			set_gpio_polar(gpionr, 1);	/* low or falling edge denoted by one */
-		else
-			set_gpio_polar(gpionr, 0);	/* high or rising edge denoted by zero */
+	if ((type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_LEVEL_LOW)))
+		set_gpio_polar(gpionr, 1);	/* low or falling edge denoted by one */
+	else
+		set_gpio_polar(gpionr, 0);	/* high or rising edge denoted by zero */
 
 	SSYNC();
 
@@ -416,7 +408,6 @@ static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
 }
 
 
-
 static struct irq_chip bfin_gpio_irqchip = {
 	.ack = bfin_gpio_ack_irq,
 	.mask = bfin_gpio_mask_irq,
-- 
1.5.1.2
