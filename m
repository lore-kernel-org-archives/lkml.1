Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZKWKll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZKWKll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZKWKk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:40:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:53255 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbZKWKk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:40:57 -0500
Message-Id: <20091123103819.764207355@chello.nl>
References: <20091123103722.140831906@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Nov 2009 11:37:26 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/8] perf: update the context time on exit
Content-Disposition: inline; filename=perf-foo-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appeared we did call update_event_times() on exit, but we failed to
update the context time, which renders the former moot.

XXX: locking is a bit iffy, we call update_event_times under
     ctx->mutex instead of ctx->lock, should probably be fixed in 
     some way.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4982,6 +4982,7 @@ void perf_event_exit_task(struct task_st
 	 * the events from it.
 	 */
 	unclone_ctx(child_ctx);
+	update_context_time(child_ctx);
 	spin_unlock_irqrestore(&child_ctx->lock, flags);
 
 	/*

-- 

