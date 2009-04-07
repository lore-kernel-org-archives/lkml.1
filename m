Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbZDGPKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbZDGPKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758239AbZDGPHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48836 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbZDGPHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:47 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [4/28] x86: MCE: Use symbolic macros to access MCG_CAP register
Message-Id: <20090407150744.D84591D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

Makes the code easier to read. No functional changes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h          |    2 ++
 arch/x86/kernel/cpu/mcheck/mce_64.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:15.000000000 +0200
@@ -551,7 +551,7 @@
 	unsigned b;
 
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
-	b = cap & 0xff;
+	b = cap & MCG_BANKS_MASK;
 	if (b > MAX_NR_BANKS) {
 		printk(KERN_WARNING
 		       "MCE: Using only %u machine check banks out of %u\n",
@@ -570,7 +570,7 @@
 	}
 
 	/* Use accurate RIP reporting if available. */
-	if ((cap & (1<<9)) && ((cap >> 16) & 0xff) >= 9)
+	if ((cap & MCG_EXT_P) && (MCG_NUM_EXT(cap) >= 9))
 		rip_msr = MSR_IA32_MCG_EIP;
 
 	return 0;
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/include/asm/mce.h	2009-04-07 16:43:14.000000000 +0200
@@ -10,8 +10,10 @@
  * Machine Check support for x86
  */
 
+#define MCG_BANKS_MASK	 (0xff)
 #define MCG_CTL_P	 (1UL<<8)   /* MCG_CAP register available */
 #define MCG_EXT_P	 (1ULL<<9)   /* Extended registers available */
+#define MCG_NUM_EXT(c)	 (((c) >> 16) & 0xff)
 #define MCG_CMCI_P	 (1ULL<<10)  /* CMCI supported */
 
 #define MCG_STATUS_RIPV  (1UL<<0)   /* restart ip valid */
