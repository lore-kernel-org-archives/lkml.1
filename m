Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZD2NIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZD2NIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758266AbZD2NGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:06:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:44529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbZD2NGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:06:08 -0400
Date: Wed, 29 Apr 2009 13:05:25 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-12-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-12-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: rename __hw_perf_counter_set_period into x86_perf_counter_set_period
Message-ID: <tip-26816c287e13eedc67bc4ed0cd40c138314b7c7d@git.kernel.org>
Git-Commit-ID: 26816c287e13eedc67bc4ed0cd40c138314b7c7d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:05:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26816c287e13eedc67bc4ed0cd40c138314b7c7d
Gitweb:     http://git.kernel.org/tip/26816c287e13eedc67bc4ed0cd40c138314b7c7d
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:06 +0200

perf_counter, x86: rename __hw_perf_counter_set_period into x86_perf_counter_set_period

[ Impact: cleanup ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-12-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 6bbdc16..fa6541d 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -498,7 +498,7 @@ static DEFINE_PER_CPU(u64, prev_left[X86_PMC_IDX_MAX]);
  * To be called with the counter disabled in hw:
  */
 static void
-__hw_perf_counter_set_period(struct perf_counter *counter,
+x86_perf_counter_set_period(struct perf_counter *counter,
 			     struct hw_perf_counter *hwc, int idx)
 {
 	s64 left = atomic64_read(&hwc->period_left);
@@ -642,7 +642,7 @@ try_generic:
 	 */
 	barrier();
 
-	__hw_perf_counter_set_period(counter, hwc, idx);
+	x86_perf_counter_set_period(counter, hwc, idx);
 	__x86_pmu_enable(counter, hwc, idx);
 
 	return 0;
@@ -731,7 +731,7 @@ static void perf_save_and_restart(struct perf_counter *counter)
 	int idx = hwc->idx;
 
 	x86_perf_counter_update(counter, hwc, idx);
-	__hw_perf_counter_set_period(counter, hwc, idx);
+	x86_perf_counter_set_period(counter, hwc, idx);
 
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
 		__x86_pmu_enable(counter, hwc, idx);
