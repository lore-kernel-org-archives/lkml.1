Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692Ab0A2J1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab0A2J1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490Ab0A2J1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:27:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:57392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab0A2J1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:27:44 -0500
Date: Fri, 29 Jan 2010 09:27:17 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100122155535.504916780@chello.nl>
References: <20100122155535.504916780@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: x86: Fixup constraints typing issue
Message-ID: <tip-81269a085669b5130058a0275aa7ba9f94abd1fa@git.kernel.org>
Git-Commit-ID: 81269a085669b5130058a0275aa7ba9f94abd1fa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:27:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81269a085669b5130058a0275aa7ba9f94abd1fa
Gitweb:     http://git.kernel.org/tip/81269a085669b5130058a0275aa7ba9f94abd1fa
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Jan 2010 14:55:22 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:36 +0100

perf_event: x86: Fixup constraints typing issue

Constraints gets defined an u64 but in long quantities and then cast to
long.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100122155535.504916780@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7bd359a..7e181a5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1232,7 +1232,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	int i, j , w, num;
 	int weight, wmax;
 	unsigned long *c;
-	u64 constraints[X86_PMC_IDX_MAX][BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long constraints[X86_PMC_IDX_MAX][BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	struct hw_perf_event *hwc;
 
@@ -1249,7 +1249,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	 */
 	for (i = 0, num = n; i < n; i++, num--) {
 		hwc = &cpuc->event_list[i]->hw;
-		c = (unsigned long *)constraints[i];
+		c = constraints[i];
 
 		/* never assigned */
 		if (hwc->idx == -1)
@@ -1306,7 +1306,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	for (w = 1, num = n; num && w <= wmax; w++) {
 		/* for each event */
 		for (i = 0; num && i < n; i++) {
-			c = (unsigned long *)constraints[i];
+			c = constraints[i];
 			hwc = &cpuc->event_list[i]->hw;
 
 			weight = bitmap_weight(c, X86_PMC_IDX_MAX);
