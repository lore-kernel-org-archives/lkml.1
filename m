Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZF1VEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZF1VEV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZF1VEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:04:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:45337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZF1VEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:04:13 -0400
Message-ID: <4A47DAB1.3090707@kernel.org>
Date: Sun, 28 Jun 2009 14:03:45 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/perf_count: update x86_pmu after WARN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


should print out before changing the value

[Impact: get right print when clipping num_conunters]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -1496,17 +1496,17 @@ void __init init_hw_perf_counters(void)
     pr_cont("%s PMU driver.\n", x86_pmu.name);
 
     if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
-        x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
         WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
              x86_pmu.num_counters, X86_PMC_MAX_GENERIC);
+        x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
     }
     perf_counter_mask = (1 << x86_pmu.num_counters) - 1;
     perf_max_counters = x86_pmu.num_counters;
 
     if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
-        x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
         WARN(1, KERN_ERR "hw perf counters fixed %d > max(%d), clipping!",
              x86_pmu.num_counters_fixed, X86_PMC_MAX_FIXED);
+        x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
     }
 
     perf_counter_mask |=
