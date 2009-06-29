Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbZF2IWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbZF2IWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbZF2IWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:22:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53917 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758127AbZF2IWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:22:30 -0400
Date: Mon, 29 Jun 2009 08:21:32 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A487017.4090007@kernel.org>
References: <4A487017.4090007@kernel.org>
Subject: [tip:perfcounters/urgent] perf_counter, x86: Update x86_pmu after WARN()
Message-ID: <tip-4078c444cf667f018c3fc7ebf141131a2b7c9480@git.kernel.org>
Git-Commit-ID: 4078c444cf667f018c3fc7ebf141131a2b7c9480
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 08:21:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4078c444cf667f018c3fc7ebf141131a2b7c9480
Gitweb:     http://git.kernel.org/tip/4078c444cf667f018c3fc7ebf141131a2b7c9480
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 29 Jun 2009 00:41:11 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Jun 2009 10:19:25 +0200

perf_counter, x86: Update x86_pmu after WARN()

The print out should read the value before changing the value.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4A487017.4090007@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index b83474b..d4cf4ce 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1496,17 +1496,17 @@ void __init init_hw_perf_counters(void)
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
 	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
-		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
 		     x86_pmu.num_counters, X86_PMC_MAX_GENERIC);
+		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 	}
 	perf_counter_mask = (1 << x86_pmu.num_counters) - 1;
 	perf_max_counters = x86_pmu.num_counters;
 
 	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
-		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
 		WARN(1, KERN_ERR "hw perf counters fixed %d > max(%d), clipping!",
 		     x86_pmu.num_counters_fixed, X86_PMC_MAX_FIXED);
+		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
 	}
 
 	perf_counter_mask |=
