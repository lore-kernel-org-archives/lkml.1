Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZCJOWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZCJOWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZCJOW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:22:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48790 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbZCJOW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:22:26 -0400
Message-Id: <20090310142015.941671402@chello.nl>
References: <20090310141913.961861111@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 15:19:17 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] perf_counter: use list_move_tail
Content-Disposition: inline; filename=perf_counter-list_op.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of del/add use a move list-op.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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

-- 

