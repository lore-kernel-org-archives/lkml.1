Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZCMLZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZCMLZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbZCMLXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:23:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312AbZCMLXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:23:45 -0400
Message-Id: <20090313112301.288765724@chello.nl>
References: <20090313112125.886730125@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 12:21:29 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/11] perf_counter: use list_move_tail
Content-Disposition: inline; filename=perf_counter-list_op.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of del/add use a move list-op.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -89,8 +89,7 @@ list_del_counter(struct perf_counter *co
 	list_for_each_entry_safe(sibling, tmp,
 				 &counter->sibling_list, list_entry) {
 
-		list_del_init(&sibling->list_entry);
-		list_add_tail(&sibling->list_entry, &ctx->counter_list);
+		list_move_tail(&sibling->list_entry, &ctx->counter_list);
 		sibling->group_leader = sibling;
 	}
 }
@@ -959,8 +958,7 @@ static void rotate_ctx(struct perf_count
 	 */
 	perf_flags = hw_perf_save_disable();
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
-		list_del(&counter->list_entry);
-		list_add_tail(&counter->list_entry, &ctx->counter_list);
+		list_move_tail(&counter->list_entry, &ctx->counter_list);
 		break;
 	}
 	hw_perf_restore(perf_flags);

-- 

