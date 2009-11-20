Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZKTV23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZKTV23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZKTV21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbZKTV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:26 -0500
Message-Id: <20091120212509.000272254@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:53 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/15] perf: simplify __perf_event_read
Content-Disposition: inline; filename=perf-time-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuctx is always active, task context is always active for current

the previous condition verifies that if its a task context its for
current, hence we can assume ctx->is_active.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1526,10 +1526,9 @@ static void __perf_event_read(void *info
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	if (ctx->is_active)
-		update_context_time(ctx);
-	event->pmu->read(event);
+	update_context_time(ctx);
 	update_event_times(event);
+	event->pmu->read(event);
 }
 
 static u64 perf_event_read(struct perf_event *event)

-- 

