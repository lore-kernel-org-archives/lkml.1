Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYH0HEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYH0HEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbYH0HEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:04:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38341 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbYH0HEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:04:45 -0400
Date: Wed, 27 Aug 2008 09:04:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       yhlu.kernel@gmail.com
Subject: Re: [patch 2/2] x2apic: use x2apic id reported by cpuid during
	topology discovery
Message-ID: <20080827070427.GH6255@elte.hu>
References: <20080826183909.887903000@linux-os.sc.intel.com> <20080826183910.047665000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826183910.047665000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


applied the delta patch below to tip/x86/x2apic - thanks Suresh.

	Ingo

>From 11c231a962c740b3216eb6565149ae5a7944cba7 Mon Sep 17 00:00:00 2001
From: Suresh Siddha <suresh.b.siddha@intel.com>
Date: Sat, 23 Aug 2008 17:47:11 +0200
Subject: [PATCH] x86: use x2apic id reported by cpuid during topology discovery, fix

v2: Fix for !SMP build

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index aa9641a..a2d1a54 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -69,6 +69,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
  */
 void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_SMP
 	unsigned int eax, ebx, ecx, edx, sub_index;
 	unsigned int ht_mask_width, core_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
@@ -132,6 +133,7 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
 		       c->cpu_core_id);
 	return;
+#endif
 }
 
 #ifdef CONFIG_X86_PAT
