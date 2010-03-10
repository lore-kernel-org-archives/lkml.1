Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab0CJNXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:23:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:53569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab0CJNXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:23:41 -0500
Date: Wed, 10 Mar 2010 13:23:09 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Reorder intel_pmu_enable_all()
Message-ID: <tip-d329527e47851f84b1e7944ed9601205f35f1b93@git.kernel.org>
Git-Commit-ID: d329527e47851f84b1e7944ed9601205f35f1b93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:23:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d329527e47851f84b1e7944ed9601205f35f1b93
Gitweb:     http://git.kernel.org/tip/d329527e47851f84b1e7944ed9601205f35f1b93
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 8 Mar 2010 13:57:14 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:37 +0100

perf, x86: Reorder intel_pmu_enable_all()

The documentation says we have to enable PEBS before we enable the PMU
proper.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index c135ed7..d3e2424 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -487,6 +487,8 @@ static void intel_pmu_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
+	intel_pmu_pebs_enable_all();
+	intel_pmu_lbr_enable_all();
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
 
 	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
@@ -498,9 +500,6 @@ static void intel_pmu_enable_all(void)
 
 		intel_pmu_enable_bts(event->hw.config);
 	}
-
-	intel_pmu_pebs_enable_all();
-	intel_pmu_lbr_enable_all();
 }
 
 static inline u64 intel_pmu_get_status(void)
