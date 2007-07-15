Return-Path: <linux-kernel-owner+w=401wt.eu-S1763111AbXGOQJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763111AbXGOQJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762273AbXGOQFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:01 -0400
Received: from www.osadl.org ([213.239.205.134]:42556 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762637AbXGOQE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:04:58 -0400
Message-Id: <20070715155541.050290527@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 09/33] x86_64: Fix APIC typo
Content-Disposition: inline; filename=x86_64-fix-apic-typo.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 arch/x86_64/kernel/apic.c    |    4 ++--
 arch/x86_64/kernel/mce_amd.c |    6 +++---
 include/asm-x86_64/apic.h    |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/apic.c	2007-07-15 17:26:49.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c	2007-07-15 17:49:04.000000000 +0200
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
Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/mce_amd.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/mce_amd.c	2007-07-15 17:26:49.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/mce_amd.c	2007-07-15 17:31:31.000000000 +0200
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
Index: linux-2.6.22-rc6-mm/include/asm-x86_64/apic.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/asm-x86_64/apic.h	2007-07-15 17:29:06.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/asm-x86_64/apic.h	2007-07-15 17:48:53.000000000 +0200
@@ -83,8 +83,8 @@ extern void disable_APIC_timer(void);
 extern void enable_APIC_timer(void);
 extern void setup_apic_routing(void);
 
-extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
-				   unsigned char msg_type, unsigned char mask);
+extern void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
+				    unsigned char msg_type, unsigned char mask);
 
 extern int apic_is_clustered_box(void);
 

-- 

