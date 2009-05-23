Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZEWQdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZEWQdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbZEWQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:33:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZEWQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:32:59 -0400
Message-Id: <20090523163012.796275849@chello.nl>
References: <20090523162854.599719825@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 23 May 2009 18:28:59 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 5/7] perf_counter: simplify context cleanup
Content-Disposition: inline; filename=perf_counter-cleanup-exit.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use perf_counter_remove_from_context() to remove counters from the context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -3416,10 +3416,7 @@ __perf_counter_exit_task(struct task_str
 	struct perf_counter *parent_counter;
 
 	update_counter_times(child_counter);
-
-	spin_lock_irq(&child_ctx->lock);
-	list_del_counter(child_counter, child_ctx);
-	spin_unlock_irq(&child_ctx->lock);
+	perf_counter_remove_from_context(child_counter);
 
 	parent_counter = child_counter->parent;
 	/*

-- 

