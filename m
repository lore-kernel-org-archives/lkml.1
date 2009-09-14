Return-Path: <linux-kernel-owner+w=401wt.eu-S933584AbZINUIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584AbZINUIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933560AbZINUIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54067 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216AbZINUIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Stefan Pledl <stefan.pledl@mesutronic.de>
Subject: [PATCH 29/72] Blackfin: fix BF548 UART0 DMA IRQ translation
Date: Mon, 14 Sep 2009 16:07:33 -0400
Message-Id: <1252958896-25150-30-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Pledl <stefan.pledl@mesutronic.de>

The initial BF54x port included some defines to keep code simple across
different processors, but it just ended up causing the UART0 DMA IRQs to
be set to the UART1 channels.

Signed-off-by: Stefan Pledl <stefan.pledl@mesutronic.de>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf548/dma.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/mach-bf548/dma.c b/arch/blackfin/mach-bf548/dma.c
index 5359806..d9239bc 100644
--- a/arch/blackfin/mach-bf548/dma.c
+++ b/arch/blackfin/mach-bf548/dma.c
@@ -91,16 +91,16 @@ int channel2irq(unsigned int channel)
 		ret_irq = IRQ_SPI1;
 		break;
 	case CH_UART0_RX:
-		ret_irq = IRQ_UART_RX;
+		ret_irq = IRQ_UART0_RX;
 		break;
 	case CH_UART0_TX:
-		ret_irq = IRQ_UART_TX;
+		ret_irq = IRQ_UART0_TX;
 		break;
 	case CH_UART1_RX:
-		ret_irq = IRQ_UART_RX;
+		ret_irq = IRQ_UART1_RX;
 		break;
 	case CH_UART1_TX:
-		ret_irq = IRQ_UART_TX;
+		ret_irq = IRQ_UART1_TX;
 		break;
 	case CH_EPPI0:
 		ret_irq = IRQ_EPPI0;
-- 
1.6.4.2

