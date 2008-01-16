Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbYAPWcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbYAPWcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbYAPW1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:27:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248AbYAPW1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:27:05 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161127.268350000@suse.de>
In-Reply-To: <200801161127.268350000@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/7] i386: Move MWAIT idle check to generic CPU initialization
Message-Id: <20080116222704.60FFA14EE3@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:27:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously it was only run for Intel CPUs, but AMD Fam10h implements MWAIT too.

This matches 64bit behaviour.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/common.c |    2 ++
 arch/x86/kernel/cpu/intel.c  |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -499,6 +499,8 @@ void __cpuinit identify_cpu(struct cpuin
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
+
+	select_idle_routine(c);
 }
 
 void __init identify_boot_cpu(void)
Index: linux/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/intel.c
+++ linux/arch/x86/kernel/cpu/intel.c
@@ -137,7 +137,6 @@ static void __cpuinit init_intel(struct 
 	}
 #endif
 
-	select_idle_routine(c);
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9 ) {
 		unsigned eax = cpuid_eax(10);
