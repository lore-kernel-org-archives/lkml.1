Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbZCRUgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbZCRUgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbZCRUb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:31:58 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56231 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753555AbZCRUbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:44 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 13/57] microblaze_v7: PVR support, cpuinfo support
Date: Wed, 18 Mar 2009 21:30:40 +0100
Message-Id: <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/pvr.h |  209 +++++++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/cpu/mb.c   |  148 ++++++++++++++++++++++++++
 arch/microblaze/kernel/cpu/pvr.c  |   81 ++++++++++++++
 3 files changed, 438 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/pvr.h
 create mode 100644 arch/microblaze/kernel/cpu/mb.c
 create mode 100644 arch/microblaze/kernel/cpu/pvr.c

diff --git a/arch/microblaze/include/asm/pvr.h b/arch/microblaze/include/asm/pvr.h
new file mode 100644
index 0000000..66f1b30
--- /dev/null
+++ b/arch/microblaze/include/asm/pvr.h
@@ -0,0 +1,209 @@
+/*
+ * Support for the MicroBlaze PVR (Processor Version Register)
+ *
+ * Copyright (C) 2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2007 - 2009 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_PVR_H
+#define _ASM_MICROBLAZE_PVR_H
+
+#define PVR_MSR_BIT 0x400
+
+struct pvr_s {
+	unsigned pvr[16];
+};
+
+/* The following taken from Xilinx's standalone BSP pvr.h */
+
+/* Basic PVR mask */
+#define PVR0_PVR_FULL_MASK		0x80000000
+#define PVR0_USE_BARREL_MASK		0x40000000
+#define PVR0_USE_DIV_MASK		0x20000000
+#define PVR0_USE_HW_MUL_MASK		0x10000000
+#define PVR0_USE_FPU_MASK		0x08000000
+#define PVR0_USE_EXC_MASK		0x04000000
+#define PVR0_USE_ICACHE_MASK		0x02000000
+#define PVR0_USE_DCACHE_MASK		0x01000000
+#define PVR0_USE_MMU			0x00800000	/* new */
+#define PVR0_VERSION_MASK		0x0000FF00
+#define PVR0_USER1_MASK			0x000000FF
+
+/* User 2 PVR mask */
+#define PVR1_USER2_MASK			0xFFFFFFFF
+
+/* Configuration PVR masks */
+#define PVR2_D_OPB_MASK			0x80000000
+#define PVR2_D_LMB_MASK			0x40000000
+#define PVR2_I_OPB_MASK			0x20000000
+#define PVR2_I_LMB_MASK			0x10000000
+#define PVR2_INTERRUPT_IS_EDGE_MASK	0x08000000
+#define PVR2_EDGE_IS_POSITIVE_MASK	0x04000000
+#define PVR2_D_PLB_MASK			0x02000000	/* new */
+#define PVR2_I_PLB_MASK			0x01000000	/* new */
+#define PVR2_INTERCONNECT		0x00800000	/* new */
+#define PVR2_USE_EXTEND_FSL		0x00080000	/* new */
+#define PVR2_USE_FSL_EXC		0x00040000	/* new */
+#define PVR2_USE_MSR_INSTR		0x00020000
+#define PVR2_USE_PCMP_INSTR		0x00010000
+#define PVR2_AREA_OPTIMISED		0x00008000
+#define PVR2_USE_BARREL_MASK		0x00004000
+#define PVR2_USE_DIV_MASK		0x00002000
+#define PVR2_USE_HW_MUL_MASK		0x00001000
+#define PVR2_USE_FPU_MASK		0x00000800
+#define PVR2_USE_MUL64_MASK		0x00000400
+#define PVR2_USE_FPU2_MASK		0x00000200	/* new */
+#define PVR2_USE_IPLBEXC 		0x00000100
+#define PVR2_USE_DPLBEXC		0x00000080
+#define PVR2_OPCODE_0x0_ILL_MASK	0x00000040
+#define PVR2_UNALIGNED_EXC_MASK		0x00000020
+#define PVR2_ILL_OPCODE_EXC_MASK	0x00000010
+#define PVR2_IOPB_BUS_EXC_MASK		0x00000008
+#define PVR2_DOPB_BUS_EXC_MASK		0x00000004
+#define PVR2_DIV_ZERO_EXC_MASK		0x00000002
+#define PVR2_FPU_EXC_MASK		0x00000001
+
+/* Debug and exception PVR masks */
+#define PVR3_DEBUG_ENABLED_MASK		0x80000000
+#define PVR3_NUMBER_OF_PC_BRK_MASK	0x1E000000
+#define PVR3_NUMBER_OF_RD_ADDR_BRK_MASK	0x00380000
+#define PVR3_NUMBER_OF_WR_ADDR_BRK_MASK	0x0000E000
+#define PVR3_FSL_LINKS_MASK		0x00000380
+
+/* ICache config PVR masks */
+#define PVR4_USE_ICACHE_MASK		0x80000000
+#define PVR4_ICACHE_ADDR_TAG_BITS_MASK	0x7C000000
+#define PVR4_ICACHE_USE_FSL_MASK	0x02000000
+#define PVR4_ICACHE_ALLOW_WR_MASK	0x01000000
+#define PVR4_ICACHE_LINE_LEN_MASK	0x00E00000
+#define PVR4_ICACHE_BYTE_SIZE_MASK	0x001F0000
+
+/* DCache config PVR masks */
+#define PVR5_USE_DCACHE_MASK		0x80000000
+#define PVR5_DCACHE_ADDR_TAG_BITS_MASK	0x7C000000
+#define PVR5_DCACHE_USE_FSL_MASK	0x02000000
+#define PVR5_DCACHE_ALLOW_WR_MASK	0x01000000
+#define PVR5_DCACHE_LINE_LEN_MASK	0x00E00000
+#define PVR5_DCACHE_BYTE_SIZE_MASK	0x001F0000
+
+/* ICache base address PVR mask */
+#define PVR6_ICACHE_BASEADDR_MASK	0xFFFFFFFF
+
+/* ICache high address PVR mask */
+#define PVR7_ICACHE_HIGHADDR_MASK	0xFFFFFFFF
+
+/* DCache base address PVR mask */
+#define PVR8_DCACHE_BASEADDR_MASK	0xFFFFFFFF
+
+/* DCache high address PVR mask */
+#define PVR9_DCACHE_HIGHADDR_MASK	0xFFFFFFFF
+
+/* Target family PVR mask */
+#define PVR10_TARGET_FAMILY_MASK	0xFF000000
+
+/* MMU descrtiption */
+#define PVR11_USE_MMU			0xC0000000
+#define PVR11_MMU_ITLB_SIZE		0x38000000
+#define PVR11_MMU_DTLB_SIZE		0x07000000
+#define PVR11_MMU_TLB_ACCESS		0x00C00000
+#define PVR11_MMU_ZONES			0x003C0000
+/* MSR Reset value PVR mask */
+#define PVR11_MSR_RESET_VALUE_MASK	0x000007FF
+
+
+/* PVR access macros */
+#define PVR_IS_FULL(pvr)		(pvr.pvr[0] & PVR0_PVR_FULL_MASK)
+#define PVR_USE_BARREL(pvr)		(pvr.pvr[0] & PVR0_USE_BARREL_MASK)
+#define PVR_USE_DIV(pvr)		(pvr.pvr[0] & PVR0_USE_DIV_MASK)
+#define PVR_USE_HW_MUL(pvr)		(pvr.pvr[0] & PVR0_USE_HW_MUL_MASK)
+#define PVR_USE_FPU(pvr)		(pvr.pvr[0] & PVR0_USE_FPU_MASK)
+#define PVR_USE_FPU2(pvr)		(pvr.pvr[2] & PVR2_USE_FPU2_MASK)
+#define PVR_USE_ICACHE(pvr)		(pvr.pvr[0] & PVR0_USE_ICACHE_MASK)
+#define PVR_USE_DCACHE(pvr)		(pvr.pvr[0] & PVR0_USE_DCACHE_MASK)
+#define PVR_VERSION(pvr)	((pvr.pvr[0] & PVR0_VERSION_MASK) >> 8)
+#define PVR_USER1(pvr)			(pvr.pvr[0] & PVR0_USER1_MASK)
+#define PVR_USER2(pvr)			(pvr.pvr[1] & PVR1_USER2_MASK)
+
+#define PVR_D_OPB(pvr)			(pvr.pvr[2] & PVR2_D_OPB_MASK)
+#define PVR_D_LMB(pvr)			(pvr.pvr[2] & PVR2_D_LMB_MASK)
+#define PVR_I_OPB(pvr)			(pvr.pvr[2] & PVR2_I_OPB_MASK)
+#define PVR_I_LMB(pvr)			(pvr.pvr[2] & PVR2_I_LMB_MASK)
+#define PVR_INTERRUPT_IS_EDGE(pvr) \
+			(pvr.pvr[2] & PVR2_INTERRUPT_IS_EDGE_MASK)
+#define PVR_EDGE_IS_POSITIVE(pvr) \
+			(pvr.pvr[2] & PVR2_EDGE_IS_POSITIVE_MASK)
+#define PVR_USE_MSR_INSTR(pvr)		(pvr.pvr[2] & PVR2_USE_MSR_INSTR)
+#define PVR_USE_PCMP_INSTR(pvr)		(pvr.pvr[2] & PVR2_USE_PCMP_INSTR)
+#define PVR_AREA_OPTIMISED(pvr)		(pvr.pvr[2] & PVR2_AREA_OPTIMISED)
+#define PVR_USE_MUL64(pvr)		(pvr.pvr[2] & PVR2_USE_MUL64_MASK)
+#define PVR_OPCODE_0x0_ILLEGAL(pvr) \
+			(pvr.pvr[2] & PVR2_OPCODE_0x0_ILL_MASK)
+#define PVR_UNALIGNED_EXCEPTION(pvr) \
+			(pvr.pvr[2] & PVR2_UNALIGNED_EXC_MASK)
+#define PVR_ILL_OPCODE_EXCEPTION(pvr) \
+			(pvr.pvr[2] & PVR2_ILL_OPCODE_EXC_MASK)
+#define PVR_IOPB_BUS_EXCEPTION(pvr) \
+			(pvr.pvr[2] & PVR2_IOPB_BUS_EXC_MASK)
+#define PVR_DOPB_BUS_EXCEPTION(pvr) \
+			(pvr.pvr[2] & PVR2_DOPB_BUS_EXC_MASK)
+#define PVR_DIV_ZERO_EXCEPTION(pvr) \
+			(pvr.pvr[2] & PVR2_DIV_ZERO_EXC_MASK)
+#define PVR_FPU_EXCEPTION(pvr)		(pvr.pvr[2] & PVR2_FPU_EXC_MASK)
+#define PVR_FSL_EXCEPTION(pvr)		(pvr.pvr[2] & PVR2_USE_EXTEND_FSL)
+
+#define PVR_DEBUG_ENABLED(pvr)		(pvr.pvr[3] & PVR3_DEBUG_ENABLED_MASK)
+#define PVR_NUMBER_OF_PC_BRK(pvr) \
+			((pvr.pvr[3] & PVR3_NUMBER_OF_PC_BRK_MASK) >> 25)
+#define PVR_NUMBER_OF_RD_ADDR_BRK(pvr) \
+			((pvr.pvr[3] & PVR3_NUMBER_OF_RD_ADDR_BRK_MASK) >> 19)
+#define PVR_NUMBER_OF_WR_ADDR_BRK(pvr) \
+			((pvr.pvr[3] & PVR3_NUMBER_OF_WR_ADDR_BRK_MASK) >> 13)
+#define PVR_FSL_LINKS(pvr)	((pvr.pvr[3] & PVR3_FSL_LINKS_MASK) >> 7)
+
+#define PVR_ICACHE_ADDR_TAG_BITS(pvr) \
+			((pvr.pvr[4] & PVR4_ICACHE_ADDR_TAG_BITS_MASK) >> 26)
+#define PVR_ICACHE_USE_FSL(pvr)		(pvr.pvr[4] & PVR4_ICACHE_USE_FSL_MASK)
+#define PVR_ICACHE_ALLOW_WR(pvr)	(pvr.pvr[4] & PVR4_ICACHE_ALLOW_WR_MASK)
+#define PVR_ICACHE_LINE_LEN(pvr) \
+			(1 << ((pvr.pvr[4] & PVR4_ICACHE_LINE_LEN_MASK) >> 21))
+#define PVR_ICACHE_BYTE_SIZE(pvr) \
+			(1 << ((pvr.pvr[4] & PVR4_ICACHE_BYTE_SIZE_MASK) >> 16))
+
+#define PVR_DCACHE_ADDR_TAG_BITS(pvr) \
+			((pvr.pvr[5] & PVR5_DCACHE_ADDR_TAG_BITS_MASK) >> 26)
+#define PVR_DCACHE_USE_FSL(pvr)		(pvr.pvr[5] & PVR5_DCACHE_USE_FSL_MASK)
+#define PVR_DCACHE_ALLOW_WR(pvr)	(pvr.pvr[5] & PVR5_DCACHE_ALLOW_WR_MASK)
+#define PVR_DCACHE_LINE_LEN(pvr) \
+			(1 << ((pvr.pvr[5] & PVR5_DCACHE_LINE_LEN_MASK) >> 21))
+#define PVR_DCACHE_BYTE_SIZE(pvr) \
+			(1 << ((pvr.pvr[5] & PVR5_DCACHE_BYTE_SIZE_MASK) >> 16))
+
+
+#define PVR_ICACHE_BASEADDR(pvr)	(pvr.pvr[6] & PVR6_ICACHE_BASEADDR_MASK)
+#define PVR_ICACHE_HIGHADDR(pvr)	(pvr.pvr[7] & PVR7_ICACHE_HIGHADDR_MASK)
+
+#define PVR_DCACHE_BASEADDR(pvr)	(pvr.pvr[8] & PVR8_DCACHE_BASEADDR_MASK)
+#define PVR_DCACHE_HIGHADDR(pvr)	(pvr.pvr[9] & PVR9_DCACHE_HIGHADDR_MASK)
+
+#define PVR_TARGET_FAMILY(pvr)	((pvr.pvr[10] & PVR10_TARGET_FAMILY_MASK) >> 24)
+
+#define PVR_MSR_RESET_VALUE(pvr) \
+				(pvr.pvr[11] & PVR11_MSR_RESET_VALUE_MASK)
+
+/* mmu */
+#define PVR_USE_MMU(pvr)	((pvr.pvr[11] & PVR11_USE_MMU) >> 30)
+#define PVR_MMU_ITLB_SIZE(pvr)	(pvr.pvr[11] & PVR11_MMU_ITLB_SIZE)
+#define PVR_MMU_DTLB_SIZE(pvr)	(pvr.pvr[11] & PVR11_MMU_DTLB_SIZE)
+#define PVR_MMU_TLB_ACCESS(pvr)	(pvr.pvr[11] & PVR11_MMU_TLB_ACCESS)
+#define PVR_MMU_ZONES(pvr)	(pvr.pvr[11] & PVR11_MMU_ZONES)
+
+
+int cpu_has_pvr(void);
+void get_pvr(struct pvr_s *pvr);
+
+#endif /* _ASM_MICROBLAZE_PVR_H */
diff --git a/arch/microblaze/kernel/cpu/mb.c b/arch/microblaze/kernel/cpu/mb.c
new file mode 100644
index 0000000..8c1b7ad
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/mb.c
@@ -0,0 +1,148 @@
+/*
+ * CPU-version specific code
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/seq_file.h>
+#include <linux/cpu.h>
+#include <linux/initrd.h>
+
+#include <linux/bug.h>
+#include <asm/cpuinfo.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <asm/page.h>
+#include <linux/param.h>
+#include <asm/pvr.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	int count = 0;
+	char *fpga_family = "Unknown";
+	char *cpu_ver = "Unknown";
+	int i;
+
+	/* Denormalised to get the fpga family string */
+	for (i = 0; family_string_lookup[i].s != NULL; i++) {
+		if (cpuinfo.fpga_family_code == family_string_lookup[i].k) {
+			fpga_family = (char *)family_string_lookup[i].s;
+			break;
+		}
+	}
+
+	/* Denormalised to get the hw version string */
+	for (i = 0; cpu_ver_lookup[i].s != NULL; i++) {
+		if (cpuinfo.ver_code == cpu_ver_lookup[i].k) {
+			cpu_ver = (char *)cpu_ver_lookup[i].s;
+			break;
+		}
+	}
+
+	count = seq_printf(m,
+			"CPU-Family:	MicroBlaze\n"
+			"FPGA-Arch:	%s\n"
+			"CPU-Ver:	%s\n"
+			"CPU-MHz:	%d.%02d\n"
+			"BogoMips:	%lu.%02lu\n",
+			fpga_family,
+			cpu_ver,
+			cpuinfo.cpu_clock_freq /
+			1000000,
+			cpuinfo.cpu_clock_freq %
+			1000000,
+			loops_per_jiffy / (500000 / HZ),
+			(loops_per_jiffy / (5000 / HZ)) % 100);
+
+	count += seq_printf(m,
+		"HW:\n Shift:\t\t%s\n"
+		" MSR:\t\t%s\n"
+		" PCMP:\t\t%s\n"
+		" DIV:\t\t%s\n",
+		(cpuinfo.use_instr & PVR0_USE_BARREL_MASK) ? "yes" : "no",
+		(cpuinfo.use_instr & PVR2_USE_MSR_INSTR) ? "yes" : "no",
+		(cpuinfo.use_instr & PVR2_USE_PCMP_INSTR) ? "yes" : "no",
+		(cpuinfo.use_instr & PVR0_USE_DIV_MASK) ? "yes" : "no");
+
+	count += seq_printf(m,
+			" MMU:\t\t%x\n",
+			cpuinfo.mmu);
+
+	count += seq_printf(m,
+		" MUL:\t\t%s\n"
+		" FPU:\t\t%s\n",
+		(cpuinfo.use_mult & PVR2_USE_MUL64_MASK) ? "v2" :
+			(cpuinfo.use_mult & PVR0_USE_HW_MUL_MASK) ? "v1" : "no",
+		(cpuinfo.use_fpu & PVR2_USE_FPU2_MASK) ? "v2" :
+			(cpuinfo.use_fpu & PVR0_USE_FPU_MASK) ? "v1" : "no");
+
+	count += seq_printf(m,
+		" Exc:\t\t%s%s%s%s%s%s%s%s\n",
+		(cpuinfo.use_exc & PVR2_OPCODE_0x0_ILL_MASK) ? "op0x0 " : "",
+		(cpuinfo.use_exc & PVR2_UNALIGNED_EXC_MASK) ? "unal " : "",
+		(cpuinfo.use_exc & PVR2_ILL_OPCODE_EXC_MASK) ? "ill " : "",
+		(cpuinfo.use_exc & PVR2_IOPB_BUS_EXC_MASK) ? "iopb " : "",
+		(cpuinfo.use_exc & PVR2_DOPB_BUS_EXC_MASK) ? "dopb " : "",
+		(cpuinfo.use_exc & PVR2_DIV_ZERO_EXC_MASK) ? "zero " : "",
+		(cpuinfo.use_exc & PVR2_FPU_EXC_MASK) ? "fpu " : "",
+		(cpuinfo.use_exc & PVR2_USE_FSL_EXC) ? "fsl " : "");
+
+	if (cpuinfo.use_icache)
+		count += seq_printf(m,
+				"Icache:\t\t%ukB\n",
+				cpuinfo.icache_size >> 10);
+	else
+		count += seq_printf(m, "Icache:\t\tno\n");
+
+	if (cpuinfo.use_dcache)
+		count += seq_printf(m,
+				"Dcache:\t\t%ukB\n",
+				cpuinfo.dcache_size >> 10);
+	else
+		count += seq_printf(m, "Dcache:\t\tno\n");
+
+	count += seq_printf(m,
+			"HW-Debug:\t%s\n",
+			cpuinfo.hw_debug ? "yes" : "no");
+
+	count += seq_printf(m,
+			"PVR-USR1:\t%x\n"
+			"PVR-USR2:\t%x\n",
+			cpuinfo.pvr_user1,
+			cpuinfo.pvr_user2);
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	int i = *pos;
+
+	return i < NR_CPUS ? (void *) (i + 1) : NULL;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return c_start(m, pos);
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+const struct seq_operations cpuinfo_op = {
+	.start = c_start,
+	.next = c_next,
+	.stop = c_stop,
+	.show = show_cpuinfo,
+};
diff --git a/arch/microblaze/kernel/cpu/pvr.c b/arch/microblaze/kernel/cpu/pvr.c
new file mode 100644
index 0000000..88b3ad7
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/pvr.c
@@ -0,0 +1,81 @@
+/*
+ * Support for MicroBlaze PVR (processor version register)
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <asm/system.h>
+#include <asm/exceptions.h>
+#include <asm/pvr.h>
+
+/*
+ * Until we get an assembler that knows about the pvr registers,
+ * this horrible cruft will have to do.
+ * That hardcoded opcode is mfs r3, rpvrNN
+ */
+
+#define get_single_pvr(pvrid, val)				\
+{								\
+	register unsigned tmp __asm__("r3");			\
+	tmp = 0x0;	/* Prevent warning about unused */	\
+	__asm__ __volatile__ (					\
+			".byte 0x94,0x60,0xa0, " #pvrid "\n\t"	\
+			: "=r" (tmp) : : "memory"); 		\
+	val = tmp;						\
+}
+
+/*
+ * Does the CPU support the PVR register?
+ * return value:
+ * 0: no PVR
+ * 1: simple PVR
+ * 2: full PVR
+ *
+ * This must work on all CPU versions, including those before the
+ * PVR was even an option.
+ */
+
+int cpu_has_pvr(void)
+{
+	unsigned flags;
+	unsigned pvr0;
+
+	local_save_flags(flags);
+
+	/* PVR bit in MSR tells us if there is any support */
+	if (!(flags & PVR_MSR_BIT))
+		return 0;
+
+	get_single_pvr(0x00, pvr0);
+	pr_debug("%s: pvr0 is 0x%08x\n", __func__, pvr0);
+
+	if (pvr0 & PVR0_PVR_FULL_MASK)
+		return 1;
+
+	/* for partial PVR use static cpuinfo */
+	return 2;
+}
+
+void get_pvr(struct pvr_s *p)
+{
+	get_single_pvr(0, p->pvr[0]);
+	get_single_pvr(1, p->pvr[1]);
+	get_single_pvr(2, p->pvr[2]);
+	get_single_pvr(3, p->pvr[3]);
+	get_single_pvr(4, p->pvr[4]);
+	get_single_pvr(5, p->pvr[5]);
+	get_single_pvr(6, p->pvr[6]);
+	get_single_pvr(7, p->pvr[7]);
+	get_single_pvr(8, p->pvr[8]);
+	get_single_pvr(9, p->pvr[9]);
+	get_single_pvr(10, p->pvr[10]);
+	get_single_pvr(11, p->pvr[11]);
+}
-- 
1.5.5.1

