Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbZD2NIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbZD2NIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZD2NGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:06:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:44546 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758342AbZD2NGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:06:22 -0400
Date: Wed, 29 Apr 2009 13:05:36 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-13-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-13-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: rename intel only functions
Message-ID: <tip-55de0f2e57994b525324bf0d04d242d9358a2417@git.kernel.org>
Git-Commit-ID: 55de0f2e57994b525324bf0d04d242d9358a2417
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:05:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55de0f2e57994b525324bf0d04d242d9358a2417
Gitweb:     http://git.kernel.org/tip/55de0f2e57994b525324bf0d04d242d9358a2417
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:06 +0200

perf_counter, x86: rename intel only functions

[ Impact: cleanup ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-13-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index fa6541d..5a52d73 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -725,7 +725,7 @@ static void x86_pmu_disable(struct perf_counter *counter)
  * Save and restart an expired counter. Called by NMI contexts,
  * so it has to be careful about preempting normal counter ops:
  */
-static void perf_save_and_restart(struct perf_counter *counter)
+static void intel_pmu_save_and_restart(struct perf_counter *counter)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
 	int idx = hwc->idx;
@@ -753,7 +753,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs, int nmi)
 	struct cpu_hw_counters *cpuc = &per_cpu(cpu_hw_counters, cpu);
 	int ret = 0;
 
-	cpuc->throttle_ctrl = hw_perf_save_disable();
+	cpuc->throttle_ctrl = intel_pmu_save_disable_all();
 
 	status = intel_pmu_get_status(cpuc->throttle_ctrl);
 	if (!status)
@@ -770,7 +770,7 @@ again:
 		if (!counter)
 			continue;
 
-		perf_save_and_restart(counter);
+		intel_pmu_save_and_restart(counter);
 		if (perf_counter_overflow(counter, nmi, regs, 0))
 			__x86_pmu_disable(counter, &counter->hw, bit);
 	}
@@ -788,7 +788,7 @@ out:
 	 * Restore - do not reenable when global enable is off or throttled:
 	 */
 	if (++cpuc->interrupts < PERFMON_MAX_INTERRUPTS)
-		hw_perf_restore(cpuc->throttle_ctrl);
+		intel_pmu_restore_all(cpuc->throttle_ctrl);
 
 	return ret;
 }
