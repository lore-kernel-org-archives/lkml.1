Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbZBLMws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbZBLMws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759219AbZBLMum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:50:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54457 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023AbZBLMul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:50:41 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212149.227733077@firstfloor.org>
In-Reply-To: <20090212149.227733077@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/9] x86: CMCI: Define MSR names and fields for new CMCI registers
Message-Id: <20090212124935.5794F3E666E@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:49:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CMCI means support for raising an interrupt on a corrected machine
check event instead of having to poll for it. It's a new feature in 
Intel Nehalem CPUs available on some machine check banks.

For details see the IA32 SDM Vol3a 14.5

Define the registers for it as a preparation for further patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/apicdef.h   |    1 +
 arch/x86/include/asm/mce.h       |    2 ++
 arch/x86/include/asm/msr-index.h |    5 +++++
 3 files changed, 8 insertions(+)

Index: linux/arch/x86/include/asm/msr-index.h
===================================================================
--- linux.orig/arch/x86/include/asm/msr-index.h	2009-02-12 11:30:45.000000000 +0100
+++ linux/arch/x86/include/asm/msr-index.h	2009-02-12 11:30:51.000000000 +0100
@@ -77,6 +77,11 @@
 #define MSR_IA32_MC0_ADDR		0x00000402
 #define MSR_IA32_MC0_MISC		0x00000403
 
+/* These are consecutive and not in the normal 4er MCE bank block */
+#define MSR_IA32_MC0_CTL2		0x00000280
+#define CMCI_EN			(1ULL << 30)
+#define CMCI_THRESHOLD_MASK		0xffffULL
+
 #define MSR_P6_PERFCTR0			0x000000c1
 #define MSR_P6_PERFCTR1			0x000000c2
 #define MSR_P6_EVNTSEL0			0x00000186
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/include/asm/mce.h	2009-02-12 12:10:17.000000000 +0100
@@ -11,6 +11,8 @@
  */
 
 #define MCG_CTL_P	 (1UL<<8)   /* MCG_CAP register available */
+#define MCG_EXT_P	 (1ULL<<9)   /* Extended registers available */
+#define MCG_CMCI_P	 (1ULL<<10)  /* CMCI supported */
 
 #define MCG_STATUS_RIPV  (1UL<<0)   /* restart ip valid */
 #define MCG_STATUS_EIPV  (1UL<<1)   /* ip points to correct instruction */
Index: linux/arch/x86/include/asm/apicdef.h
===================================================================
--- linux.orig/arch/x86/include/asm/apicdef.h	2009-02-12 11:30:45.000000000 +0100
+++ linux/arch/x86/include/asm/apicdef.h	2009-02-12 11:30:51.000000000 +0100
@@ -53,6 +53,7 @@
 #define		APIC_ESR_SENDILL	0x00020
 #define		APIC_ESR_RECVILL	0x00040
 #define		APIC_ESR_ILLREGA	0x00080
+#define 	APIC_LVTCMCI	0x2f0
 #define	APIC_ICR	0x300
 #define		APIC_DEST_SELF		0x40000
 #define		APIC_DEST_ALLINC	0x80000
