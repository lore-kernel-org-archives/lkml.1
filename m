Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233Ab0A0WOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab0A0WOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200Ab0A0WOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:14:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab0A0WOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:14:07 -0500
Message-Id: <20100127221122.261477183@chello.nl>
References: <20100127220745.027096123@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jan 2010 23:07:49 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] perf_events: x86: Remove spurious counter reset from x86_pmu_enable()
Content-Disposition: inline; filename=perf-cleanup-enable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At enable time the counter might still have a ->idx pointing to a
previously occupied location that might now be taken by another event.
Resetting the counter at that location with data from this event will
destroy the other counter's count.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1769,9 +1769,6 @@ static int x86_pmu_enable(struct perf_ev
 	cpuc->n_events = n;
 	cpuc->n_added  = n - n0;
 
-	if (hwc->idx != -1)
-		x86_perf_event_set_period(event, hwc, hwc->idx);
-
 	return 0;
 }
 

-- 

