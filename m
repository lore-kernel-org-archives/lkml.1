Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbZBLMvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbZBLMvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648AbZBLMuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:50:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54450 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180AbZBLMue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:50:34 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212149.227733077@firstfloor.org>
In-Reply-To: <20090212149.227733077@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/9] x86: CMCI: Export MAX_NR_BANKS
Message-Id: <20090212124930.3F5E63E666E@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:49:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move MAX_NR_BANKS into mce.h because it's needed there
for followup patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h          |    6 ++++++
 arch/x86/kernel/cpu/mcheck/mce_64.c |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/include/asm/mce.h	2009-02-12 12:10:18.000000000 +0100
@@ -95,6 +95,12 @@
 DECLARE_PER_CPU(struct sys_device, device_mce);
 extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
+/*
+ * To support more than 128 would need to escape the predefined
+ * Linux defined extended banks first.
+ */
+#define MAX_NR_BANKS (MCE_EXTENDED_BANK - 1)
+
 #ifdef CONFIG_X86_MCE_INTEL
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 #else
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:18.000000000 +0100
@@ -37,12 +37,6 @@
 
 #define MISC_MCELOG_MINOR 227
 
-/*
- * To support more than 128 would need to escape the predefined
- * Linux defined extended banks first.
- */
-#define MAX_NR_BANKS (MCE_EXTENDED_BANK - 1)
-
 atomic_t mce_entry;
 
 static int mce_dont_init;
