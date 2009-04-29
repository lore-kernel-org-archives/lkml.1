Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbZD2LAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbZD2LAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbZD2Kvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:39 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:9805 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbZD2KvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:03 -0400
X-BigFish: VPS1(zzzz1202hzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KIUZGO-01-7AB-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 11/29] x86/perfcounters: rename __hw_perf_counter_set_period into x86_perf_counter_set_period
Date: Wed, 29 Apr 2009 12:47:08 +0200
Message-ID: <1241002046-8832-12-git-send-email-robert.richter@amd.com>
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
-- 
1.6.1.3


