Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722Ab0AVQCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab0AVQCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461Ab0AVQCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:02:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:38259 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0AVP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:59:31 -0500
Message-Id: <20100122155535.504916780@chello.nl>
References: <20100122155044.391857484@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jan 2010 16:50:48 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/10] perf_event: x86: Fixup weight tying issue
Content-Disposition: inline; filename=perf-fix-types.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

constraints gets defined an u64 but in long quantities and then cast to long.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1235,7 +1235,7 @@ static int x86_schedule_events(struct cp
 	int i, j , w, num;
 	int weight, wmax;
 	unsigned long *c;
-	u64 constraints[X86_PMC_IDX_MAX][BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long constraints[X86_PMC_IDX_MAX][BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	struct hw_perf_event *hwc;
 
@@ -1252,7 +1252,7 @@ static int x86_schedule_events(struct cp
 	 */
 	for (i = 0, num = n; i < n; i++, num--) {
 		hwc = &cpuc->event_list[i]->hw;
-		c = (unsigned long *)constraints[i];
+		c = constraints[i];
 
 		/* never assigned */
 		if (hwc->idx == -1)
@@ -1309,7 +1309,7 @@ static int x86_schedule_events(struct cp
 	for (w = 1, num = n; num && w <= wmax; w++) {
 		/* for each event */
 		for (i = 0; num && i < n; i++) {
-			c = (unsigned long *)constraints[i];
+			c = constraints[i];
 			hwc = &cpuc->event_list[i]->hw;
 
 			weight = bitmap_weight(c, X86_PMC_IDX_MAX);

-- 

