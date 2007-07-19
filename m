Return-Path: <linux-kernel-owner+w=401wt.eu-S937202AbXGSKLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937202AbXGSKLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbXGSJzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:36 -0400
Received: from mx1.suse.de ([195.135.220.2]:35389 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbXGSJzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:19 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: tglx@linutronix.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [28/58] x86_64: Fix APIC typo
Message-Id: <20070719095513.BA50F14E0B@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/apic.c    |    4 ++--
 arch/x86_64/kernel/mce_amd.c |    6 +++---
 include/asm-x86_64/apic.h    |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: linux/arch/x86_64/kernel/apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/apic.c
+++ linux/arch/x86_64/kernel/apic.c
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
Index: linux/arch/x86_64/kernel/mce_amd.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce_amd.c
+++ linux/arch/x86_64/kernel/mce_amd.c
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
Index: linux/include/asm-x86_64/apic.h
===================================================================
--- linux.orig/include/asm-x86_64/apic.h
+++ linux/include/asm-x86_64/apic.h
@@ -83,8 +83,8 @@ extern void disable_APIC_timer(void);
 extern void enable_APIC_timer(void);
 extern void setup_apic_routing(void);
 
-extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
-				   unsigned char msg_type, unsigned char mask);
+extern void setup_APIC_extended_lvt(unsigned char lvt_off, unsigned char vector,
+				    unsigned char msg_type, unsigned char mask);
 
 extern int apic_is_clustered_box(void);
 
