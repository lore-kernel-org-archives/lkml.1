Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0CCFIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:08:45 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:60940 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab0CCFIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:08:02 -0500
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
       deepak.sikri@st.com, ashish.priyadarshi@st.com,
       Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 02/11] ST SPEAr: Added basic header files for SPEAr3xx machine family
Date: Wed,  3 Mar 2010 10:37:32 +0530
Message-Id: <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear3xx/include/mach/debug-macro.S |   38 +++++
 arch/arm/mach-spear3xx/include/mach/dma.h         |   18 +++
 arch/arm/mach-spear3xx/include/mach/entry-macro.S |   46 ++++++
 arch/arm/mach-spear3xx/include/mach/generic.h     |   39 +++++
 arch/arm/mach-spear3xx/include/mach/hardware.h    |   20 +++
 arch/arm/mach-spear3xx/include/mach/io.h          |   22 +++
 arch/arm/mach-spear3xx/include/mach/irqs.h        |   57 +++++++
 arch/arm/mach-spear3xx/include/mach/memory.h      |   20 +++
 arch/arm/mach-spear3xx/include/mach/misc_regs.h   |  163 +++++++++++++++++++++
 arch/arm/mach-spear3xx/include/mach/spear.h       |  136 +++++++++++++++++
 arch/arm/mach-spear3xx/include/mach/spear300.h    |   64 ++++++++
 arch/arm/mach-spear3xx/include/mach/spear310.h    |   43 ++++++
 arch/arm/mach-spear3xx/include/mach/spear320.h    |   69 +++++++++
 arch/arm/mach-spear3xx/include/mach/system.h      |   41 +++++
 arch/arm/mach-spear3xx/include/mach/timex.h       |   19 +++
 arch/arm/mach-spear3xx/include/mach/uncompress.h  |   43 ++++++
 arch/arm/mach-spear3xx/include/mach/vmalloc.h     |   22 +++
 17 files changed, 860 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-spear3xx/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-spear3xx/include/mach/dma.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-spear3xx/include/mach/generic.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/hardware.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/io.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/irqs.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/memory.h
 create mode 100755 arch/arm/mach-spear3xx/include/mach/misc_regs.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/spear.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/spear300.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/spear310.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/spear320.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/system.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/timex.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach/vmalloc.h

diff --git a/arch/arm/mach-spear3xx/include/mach/debug-macro.S b/arch/arm/mach-spear3xx/include/mach/debug-macro.S
new file mode 100644
index 0000000..2f6c5bd
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/debug-macro.S
@@ -0,0 +1,38 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/debug-macro.S
+ *
+ * Debugging macro include header spear3xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/amba/serial.h>
+#include <mach/spear.h>
+
+		.macro	addruart, rx
+		mrc	p15, 0, \rx, c1, c0
+		tst	\rx, #1					@ MMU enabled?
+		moveq	\rx, =SPEAR3XX_ICM1_UART_BASE		@ Physical base
+		movne	\rx, =VA_SPEAR3XX_ICM1_UART_BASE	@ Virtual base
+		.endm
+
+		.macro	senduart, rd, rx
+		strb	\rd, [\rx, #UART01x_DR]			@ ASC_TX_BUFFER
+		.endm
+
+		.macro	waituart, rd, rx
+1001:		ldr	\rd, [\rx, #UART01x_FR]			@ FLAG REGISTER
+		tst	\rd, #UART01x_FR_TXFF			@ TX_FULL
+		bne	1001b
+		.endm
+
+		.macro	busyuart, rd, rx
+1002:		ldr	\rd, [\rx, #UART01x_FR]			@ FLAG REGISTER
+		tst	\rd, #UART011_FR_TXFE			@ TX_EMPTY
+		beq	1002b
+		.endm
diff --git a/arch/arm/mach-spear3xx/include/mach/dma.h b/arch/arm/mach-spear3xx/include/mach/dma.h
new file mode 100644
index 0000000..9b93bc6
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/dma.h
@@ -0,0 +1,18 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/dma.h
+ *
+ * Generic DMA support for SPEAr3xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_ARCH_DMA_H
+#define __ASM_ARCH_DMA_H
+
+#endif /* __ASM_ARCH_DMA_H */
+
diff --git a/arch/arm/mach-spear3xx/include/mach/entry-macro.S b/arch/arm/mach-spear3xx/include/mach/entry-macro.S
new file mode 100644
index 0000000..947625d
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/entry-macro.S
@@ -0,0 +1,46 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/entry-macro.S
+ *
+ * Low-level IRQ helper macros for SPEAr3xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <mach/hardware.h>
+#include <mach/spear.h>
+#include <asm/hardware/vic.h>
+
+		.macro	disable_fiq
+		.endm
+
+		.macro	get_irqnr_preamble, base, tmp
+		.endm
+
+		.macro	arch_ret_to_user, tmp1, tmp2
+		.endm
+
+		.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
+		ldr	\base, =VA_SPEAR3XX_ML1_VIC_BASE
+		ldr	\irqstat, [\base, #VIC_IRQ_STATUS]	@ get status
+		teq	\irqstat, #0
+		beq	1001f				@ this will set/reset
+							@ zero register
+		/*
+		 * Following code will find bit position of least significang
+		 * bit set in irqstat, using following equation
+		 * least significant bit set in n = (n & ~(n-1))
+		 */
+		sub	\tmp, \irqstat, #1		@ tmp = irqstat - 1
+		mvn	\tmp, \tmp			@ tmp = ~tmp
+		and	\irqstat, \irqstat, \tmp	@ irqstat &= tmp
+		/* Now, irqstat is = bit no. of 1st bit set in vic irq status */
+		clz	\tmp, \irqstat			@ tmp = leading zeros
+		rsb	\irqnr, \tmp, #0x1F		@ irqnr = 32 - tmp - 1
+
+1001:		/* EQ will be set if no irqs pending */
+		.endm
diff --git a/arch/arm/mach-spear3xx/include/mach/generic.h b/arch/arm/mach-spear3xx/include/mach/generic.h
new file mode 100644
index 0000000..a659e60
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/generic.h
@@ -0,0 +1,39 @@
+/*
+ * arch/arm/mach-spear3xx/generic.h
+ *
+ * SPEAr3XX machine family generic header file
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_ARCH_GENERIC_H
+#define __ASM_ARCH_GENERIC_H
+
+#include <asm/mach/time.h>
+#include <asm/mach/map.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/amba/bus.h>
+
+/* Add spear3xx family device structure declarations here */
+extern struct amba_device uart_device;
+extern struct sys_timer spear_sys_timer;
+
+/* Add spear300 machine device structure declarations here */
+
+/* Add spear3xx family function declarations here */
+void __init spear3xx_map_io(void);
+void __init spear3xx_init_irq(void);
+void __init spear3xx_init(void);
+void __init spear300_init(void);
+void __init spear310_init(void);
+void __init spear320_init(void);
+void __init spear_gpt_init(void);
+void __init clk_init(void);
+
+#endif /* __ASM_ARCH_GENERIC_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/hardware.h b/arch/arm/mach-spear3xx/include/mach/hardware.h
new file mode 100644
index 0000000..e92267a
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/hardware.h
@@ -0,0 +1,20 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/hardware.h
+ *
+ * Hardware definitions for SPEAr3xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_HARDWARE_H
+#define __ASM_MACH_HARDWARE_H
+
+/* Vitual to physical translation of statically mapped space */
+#define IO_ADDRESS(x)		(x | 0xF0000000)
+
+#endif /* __ASM_MACH_HARDWARE_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/io.h b/arch/arm/mach-spear3xx/include/mach/io.h
new file mode 100644
index 0000000..235df7a
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/io.h
@@ -0,0 +1,22 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/io.h
+ *
+ * IO definitions for SPEAr3xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_IO_H
+#define __ASM_MACH_IO_H
+
+#define IO_SPACE_LIMIT		0xFFFFFFFF
+
+#define __io(a)			__typesafe_io(a)
+#define __mem_pci(a)		(a)
+
+#endif /* __ASM_MACH_IO_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/irqs.h b/arch/arm/mach-spear3xx/include/mach/irqs.h
new file mode 100644
index 0000000..7e451e8
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/irqs.h
@@ -0,0 +1,57 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/irqs.h
+ *
+ * IRQ helper macros for SPEAr3xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_IRQS_H
+#define __ASM_MACH_IRQS_H
+
+/* IRQ definitions */
+#define IRQ_HW_ACCEL_MOD_0			0
+#define IRQ_INTRCOMM_RAS_ARM			1
+#define IRQ_CPU_GPT1_1				2
+#define IRQ_CPU_GPT1_2				3
+#define IRQ_BASIC_GPT1_1			4
+#define IRQ_BASIC_GPT1_2			5
+#define IRQ_BASIC_GPT2_1			6
+#define IRQ_BASIC_GPT2_2			7
+#define IRQ_BASIC_DMA				8
+#define IRQ_BASIC_SMI				9
+#define IRQ_BASIC_RTC				10
+#define IRQ_BASIC_GPIO				11
+#define IRQ_BASIC_WDT				12
+#define IRQ_DDR_CONTROLLER			13
+#define IRQ_SYS_ERROR				14
+#define IRQ_WAKEUP_RCV				15
+#define IRQ_JPEG				16
+#define IRQ_IRDA				17
+#define IRQ_ADC					18
+#define IRQ_UART				19
+#define IRQ_SSP					20
+#define IRQ_I2C					21
+#define IRQ_MAC_1				22
+#define IRQ_MAC_2				23
+#define IRQ_USB_DEV				24
+#define IRQ_USB_H_OHCI_0			25
+#define IRQ_USB_H_EHCI_0			26
+#define IRQ_USB_H_EHCI_1			IRQ_USB_H_EHCI_0
+#define IRQ_USB_H_OHCI_1			27
+#define IRQ_GEN_RAS_1				28
+#define IRQ_GEN_RAS_2				29
+#define IRQ_GEN_RAS_3				30
+#define IRQ_HW_ACCEL_MOD_1			31
+#define IRQ_VIC_END				32
+
+#define SPEAR_GPIO_INT_BASE	IRQ_VIC_END
+#define VIRTUAL_IRQS		0
+#define NR_IRQS 		(IRQ_VIC_END + VIRTUAL_IRQS)
+
+#endif /* __ASM_MACH_IRQS_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/memory.h b/arch/arm/mach-spear3xx/include/mach/memory.h
new file mode 100644
index 0000000..1090287
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/memory.h
@@ -0,0 +1,20 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/memory.h
+ *
+ * Memory map for SPEAr3xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_MEMORY_H
+#define __ASM_MACH_MEMORY_H
+
+/* Physical DRAM offset */
+#define PHYS_OFFSET		UL(0x00000000)
+
+#endif /* __ASM_MACH_MEMORY_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/misc_regs.h b/arch/arm/mach-spear3xx/include/mach/misc_regs.h
new file mode 100755
index 0000000..d83dae9
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/misc_regs.h
@@ -0,0 +1,163 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/misc_regs.h
+ *
+ * Miscellaneous registers definitions for SPEAr3xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_MISC_REGS_H
+#define __ASM_MACH_MISC_REGS_H
+
+#include <mach/spear.h>
+
+#define MISC_BASE		VA_SPEAR3XX_ICM3_MISC_REG_BASE
+
+#define SOC_CFG_CTR		((unsigned int *)(MISC_BASE + 0x000))
+#define DIAG_CFG_CTR 		((unsigned int *)(MISC_BASE + 0x004))
+#define PLL1_CTR 		((unsigned int *)(MISC_BASE + 0x008))
+#define PLL1_FRQ 		((unsigned int *)(MISC_BASE + 0x00C))
+#define PLL1_MOD 		((unsigned int *)(MISC_BASE + 0x010))
+#define PLL2_CTR 		((unsigned int *)(MISC_BASE + 0x014))
+/* PLL_CTR register masks */
+#define PLL_ENABLE		2
+#define PLL_MODE_SHIFT		4
+#define PLL_MODE_MASK		0x3
+#define PLL_MODE_NORMAL		0
+#define PLL_MODE_FRACTION	1
+#define PLL_MODE_DITH_DSB	2
+#define PLL_MODE_DITH_SSB	3
+
+#define PLL2_FRQ 		((unsigned int *)(MISC_BASE + 0x018))
+/* PLL FRQ register masks */
+#define PLL_DIV_N_SHIFT		0
+#define PLL_DIV_N_MASK		0xFF
+#define PLL_DIV_P_SHIFT		8
+#define PLL_DIV_P_MASK		0x7
+#define PLL_NORM_FDBK_M_SHIFT	24
+#define PLL_NORM_FDBK_M_MASK	0xFF
+#define PLL_DITH_FDBK_M_SHIFT	16
+#define PLL_DITH_FDBK_M_MASK	0xFFFF
+
+#define PLL2_MOD 		((unsigned int *)(MISC_BASE + 0x01C))
+#define PLL_CLK_CFG 		((unsigned int *)(MISC_BASE + 0x020))
+#define CORE_CLK_CFG 		((unsigned int *)(MISC_BASE + 0x024))
+/* CORE CLK CFG register masks */
+#define PLL_HCLK_RATIO_SHIFT	10
+#define PLL_HCLK_RATIO_MASK	0x3
+#define HCLK_PCLK_RATIO_SHIFT	8
+#define HCLK_PCLK_RATIO_MASK	0x3
+
+#define PERIP_CLK_CFG 		((unsigned int *)(MISC_BASE + 0x028))
+/* PERIP_CLK_CFG register masks */
+#define UART_CLK_SHIFT		4
+#define UART_CLK_MASK		0x1
+#define FIRDA_CLK_SHIFT		5
+#define FIRDA_CLK_MASK		0x3
+#define GPT0_CLK_SHIFT		8
+#define GPT1_CLK_SHIFT		11
+#define GPT2_CLK_SHIFT		12
+#define GPT_CLK_MASK		0x1
+#define AUX_CLK_PLL3_MASK	0
+#define AUX_CLK_PLL1_MASK	1
+
+#define PERIP1_CLK_ENB 		((unsigned int *)(MISC_BASE + 0x02C))
+/* PERIP1_CLK_ENB register masks */
+#define UART_CLK_ENB		3
+#define SSP_CLK_ENB		5
+#define I2C_CLK_ENB		7
+#define JPEG_CLK_ENB		8
+#define FIRDA_CLK_ENB		10
+#define GPT1_CLK_ENB		11
+#define GPT2_CLK_ENB		12
+#define ADC_CLK_ENB		15
+#define RTC_CLK_ENB		17
+#define GPIO_CLK_ENB		18
+#define DMA_CLK_ENB		19
+#define SMI_CLK_ENB		21
+#define GMAC_CLK_ENB		23
+#define USBD_CLK_ENB		24
+#define USBH_CLK_ENB		25
+#define C3_CLK_ENB		31
+
+#define SOC_CORE_ID		((unsigned int *)(MISC_BASE + 0x030))
+#define RAS_CLK_ENB 		((unsigned int *)(MISC_BASE + 0x034))
+#define PERIP1_SOF_RST 		((unsigned int *)(MISC_BASE + 0x038))
+/* PERIP1_SOF_RST register masks */
+#define JPEG_SOF_RST		8
+
+#define SOC_USER_ID 		((unsigned int *)(MISC_BASE + 0x03C))
+#define RAS_SOF_RST 		((unsigned int *)(MISC_BASE + 0x040))
+#define PRSC1_CLK_CFG 		((unsigned int *)(MISC_BASE + 0x044))
+#define PRSC2_CLK_CFG 		((unsigned int *)(MISC_BASE + 0x048))
+#define PRSC3_CLK_CFG 		((unsigned int *)(MISC_BASE + 0x04C))
+/* gpt synthesizer register masks */
+#define GPT_MSCALE_SHIFT	0
+#define GPT_MSCALE_MASK		0xFFF
+#define GPT_NSCALE_SHIFT	12
+#define GPT_NSCALE_MASK		0xF
+
+#define AMEM_CLK_CFG 		((unsigned int *)(MISC_BASE + 0x050))
+#define EXPI_CLK_CFG 		((unsigned int *)(MISC_BASE + 0x054))
+#define CLCD_CLK_SYNT 		((unsigned int *)(MISC_BASE + 0x05C))
+#define FIRDA_CLK_SYNT 		((unsigned int *)(MISC_BASE + 0x060))
+#define UART_CLK_SYNT 		((unsigned int *)(MISC_BASE + 0x064))
+#define GMAC_CLK_SYNT 		((unsigned int *)(MISC_BASE + 0x068))
+#define RAS1_CLK_SYNT 		((unsigned int *)(MISC_BASE + 0x06C))
+#define RAS2_CLK_SYNT 		((unsigned int *)(MISC_BASE + 0x070))
+#define RAS3_CLK_SYNT 		((unsigned int *)(MISC_BASE + 0x074))
+#define RAS4_CLK_SYNT 		((unsigned int *)(MISC_BASE + 0x078))
+/* aux clk synthesiser register masks for irda to ras4 */
+#define AUX_EQ_SEL_SHIFT	30
+#define AUX_EQ_SEL_MASK		1
+#define AUX_EQ1_SEL		0
+#define AUX_EQ2_SEL		1
+#define AUX_XSCALE_SHIFT	16
+#define AUX_XSCALE_MASK		0xFFF
+#define AUX_YSCALE_SHIFT	0
+#define AUX_YSCALE_MASK		0xFFF
+
+#define ICM1_ARB_CFG 		((unsigned int *)(MISC_BASE + 0x07C))
+#define ICM2_ARB_CFG 		((unsigned int *)(MISC_BASE + 0x080))
+#define ICM3_ARB_CFG 		((unsigned int *)(MISC_BASE + 0x084))
+#define ICM4_ARB_CFG 		((unsigned int *)(MISC_BASE + 0x088))
+#define ICM5_ARB_CFG 		((unsigned int *)(MISC_BASE + 0x08C))
+#define ICM6_ARB_CFG 		((unsigned int *)(MISC_BASE + 0x090))
+#define ICM7_ARB_CFG 		((unsigned int *)(MISC_BASE + 0x094))
+#define ICM8_ARB_CFG 		((unsigned int *)(MISC_BASE + 0x098))
+#define ICM9_ARB_CFG 		((unsigned int *)(MISC_BASE + 0x09C))
+#define DMA_CHN_CFG 		((unsigned int *)(MISC_BASE + 0x0A0))
+#define USB2_PHY_CFG 		((unsigned int *)(MISC_BASE + 0x0A4))
+#define GMAC_CFG_CTR 		((unsigned int *)(MISC_BASE + 0x0A8))
+#define EXPI_CFG_CTR 		((unsigned int *)(MISC_BASE + 0x0AC))
+#define PRC1_LOCK_CTR 		((unsigned int *)(MISC_BASE + 0x0C0))
+#define PRC2_LOCK_CTR 		((unsigned int *)(MISC_BASE + 0x0C4))
+#define PRC3_LOCK_CTR 		((unsigned int *)(MISC_BASE + 0x0C8))
+#define PRC4_LOCK_CTR 		((unsigned int *)(MISC_BASE + 0x0CC))
+#define PRC1_IRQ_CTR 		((unsigned int *)(MISC_BASE + 0x0D0))
+#define PRC2_IRQ_CTR 		((unsigned int *)(MISC_BASE + 0x0D4))
+#define PRC3_IRQ_CTR 		((unsigned int *)(MISC_BASE + 0x0D8))
+#define PRC4_IRQ_CTR 		((unsigned int *)(MISC_BASE + 0x0DC))
+#define PWRDOWN_CFG_CTR 	((unsigned int *)(MISC_BASE + 0x0E0))
+#define COMPSSTL_1V8_CFG 	((unsigned int *)(MISC_BASE + 0x0E4))
+#define COMPSSTL_2V5_CFG 	((unsigned int *)(MISC_BASE + 0x0E8))
+#define COMPCOR_3V3_CFG 	((unsigned int *)(MISC_BASE + 0x0EC))
+#define SSTLPAD_CFG_CTR 	((unsigned int *)(MISC_BASE + 0x0F0))
+#define BIST1_CFG_CTR 		((unsigned int *)(MISC_BASE + 0x0F4))
+#define BIST2_CFG_CTR 		((unsigned int *)(MISC_BASE + 0x0F8))
+#define BIST3_CFG_CTR 		((unsigned int *)(MISC_BASE + 0x0FC))
+#define BIST4_CFG_CTR 		((unsigned int *)(MISC_BASE + 0x100))
+#define BIST5_CFG_CTR 		((unsigned int *)(MISC_BASE + 0x104))
+#define BIST1_STS_RES 		((unsigned int *)(MISC_BASE + 0x108))
+#define BIST2_STS_RES 		((unsigned int *)(MISC_BASE + 0x10C))
+#define BIST3_STS_RES 		((unsigned int *)(MISC_BASE + 0x110))
+#define BIST4_STS_RES 		((unsigned int *)(MISC_BASE + 0x114))
+#define BIST5_STS_RES 		((unsigned int *)(MISC_BASE + 0x118))
+#define SYSERR_CFG_CTR 		((unsigned int *)(MISC_BASE + 0x11C))
+
+#endif /* __ASM_MACH_MISC_REGS_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/spear.h b/arch/arm/mach-spear3xx/include/mach/spear.h
new file mode 100644
index 0000000..ade272a
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/spear.h
@@ -0,0 +1,136 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/spear.h
+ *
+ * SPEAr3xx Machine family specific definition
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_SPEAR3XX_H
+#define __ASM_MACH_SPEAR3XX_H
+
+#include <mach/hardware.h>
+#include <mach/spear300.h>
+#include <mach/spear310.h>
+#include <mach/spear320.h>
+
+#define SPEAR3XX_ICM9_BASE		0xC0000000
+#define SPEAR3XX_ICM9_SIZE		0x10000000
+
+/* ICM1 - Low speed connection */
+#define SPEAR3XX_ICM1_2_BASE		0xD0000000
+#define SPEAR3XX_ICM1_2_SIZE		0x10000000
+
+#define SPEAR3XX_ICM1_UART_BASE		0xD0000000
+#define VA_SPEAR3XX_ICM1_UART_BASE	IO_ADDRESS(SPEAR3XX_ICM1_UART_BASE)
+#define SPEAR3XX_ICM1_UART_SIZE		0x00080000
+
+#define SPEAR3XX_ICM1_ADC_BASE 		0xD0080000
+#define SPEAR3XX_ICM1_ADC_SIZE 		0x00080000
+
+#define SPEAR3XX_ICM1_SSP_BASE		0xD0100000
+#define SPEAR3XX_ICM1_SSP_SIZE		0x00080000
+
+#define SPEAR3XX_ICM1_I2C_BASE 		0xD0180000
+#define SPEAR3XX_ICM1_I2C_SIZE 		0x00080000
+
+#define SPEAR3XX_ICM1_JPEG_BASE 	0xD0800000
+#define SPEAR3XX_ICM1_JPEG_SIZE		0x00800000
+
+#define SPEAR3XX_ICM1_IRDA_BASE		0xD1000000
+#define SPEAR3XX_ICM1_IRDA_SIZE		0x00080000
+
+#define SPEAR3XX_ICM1_SRAM_BASE		0xD2800000
+#define SPEAR3XX_ICM1_SRAM_SIZE		0x05800000
+
+/* ICM2 - Application Subsystem */
+#define SPEAR3XX_ICM2_HWACCEL0_BASE 	0xD8800000
+#define SPEAR3XX_ICM2_HWACCEL0_SIZE 	0x00800000
+
+#define SPEAR3XX_ICM2_HWACCEL1_BASE 	0xD9000000
+#define SPEAR3XX_ICM2_HWACCEL1_SIZE 	0x00800000
+
+/* ICM4 - High Speed Connection */
+#define SPEAR3XX_ICM4_BASE		0xE0000000
+#define SPEAR3XX_ICM4_SIZE		0x08000000
+
+#define SPEAR3XX_ICM4_MII_BASE		0xE0800000
+#define SPEAR3XX_ICM4_MII_SIZE		0x00800000
+
+#define SPEAR3XX_ICM4_USBD_FIFO_BASE	0xE1000000
+#define SPEAR3XX_ICM4_USBD_FIFO_SIZE	0x00100000
+
+#define SPEAR3XX_ICM4_USBD_CSR_BASE 	0xE1100000
+#define SPEAR3XX_ICM4_USBD_CSR_SIZE 	0x00100000
+
+#define SPEAR3XX_ICM4_USBD_PLDT_BASE	0xE1200000
+#define SPEAR3XX_ICM4_USBD_PLDT_SIZE	0x00100000
+
+#define SPEAR3XX_ICM4_USB_EHCI0_1_BASE	0xE1800000
+#define SPEAR3XX_ICM4_USB_EHCI0_1_SIZE	0x00100000
+
+#define SPEAR3XX_ICM4_USB_OHCI0_BASE	0xE1900000
+#define SPEAR3XX_ICM4_USB_OHCI0_SIZE	0x00100000
+
+#define SPEAR3XX_ICM4_USB_OHCI1_BASE	0xE2100000
+#define SPEAR3XX_ICM4_USB_OHCI1_SIZE	0x00100000
+
+#define SPEAR3XX_ICM4_USB_ARB_BASE	0xE2800000
+#define SPEAR3XX_ICM4_USB_ARB_SIZE	0x00010000
+
+/* ML1 - Multi Layer CPU Subsystem */
+#define SPEAR3XX_ICM3_ML1_2_BASE	0xF0000000
+#define SPEAR3XX_ICM3_ML1_2_SIZE	0x0F000000
+
+#define SPEAR3XX_ML1_SDRAM_BASE		0x00000000
+#define SPEAR3XX_ML1_SDRAM_SIZE		0x40000000
+
+#define SPEAR3XX_ML1_TMR_BASE		0xF0000000
+#define SPEAR3XX_ML1_TMR_SIZE 		0x00100000
+
+#define SPEAR3XX_ML1_VIC_BASE		0xF1100000
+#define VA_SPEAR3XX_ML1_VIC_BASE	IO_ADDRESS(SPEAR3XX_ML1_VIC_BASE)
+#define SPEAR3XX_ML1_VIC_SIZE		0x00100000
+
+/* ICM3 - Basic Subsystem */
+#define SPEAR3XX_ICM3_SMEM_BASE		0xF8000000
+#define SPEAR3XX_ICM3_SMEM_SIZE		0x04000000
+
+#define SPEAR3XX_ICM3_SMI_CTRL_BASE	0xFC000000
+#define SPEAR3XX_ICM3_SMI_CTRL_SIZE	0x00200000
+
+#define SPEAR3XX_ICM3_DMA_BASE		0xFC400000
+#define SPEAR3XX_ICM3_DMA_SIZE		0x00200000
+
+#define SPEAR3XX_ICM3_SDRAM_CTRL_BASE	0xFC600000
+#define SPEAR3XX_ICM3_SDRAM_CTRL_SIZE	0x00200000
+
+#define SPEAR3XX_ICM3_TMR0_BASE 	0xFC800000
+#define SPEAR3XX_ICM3_TMR0_SIZE 	0x00080000
+
+#define SPEAR3XX_ICM3_WDT_BASE		0xFC880000
+#define SPEAR3XX_ICM3_WDT_SIZE		0x00080000
+
+#define SPEAR3XX_ICM3_RTC_BASE		0xFC900000
+#define SPEAR3XX_ICM3_RTC_SIZE		0x00080000
+
+#define SPEAR3XX_ICM3_GPIO_BASE		0xFC980000
+#define SPEAR3XX_ICM3_GPIO_SIZE		0x00080000
+
+#define SPEAR3XX_ICM3_SYS_CTRL_BASE	0xFCA00000
+#define VA_SPEAR3XX_ICM3_SYS_CTRL_BASE	IO_ADDRESS(SPEAR3XX_ICM3_SYS_CTRL_BASE)
+#define SPEAR3XX_ICM3_SYS_CTRL_SIZE	0x00080000
+
+#define SPEAR3XX_ICM3_MISC_REG_BASE 	0xFCA80000
+#define VA_SPEAR3XX_ICM3_MISC_REG_BASE	IO_ADDRESS(SPEAR3XX_ICM3_MISC_REG_BASE)
+#define SPEAR3XX_ICM3_MISC_REG_SIZE 	0x00080000
+
+#define SPEAR3XX_ICM3_TMR1_BASE 	0xFCB00000
+#define SPEAR3XX_ICM3_TMR1_SIZE 	0x00080000
+
+#endif /* __ASM_MACH_SPEAR3XX_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/spear300.h b/arch/arm/mach-spear3xx/include/mach/spear300.h
new file mode 100644
index 0000000..0cd95be
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/spear300.h
@@ -0,0 +1,64 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/spear300.h
+ *
+ * SPEAr300 Machine specific definition
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifdef	CONFIG_MACH_SPEAR300
+
+#ifndef __ASM_MACH_SPEAR300_H
+#define __ASM_MACH_SPEAR300_H
+
+/* Base address of various IPs */
+#define SPEAR300_TELECOM_BASE		0x50000000
+#define SPEAR300_TELECOM_SIZE		0x10000000
+
+#define SPEAR300_CLCD_BASE		0x60000000
+#define SPEAR300_CLCD_SIZE		0x10000000
+
+#define SPEAR300_SDIO_BASE		0x70000000
+#define SPEAR300_SDIO_SIZE		0x10000000
+
+#define SPEAR300_NAND_0_BASE		0x80000000
+#define SPEAR300_NAND_0_SIZE		0x04000000
+
+#define SPEAR300_NAND_1_BASE		0x84000000
+#define SPEAR300_NAND_1_SIZE		0x04000000
+
+#define SPEAR300_NAND_2_BASE		0x88000000
+#define SPEAR300_NAND_2_SIZE		0x04000000
+
+#define SPEAR300_NAND_3_BASE		0x8c000000
+#define SPEAR300_NAND_3_SIZE		0x04000000
+
+#define SPEAR300_NOR_0_BASE		0x90000000
+#define SPEAR300_NOR_0_SIZE		0x01000000
+
+#define SPEAR300_NOR_1_BASE		0x91000000
+#define SPEAR300_NOR_1_SIZE		0x01000000
+
+#define SPEAR300_NOR_2_BASE		0x92000000
+#define SPEAR300_NOR_2_SIZE		0x01000000
+
+#define SPEAR300_NOR_3_BASE		0x93000000
+#define SPEAR300_NOR_3_SIZE		0x01000000
+
+#define SPEAR300_FSMC_BASE		0x94000000
+#define SPEAR300_FSMC_SIZE		0x05000000
+
+#define SPEAR300_KEYBOARD_BASE 		0xA0000000
+#define SPEAR300_KEYBOARD_SIZE 		0x09000000
+
+#define SPEAR300_GPIO_BASE		0xA9000000
+#define SPEAR300_GPIO_SIZE		0x07000000
+
+#endif /* __ASM_MACH_SPEAR300_H */
+
+#endif /* CONFIG_MACH_SPEAR300 */
diff --git a/arch/arm/mach-spear3xx/include/mach/spear310.h b/arch/arm/mach-spear3xx/include/mach/spear310.h
new file mode 100644
index 0000000..5c79131
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/spear310.h
@@ -0,0 +1,43 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/spear310.h
+ *
+ * SPEAr310 Machine specific definition
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifdef	CONFIG_MACH_SPEAR310
+
+#ifndef __ASM_MACH_SPEAR310_H
+#define __ASM_MACH_SPEAR310_H
+
+#define SPEAR310_NAND_BASE		0x40000000
+#define SPEAR310_NAND_SIZE		0x04000000
+
+#define SPEAR310_FSMC_BASE		0x44000000
+#define SPEAR310_FSMC_SIZE		0x01000000
+
+#define SPEAR310_UART0_BASE		0xB2000000
+#define SPEAR310_UART1_BASE		0xB2080000
+#define SPEAR310_UART2_BASE		0xB2100000
+#define SPEAR310_UART3_BASE		0xB2180000
+#define SPEAR310_UART4_BASE		0xB2200000
+#define SPEAR310_UART_SIZE		0x00080000
+
+#define SPEAR310_HDLC_BASE		0xB2800000
+#define SPEAR310_HDLC_SIZE		0x00800000
+
+#define SPEAR310_RS485_0_BASE		0xB3000000
+#define SPEAR310_RS485_0_SIZE		0x00800000
+
+#define SPEAR310_RS485_1_BASE		0xB3800000
+#define SPEAR310_RS485_1_SIZE		0x00800000
+
+#endif /* __ASM_MACH_SPEAR310_H */
+
+#endif /* CONFIG_MACH_SPEAR310 */
diff --git a/arch/arm/mach-spear3xx/include/mach/spear320.h b/arch/arm/mach-spear3xx/include/mach/spear320.h
new file mode 100644
index 0000000..ab6a85a
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/spear320.h
@@ -0,0 +1,69 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/spear320.h
+ *
+ * SPEAr320 Machine specific definition
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifdef	CONFIG_MACH_SPEAR320
+
+#ifndef __ASM_MACH_SPEAR320_H
+#define __ASM_MACH_SPEAR320_H
+
+#define SPEAR320_EMI_CTRL_BASE		0x40000000
+#define SPEAR320_EMI_CTRL_SIZE		0x08000000
+
+#define SPEAR320_FSMC_BASE		0x4C000000
+#define SPEAR320_FSMC_SIZE		0x01000000
+
+#define SPEAR320_I2S_BASE		0x60000000
+#define SPEAR320_I2S_SIZE		0x10000000
+
+#define SPEAR320_SDIO_BASE		0x70000000
+#define SPEAR320_SDIO_SIZE		0x10000000
+
+#define SPEAR320_CLCD_BASE		0x90000000
+#define SPEAR320_CLCD_SIZE		0x10000000
+
+#define SPEAR320_PAR_PORT_BASE		0xA0000000
+#define SPEAR320_PAR_PORT_SIZE		0x01000000
+
+#define SPEAR320_CAN0_BASE		0xA1000000
+#define SPEAR320_CAN0_SIZE		0x01000000
+
+#define SPEAR320_CAN1_BASE		0xA2000000
+#define SPEAR320_CAN1_SIZE		0x01000000
+
+#define SPEAR320_UART0_BASE		0xA3000000
+#define SPEAR320_UART0_SIZE		0x01000000
+
+#define SPEAR320_UART1_BASE		0xA4000000
+#define SPEAR320_UART1_SIZE		0x01000000
+
+#define SPEAR320_SSP0_BASE		0xA5000000
+#define SPEAR320_SSP0_SIZE		0x01000000
+
+#define SPEAR320_SSP1_BASE		0xA6000000
+#define SPEAR320_SSP1_SIZE		0x01000000
+
+#define SPEAR320_I2C_BASE		0xA7000000
+#define SPEAR320_I2C_SIZE		0x01000000
+
+#define SPEAR320_PWM_BASE		0xA8000000
+#define SPEAR320_PWM_SIZE		0x01000000
+
+#define SPEAR320_SMII0_BASE		0xAA000000
+#define SPEAR320_SMII0_SIZE		0x01000000
+
+#define SPEAR320_SMII1_BASE		0xAB000000
+#define SPEAR320_SMII1_SIZE		0x01000000
+
+#endif /* __ASM_MACH_SPEAR320_H */
+
+#endif /* CONFIG_MACH_SPEAR320 */
diff --git a/arch/arm/mach-spear3xx/include/mach/system.h b/arch/arm/mach-spear3xx/include/mach/system.h
new file mode 100644
index 0000000..b7bc53f
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/system.h
@@ -0,0 +1,41 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/system.h
+ *
+ * SPEAr3xx Machine family specific architecture functions
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_SYSTEM_H
+#define __ASM_MACH_SYSTEM_H
+
+#include <linux/io.h>
+#include <linux/sysctl_sp810.h>
+#include <mach/spear.h>
+
+static inline void arch_idle(void)
+{
+	/*
+	 * This should do all the clock switching
+	 * and wait for interrupt tricks
+	 */
+	cpu_do_idle();
+}
+
+static inline void arch_reset(char mode, const char *cmd)
+{
+	if (mode == 's') {
+		/* software reset, Jump into ROM at address 0 */
+		cpu_reset(0);
+	} else {
+		/* hardware reset, Use on-chip reset capability */
+		sysctl_soft_reset(SPEAR3XX_ICM3_SYS_CTRL_BASE);
+	}
+}
+
+#endif /* __ASM_MACH_SYSTEM_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/timex.h b/arch/arm/mach-spear3xx/include/mach/timex.h
new file mode 100644
index 0000000..29708db
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/timex.h
@@ -0,0 +1,19 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/timex.h
+ *
+ * SPEAr3XX machine family specific timex definitions
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_TIMEX_H
+#define __ASM_MACH_TIMEX_H
+
+#define CLOCK_TICK_RATE			48000000
+
+#endif /* __ASM_MACH_TIMEX_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/uncompress.h b/arch/arm/mach-spear3xx/include/mach/uncompress.h
new file mode 100644
index 0000000..08ec3b1
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/uncompress.h
@@ -0,0 +1,43 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/uncompress.h
+ *
+ * Serial port stubs for kernel decompress status messages
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/io.h>
+#include <linux/amba/serial.h>
+#include <mach/spear.h>
+
+#ifndef __ASM_MACH_UNCOMPRESS_H
+#define __ASM_MACH_UNCOMPRESS_H
+/*
+ * This does not append a newline
+ */
+static inline void putc(int c)
+{
+	void __iomem *base = (void __iomem *)SPEAR3XX_ICM1_UART_BASE;
+
+	while (readl(base + UART01x_FR) & UART01x_FR_TXFF)
+		barrier();
+
+	writel(c, base + UART01x_DR);
+}
+
+static inline void flush(void)
+{
+}
+
+/*
+ * nothing to do
+ */
+#define arch_decomp_setup()
+#define arch_decomp_wdog()
+
+#endif /* __ASM_MACH_UNCOMPRESS_H */
diff --git a/arch/arm/mach-spear3xx/include/mach/vmalloc.h b/arch/arm/mach-spear3xx/include/mach/vmalloc.h
new file mode 100644
index 0000000..4f236f3
--- /dev/null
+++ b/arch/arm/mach-spear3xx/include/mach/vmalloc.h
@@ -0,0 +1,22 @@
+/*
+ * arch/arm/mach-spear3xx/include/mach/vmalloc.h
+ *
+ * Defining Vmalloc area for SPEAr3xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_VMALLOC_H
+#define __ASM_MACH_VMALLOC_H
+
+#include <mach/memory.h>
+
+#define VMALLOC_SIZE		(0x30000000)
+#define VMALLOC_END		(PAGE_OFFSET + VMALLOC_SIZE)
+
+#endif /* __ASM_MACH_VMALLOC_H */
-- 
1.6.0.2

