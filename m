Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbZFMHHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbZFMHHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 03:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbZFMHHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 03:07:22 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42973 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbZFMHHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 03:07:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18995.20490.979429.244883@cargo.ozlabs.ibm.com>
Date: Sat, 13 Jun 2009 17:06:50 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Fix atomic_set vs. atomic64_t type mismatch
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using atomic_set on an atomic64_t variable gives a compiler warning on
powerpc, and won't give the desired result at runtime.  This fixes an
instance of this error in the perf_counter code.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 29b685f..8d14a73 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1283,7 +1283,7 @@ static void perf_ctx_adjust_freq(struct perf_counter_context *ctx)
 		if (!interrupts) {
 			perf_disable();
 			counter->pmu->disable(counter);
-			atomic_set(&hwc->period_left, 0);
+			atomic64_set(&hwc->period_left, 0);
 			counter->pmu->enable(counter);
 			perf_enable();
 		}
-- 
1.6.0.4

