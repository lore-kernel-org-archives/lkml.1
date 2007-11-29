Return-Path: <linux-kernel-owner+w=401wt.eu-S1762068AbXK2BHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762068AbXK2BHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760183AbXK2BHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:07:11 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:51886 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759679AbXK2BHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:07:10 -0500
Message-ID: <474E10BA.8020704@tiscali.nl>
Date: Thu, 29 Nov 2007 02:07:06 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: kernel@wantstofly.org, Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH] asm-arm/{arch-omap,arch-ixp23xx}: parentheses around NR_IRQS
 definition
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in include/asm-arm/arch-omap/board-innovator.h:40
#define NR_IRQS    IH_BOARD_BASE + NR_FPGA_IRQS

in include/asm-arm/arch-ixp23xx/irqs.h:156:
#define NR_IRQS      NR_IXP23XX_IRQS + NR_IXP23XX_MACH_IRQS

This could lead to problems when this definition is used in:

arch/ia64/sn/kernel/irq.c:516:
sn_irq_lh = kmalloc(sizeof(struct list_head *) * NR_IRQS, GFP_KERNEL);
arch/x86/kernel/io_apic_32.c:693:
irq_cpu_data[i].irq_delta = kmalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
694:
irq_cpu_data[i].last_irq = kmalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
699:
memset(irq_cpu_data[i].irq_delta,0,sizeof(unsigned long) * NR_IRQS);
700:
memset(irq_cpu_data[i].last_irq,0,sizeof(unsigned long) * NR_IRQS);
fs/proc/proc_misc.c:464:
per_irq_sum = kzalloc(sizeof(unsigned int)*NR_IRQS, GFP_KERNEL);

I am not sure whether this definition actually is used in any of these files.
Am I being paranoya? anyway, adding parentheses should be safe.
--
Add parentheses to prevent operator precedence errors

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/include/asm-arm/arch-ixp23xx/irqs.h b/include/asm-arm/arch-ixp23xx/irqs.h
index e696395..27c5808 100644
--- a/include/asm-arm/arch-ixp23xx/irqs.h
+++ b/include/asm-arm/arch-ixp23xx/irqs.h
@@ -153,7 +153,7 @@
  */
 #define NR_IXP23XX_MACH_IRQS 		32
 
-#define NR_IRQS				NR_IXP23XX_IRQS + NR_IXP23XX_MACH_IRQS
+#define NR_IRQS				(NR_IXP23XX_IRQS + NR_IXP23XX_MACH_IRQS)
 
 #define IXP23XX_MACH_IRQ(irq) 		(NR_IXP23XX_IRQ + (irq))
 
diff --git a/include/asm-arm/arch-omap/board-innovator.h b/include/asm-arm/arch-omap/board-innovator.h
index b3cf334..56d2c98 100644
--- a/include/asm-arm/arch-omap/board-innovator.h
+++ b/include/asm-arm/arch-omap/board-innovator.h
@@ -37,7 +37,7 @@
 #define OMAP1510P1_EMIFF_PRI_VALUE		0x00
 
 #define NR_FPGA_IRQS		24
-#define NR_IRQS                 IH_BOARD_BASE + NR_FPGA_IRQS
+#define NR_IRQS                 (IH_BOARD_BASE + NR_FPGA_IRQS)
 
 #ifndef __ASSEMBLY__
 void fpga_write(unsigned char val, int reg);
