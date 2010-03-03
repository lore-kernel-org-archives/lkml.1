Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967Ab0CCFIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:08:42 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:56656 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887Ab0CCFID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:08:03 -0500
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
       deepak.sikri@st.com, ashish.priyadarshi@st.com,
       Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 03/11] ST SPEAr: Added basic header files for SPEAr6xx machine family
Date: Wed,  3 Mar 2010 10:37:33 +0530
Message-Id: <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear6xx/include/mach/debug-macro.S |   38 +++++
 arch/arm/mach-spear6xx/include/mach/dma.h         |   17 ++
 arch/arm/mach-spear6xx/include/mach/entry-macro.S |   55 +++++++
 arch/arm/mach-spear6xx/include/mach/generic.h     |   37 +++++
 arch/arm/mach-spear6xx/include/mach/hardware.h    |   21 +++
 arch/arm/mach-spear6xx/include/mach/io.h          |   23 +++
 arch/arm/mach-spear6xx/include/mach/irqs.h        |   92 +++++++++++
 arch/arm/mach-spear6xx/include/mach/memory.h      |   20 +++
 arch/arm/mach-spear6xx/include/mach/misc_regs.h   |  173 +++++++++++++++++++++
 arch/arm/mach-spear6xx/include/mach/spear.h       |  165 ++++++++++++++++++++
 arch/arm/mach-spear6xx/include/mach/spear600.h    |   21 +++
 arch/arm/mach-spear6xx/include/mach/system.h      |   41 +++++
 arch/arm/mach-spear6xx/include/mach/timex.h       |   19 +++
 arch/arm/mach-spear6xx/include/mach/uncompress.h  |   43 +++++
 arch/arm/mach-spear6xx/include/mach/vmalloc.h     |   22 +++
 15 files changed, 787 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-spear6xx/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-spear6xx/include/mach/dma.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-spear6xx/include/mach/generic.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/hardware.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/io.h
 create mode 100755 arch/arm/mach-spear6xx/include/mach/irqs.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/memory.h
 create mode 100755 arch/arm/mach-spear6xx/include/mach/misc_regs.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/spear.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/spear600.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/system.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/timex.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach/vmalloc.h

diff --git a/arch/arm/mach-spear6xx/include/mach/debug-macro.S b/arch/arm/mach-spear6xx/include/mach/debug-macro.S
new file mode 100644
index 0000000..a3ac823
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/debug-macro.S
@@ -0,0 +1,38 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/debug-macro.S
+ *
+ * Debugging macro include header for SPEAr6xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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
+		moveq 	\rx, =SPEAR6XX_ICM1_UART0_BASE		@ Physical base
+		movne 	\rx, =VA_SPEAR6XX_ICM1_UART0_BASE	@ Virtual base
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
diff --git a/arch/arm/mach-spear6xx/include/mach/dma.h b/arch/arm/mach-spear6xx/include/mach/dma.h
new file mode 100644
index 0000000..c4afd17
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/dma.h
@@ -0,0 +1,17 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/dma.h
+ *
+ * Generic SPEAr6XX machine family DMA support
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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
diff --git a/arch/arm/mach-spear6xx/include/mach/entry-macro.S b/arch/arm/mach-spear6xx/include/mach/entry-macro.S
new file mode 100644
index 0000000..9eaecae
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/entry-macro.S
@@ -0,0 +1,55 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/entry-macro.S
+ *
+ * Low-level IRQ helper macros for SPEAr6xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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
+		ldr	\base, =VA_SPEAR6XX_CPU_VIC_PRI_BASE
+		ldr	\irqstat, [\base, #VIC_IRQ_STATUS]	@ get status
+		mov	\irqnr, #0
+		teq	\irqstat, #0
+		bne	1001f
+		ldr	\base, =VA_SPEAR6XX_CPU_VIC_SEC_BASE
+		ldr	\irqstat, [\base, #VIC_IRQ_STATUS]	@ get status
+		teq	\irqstat, #0
+		beq	1002f				@ this will set/reset
+							@ zero register
+		mov	\irqnr, #32
+1001:
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
+
+		rsb	\tmp, \tmp, #0x1F		@ tmp = 32 - tmp - 1
+		add	\irqnr, \irqnr, \tmp
+
+1002:		/* EQ will be set if no irqs pending */
+		.endm
diff --git a/arch/arm/mach-spear6xx/include/mach/generic.h b/arch/arm/mach-spear6xx/include/mach/generic.h
new file mode 100644
index 0000000..9c3f91f
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/generic.h
@@ -0,0 +1,37 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/generic.h
+ *
+ * SPEAr6XX machine family specific generic header file
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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
+/* Add spear6xx family device structure declarations here */
+extern struct amba_device uart_device[];
+extern struct sys_timer spear_sys_timer;
+
+/* Add spear600 machine device structure declarations here */
+
+/* Add spear6xx family function declarations here */
+void __init spear6xx_map_io(void);
+void __init spear6xx_init_irq(void);
+void __init spear6xx_init(void);
+void __init spear600_init(void);
+void __init spear_gpt_init(void);
+void __init clk_init(void);
+
+#endif /* __ASM_ARCH_GENERIC_H */
diff --git a/arch/arm/mach-spear6xx/include/mach/hardware.h b/arch/arm/mach-spear6xx/include/mach/hardware.h
new file mode 100644
index 0000000..e9a268e
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/hardware.h
@@ -0,0 +1,21 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/hardware.h
+ *
+ * Hardware definitions for SPEAr6xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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
+
diff --git a/arch/arm/mach-spear6xx/include/mach/io.h b/arch/arm/mach-spear6xx/include/mach/io.h
new file mode 100644
index 0000000..0563910
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/io.h
@@ -0,0 +1,23 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/io.h
+ *
+ * IO definitions for SPEAr6xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar Kumar<rajeev-dlh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_ARM_MACH_IO_H
+#define __ASM_ARM_MACH_IO_H
+
+#define IO_SPACE_LIMIT		0xFFFFFFFF
+
+#define __io(a)			__typesafe_io(a)
+#define __mem_pci(a)		(a)
+
+#endif	/* __ASM_ARM_MACH_IO_H */
+
diff --git a/arch/arm/mach-spear6xx/include/mach/irqs.h b/arch/arm/mach-spear6xx/include/mach/irqs.h
new file mode 100755
index 0000000..a626068
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/irqs.h
@@ -0,0 +1,92 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/irqs.h
+ *
+ * IRQ helper macros for SPEAr6xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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
+/* VIC 1 */
+#define IRQ_INTRCOMM_SW_IRQ			0
+#define IRQ_INTRCOMM_CPU_1			1
+#define IRQ_INTRCOMM_CPU_2			2
+#define IRQ_INTRCOMM_RAS2A11_1			3
+#define IRQ_INTRCOMM_RAS2A11_2			4
+#define IRQ_INTRCOMM_RAS2A12_1			5
+#define IRQ_INTRCOMM_RAS2A12_2			6
+#define IRQ_GEN_RAS_0				7
+#define IRQ_GEN_RAS_1				8
+#define IRQ_GEN_RAS_2				9
+#define IRQ_GEN_RAS_3				10
+#define IRQ_GEN_RAS_4				11
+#define IRQ_GEN_RAS_5				12
+#define IRQ_GEN_RAS_6				13
+#define IRQ_GEN_RAS_7				14
+#define IRQ_GEN_RAS_8				15
+#define IRQ_CPU_GPT1_1				16
+#define IRQ_CPU_GPT1_2				17
+#define IRQ_LOCAL_GPIO				18
+#define IRQ_PLL_UNLOCK				19
+#define IRQ_JPEG				20
+#define IRQ_FSMC				21
+#define IRQ_IRDA				22
+#define IRQ_RESERVED				23
+#define IRQ_UART_0				24
+#define IRQ_UART_1				25
+#define IRQ_SSP_1				26
+#define IRQ_SSP_2				27
+#define IRQ_I2C					28
+#define IRQ_GEN_RAS_9				29
+#define IRQ_GEN_RAS_10				30
+#define IRQ_GEN_RAS_11				31
+
+/* VIC 2 */
+#define IRQ_APPL_GPT1_1				32
+#define IRQ_APPL_GPT1_2				33
+#define IRQ_APPL_GPT2_1 			34
+#define IRQ_APPL_GPT2_2				35
+#define IRQ_APPL_GPIO				36
+#define IRQ_APPL_SSP				37
+#define IRQ_APPL_ADC				38
+#define IRQ_APPL_RESERVED			39
+#define IRQ_AHB_EXP_MASTER			40
+#define IRQ_DDR_CONTROLLER			41
+#define IRQ_BASIC_DMA				42
+#define IRQ_BASIC_RESERVED1			43
+#define IRQ_BASIC_SMI				44
+#define IRQ_BASIC_CLCD				45
+#define IRQ_EXP_AHB_1				46
+#define IRQ_EXP_AHB_2				47
+#define IRQ_BASIC_GPT1_1			48
+#define IRQ_BASIC_GPT1_2			49
+#define IRQ_BASIC_RTC				50
+#define IRQ_BASIC_GPIO				51
+#define IRQ_BASIC_WDT				52
+#define IRQ_BASIC_RESERVED			53
+#define IRQ_AHB_EXP_SLAVE			54
+#define IRQ_GMAC_1				55
+#define IRQ_GMAC_2				56
+#define IRQ_USB_DEV				57
+#define IRQ_USB_H_OHCI_0			58
+#define IRQ_USB_H_EHCI_0			59
+#define IRQ_USB_H_OHCI_1			60
+#define IRQ_USB_H_EHCI_1			61
+#define IRQ_EXP_AHB_3				62
+#define IRQ_EXP_AHB_4				63
+
+#define IRQ_VIC_END				64
+
+#define SPEAR_GPIO_INT_BASE	IRQ_VIC_END
+#define VIRTUAL_IRQS		0
+#define NR_IRQS 		(IRQ_VIC_END + VIRTUAL_IRQS)
+
+#endif	/* __ASM_MACH_IRQS_H */
diff --git a/arch/arm/mach-spear6xx/include/mach/memory.h b/arch/arm/mach-spear6xx/include/mach/memory.h
new file mode 100644
index 0000000..f0e4627
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/memory.h
@@ -0,0 +1,20 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/memory.h
+ *
+ * Memory map for SPEAr6xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_MEMORY_H
+#define __ASM_MACH_MEMORY_H
+
+/* Physical DRAM offset.*/
+#define PHYS_OFFSET	UL(0x00000000)
+
+#endif	/* __ASM_MACH_MEMORY_H */
diff --git a/arch/arm/mach-spear6xx/include/mach/misc_regs.h b/arch/arm/mach-spear6xx/include/mach/misc_regs.h
new file mode 100755
index 0000000..6184107
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/misc_regs.h
@@ -0,0 +1,173 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/misc_regs.h
+ *
+ * Miscellaneous registers definitions for SPEAr6xx machine family
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
+#define MISC_BASE		VA_SPEAR6XX_ICM3_MISC_REG_BASE
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
+#define CLCD_CLK_SHIFT		2
+#define CLCD_CLK_MASK		0x3
+#define UART_CLK_SHIFT		4
+#define UART_CLK_MASK		0x1
+#define FIRDA_CLK_SHIFT		5
+#define FIRDA_CLK_MASK		0x3
+#define GPT0_CLK_SHIFT		8
+#define GPT1_CLK_SHIFT		10
+#define GPT2_CLK_SHIFT		11
+#define GPT3_CLK_SHIFT		12
+#define GPT_CLK_MASK		0x1
+#define AUX_CLK_PLL3_MASK	0
+#define AUX_CLK_PLL1_MASK	1
+
+#define PERIP1_CLK_ENB 		((unsigned int *)(MISC_BASE + 0x02C))
+/* PERIP1_CLK_ENB register masks */
+#define UART0_CLK_ENB		3
+#define UART1_CLK_ENB		4
+#define SSP0_CLK_ENB		5
+#define SSP1_CLK_ENB		6
+#define I2C_CLK_ENB		7
+#define JPEG_CLK_ENB		8
+#define FSMC_CLK_ENB		9
+#define FIRDA_CLK_ENB		10
+#define GPT2_CLK_ENB		11
+#define GPT3_CLK_ENB		12
+#define GPIO2_CLK_ENB		13
+#define SSP2_CLK_ENB		14
+#define ADC_CLK_ENB		15
+#define GPT1_CLK_ENB		11
+#define RTC_CLK_ENB		17
+#define GPIO1_CLK_ENB		18
+#define DMA_CLK_ENB		19
+#define SMI_CLK_ENB		21
+#define CLCD_CLK_ENB		22
+#define GMAC_CLK_ENB		23
+#define USBD_CLK_ENB		24
+#define USBH0_CLK_ENB		25
+#define USBH1_CLK_ENB		26
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
diff --git a/arch/arm/mach-spear6xx/include/mach/spear.h b/arch/arm/mach-spear6xx/include/mach/spear.h
new file mode 100644
index 0000000..9df2ef2
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/spear.h
@@ -0,0 +1,165 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/spear.h
+ *
+ * SPEAr6xx Machine family specific definition
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ASM_MACH_SPEAR6XX_H
+#define __ASM_MACH_SPEAR6XX_H
+
+#include <mach/hardware.h>
+#include <mach/spear600.h>
+
+/* ICM1 - Low speed connection */
+#define SPEAR6XX_ICM1_BASE		0xD0000000
+#define SPEAR6XX_ICM1_SIZE		0x10000000
+
+#define SPEAR6XX_ICM1_UART0_BASE	0xD0000000
+#define VA_SPEAR6XX_ICM1_UART0_BASE	IO_ADDRESS(SPEAR6XX_ICM1_UART0_BASE)
+#define SPEAR6XX_ICM1_UART0_SIZE	0x00080000
+
+#define SPEAR6XX_ICM1_UART1_BASE	0xD0080000
+#define SPEAR6XX_ICM1_UART1_SIZE	0x00080000
+
+#define SPEAR6XX_ICM1_SSP0_BASE		0xD0100000
+#define SPEAR6XX_ICM1_SSP0_SIZE		0x00080000
+
+#define SPEAR6XX_ICM1_SSP1_BASE		0xD0180000
+#define SPEAR6XX_ICM1_SSP1_SIZE		0x00080000
+
+#define SPEAR6XX_ICM1_I2C_BASE 		0xD0200000
+#define SPEAR6XX_ICM1_I2C_SIZE 		0x00080000
+
+#define SPEAR6XX_ICM1_JPEG_BASE 	0xD0800000
+#define SPEAR6XX_ICM1_JPEG_SIZE		0x00800000
+
+#define SPEAR6XX_ICM1_IRDA_BASE		0xD1000000
+#define SPEAR6XX_ICM1_IRDA_SIZE		0x00080000
+
+#define SPEAR6XX_ICM1_FSMC_BASE		0xD1800000
+#define SPEAR6XX_ICM1_FSMC_SIZE		0x00800000
+
+#define SPEAR6XX_ICM1_NAND_BASE		0xD2000000
+#define SPEAR6XX_ICM1_NAND_SIZE		0x00800000
+
+#define SPEAR6XX_ICM1_SRAM_BASE		0xD2800000
+#define SPEAR6XX_ICM1_SRAM_SIZE		0x00800000
+
+/* ICM2 - Application Subsystem */
+#define SPEAR6XX_ICM2_BASE		0xD8000000
+#define SPEAR6XX_ICM2_SIZE		0x08000000
+
+#define SPEAR6XX_ICM2_TMR0_BASE		0xD8000000
+#define SPEAR6XX_ICM2_SRAM_SIZE		0x00800000
+
+#define SPEAR6XX_ICM2_TMR1_BASE		0xD8080000
+#define SPEAR6XX_ICM2_SRAM_SIZE		0x00800000
+
+#define SPEAR6XX_ICM2_GPIO_BASE		0xD8100000
+#define SPEAR6XX_ICM2_SRAM_SIZE		0x00800000
+
+#define SPEAR6XX_ICM2_SPI2_BASE		0xD8180000
+#define SPEAR6XX_ICM2_SPI2_SIZE		0x00800000
+
+#define SPEAR6XX_ICM2_ADC_BASE		0xD8200000
+#define SPEAR6XX_ICM2_ADC_SIZE		0x00800000
+
+/* ML-1, 2 - Multi Layer CPU Subsystem */
+#define SPEAR6XX_ML_CPU_BASE		0xF0000000
+#define SPEAR6XX_ML_CPU_SIZE		0x0F000000
+
+#define SPEAR6XX_ML_SDRAM_BASE		0x00000000
+#define SPEAR6XX_ML_SDRAM_SIZE		0x40000000
+
+#define SPEAR6XX_CPU_TMR_BASE		0xF0000000
+#define SPEAR6XX_CPU_TMR_SIZE		0x00100000
+
+#define SPEAR6XX_CPU_GPIO_BASE		0xF0100000
+#define SPEAR6XX_CPU_GPIO_SIZE		0x00100000
+
+#define SPEAR6XX_CPU_VIC_SEC_BASE	0xF1000000
+#define VA_SPEAR6XX_CPU_VIC_SEC_BASE	IO_ADDRESS(SPEAR6XX_CPU_VIC_SEC_BASE)
+#define SPEAR6XX_CPU_VIC_SEC_SIZE	0x00100000
+
+#define SPEAR6XX_CPU_VIC_PRI_BASE	0xF1100000
+#define VA_SPEAR6XX_CPU_VIC_PRI_BASE	IO_ADDRESS(SPEAR6XX_CPU_VIC_PRI_BASE)
+#define SPEAR6XX_CPU_VIC_PRI_SIZE	0x00100000
+
+/* ICM3 - Basic Subsystem */
+#define SPEAR6XX_ICM3_BASE		0xF8000000
+#define SPEAR6XX_ICM3_SIZE		0x08000000
+
+#define SPEAR6XX_ICM3_SFLASH_BASE	0xF8000000
+#define SPEAR6XX_ICM3_SFLASH_SIZE	0x04000000
+
+#define SPEAR6XX_ICM3_SFLASH_CTRL_BASE	0xFC000000
+#define SPEAR6XX_ICM3_SFLASH_CTRL_SIZE	0x04000000
+
+#define SPEAR6XX_ICM3_CLCD_BASE		0xFC200000
+#define SPEAR6XX_ICM3_CLCD_SIZE		0x00200000
+
+#define SPEAR6XX_ICM3_DMA_BASE		0xFC400000
+#define SPEAR6XX_ICM3_DMA_SIZE		0x00200000
+
+#define SPEAR6XX_ICM3_SDRAM_BASE	0xFC600000
+#define SPEAR6XX_ICM3_SDRAM_SIZE	0x00200000
+
+#define SPEAR6XX_ICM3_TMR_BASE		0xFC800000
+#define SPEAR6XX_ICM3_TMR_SIZE		0x00080000
+
+#define SPEAR6XX_ICM3_WDT_BASE		0xFC880000
+#define SPEAR6XX_ICM3_WDT_SIZE		0x00080000
+
+#define SPEAR6XX_ICM3_RTC_BASE		0xFC900000
+#define SPEAR6XX_ICM3_RTC_SIZE		0x00080000
+
+#define SPEAR6XX_ICM3_GPIO_BASE		0xFC980000
+#define SPEAR6XX_ICM3_GPIO_SIZE		0x00080000
+
+#define SPEAR6XX_ICM3_SYS_CTRL_BASE	0xFCA00000
+#define VA_SPEAR6XX_ICM3_SYS_CTRL_BASE	IO_ADDRESS(SPEAR6XX_ICM3_SYS_CTRL_BASE)
+#define SPEAR6XX_ICM3_SYS_CTRL_SIZE 	0x00080000
+
+#define SPEAR6XX_ICM3_MISC_REG_BASE	0xFCA80000
+#define VA_SPEAR6XX_ICM3_MISC_REG_BASE	IO_ADDRESS(SPEAR6XX_ICM3_MISC_REG_BASE)
+#define SPEAR6XX_ICM3_MISC_REG_SIZE	0x00080000
+
+/* ICM4 - High Speed Connection */
+#define SPEAR6XX_ICM4_BASE		0xE0000000
+#define SPEAR6XX_ICM4_SIZE		0x08000000
+
+#define SPEAR6XX_ICM4_GMAC_BASE		0xE0800000
+#define SPEAR6XX_ICM4_GMAC_SIZE		0x00800000
+
+#define SPEAR6XX_ICM4_USBD_FIFO_BASE	0xE1000000
+#define SPEAR6XX_ICM4_USBD_FIFO_SIZE	0x00100000
+
+#define SPEAR6XX_ICM4__USBD_CFG_BASE	0xE1100000
+#define SPEAR6XX_ICM4_USBD_CFG_SIZE	0x00100000
+
+#define SPEAR6XX_ICM4_USBD_PLUG_BASE	0xE1200000
+#define SPEAR6XX_ICM4_USBD_PLUG_SIZE	0x00100000
+
+#define SPEAR6XX_ICM4_USB_EHCI0_BASE	0xE1800000
+#define SPEAR6XX_ICM4_USB_EHCI0_SIZE	0x00100000
+
+#define SPEAR6XX_ICM4_USB_OHCI0_BASE	0xE1900000
+#define SPEAR6XX_ICM4_USB_OHCI0_SIZE	0x00100000
+
+#define SPEAR6XX_ICM4_USB_EHCI1_BASE	0xE2000000
+#define SPEAR6XX_ICM4_USB_EHCI1_SIZE	0x00100000
+
+#define SPEAR6XX_ICM4_USB_OHCI1_BASE	0xE2100000
+#define SPEAR6XX_ICM4_USB_OHCI1_SIZE	0x00100000
+
+#define SPEAR6XX_ICM4_USB_ARB_CFG_BASE	0xE2800000
+#define SPEAR6XX_ICM4_USB_ARB_SIZE	0x00010000
+
+#endif /* __ASM_MACH_SPEAR6XX_H */
diff --git a/arch/arm/mach-spear6xx/include/mach/spear600.h b/arch/arm/mach-spear6xx/include/mach/spear600.h
new file mode 100644
index 0000000..6b62fb7
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/spear600.h
@@ -0,0 +1,21 @@
+/*
+ * arch/arm/mach-spear66xx/include/mach/spear600.h
+ *
+ * SPEAr600 Machine specific definition
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Viresh Kumar<viresh.kumar@st.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifdef	CONFIG_MACH_SPEAR600
+
+#ifndef __ASM_MACH_SPEAR600_H
+#define __ASM_MACH_SPEAR600_H
+
+#endif /* __ASM_MACH_SPEAR600_H */
+
+#endif /* CONFIG_MACH_SPEAR600 */
diff --git a/arch/arm/mach-spear6xx/include/mach/system.h b/arch/arm/mach-spear6xx/include/mach/system.h
new file mode 100644
index 0000000..8a70c46
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/system.h
@@ -0,0 +1,41 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/system.h
+ *
+ * SPEAr6xx Machine family specific architecture functions
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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
+	* This should do all the clock switching
+	* and wait for interrupt tricks
+	*/
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
+		sysctl_soft_reset(SPEAR6XX_ICM3_SYS_CTRL_BASE);
+	}
+}
+
+#endif	/* __ASM_MACH_SYSTEM_H */
diff --git a/arch/arm/mach-spear6xx/include/mach/timex.h b/arch/arm/mach-spear6xx/include/mach/timex.h
new file mode 100644
index 0000000..f02ec47
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/timex.h
@@ -0,0 +1,19 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/timex.h
+ *
+ * SPEAr6XX machine family specific timex definitions
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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
+#endif	/* __ASM_MACH_TIMEX_H */
diff --git a/arch/arm/mach-spear6xx/include/mach/uncompress.h b/arch/arm/mach-spear6xx/include/mach/uncompress.h
new file mode 100644
index 0000000..2ea6878
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/uncompress.h
@@ -0,0 +1,43 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/uncompress.h
+ *
+ * Serial port stubs for kernel decompress status messages
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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
+* This does not append a newline
+*/
+static inline void putc(int c)
+{
+	void __iomem *base = (void __iomem *)SPEAR6XX_ICM1_UART0_BASE;
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
+* nothing to do
+*/
+#define arch_decomp_setup()
+#define arch_decomp_wdog()
+
+#endif	/* __ASM_MACH_UNCOMPRESS_H */
diff --git a/arch/arm/mach-spear6xx/include/mach/vmalloc.h b/arch/arm/mach-spear6xx/include/mach/vmalloc.h
new file mode 100644
index 0000000..59f3c06
--- /dev/null
+++ b/arch/arm/mach-spear6xx/include/mach/vmalloc.h
@@ -0,0 +1,22 @@
+/*
+ * arch/arm/mach-spear6xx/include/mach/vmalloc.h
+ *
+ * Defining Vmalloc area for SPEAr6xx machine family
+ *
+ * Copyright (C) 2009 ST Microelectronics
+ * Rajeev Kumar<rajeev-dlh.kumar@st.com>
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
+#endif	/* __ASM_MACH_VMALLOC_H */
-- 
1.6.0.2

