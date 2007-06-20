Return-Path: <linux-kernel-owner+w=401wt.eu-S1763829AbXFTSqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763829AbXFTSqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762533AbXFTSlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:41:47 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:27127 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762287AbXFTSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:41:45 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 20:41:31 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 3/8] 2.6.22-rc3 perfmon2 : Minor changes
Message-ID: <20070620184131.GD5874@erda.amd.com>
References: <20070620182126.248753000@amd.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jun 2007 18:41:31.0237 (UTC)
 FILETIME=[9E9D6950:01C7B36A]
X-WSS-ID: 6A67AB541S4957721-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=perfmon2-fam10h-003.diff
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Minor changes (whitespace, comments, ...)

Signed-off-by: Robert Richter <robert.richter@amd.com>

Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
+++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
@@ -1,5 +1,5 @@
 /*
- * This file contains the PMU description for the Ahtlon64 and Opteron64
+ * This file contains the PMU description for the Athlon64 and Opteron64
  * processors. It supports 32 and 64-bit modes.
  *
  * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
@@ -32,23 +32,29 @@ static int force_nmi;
 MODULE_PARM_DESC(force_nmi, "bool: force use of NMI for PMU interrupt");
 module_param(force_nmi, bool, 0600);
 
-static struct pfm_arch_pmu_info pfm_k8_pmu_info={
+static struct pfm_arch_pmu_info pfm_k8_pmu_info = {
 	.pmc_addrs = {
-		{{MSR_K7_EVNTSEL0, 0}, 0, PFM_REGT_EN},
-		{{MSR_K7_EVNTSEL1, 0}, 1, PFM_REGT_EN},
-		{{MSR_K7_EVNTSEL2, 0}, 2, PFM_REGT_EN},
-		{{MSR_K7_EVNTSEL3, 0}, 3, PFM_REGT_EN},
+/* pmc0  */	{{MSR_K7_EVNTSEL0, 0}, 0, PFM_REGT_EN},
+/* pmc1  */	{{MSR_K7_EVNTSEL1, 0}, 1, PFM_REGT_EN},
+/* pmc2  */	{{MSR_K7_EVNTSEL2, 0}, 2, PFM_REGT_EN},
+/* pmc3  */	{{MSR_K7_EVNTSEL3, 0}, 3, PFM_REGT_EN},
 	},
 	.pmd_addrs = {
-		{{MSR_K7_PERFCTR0, 0}, 0, PFM_REGT_CTR},
-		{{MSR_K7_PERFCTR1, 0}, 0, PFM_REGT_CTR},
-		{{MSR_K7_PERFCTR2, 0}, 0, PFM_REGT_CTR},
-		{{MSR_K7_PERFCTR3, 0}, 0, PFM_REGT_CTR},
+/* pmd0  */	{{MSR_K7_PERFCTR0, 0}, 0, PFM_REGT_CTR},
+/* pmd1  */	{{MSR_K7_PERFCTR1, 0}, 0, PFM_REGT_CTR},
+/* pmd2  */	{{MSR_K7_PERFCTR2, 0}, 0, PFM_REGT_CTR},
+/* pmd3  */	{{MSR_K7_PERFCTR3, 0}, 0, PFM_REGT_CTR},
 	},
 	.pmu_style = PFM_X86_PMU_P6
 };
 
 /*
+ * force Local APIC interrupt on overflow
+ */
+#define PFM_K8_VAL	(1ULL<<20)
+#define PFM_K8_NO64	(1ULL<<20)
+
+/*
  * reserved bits must be zero
  *
  * - upper 32 bits are reserved
@@ -59,12 +65,6 @@ static struct pfm_arch_pmu_info pfm_k8_p
 			| (1ULL<<20)	\
 			| (1ULL<<21))
 
-/*
- * force Local APIC interrupt on overflow
- */
-#define PFM_K8_VAL	(1ULL<<20)
-#define PFM_K8_NO64	(1ULL<<20)
-
 static struct pfm_reg_desc pfm_k8_pmc_desc[]={
 /* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),
 /* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),
@@ -73,11 +73,11 @@ static struct pfm_reg_desc pfm_k8_pmc_de
 };
 #define PFM_AMD_NUM_PMCS ARRAY_SIZE(pfm_k8_pmc_desc)
 
-static struct pfm_reg_desc pfm_k8_pmd_desc[]={
-/* pmd0  */ PMD_D(PFM_REG_C, "PERFCTR0", MSR_K7_PERFCTR0),
-/* pmd1  */ PMD_D(PFM_REG_C, "PERFCTR1", MSR_K7_PERFCTR1),
-/* pmd2  */ PMD_D(PFM_REG_C, "PERFCTR2", MSR_K7_PERFCTR2),
-/* pmd3  */ PMD_D(PFM_REG_C, "PERFCTR3", MSR_K7_PERFCTR3),
+static struct pfm_reg_desc pfm_k8_pmd_desc[] = {
+/* pmd0  */ PMD_D(PFM_REG_C,   "PERFCTR0",	MSR_K7_PERFCTR0),
+/* pmd1  */ PMD_D(PFM_REG_C,   "PERFCTR1",	MSR_K7_PERFCTR1),
+/* pmd2  */ PMD_D(PFM_REG_C,   "PERFCTR2",	MSR_K7_PERFCTR2),
+/* pmd3  */ PMD_D(PFM_REG_C,   "PERFCTR3",	MSR_K7_PERFCTR3),
 };
 #define PFM_AMD_NUM_PMDS ARRAY_SIZE(pfm_k8_pmd_desc)
 
Index: linux-2.6.22-rc3/include/asm-i386/perfmon.h
===================================================================
--- linux-2.6.22-rc3.orig/include/asm-i386/perfmon.h
+++ linux-2.6.22-rc3/include/asm-i386/perfmon.h
@@ -50,14 +50,14 @@
 /*
  * bitmask for reg_type
  */
-#define PFM_REGT_NA	 0x00 /* not available */
-#define PFM_REGT_EN 	 0x01 /* has enable bit (cleared on ctxsw) */
-#define PFM_REGT_ESCR    0x02 /* P4: ESCR */
-#define PFM_REGT_CCCR    0x04 /* P4: CCCR */
-#define PFM_REGT_OTH 	 0x80 /* other type of register */
-#define PFM_REGT_PEBS	 0x10 /* PEBS related */
-#define PFM_REGT_NOHT    0x20 /* unavailable with HT */
-#define PFM_REGT_CTR     0x40 /* counter */
+#define PFM_REGT_NA		0x0000	/* not available */
+#define PFM_REGT_EN		0x0001	/* has enable bit (cleared on ctxsw) */
+#define PFM_REGT_ESCR		0x0002	/* P4: ESCR */
+#define PFM_REGT_CCCR		0x0004	/* P4: CCCR */
+#define PFM_REGT_PEBS		0x0010	/* PEBS related */
+#define PFM_REGT_NOHT		0x0020	/* unavailable with HT */
+#define PFM_REGT_CTR		0x0040	/* counter */
+#define PFM_REGT_OTH		0x0080	/* other type of register */
 
 /*
  * This design and the partitioning of resources for SMT (hyper threads)
Index: linux-2.6.22-rc3/include/linux/perfmon_pmu.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/perfmon_pmu.h
+++ linux-2.6.22-rc3/include/linux/perfmon_pmu.h
@@ -69,7 +69,7 @@ struct pfm_reg_desc {
 #define PFM_REG_C64	0x04  /* PMD: 64-bit virtualization */
 #define PFM_REG_RO	0x08  /* PMD: read-only (writes ignored) */
 #define PFM_REG_V	0x10  /* PMD: virtual reg (provided by PMU description) */
-#define PFM_REG_NO64	0x100 /* PMC: supports REGFL_NOEMUL64 */
+#define PFM_REG_NO64	0x100 /* PMC: supports PFM_REGFL_NO_EMUL64 */
 
 /*
  * define some shortcuts for common types

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



