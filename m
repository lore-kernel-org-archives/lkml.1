Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbXFWN25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbXFWN25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbXFWNW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:27 -0400
Received: from www.osadl.org ([213.239.205.134]:59284 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756350AbXFWNWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:14 -0400
Message-Id: <20070623124031.077153555@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 21/28] x86-64: Fix APIC typo
Content-Disposition: inline; filename=x86-64-fix-apic-typo.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86_64/kernel/apic.c    |    4 ++--
 arch/x86_64/kernel/mce_amd.c |    6 +++---
 include/asm-x86_64/apic.h    |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.22-rc4-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/kernel/apic.c	2007-06-23 14:38:54.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/kernel/apic.c	2007-06-23 14:39:00.000000000 +0200
@@ -990,8 +990,8 @@ int setup_profiling_timer(unsigned int m
 	return -EINVAL;
 }
 
-void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
-			    unsigned char msg_type, unsigned char mask)
+void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
+			     unsigned char msg_type, unsigned char mask)
 {
 	unsigned long reg = (lvt_off << 4) + K8_APIC_EXT_LVT_BASE;
 	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
Index: linux-2.6.22-rc4-mm/arch/x86_64/kernel/mce_amd.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/x86_64/kernel/mce_amd.c	2007-06-23 14:38:54.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/x86_64/kernel/mce_amd.c	2007-06-23 14:39:00.000000000 +0200
@@ -157,9 +157,9 @@ void __cpuinit mce_amd_feature_init(stru
 			high |= K8_APIC_EXT_LVT_ENTRY_THRESHOLD << 20;
 			wrmsr(address, low, high);
 
-			setup_APIC_extened_lvt(K8_APIC_EXT_LVT_ENTRY_THRESHOLD,
-					       THRESHOLD_APIC_VECTOR,
-					       K8_APIC_EXT_INT_MSG_FIX, 0);
+			setup_APIC_extended_lvt(K8_APIC_EXT_LVT_ENTRY_THRESHOLD,
+						THRESHOLD_APIC_VECTOR,
+						K8_APIC_EXT_INT_MSG_FIX, 0);
 
 			threshold_defaults.address = address;
 			threshold_restart_bank(&threshold_defaults, 0, 0);
Index: linux-2.6.22-rc4-mm/include/asm-x86_64/apic.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/asm-x86_64/apic.h	2007-06-23 14:38:59.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/asm-x86_64/apic.h	2007-06-23 14:39:00.000000000 +0200
@@ -83,8 +83,8 @@ extern void disable_APIC_timer(void);
 extern void enable_APIC_timer(void);
 extern void setup_apic_routing(void);
 
-extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
-				   unsigned char msg_type, unsigned char mask);
+extern void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
+				    unsigned char msg_type, unsigned char mask);
 
 extern int apic_is_clustered_box(void);
 

-- 

