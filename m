Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbYKYPXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbYKYPXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYKYPW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:22:57 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:35958 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYKYPWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:22:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p4u51UJK9jA4/lTWNPuigZjZps7YgPmCykWTKTl5BjsKg7CJh/bZnr/6lL58IX3t/P
         dySlVpOFAiiiTLzIx8sA1wIMKTIspwPlM4tbe7QaKFDK75UW7yvnbGT5Y8WAceBmOWWA
         zqEtM3fWbVrMXw1UP6XOHZOTwJLRKQQnhT/ik=
From: "Antonio R. Costa" <costa.antonior@gmail.com>
To: linux@maxim.org.za, nicolas.ferre@atmel.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Antonio R. Costa" <costa.antonior@gmail.com>
Subject: [PATCH 2/5] [RFC PATCH] Support for AT572D940HF-EK [RFC PATCH]
Date: Tue, 25 Nov 2008 16:22:42 +0100
Message-Id: <1227626565-25209-2-git-send-email-costa.antonior@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227626565-25209-1-git-send-email-costa.antonior@gmail.com>
References: <>
 <1227626565-25209-1-git-send-email-costa.antonior@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AT572D940HF (Diopsis) is an ARM926 + a 40-bits floating point DSP
(mAgicV)

Reference for machine type:
1783    Atmel DIOPSIS AT572D940HF EK

This RFC patch starts from v2.6.26 because we needed to
test it together with Xenomai 2.4.5.

This patch, if approved, will be rebased to the latest linux kernel.

New files in include/asm-arm/arch-at91

	include/asm-arm/arch-at91/at572d940hf.h
	include/asm-arm/arch-at91/at572d940hf_mAgicV.h
	include/asm-arm/arch-at91/at572d940hf_matrix.h

Signed-off-by: Antonio R. Costa <costa.antonior@gmail.com>
---
 include/asm-arm/arch-at91/at572d940hf.h        |  180 ++++++++++++++++++++++++
 include/asm-arm/arch-at91/at572d940hf_mAgicV.h |   34 +++++
 include/asm-arm/arch-at91/at572d940hf_matrix.h |   73 ++++++++++
 3 files changed, 287 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-arm/arch-at91/at572d940hf.h
 create mode 100644 include/asm-arm/arch-at91/at572d940hf_mAgicV.h
 create mode 100644 include/asm-arm/arch-at91/at572d940hf_matrix.h

diff --git a/include/asm-arm/arch-at91/at572d940hf.h b/include/asm-arm/arch-at91/at572d940hf.h
new file mode 100644
index 0000000..58da589
--- /dev/null
+++ b/include/asm-arm/arch-at91/at572d940hf.h
@@ -0,0 +1,180 @@
+/*
+ * include/asm-arm/arch-at91/at572d940hf.h
+ *
+ * Antonio R. Costa <costa.antonior@gmail.com>
+ * Copyright (C) 2008 Atmel
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
+ *
+ */
+
+#ifndef AT572D940HF_H
+#define AT572D940HF_H
+
+/*
+ * Peripheral identifiers/interrupts.
+ */
+#define AT91_ID_FIQ		0	/* Advanced Interrupt Controller (FIQ) */
+#define AT91_ID_SYS		1	/* System Peripherals */
+#define AT572D940HF_ID_PIOA	2	/* Parallel IO Controller A */
+#define AT572D940HF_ID_PIOB	3	/* Parallel IO Controller B */
+#define AT572D940HF_ID_PIOC	4	/* Parallel IO Controller C */
+#define AT572D940HF_ID_MACB	5	/* MACB ethernet controller */
+#define AT572D940HF_ID_US0	6	/* USART 0 */
+#define AT572D940HF_ID_US1	7	/* USART 1 */
+#define AT572D940HF_ID_US2	8	/* USART 2 */
+#define AT572D940HF_ID_MCI	9	/* Multimedia Card Interface */
+#define AT572D940HF_ID_UDP	10	/* USB Device Port */
+#define AT572D940HF_ID_TWI0	11	/* Two-Wire Interface 0 */
+#define AT572D940HF_ID_SPI0	12	/* Serial Peripheral Interface 0 */
+#define AT572D940HF_ID_SPI1	13	/* Serial Peripheral Interface 1 */
+#define AT572D940HF_ID_SSC0	14	/* Serial Synchronous Controller 0 */
+#define AT572D940HF_ID_SSC1	15	/* Serial Synchronous Controller 1 */
+#define AT572D940HF_ID_SSC2	16	/* Serial Synchronous Controller 2 */
+#define AT572D940HF_ID_TC0	17	/* Timer Counter 0 */
+#define AT572D940HF_ID_TC1	18	/* Timer Counter 1 */
+#define AT572D940HF_ID_TC2	19	/* Timer Counter 2 */
+#define AT572D940HF_ID_UHP	20	/* USB Host port */
+#define AT572D940HF_ID_SSC3	21	/* Serial Synchronous Controller 3 */
+#define AT572D940HF_ID_TWI1	22	/* Two-Wire Interface 1 */
+#define AT572D940HF_ID_CAN0	23	/* CAN Controller 0 */
+#define AT572D940HF_ID_CAN1	24	/* CAN Controller 1 */
+#define AT572D940HF_ID_MHALT	25	/* mAgicV HALT line */
+#define AT572D940HF_ID_MSIRQ1	26	/* mAgicV SIRQ1 line */
+#define AT572D940HF_ID_MEXC	27	/* mAgicV exception line */
+#define AT572D940HF_ID_MEDMA	28	/* mAgicV end of DMA line */
+#define AT572D940HF_ID_EXT_IRQ0	29	/* External Interrupt Source (IRQ0) */
+#define AT572D940HF_ID_EXT_IRQ1	30	/* External Interrupt Source (IRQ1) */
+#define AT572D940HF_ID_EXT_IRQ2	31	/* External Interrupt Source (IRQ2) */
+
+#define AT572D940HF_ID_TWI	(AT572D940HF_ID_TWI0)
+#define AT572D940HF_ID_SPI	(AT572D940HF_ID_SPI0)
+#define AT572D940HF_ID_SSC	(AT572D940HF_ID_SSC0)
+#define AT572D940HF_ID_EMAC  	(AT572D940HF_ID_MACB)
+
+
+#define AT572D940HF_PMC_PCK4		(1 << 12)		/* Programmable Clock 4 */
+
+#define AT572D940HF_PMC_PIOA	(1 << 2)
+#define AT572D940HF_PMC_PIOB 	(1 << 3)
+#define AT572D940HF_PMC_PIOC 	(1 << 4)
+#define AT572D940HF_PMC_ETH	(1 << 5)
+#define AT572D940HF_PMC_US0	(1 << 6)
+#define AT572D940HF_PMC_US1	(1 << 7)
+#define AT572D940HF_PMC_US2	(1 << 8)
+#define AT572D940HF_PMC_MCI	(1 << 9)
+#define AT572D940HF_PMC_UDP	(1 << 10)
+#define AT572D940HF_PMC_TWI0	(1 << 11)
+#define AT572D940HF_PMC_SPI0 	(1 << 12)
+#define AT572D940HF_PMC_SPI1 	(1 << 13)
+#define AT572D940HF_PMC_SSC0 	(1 << 14)
+#define AT572D940HF_PMC_SSC1 	(1 << 15)
+#define AT572D940HF_PMC_SSC2 	(1 << 16)
+#define AT572D940HF_PMC_TC0  	(1 << 17)
+#define AT572D940HF_PMC_TC1  	(1 << 18)
+#define AT572D940HF_PMC_TC2  	(1 << 19)
+#define AT572D940HF_PMC_UHP 	(1 << 20)
+#define AT572D940HF_PMC_SSC3	(1 << 21)
+#define AT572D940HF_PMC_TWI1	(1 << 22)
+#define AT572D940HF_PMC_CAN0	(1 << 23)
+#define AT572D940HF_PMC_CAN1	(1 << 24)
+#define AT572D940HF_PMC_DSP  	(1 << 26)
+#define AT572D940HF_PMC_MAGIC	(1 << 26)
+
+
+/*
+ * User Peripheral physical base addresses.
+ */
+#define AT572D940HF_BASE_TCB0	0xfffa0000
+#define AT572D940HF_BASE_TC0	0xfffa0000
+#define AT572D940HF_BASE_TC1	0xfffa0040
+#define AT572D940HF_BASE_TC2	0xfffa0080
+#define AT572D940HF_BASE_UDP	0xfffa4000
+#define AT572D940HF_BASE_MCI	0xfffa8000
+#define AT572D940HF_BASE_TWI0	0xfffac000
+#define AT572D940HF_BASE_US0	0xfffb0000
+#define AT572D940HF_BASE_US1	0xfffb4000
+#define AT572D940HF_BASE_US2	0xfffb8000
+#define AT572D940HF_BASE_SSC0	0xfffbc000
+#define AT572D940HF_BASE_SSC1	0xfffc0000
+#define AT572D940HF_BASE_SSC2	0xfffc4000
+#define AT572D940HF_BASE_SPI0	0xfffc8000
+#define AT572D940HF_BASE_SPI1	0xfffcc000
+#define AT572D940HF_BASE_SSC3	0xfffd0000
+#define AT572D940HF_BASE_TWI1	0xfffd4000
+#define AT572D940HF_BASE_MACB	0xfffd8000
+#define AT572D940HF_BASE_CAN0	0xfffdc000
+#define AT572D940HF_BASE_CAN1	0xfffe0000
+
+#define AT572D940HF_BASE_TWI   	(AT572D940HF_BASE_TWI0)
+#define AT572D940HF_BASE_SSC   	(AT572D940HF_BASE_SSC0)
+#define AT572D940HF_BASE_SPI   	(AT572D940HF_BASE_SPI0)
+
+#define AT572D940HF_BASE_SYS   	0xffffea00
+#define AT91_BASE_SYS	    	(AT572D940HF_BASE_SYS)
+
+
+/*
+ * System Peripherals (offset from AT91_BASE_SYS)
+ */
+#define AT572D940HF_SDRAMC	(0xffffea00 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_SMC		(0xffffec00 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_MATRIX	(0xffffee00 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_AIC		(0xfffff000 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_DBGU	(0xfffff200 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_PIOA	(0xfffff400 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_PIOB	(0xfffff600 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_PIOC	(0xfffff800 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_PMC		(0xfffffc00 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_RSTC	(0xfffffd00 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_SHDWC	(0xfffffd10 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_RTT		(0xfffffd20 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_PIT		(0xfffffd30 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_WDT		(0xfffffd40 - AT572D940HF_BASE_SYS)
+#define AT572D940HF_GPBR	(0xfffffd50 - AT572D940HF_BASE_SYS)
+
+
+#define AT91_SDRAMC	(AT572D940HF_SDRAMC)
+#define AT91_SMC	(AT572D940HF_SMC)
+#define AT91_MATRIX	(AT572D940HF_MATRIX)
+#define AT91_AIC	(AT572D940HF_AIC)
+#define AT91_DBGU	(AT572D940HF_DBGU)
+#define AT91_PIOA	(AT572D940HF_PIOA)
+#define AT91_PIOB	(AT572D940HF_PIOB)
+#define AT91_PIOC	(AT572D940HF_PIOC)
+#define AT91_PMC	(AT572D940HF_PMC)
+#define AT91_RSTC	(AT572D940HF_RSTC)
+#define AT91_SHDWC	(AT572D940HF_SHDWC)
+#define AT91_RTT	(AT572D940HF_RTT)
+#define AT91_PIT	(AT572D940HF_PIT)
+#define AT91_WDT	(AT572D940HF_WDT)
+#define AT91_GPBR	(AT572D940HF_GPBR)
+
+
+
+
+/*
+ * Internal Memory.
+ */
+#define AT572D940HF_SRAM_BASE	0x00300000	/* Internal SRAM base address */
+#define AT572D940HF_SRAM_SIZE	0x000c0000 	/* Internal SRAM size (48Kb) */
+
+#define AT572D940HF_ROM_BASE	0x00400000	/* Internal ROM base address */
+#define AT572D940HF_ROM_SIZE	0x00008000	/* Internal ROM size (32Kb) */
+
+#define AT572D940HF_UHP_BASE	0x00500000	/* USB Host controller */
+
+
+#endif
diff --git a/include/asm-arm/arch-at91/at572d940hf_mAgicV.h b/include/asm-arm/arch-at91/at572d940hf_mAgicV.h
new file mode 100644
index 0000000..4e6bdad
--- /dev/null
+++ b/include/asm-arm/arch-at91/at572d940hf_mAgicV.h
@@ -0,0 +1,34 @@
+/* mAgicV definitions */
+
+#ifndef __AT572D940HF_MAGIC_H_
+#define __AT572D940HF_MAGIC_H_
+
+#define AT572D940HF_MAGIC_BASE 0x00600000
+#define AT572D940HF_MAGIC_SIZE 0x81000
+
+#define AT572D940HF_MAGIC_PM_BASE 0x00600000
+#define AT572D940HF_MAGIC_PM_SIZE 0x20000
+
+#define AT572D940HF_MAGIC_DM_I_BASE 0x00620000
+#define AT572D940HF_MAGIC_DM_I_SIZE 0x10000
+
+#define AT572D940HF_MAGIC_DM_F_BASE 0x00640000
+#define AT572D940HF_MAGIC_DM_F_SIZE 0x10000
+
+#define AT572D940HF_MAGIC_DM_DB_BASE 0x00660000
+#define AT572D940HF_MAGIC_DM_DB_SIZE 0x20000
+
+#define AT572D940HF_MAGIC_REGS_BASE 0x00680000
+#define AT572D940HF_MAGIC_REGS_SIZE 0x1000
+
+#define AT572D940HF_MAGIC_EXTPAGE_BASE 0x23000000
+#define AT572D940HF_MAGIC_EXTPAGE_SIZE 0x1000000
+
+#define AT572D940HF_MAGIC_MSIRQ0 0
+#define AT572D940HF_MAGIC_MSIRQ1 26
+#define AT572D940HF_MAGIC_MHLT 25
+#define AT572D940HF_MAGIC_MEXC 27
+#define AT572D940HF_MAGIC_MEDMA 28
+
+
+#endif
diff --git a/include/asm-arm/arch-at91/at572d940hf_matrix.h b/include/asm-arm/arch-at91/at572d940hf_matrix.h
new file mode 100644
index 0000000..239f499
--- /dev/null
+++ b/include/asm-arm/arch-at91/at572d940hf_matrix.h
@@ -0,0 +1,73 @@
+/*
+ * include/asm-arm/arch-at91/at572d940hf_matrix.h
+ *
+ * Antonio R. Costa <costa.antonior@gmail.com>
+ * Copyright (C) 2008 Atmel
+ *
+ * Copyright (C) 2005 SAN People
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
+#ifndef AT572D940HF_MATRIX_H
+#define AT572D940HF_MATRIX_H
+
+#define AT572D940HF_MATRIX_MCFG	(AT572D940HF_MATRIX + 0x00)	/* Master Configuration Register */
+#define	AT572D940HF_MATRIX_RCB0	(1 << 0)		/* Remap Command for AHB Master 0 (ARM926EJ-S Instruction Master) */
+#define	AT572D940HF_MATRIX_RCB1	(1 << 1)		/* Remap Command for AHB Master 1 (ARM926EJ-S Data Master) */
+
+#define AT572D940HF_MATRIX_SCFG0	(AT572D940HF_MATRIX + 0x04)	/* Slave Configuration Register 0 */
+#define AT572D940HF_MATRIX_SCFG1	(AT572D940HF_MATRIX + 0x08)	/* Slave Configuration Register 1 */
+#define AT572D940HF_MATRIX_SCFG2	(AT572D940HF_MATRIX + 0x0C)	/* Slave Configuration Register 2 */
+#define AT572D940HF_MATRIX_SCFG3	(AT572D940HF_MATRIX + 0x10)	/* Slave Configuration Register 3 */
+#define AT572D940HF_MATRIX_SCFG4	(AT572D940HF_MATRIX + 0x14)	/* Slave Configuration Register 4 */
+#define	AT572D940HF_MATRIX_SLOT_CYCLE		(0xff << 0)	/* Maximum Number of Allowed Cycles for a Burst */
+#define	AT572D940HF_MATRIX_DEFMSTR_TYPE		(3 << 16)	/* Default Master Type */
+#define	AT572D940HF_MATRIX_DEFMSTR_TYPE_NONE	(0 << 16)
+#define	AT572D940HF_MATRIX_DEFMSTR_TYPE_LAST	(1 << 16)
+#define	AT572D940HF_MATRIX_DEFMSTR_TYPE_FIXED	(2 << 16)
+#define	AT572D940HF_MATRIX_FIXED_DEFMSTR	(7 << 18)	/* Fixed Index of Default Master */
+
+#define AT572D940HF_MATRIX_TCR		(AT572D940HF_MATRIX + 0x24)	/* TCM Configuration Register */
+#define	AT572D940HF_MATRIX_ITCM_SIZE	(0xf << 0)	/* Size of ITCM enabled memory block */
+#define	AT572D940HF_MATRIX_ITCM_0	(0 << 0)
+#define	AT572D940HF_MATRIX_ITCM_16	(5 << 0)
+#define	AT572D940HF_MATRIX_ITCM_32	(6 << 0)
+#define	AT572D940HF_MATRIX_ITCM_64	(7 << 0)
+#define	AT572D940HF_MATRIX_DTCM_SIZE	(0xf << 4)	/* Size of DTCM enabled memory block */
+#define	AT572D940HF_MATRIX_DTCM_0	(0 << 4)
+#define	AT572D940HF_MATRIX_DTCM_16	(5 << 4)
+#define	AT572D940HF_MATRIX_DTCM_32	(6 << 4)
+#define	AT572D940HF_MATRIX_DTCM_64	(7 << 4)
+
+#define AT572D940HF_MATRIX_EBICSA	(	AT572D940HF_MATRIX + 0x30)	/* EBI Chip Select Assignment Register */
+#define	AT572D940HF_MATRIX_CS1A			(1 << 1)	/* Chip Select 1 Assignment */
+#define	AT572D940HF_MATRIX_CS1A_SMC		(0 << 1)
+#define	AT572D940HF_MATRIX_CS1A_SDRAMC		(1 << 1)
+#define	AT572D940HF_MATRIX_CS3A			(1 << 3)	/* Chip Select 3 Assignment */
+#define	AT572D940HF_MATRIX_CS3A_SMC		(0 << 3)
+#define	AT572D940HF_MATRIX_CS3A_SMC_SMARTMEDIA	(1 << 3)
+#define	AT572D940HF_MATRIX_CS4A			(1 << 4)	/* Chip Select 4 Assignment */
+#define	AT572D940HF_MATRIX_CS4A_SMC		(0 << 4)
+#define	AT572D940HF_MATRIX_CS4A_SMC_CF1		(1 << 4)
+#define	AT572D940HF_MATRIX_CS5A			(1 << 5)	/* Chip Select 5 Assignment */
+#define	AT572D940HF_MATRIX_CS5A_SMC		(0 << 5)
+#define	AT572D940HF_MATRIX_CS5A_SMC_CF2		(1 << 5)
+#define	AT572D940HF_MATRIX_DBPUC		(1 << 8)	/* Data Bus Pull-up Configuration */
+
+#define AT572D940HF_MATRIX_USBPUCR	(AT572D940HF_MATRIX + 0x34)	/* USB Pad Pull-Up Control Register */
+#define	AT572D940HF_MATRIX_USBPUCR_PUON	(1 << 30)	/* USB Device PAD Pull-up Enable */
+
+#endif
-- 
1.5.4.3

