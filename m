Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbYACAxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbYACAxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759740AbYACAuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:10 -0500
Received: from mx1.suse.de ([195.135.220.2]:51777 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759431AbYACAuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:06 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [10/20] i386: Move MWAIT idle check to generic CPU initialization
Message-Id: <20080103005005.B13C714D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:05 +0100 (CET)
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
@@ -510,6 +510,8 @@ void __cpuinit identify_cpu(struct cpuin
 
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
@@ -134,7 +134,6 @@ static void __cpuinit init_intel(struct 
 	}
 #endif
 
-	select_idle_routine(c);
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9 ) {
 		unsigned eax = cpuid_eax(10);
