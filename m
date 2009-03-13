Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbZCMLYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbZCMLYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZCMLXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:23:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:42375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbZCMLXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:23:44 -0400
Message-Id: <20090313112301.188032328@chello.nl>
References: <20090313112125.886730125@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 12:21:28 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/11] perf_counter: x86: fix 32bit irq_period assumption.
Content-Disposition: inline; filename=perf_counter-x86.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to assume the irq_period is 32bit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -449,7 +449,7 @@ __hw_perf_counter_set_period(struct perf
 			     struct hw_perf_counter *hwc, int idx)
 {
 	s64 left = atomic64_read(&hwc->period_left);
-	s32 period = hwc->irq_period;
+	s64 period = hwc->irq_period;
 	int err;
 
 	/*

-- 

