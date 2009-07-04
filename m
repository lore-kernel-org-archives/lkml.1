Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZGDBpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZGDBpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757711AbZGDBo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:44:29 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1777 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752AbZGDBoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:44:23 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:44:19 -0700
Subject: [PATCH v2 10/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 10/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SPJaiSViALlZRmS1HqywXIW99w==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C18@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506C7E4CG20368086-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 35fe5c745edbed1e074940f9cef125575a56c6b5 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 17:06:49 -0700
Subject: [PATCH 10/18] add header files for mach-bcmring

add basic header files in mach-bcmring/include/mach directory

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/include/mach/clkdev.h        |    7 +
 arch/arm/mach-bcmring/include/mach/entry-macro.S   |   90 ++++++++++++
 arch/arm/mach-bcmring/include/mach/io.h            |   56 ++++++++
 arch/arm/mach-bcmring/include/mach/irqs.h          |  135 ++++++++++++++++++
 arch/arm/mach-bcmring/include/mach/memory.h        |   45 ++++++
 .../mach-bcmring/include/mach/memory_settings.h    |   67 +++++++++
 arch/arm/mach-bcmring/include/mach/reg_nand.h      |   61 ++++++++
 arch/arm/mach-bcmring/include/mach/reg_umi.h       |  144 ++++++++++++++++++++
 arch/arm/mach-bcmring/include/mach/timex.h         |   25 ++++
 arch/arm/mach-bcmring/include/mach/uncompress.h    |   52 +++++++
 arch/arm/mach-bcmring/include/mach/vmalloc.h       |   32 +++++
 11 files changed, 714 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-bcmring/include/mach/io.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/irqs.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/memory.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/memory_settings.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/reg_nand.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/reg_umi.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/timex.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/vmalloc.h

diff --git a/arch/arm/mach-bcmring/include/mach/clkdev.h b/arch/arm/mach-bcmring/include/mach/clkdev.h
new file mode 100644
index 0000000..04b37a8
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/clkdev.h
@@ -0,0 +1,7 @@
+#ifndef __ASM_MACH_CLKDEV_H
+#define __ASM_MACH_CLKDEV_H
+
+#define __clk_get(clk) ({ 1; })
+#define __clk_put(clk) do { } while (0)
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/entry-macro.S b/arch/arm/mach-bcmring/include/mach/entry-macro.S
new file mode 100644
index 0000000..7299466
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/entry-macro.S
@@ -0,0 +1,90 @@
+/*****************************************************************************
+* Copyright 2006 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/*
+ *
+ * Low-level IRQ helper macros for BCM116X-based platforms
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <mach/irqs.h>
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+#include <mach/csp/mm_io.h>
+
+               .macro  disable_fiq
+               .endm
+
+               .macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
+               ldr     \base, =(MM_IO_BASE_INTC0)
+               ldr     \irqstat, [\base, #0]           @ get status
+                ldr     \irqnr, [\base, #0x10]          @ mask with enable register
+                ands    \irqstat, \irqstat, \irqnr
+               mov     \irqnr, #IRQ_INTC0_START
+               cmp     \irqstat, #0
+               bne     1001f
+
+               ldr     \base, =(MM_IO_BASE_INTC1)
+               ldr     \irqstat, [\base, #0]           @ get status
+                ldr     \irqnr, [\base, #0x10]          @ mask with enable register
+                ands    \irqstat, \irqstat, \irqnr
+               mov     \irqnr, #IRQ_INTC1_START
+               cmp     \irqstat, #0
+               bne     1001f
+
+               ldr     \base, =(MM_IO_BASE_SINTC)
+               ldr     \irqstat, [\base, #0]           @ get status
+                ldr     \irqnr, [\base, #0x10]          @ mask with enable register
+                ands    \irqstat, \irqstat, \irqnr
+               mov     \irqnr, #0xffffffff             @ code meaning no interrupt bits set
+               cmp     \irqstat, #0
+               beq     1002f
+
+               mov     \irqnr, #IRQ_SINTC_START        @ something is set, so fixup return value
+
+1001:
+               movs    \tmp, \irqstat, lsl #16
+               movne   \irqstat, \tmp
+               addeq   \irqnr, \irqnr, #16
+
+               movs    \tmp, \irqstat, lsl #8
+               movne   \irqstat, \tmp
+               addeq   \irqnr, \irqnr, #8
+
+               movs    \tmp, \irqstat, lsl #4
+               movne   \irqstat, \tmp
+               addeq   \irqnr, \irqnr, #4
+
+               movs    \tmp, \irqstat, lsl #2
+               movne   \irqstat, \tmp
+               addeq   \irqnr, \irqnr, #2
+
+               movs    \tmp, \irqstat, lsl #1
+               addeq   \irqnr, \irqnr, #1
+               orrs    \base, \base, #1
+
+1002:           @ irqnr will be set to 0xffffffff if no irq bits are set
+               .endm
+
+               .macro  get_irqnr_preamble, base, tmp
+               .endm
+
+               .macro  arch_ret_to_user, tmp1, tmp2
+               .endm
+
+               .macro  irq_prio_table
+               .endm
+
diff --git a/arch/arm/mach-bcmring/include/mach/io.h b/arch/arm/mach-bcmring/include/mach/io.h
new file mode 100644
index 0000000..4db0eff
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/io.h
@@ -0,0 +1,56 @@
+/*
+ *
+ *  Copyright (C) 1999 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __ASM_ARM_ARCH_IO_H
+#define __ASM_ARM_ARCH_IO_H
+
+#include <mach/hardware.h>
+
+#define IO_SPACE_LIMIT 0xffffffff
+
+#define __io(a)         ((void __iomem *)HW_IO_PHYS_TO_VIRT(a))
+
+/* Do not enable mem_pci for a big endian arm architecture or unexpected byteswaps will */
+/* happen in readw/writew etc. */
+
+#define readb(c)        __raw_readb(c)
+#define readw(c)        __raw_readw(c)
+#define readl(c)        __raw_readl(c)
+#define readb_relaxed(addr) readb(addr)
+#define readw_relaxed(addr) readw(addr)
+#define readl_relaxed(addr) readl(addr)
+
+#define readsb(p, d, l)   __raw_readsb(p, d, l)
+#define readsw(p, d, l)   __raw_readsw(p, d, l)
+#define readsl(p, d, l)   __raw_readsl(p, d, l)
+
+#define writeb(v, c)     __raw_writeb(v, c)
+#define writew(v, c)     __raw_writew(v, c)
+#define writel(v, c)     __raw_writel(v, c)
+
+#define writesb(p, d, l)  __raw_writesb(p, d, l)
+#define writesw(p, d, l)  __raw_writesw(p, d, l)
+#define writesl(p, d, l)  __raw_writesl(p, d, l)
+
+#define memset_io(c, v, l)    _memset_io((c), (v), (l))
+#define memcpy_fromio(a, c, l)    _memcpy_fromio((a), (c), (l))
+#define memcpy_toio(c, a, l)  _memcpy_toio((c), (a), (l))
+
+#define eth_io_copy_and_sum(s, c, l, b) eth_copy_and_sum((s), (c), (l), (b))
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/irqs.h b/arch/arm/mach-bcmring/include/mach/irqs.h
new file mode 100644
index 0000000..a1065c0
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/irqs.h
@@ -0,0 +1,135 @@
+/*
+ *  Copyright (C) 2007 Broadcom
+ *  Copyright (C) 1999 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#if !defined(ARCH_BCMRING_IRQS_H)
+#define ARCH_BCMRING_IRQS_H
+
+/* INTC0 - interrupt controller 0 */
+#define IRQ_INTC0_START     0
+#define IRQ_DMA0C0          0  /* DMA0 channel 0 interrupt */
+#define IRQ_DMA0C1          1  /* DMA0 channel 1 interrupt */
+#define IRQ_DMA0C2          2  /* DMA0 channel 2 interrupt */
+#define IRQ_DMA0C3          3  /* DMA0 channel 3 interrupt */
+#define IRQ_DMA0C4          4  /* DMA0 channel 4 interrupt */
+#define IRQ_DMA0C5          5  /* DMA0 channel 5 interrupt */
+#define IRQ_DMA0C6          6  /* DMA0 channel 6 interrupt */
+#define IRQ_DMA0C7          7  /* DMA0 channel 7 interrupt */
+#define IRQ_DMA1C0          8  /* DMA1 channel 0 interrupt */
+#define IRQ_DMA1C1          9  /* DMA1 channel 1 interrupt */
+#define IRQ_DMA1C2         10  /* DMA1 channel 2 interrupt */
+#define IRQ_DMA1C3         11  /* DMA1 channel 3 interrupt */
+#define IRQ_DMA1C4         12  /* DMA1 channel 4 interrupt */
+#define IRQ_DMA1C5         13  /* DMA1 channel 5 interrupt */
+#define IRQ_DMA1C6         14  /* DMA1 channel 6 interrupt */
+#define IRQ_DMA1C7         15  /* DMA1 channel 7 interrupt */
+#define IRQ_VPM            16  /* Voice process module interrupt */
+#define IRQ_USBHD2         17  /* USB host2/device2 interrupt */
+#define IRQ_USBH1          18  /* USB1 host interrupt */
+#define IRQ_USBD           19  /* USB device interrupt */
+#define IRQ_SDIOH0         20  /* SDIO0 host interrupt */
+#define IRQ_SDIOH1         21  /* SDIO1 host interrupt */
+#define IRQ_TIMER0         22  /* Timer0 interrupt */
+#define IRQ_TIMER1         23  /* Timer1 interrupt */
+#define IRQ_TIMER2         24  /* Timer2 interrupt */
+#define IRQ_TIMER3         25  /* Timer3 interrupt */
+#define IRQ_SPIH           26  /* SPI host interrupt */
+#define IRQ_ESW            27  /* Ethernet switch interrupt */
+#define IRQ_APM            28  /* Audio process module interrupt */
+#define IRQ_GE             29  /* Graphic engine interrupt */
+#define IRQ_CLCD           30  /* LCD Controller interrupt */
+#define IRQ_PIF            31  /* Peripheral interface interrupt */
+#define IRQ_INTC0_END      31
+
+/* INTC1 - interrupt controller 1 */
+#define IRQ_INTC1_START    32
+#define IRQ_GPIO0          32  /*  0 GPIO bit 31//0 combined interrupt */
+#define IRQ_GPIO1          33  /*  1 GPIO bit 64//32 combined interrupt */
+#define IRQ_I2S0           34  /*  2 I2S0 interrupt */
+#define IRQ_I2S1           35  /*  3 I2S1 interrupt */
+#define IRQ_I2CH           36  /*  4 I2C host interrupt */
+#define IRQ_I2CS           37  /*  5 I2C slave interrupt */
+#define IRQ_SPIS           38  /*  6 SPI slave interrupt */
+#define IRQ_GPHY           39  /*  7 Gigabit Phy interrupt */
+#define IRQ_FLASHC         40  /*  8 Flash controller interrupt */
+#define IRQ_COMMTX         41  /*  9 ARM DDC transmit interrupt */
+#define IRQ_COMMRX         42  /* 10 ARM DDC receive interrupt */
+#define IRQ_PMUIRQ         43  /* 11 ARM performance monitor interrupt */
+#define IRQ_UARTB          44  /* 12 UARTB */
+#define IRQ_WATCHDOG       45  /* 13 Watchdog timer interrupt */
+#define IRQ_UARTA          46  /* 14 UARTA */
+#define IRQ_TSC            47  /* 15 Touch screen controller interrupt */
+#define IRQ_KEYC           48  /* 16 Key pad controller interrupt */
+#define IRQ_DMPU           49  /* 17 DDR2 memory partition interrupt */
+#define IRQ_VMPU           50  /* 18 VRAM memory partition interrupt */
+#define IRQ_FMPU           51  /* 19 Flash memory parition unit interrupt */
+#define IRQ_RNG            52  /* 20 Random number generator interrupt */
+#define IRQ_RTC0           53  /* 21 Real time clock periodic interrupt */
+#define IRQ_RTC1           54  /* 22 Real time clock one-shot interrupt */
+#define IRQ_SPUM           55  /* 23 Secure process module interrupt */
+#define IRQ_VDEC           56  /* 24 Hantro video decoder interrupt */
+#define IRQ_RTC2           57  /* 25 Real time clock tamper interrupt */
+#define IRQ_DDRP           58  /* 26 DDR Panic interrupt */
+#define IRQ_INTC1_END      58
+
+/* SINTC secure int controller */
+#define IRQ_SINTC_START    59
+#define IRQ_SEC_WATCHDOG   59  /*  0 Watchdog timer interrupt */
+#define IRQ_SEC_UARTA      60  /*  1 UARTA interrupt */
+#define IRQ_SEC_TSC        61  /*  2 Touch screen controller interrupt */
+#define IRQ_SEC_KEYC       62  /*  3 Key pad controller interrupt */
+#define IRQ_SEC_DMPU       63  /*  4 DDR2 memory partition interrupt */
+#define IRQ_SEC_VMPU       64  /*  5 VRAM memory partition interrupt */
+#define IRQ_SEC_FMPU       65  /*  6 Flash memory parition unit interrupt */
+#define IRQ_SEC_RNG        66  /*  7 Random number generator interrupt */
+#define IRQ_SEC_RTC0       67  /*  8 Real time clock periodic interrupt */
+#define IRQ_SEC_RTC1       68  /*  9 Real time clock one-shot interrupt */
+#define IRQ_SEC_SPUM       69  /* 10 Secure process module interrupt */
+#define IRQ_SEC_TIMER0     70  /* 11 Secure timer0 interrupt */
+#define IRQ_SEC_TIMER1     71  /* 12 Secure timer1 interrupt */
+#define IRQ_SEC_TIMER2     72  /* 13 Secure timer2 interrupt */
+#define IRQ_SEC_TIMER3     73  /* 14 Secure timer3 interrupt */
+#define IRQ_SEC_RTC2       74  /* 15 Real time clock tamper interrupt */
+
+#define IRQ_SINTC_END      74
+
+/* Note: there are 3 INTC registers of 32 bits each. So internal IRQs could go from 0-95 */
+/*       Since IRQs are typically viewed in decimal, we start the gpio based IRQs off at 100 */
+/*       to make the mapping easy for humans to decipher. */
+
+#define IRQ_GPIO_0                  100
+
+#define NUM_INTERNAL_IRQS          (IRQ_SINTC_END+1)
+
+/* I couldn't get the gpioHw_reg.h file to be included cleanly, so I hardcoded it */
+/* define NUM_GPIO_IRQS               GPIOHW_TOTAL_NUM_PINS */
+#define NUM_GPIO_IRQS               62
+
+#define NR_IRQS                     (IRQ_GPIO_0 + NUM_GPIO_IRQS)
+
+#define IRQ_UNKNOWN                 -1
+
+/* Tune these bits to preclude noisy or unsupported interrupt sources as required. */
+#define IRQ_INTC0_VALID_MASK        0xffffffff
+#define IRQ_INTC1_VALID_MASK        0x07ffffff
+#define IRQ_SINTC_VALID_MASK        0x0000ffff
+
+#define  gpio_to_irq(gpio)        ((gpio) + IRQ_GPIO_0)
+#define  irq_to_gpio(irq)         ((irq) - IRQ_GPIO_0)
+
+#endif /* ARCH_BCMRING_IRQS_H */
diff --git a/arch/arm/mach-bcmring/include/mach/memory.h b/arch/arm/mach-bcmring/include/mach/memory.h
new file mode 100644
index 0000000..86e70f9
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/memory.h
@@ -0,0 +1,45 @@
+/*****************************************************************************
+* Copyright 2005 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#ifndef __ASM_ARCH_MEMORY_H
+#define __ASM_ARCH_MEMORY_H
+
+#include <cfg_global.h>
+
+/*
+ * Physical vs virtual RAM address space conversion.  These are
+ * private definitions which should NOT be used outside memory.h
+ * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
+ */
+
+#define PHYS_OFFSET CFG_GLOBAL_RAM_BASE
+
+/*
+ * Maximum DMA memory allowed is 14M
+ */
+#define CONSISTENT_DMA_SIZE (SZ_16M - SZ_2M)
+
+/*
+ * DEPRECATED: See include/asm/memory.h
+ *
+ * Virtual view <-> DMA view memory address translations
+ * virt_to_bus: Used to translate the virtual address to an
+ *              address suitable to be passed to set_dma_addr
+ * bus_to_virt: Used to convert an address for DMA operations
+ *              to an address that the kernel can use.
+ */
+#define __virt_to_bus(x) __virt_to_phys(x)
+#define __bus_to_virt(x) __phys_to_virt(x)
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/memory_settings.h b/arch/arm/mach-bcmring/include/mach/memory_settings.h
new file mode 100644
index 0000000..ce5cd16
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/memory_settings.h
@@ -0,0 +1,67 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#ifndef MEMORY_SETTINGS_H
+#define MEMORY_SETTINGS_H
+
+/* ---- Include Files ---------------------------------------- */
+/* ---- Constants and Types ---------------------------------- */
+
+/* Memory devices */
+/* NAND Flash timing for 166 MHz setting */
+#define HW_CFG_NAND_tBTA  (5 << 16)    /* Bus turnaround cycle (n)        0-7  (30 ns) */
+#define HW_CFG_NAND_tWP   (4 << 11)    /* Write pulse width cycle (n+1)   0-31 (25 ns) */
+#define HW_CFG_NAND_tWR   (1 << 9)     /* Write recovery cycle (n+1)      0-3  (10 ns) */
+#define HW_CFG_NAND_tAS   (0 << 7)     /* Write address setup cycle (n+1) 0-3  ( 0 ns) */
+#define HW_CFG_NAND_tOE   (3 << 5)     /* Output enable delay cycle (n)   0-3  (15 ns) */
+#define HW_CFG_NAND_tRC   (7 << 0)     /* Read access cycle (n+2)         0-31 (50 ns) */
+
+#define HW_CFG_NAND_TCR (HW_CFG_NAND_tBTA \
+       | HW_CFG_NAND_tWP  \
+       | HW_CFG_NAND_tWR  \
+       | HW_CFG_NAND_tAS  \
+       | HW_CFG_NAND_tOE  \
+       | HW_CFG_NAND_tRC)
+
+/* NOR Flash timing for 166 MHz setting */
+#define HW_CFG_NOR_TPRC_TWLC (0 << 19) /* Page read access cycle / Burst write latency (n+2 / n+1) (max 25ns) */
+#define HW_CFG_NOR_TBTA      (0 << 16) /* Bus turnaround cycle (n)                                 (DNA)      */
+#define HW_CFG_NOR_TWP       (6 << 11) /* Write pulse width cycle (n+1)                            (35ns)     */
+#define HW_CFG_NOR_TWR       (0 << 9)  /* Write recovery cycle (n+1)                               (0ns)      */
+#define HW_CFG_NOR_TAS       (0 << 7)  /* Write address setup cycle (n+1)                          (0ns)      */
+#define HW_CFG_NOR_TOE       (0 << 5)  /* Output enable delay cycle (n)                            (max 25ns) */
+#define HW_CFG_NOR_TRC_TLC   (0x10 << 0)       /* Read access cycle / Burst read latency (n+2 / n+1)       (100ns)    */
+
+#define HW_CFG_FLASH0_TCR (HW_CFG_NOR_TPRC_TWLC \
+       | HW_CFG_NOR_TBTA      \
+       | HW_CFG_NOR_TWP       \
+       | HW_CFG_NOR_TWR       \
+       | HW_CFG_NOR_TAS       \
+       | HW_CFG_NOR_TOE       \
+       | HW_CFG_NOR_TRC_TLC)
+
+#define HW_CFG_FLASH1_TCR    HW_CFG_FLASH0_TCR
+#define HW_CFG_FLASH2_TCR    HW_CFG_FLASH0_TCR
+
+/* SDRAM Settings */
+/* #define HW_CFG_SDRAM_CAS_LATENCY        5    Default 5, Values [3..6] */
+/* #define HW_CFG_SDRAM_CHIP_SELECT_CNT    1    Default 1, Vaules [1..2] */
+/* #define HW_CFG_SDRAM_SPEED_GRADE        667  Default 667, Values [400,533,667,800] */
+/* #define HW_CFG_SDRAM_WIDTH_BITS         16   Default 16, Vaules [8,16] */
+#define HW_CFG_SDRAM_SIZE_BYTES         0x10000000     /* Total memory, not per device size */
+
+/* ---- Variable Externs ------------------------------------- */
+/* ---- Function Prototypes ---------------------------------- */
+
+#endif /* MEMORY_SETTINGS_H */
diff --git a/arch/arm/mach-bcmring/include/mach/reg_nand.h b/arch/arm/mach-bcmring/include/mach/reg_nand.h
new file mode 100644
index 0000000..8158b45
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/reg_nand.h
@@ -0,0 +1,61 @@
+/*****************************************************************************
+* Copyright 2001 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/*
+*
+*****************************************************************************
+*
+*  REG_NAND.h
+*
+*  PURPOSE:
+*
+*     This file contains definitions for the nand registers:
+*
+*  NOTES:
+*
+*****************************************************************************/
+
+#if !defined(__ASM_ARCH_REG_NAND_H)
+#define __ASM_ARCH_REG_NAND_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/reg.h>
+#include <mach/reg_umi.h>
+
+/* ---- Constants and Types ---------------------------------------------- */
+
+#define HW_NAND_BASE       MM_IO_BASE_NAND     /* NAND Flash */
+
+/* DMA accesses by the bootstrap need hard nonvirtual addresses */
+#define REG_NAND_CMD            __REG16(HW_NAND_BASE + 0)
+#define REG_NAND_ADDR           __REG16(HW_NAND_BASE + 4)
+
+#define REG_NAND_PHYS_DATA16   (HW_NAND_BASE + 8)
+#define REG_NAND_PHYS_DATA8    (HW_NAND_BASE + 8)
+#define REG_NAND_DATA16         __REG16(REG_NAND_PHYS_DATA16)
+#define REG_NAND_DATA8          __REG8 (REG_NAND_PHYS_DATA8)
+
+/* use appropriate offset to make sure it start at the 1K boundary */
+#define REG_NAND_PHYS_DATA_DMA   (HW_NAND_BASE + 0x400)
+#define REG_NAND_DATA_DMA         __REG32(REG_NAND_PHYS_DATA_DMA)
+
+/* Linux DMA requires physical address of the data register */
+#define REG_NAND_DATA16_PADDR    HW_IO_VIRT_TO_PHYS(REG_NAND_PHYS_DATA16)
+#define REG_NAND_DATA8_PADDR     HW_IO_VIRT_TO_PHYS(REG_NAND_PHYS_DATA8)
+#define REG_NAND_DATA_PADDR      HW_IO_VIRT_TO_PHYS(REG_NAND_PHYS_DATA_DMA)
+
+#define NAND_BUS_16BIT()        (0)
+#define NAND_BUS_8BIT()         (!NAND_BUS_16BIT())
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/reg_umi.h b/arch/arm/mach-bcmring/include/mach/reg_umi.h
new file mode 100644
index 0000000..2f6c10c
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/reg_umi.h
@@ -0,0 +1,144 @@
+/*****************************************************************************
+* Copyright 2005 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/*
+*
+*****************************************************************************
+*
+*  REG_UMI.h
+*
+*  PURPOSE:
+*
+*     This file contains definitions for the nand registers:
+*
+*  NOTES:
+*
+*****************************************************************************/
+
+#if !defined(__ASM_ARCH_REG_UMI_H)
+#define __ASM_ARCH_REG_UMI_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/reg.h>
+#include <mach/csp/mm_io.h>
+
+/* ---- Constants and Types ---------------------------------------------- */
+
+#define HW_UMI_BASE       MM_IO_BASE_UMI       /* Unified Memory Interface Ctrl Register */
+
+#define REG_UMI_FLASH0_TCR         __REG32(HW_UMI_BASE  + 0x00)        /* Flash bank 0 timing and control register */
+#define REG_UMI_FLASH1_TCR         __REG32(HW_UMI_BASE  + 0x04)        /* Flash bank 1 timing and control register */
+#define REG_UMI_FLASH2_TCR         __REG32(HW_UMI_BASE  + 0x08)        /* Flash bank 2 timing and control register */
+#define REG_UMI_MMD_ICR            __REG32(HW_UMI_BASE  + 0x0c)        /* MMD interface and control register */
+#define REG_UMI_NAND_TCR           __REG32(HW_UMI_BASE  + 0x18)        /* NAND timing and control register */
+#define REG_UMI_NAND_RCSR          __REG32(HW_UMI_BASE  + 0x1c)        /* NAND ready/chip select register */
+#define REG_UMI_NAND_ECC_CSR       __REG32(HW_UMI_BASE  + 0x20)        /* NAND ECC control & status register */
+#define REG_UMI_NAND_ECC_DATA      __REG32(HW_UMI_BASE  + 0x24)        /* NAND ECC data register XXB2B1B0 */
+#define REG_UMI_BCH_N              __REG32(HW_UMI_BASE  + 0x40)        /* BCH ECC Parameter N */
+#define REG_UMI_BCH_K              __REG32(HW_UMI_BASE  + 0x44)        /* BCH ECC Parameter T */
+#define REG_UMI_BCH_T              __REG32(HW_UMI_BASE  + 0x48)        /* BCH ECC Parameter K */
+#define REG_UMI_BCH_CTRL_STATUS    __REG32(HW_UMI_BASE  + 0x4C)        /* BCH ECC Contro Status */
+#define REG_UMI_BCH_WR_ECC_0       __REG32(HW_UMI_BASE  + 0x50)        /* BCH WR ECC 31:0 */
+#define REG_UMI_BCH_WR_ECC_1       __REG32(HW_UMI_BASE  + 0x54)        /* BCH WR ECC 63:32 */
+#define REG_UMI_BCH_WR_ECC_2       __REG32(HW_UMI_BASE  + 0x58)        /* BCH WR ECC 95:64 */
+#define REG_UMI_BCH_WR_ECC_3       __REG32(HW_UMI_BASE  + 0x5c)        /* BCH WR ECC 127:96 */
+#define REG_UMI_BCH_WR_ECC_4       __REG32(HW_UMI_BASE  + 0x60)        /* BCH WR ECC 155:128 */
+#define REG_UMI_BCH_RD_ERR_LOC_1_0 __REG32(HW_UMI_BASE  + 0x64)        /* BCH Read Error Location 1,0 */
+#define REG_UMI_BCH_RD_ERR_LOC_3_2 __REG32(HW_UMI_BASE  + 0x68)        /* BCH Read Error Location 3,2 */
+#define REG_UMI_BCH_RD_ERR_LOC_5_4 __REG32(HW_UMI_BASE  + 0x6c)        /* BCH Read Error Location 5,4 */
+#define REG_UMI_BCH_RD_ERR_LOC_7_6 __REG32(HW_UMI_BASE  + 0x70)        /* BCH Read Error Location 7,6 */
+#define REG_UMI_BCH_RD_ERR_LOC_9_8 __REG32(HW_UMI_BASE  + 0x74)        /* BCH Read Error Location 9,8 */
+#define REG_UMI_BCH_RD_ERR_LOC_B_A __REG32(HW_UMI_BASE  + 0x78)        /* BCH Read Error Location 11,10 */
+
+/* REG_UMI_FLASH0/1/2_TCR, REG_UMI_SRAM0/1_TCR bits */
+#define REG_UMI_TCR_WAITEN              0x80000000     /* Enable wait pin during burst write or read */
+#define REG_UMI_TCR_LOWFREQ             0x40000000     /* Enable mem ctrlr to work iwth ext mem of lower freq than AHB clk */
+#define REG_UMI_TCR_MEMTYPE_SYNCWRITE   0x20000000     /* 1=synch write, 0=async write */
+#define REG_UMI_TCR_MEMTYPE_SYNCREAD    0x10000000     /* 1=synch read, 0=async read */
+#define REG_UMI_TCR_MEMTYPE_PAGEREAD    0x08000000     /* 1=page mode read, 0=normal mode read */
+#define REG_UMI_TCR_MEMTYPE_PGSZ_MASK   0x07000000     /* page size/burst size (wrap only) */
+#define REG_UMI_TCR_MEMTYPE_PGSZ_4      0x00000000     /* 4 word */
+#define REG_UMI_TCR_MEMTYPE_PGSZ_8      0x01000000     /* 8 word */
+#define REG_UMI_TCR_MEMTYPE_PGSZ_16     0x02000000     /* 16 word */
+#define REG_UMI_TCR_MEMTYPE_PGSZ_32     0x03000000     /* 32 word */
+#define REG_UMI_TCR_MEMTYPE_PGSZ_64     0x04000000     /* 64 word */
+#define REG_UMI_TCR_MEMTYPE_PGSZ_128    0x05000000     /* 128 word */
+#define REG_UMI_TCR_MEMTYPE_PGSZ_256    0x06000000     /* 256 word */
+#define REG_UMI_TCR_MEMTYPE_PGSZ_512    0x07000000     /* 512 word */
+#define REG_UMI_TCR_TPRC_TWLC_MASK      0x00f80000     /* Page read access cycle / Burst write latency (n+2 / n+1) */
+#define REG_UMI_TCR_TBTA_MASK           0x00070000     /* Bus turnaround cycle (n) */
+#define REG_UMI_TCR_TWP_MASK            0x0000f800     /* Write pulse width cycle (n+1) */
+#define REG_UMI_TCR_TWR_MASK            0x00000600     /* Write recovery cycle (n+1) */
+#define REG_UMI_TCR_TAS_MASK            0x00000180     /* Write address setup cycle (n+1) */
+#define REG_UMI_TCR_TOE_MASK            0x00000060     /* Output enable delay cycle (n) */
+#define REG_UMI_TCR_TRC_TLC_MASK        0x0000001f     /* Read access cycle / Burst read latency (n+2 / n+1) */
+
+/* REG_UMI_MMD_ICR bits */
+#define REG_UMI_MMD_ICR_FLASH_WP            0x8000     /* Flash write protection pin control */
+#define REG_UMI_MMD_ICR_XHCS                0x4000     /* Extend hold time for sram0, sram1 csn (39 MHz operation) */
+#define REG_UMI_MMD_ICR_SDRAM2EN            0x2000     /* Enable SDRAM 2 interface control */
+#define REG_UMI_MMD_ICR_INST512             0x1000     /* Enable merge of flash banks 0/1 to 512 MBit bank */
+#define REG_UMI_MMD_ICR_DATA512             0x0800     /* Enable merge of flash banks 1/2 to 512 MBit bank */
+#define REG_UMI_MMD_ICR_SDRAMEN             0x0400     /* Enable SDRAM interface control */
+#define REG_UMI_MMD_ICR_WAITPOL             0x0200     /* Polarity of busy state of Burst Wait Signal */
+#define REG_UMI_MMD_ICR_BCLKSTOP            0x0100     /* Enable burst clock stopped when not accessing external burst flash/sram */
+#define REG_UMI_MMD_ICR_PERI1EN             0x0080     /* Enable the peri1_csn to replace flash1_csn in 512 Mb flash mode */
+#define REG_UMI_MMD_ICR_PERI2EN             0x0040     /* Enable the peri2_csn to replace sdram_csn */
+#define REG_UMI_MMD_ICR_PERI3EN             0x0020     /* Enable the peri3_csn to replace sdram2_csn */
+#define REG_UMI_MMD_ICR_MRSB1               0x0010     /* Enable sram bank1 for H/W controlled MRS */
+#define REG_UMI_MMD_ICR_MRSB0               0x0008     /* Enable sram bank0 for H/W controlled MRS */
+#define REG_UMI_MMD_ICR_MRSPOL              0x0004     /* Polarity for assert3ed state of H/W controlled MRS */
+#define REG_UMI_MMD_ICR_MRSMODE             0x0002     /* 0: S/W controllable ZZ/MRS/CRE/P-Mode pin */
+                                                           /* 1: H/W controlled ZZ/MRS/CRE/P-Mode, same timing as CS */
+#define REG_UMI_MMD_ICR_MRSSTATE            0x0001     /* MRS state for S/W controlled mode */
+
+/* REG_UMI_NAND_TCR bits */
+#define REG_UMI_NAND_TCR_CS_SWCTRL          0x80000000 /* Enable software to control CS */
+#define REG_UMI_NAND_TCR_WORD16             0x40000000 /* 16-bit nand wordsize if set */
+#define REG_UMI_NAND_TCR_TBTA_MASK          0x00070000 /* Bus turnaround cycle (n) */
+#define REG_UMI_NAND_TCR_TWP_MASK           0x0000f800 /* Write pulse width cycle (n+1) */
+#define REG_UMI_NAND_TCR_TWR_MASK           0x00000600 /* Write recovery cycle (n+1) */
+#define REG_UMI_NAND_TCR_TAS_MASK           0x00000180 /* Write address setup cycle (n+1) */
+#define REG_UMI_NAND_TCR_TOE_MASK           0x00000060 /* Output enable delay cycle (n) */
+#define REG_UMI_NAND_TCR_TRC_TLC_MASK       0x0000001f /* Read access cycle (n+2) */
+
+/* REG_UMI_NAND_RCSR bits */
+#define REG_UMI_NAND_RCSR_RDY               0x02       /* Status: Ready=1, Busy=0 */
+#define REG_UMI_NAND_RCSR_CS_ASSERTED       0x01       /* Keep CS asserted during operation */
+
+/* REG_UMI_NAND_ECC_CSR bits */
+#define REG_UMI_NAND_ECC_CSR_NANDINT        0x80000000 /* Interrupt status - read-only */
+#define REG_UMI_NAND_ECC_CSR_ECCINT_RAW     0x00800000 /* Read: Status of ECC done, Write: clear ECC interrupt */
+#define REG_UMI_NAND_ECC_CSR_RBINT_RAW      0x00400000 /* Read: Status of R/B, Write: clear R/B interrupt */
+#define REG_UMI_NAND_ECC_CSR_ECCINT_ENABLE  0x00008000 /* 1 = Enable ECC Interrupt */
+#define REG_UMI_NAND_ECC_CSR_RBINT_ENABLE   0x00004000 /* 1 = Assert interrupt at rising edge of R/B_ */
+#define REG_UMI_NAND_ECC_CSR_256BYTE        0x00000080 /* Calculate ECC by 0=512 bytes, 1=256 bytes */
+#define REG_UMI_NAND_ECC_CSR_ECC_ENABLE     0x00000001 /* Enable ECC in hardware */
+
+/* REG_UMI_BCH_CTRL_STATUS bits */
+#define REG_UMI_BCH_CTRL_STATUS_NB_CORR_ERROR 0x00F00000       /* Indicate Number of correctable errors detected */
+#define REG_UMI_BCH_CTRL_STATUS_UNCORR_ERR    0x00080000       /* Indicate Errors detected during read but uncorrectable */
+#define REG_UMI_BCH_CTRL_STATUS_CORR_ERR      0x00040000       /* Indicate Errors detected during read and are correctable */
+#define REG_UMI_BCH_CTRL_STATUS_RD_ECC_VALID  0x00020000       /* Flag indicates BCH's ECC status of read process are valid */
+#define REG_UMI_BCH_CTRL_STATUS_WR_ECC_VALID  0x00010000       /* Flag indicates BCH's ECC status of write process are valid */
+#define REG_UMI_BCH_CTRL_STATUS_PAUSE_ECC_DEC 0x00000010       /* Pause ECC calculation */
+#define REG_UMI_BCH_CTRL_STATUS_INT_EN        0x00000004       /* Enable Interrupt */
+#define REG_UMI_BCH_CTRL_STATUS_ECC_RD_EN     0x00000002       /* Enable ECC during read */
+#define REG_UMI_BCH_CTRL_STATUS_ECC_WR_EN     0x00000001       /* Enable ECC during write */
+#define REG_UMI_BCH_ERR_LOC_MASK              0x00001FFF       /* Mask for location */
+#define REG_UMI_BCH_ERR_LOC_BYTE              0x00000007       /* location within a byte */
+#define REG_UMI_BCH_ERR_LOC_WORD              0x00000018       /* location within a word */
+#define REG_UMI_BCH_ERR_LOC_PAGE              0x00001FE0       /* location within a page (512 byte) */
+#define REG_UMI_BCH_ERR_LOC_ADDR(index)     (__REG32(HW_UMI_BASE + 0x64 + (index / 2)*4) >> ((index % 2) * 16))
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/timex.h b/arch/arm/mach-bcmring/include/mach/timex.h
new file mode 100644
index 0000000..40d033e
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/timex.h
@@ -0,0 +1,25 @@
+/*
+ *
+ *  Integrator architecture timex specifications
+ *
+ *  Copyright (C) 1999 ARM Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/*
+ * Specifies the number of ticks per second
+ */
+#define CLOCK_TICK_RATE                100000 /* REG_SMT_TICKS_PER_SEC */
diff --git a/arch/arm/mach-bcmring/include/mach/uncompress.h b/arch/arm/mach-bcmring/include/mach/uncompress.h
new file mode 100644
index 0000000..01fb754
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/uncompress.h
@@ -0,0 +1,52 @@
+/*****************************************************************************
+* Copyright 2005 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/* The piggy build defines __KERNEL__ but can't actually */
+/* work with kernel code in general, especially the static inline functions. */
+/* -Dstatic= is set for the misc.c compile, and this causes unnecessary includes */
+/* of "static inline" functions (just "inline" are included by mistake). */
+/* So we have to be careful to not call much kernel code from the piggy build. */
+/* We want the simplified REG_LOCAL_IRQ_SAVE/RESTORE macros from reg.h for */
+/* this reason and also because piggy doesn't need protection since it is */
+/* effectively single threaded boot code. */
+/* uartHw.h below includes  uartHw_inline.h which includes reg.h which brings */
+/* in too much kernel code for piggy unless we define STANDALONE. */
+#define STANDALONE
+
+/*
+ * Map IO 1 to 1 with physical addresses.
+ * Do not move this below the include of mm_io.h
+ */
+#undef MM_IO_PHYS_TO_VIRT
+#define MM_IO_PHYS_TO_VIRT(x)  (x)
+#include <mach/csp/mm_io.h>
+#include <csp/uartHw.h>
+
+/*
+ * This does not append a newline
+ */
+static inline void putc(int c)
+{
+       /* Send out UARTA */
+       uartHw_TxFifoPut(0, c);
+}
+
+static inline void flush(void)
+{
+       /* Flush UARTA */
+       uartHw_TxWaitIdle(0);
+}
+
+#define arch_decomp_setup()
+#define arch_decomp_wdog()
diff --git a/arch/arm/mach-bcmring/include/mach/vmalloc.h b/arch/arm/mach-bcmring/include/mach/vmalloc.h
new file mode 100644
index 0000000..58c2a93
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/vmalloc.h
@@ -0,0 +1,32 @@
+/*
+ *
+ *  Copyright (C) 2000 Russell King.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/*
+ * Just any arbitrary offset to the start of the vmalloc VM area: the
+ * current 8MB value just means that there will be a 8MB "hole" after the
+ * physical memory until the kernel virtual memory starts.  That means that
+ * any out-of-bounds memory accesses will hopefully be caught.
+ * The vmalloc() routines leaves a hole of 4kB between each vmalloced
+ * area for the same reason. ;)
+ */
+#define VMALLOC_OFFSET   (8*1024*1024)
+#define VMALLOC_START    (((unsigned long)high_memory + VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1))
+#define VMALLOC_VMADDR(x) ((unsigned long)(x))
+/* We have a range of 0xC0000000 to 0xDFFFFFFF minus the VMALLOC and high_memory area available for virtual memory */
+#define VMALLOC_END       (PAGE_OFFSET + 0x1F000000)
--
1.6.0.6



Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


