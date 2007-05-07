Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbXEGIso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbXEGIso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 04:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbXEGIso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 04:48:44 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:60723 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754117AbXEGIsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 04:48:43 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: David Brownell <david-b@pacbell.net>, Andrew Victor <andrew@sanpeople.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 2/2] atmel_spi: Remove unnecessary (and wrong) #ifdefs
Date: Mon,  7 May 2007 10:48:04 +0200
Message-Id: <11785276843977-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11785276841920-git-send-email-hskinnemoen@atmel.com>
References: <11785276841920-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the cpu_is_xxx() macros are available both on AVR32 and AT91,
we can remove a couple of #ifdefs from this driver. One of them is
actually wrong -- new_1 should be set on AVR32 but isn't. This causes
the bus clock to run at twice the speed it is configured to.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/spi/atmel_spi.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 66e7bc9..1d8a2f6 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -22,10 +22,7 @@
 #include <asm/io.h>
 #include <asm/arch/board.h>
 #include <asm/arch/gpio.h>
-
-#ifdef CONFIG_ARCH_AT91
 #include <asm/arch/cpu.h>
-#endif
 
 #include "atmel_spi.h"
 
@@ -552,10 +549,8 @@ static int __init atmel_spi_probe(struct platform_device *pdev)
 		goto out_free_buffer;
 	as->irq = irq;
 	as->clk = clk;
-#ifdef CONFIG_ARCH_AT91
 	if (!cpu_is_at91rm9200())
 		as->new_1 = 1;
-#endif
 
 	ret = request_irq(irq, atmel_spi_interrupt, 0,
 			pdev->dev.bus_id, master);
-- 
1.4.4.4

