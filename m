Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZKKLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZKKLnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 06:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbZKKLnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 06:43:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:53631 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZKKLnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 06:43:16 -0500
Date: Wed, 11 Nov 2009 11:42:45 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yong.y.wang@linux.intel.com, yong.y.wang@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yong.y.wang@linux.intel.com, yong.y.wang@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091111075125.GA17900@ywang-moblin2.bj.intel.com>
References: <20091111075125.GA17900@ywang-moblin2.bj.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/mce] x86: Mark the thermal init functions __init
Message-ID: <tip-ce6b5d768c79b9d5dd6345c033bae781d5ca9b8e@git.kernel.org>
Git-Commit-ID: ce6b5d768c79b9d5dd6345c033bae781d5ca9b8e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce6b5d768c79b9d5dd6345c033bae781d5ca9b8e
Gitweb:     http://git.kernel.org/tip/ce6b5d768c79b9d5dd6345c033bae781d5ca9b8e
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Wed, 11 Nov 2009 15:51:25 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 12:33:32 +0100

x86: Mark the thermal init functions __init

Mark the thermal init functions __init so that the init memory
can be freed.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
LKML-Reference: <20091111075125.GA17900@ywang-moblin2.bj.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 7f3cf36..8a73d5c 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -256,7 +256,7 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 }
 
-void mcheck_intel_therm_init(void)
+void __init mcheck_intel_therm_init(void)
 {
 	/*
 	 * This function is only called on boot CPU. Save the init thermal
@@ -268,7 +268,7 @@ void mcheck_intel_therm_init(void)
 		lvtthmr_init = apic_read(APIC_LVTTHMR);
 }
 
-void intel_init_thermal(struct cpuinfo_x86 *c)
+void __init intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	unsigned int cpu = smp_processor_id();
 	int tm2 = 0;
