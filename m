Return-Path: <linux-kernel-owner+w=401wt.eu-S937164AbXHHDlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937164AbXHHDlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936065AbXHHDga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:36:30 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:45539 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934570AbXHHDfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:52 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="36639272:sNHT1150389380"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 04/12] Blackfin arch: Finalize the generic gpio support - add gpio_to_irq and irq_to_gpio
Date: Wed,  8 Aug 2007 11:35:29 +0800
Message-Id: <11865441393723-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/gpio.h           |   13 +++++++++++++
 include/asm-blackfin/mach-bf533/irq.h |    2 ++
 include/asm-blackfin/mach-bf537/irq.h |    2 ++
 include/asm-blackfin/mach-bf548/irq.h |    2 ++
 include/asm-blackfin/mach-bf561/irq.h |    2 ++
 5 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/asm-blackfin/gpio.h b/include/asm-blackfin/gpio.h
index 7480cfa..e714363 100644
--- a/include/asm-blackfin/gpio.h
+++ b/include/asm-blackfin/gpio.h
@@ -421,6 +421,19 @@ unsigned short gpio_get_value(unsigned short gpio);
 void gpio_direction_input(unsigned short gpio);
 void gpio_direction_output(unsigned short gpio);
 
+#include <asm-generic/gpio.h>		/* cansleep wrappers */
+#include <asm/irq.h>
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return (gpio + GPIO_IRQ_BASE);
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return (irq - GPIO_IRQ_BASE);
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __ARCH_BLACKFIN_GPIO_H__ */
diff --git a/include/asm-blackfin/mach-bf533/irq.h b/include/asm-blackfin/mach-bf533/irq.h
index 9879e68..452fb82 100644
--- a/include/asm-blackfin/mach-bf533/irq.h
+++ b/include/asm-blackfin/mach-bf533/irq.h
@@ -128,6 +128,8 @@ Core        Emulation               **
 #define IRQ_PF14		47
 #define IRQ_PF15		48
 
+#define GPIO_IRQ_BASE		IRQ_PF0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define	NR_IRQS		(IRQ_PF15+1)
 #else
diff --git a/include/asm-blackfin/mach-bf537/irq.h b/include/asm-blackfin/mach-bf537/irq.h
index 8af2a83..36c44bc 100644
--- a/include/asm-blackfin/mach-bf537/irq.h
+++ b/include/asm-blackfin/mach-bf537/irq.h
@@ -160,6 +160,8 @@ Core        Emulation               **
 #define IRQ_PH14        96
 #define IRQ_PH15        97
 
+#define GPIO_IRQ_BASE	IRQ_PF0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS     (IRQ_PH15+1)
 #else
diff --git a/include/asm-blackfin/mach-bf548/irq.h b/include/asm-blackfin/mach-bf548/irq.h
index e548d3c..21f06f7 100644
--- a/include/asm-blackfin/mach-bf548/irq.h
+++ b/include/asm-blackfin/mach-bf548/irq.h
@@ -337,6 +337,8 @@ Events         (highest priority)  EMU         0
 #define IRQ_PJ14	BFIN_PJ_IRQ(14)		/* N/A */
 #define IRQ_PJ15	BFIN_PJ_IRQ(15)		/* N/A */
 
+#define GPIO_IRQ_BASE	IRQ_PA0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS     (IRQ_PJ15+1)
 #else
diff --git a/include/asm-blackfin/mach-bf561/irq.h b/include/asm-blackfin/mach-bf561/irq.h
index a753ce7..1278992 100644
--- a/include/asm-blackfin/mach-bf561/irq.h
+++ b/include/asm-blackfin/mach-bf561/irq.h
@@ -289,6 +289,8 @@
 #define IRQ_PF46		119
 #define IRQ_PF47		120
 
+#define GPIO_IRQ_BASE		IRQ_PF0
+
 #ifdef CONFIG_IRQCHIP_DEMUX_GPIO
 #define NR_IRQS			(IRQ_PF47 + 1)
 #else
-- 
1.5.2
