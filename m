Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbZD2LHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbZD2LHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760090AbZD2LGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:06:14 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:4349 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760088AbZD2LGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:06:12 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KIUZGR-04-0X4-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 12/29] x86/perfcounters: rename intel only functions
Date: Wed, 29 Apr 2009 12:47:09 +0200
Message-ID: <1241002046-8832-13-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0321 (UTC) FILETIME=[5B9B4590:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.6.1.3


