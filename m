Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZFYUsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZFYUsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZFYUsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:48:14 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36277 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZFYUsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:48:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=MiYAfDiSTnJWj1tYB+ERJzgBz2hW86Oum8p1koMqGf0uDgTpq6qZ3AjdlPBBfNaZ5
	WajuFU2v426NOWZDaNnGA==
Date: Thu, 25 Jun 2009 13:48:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Menage <menage@google.com>, Miao Xie <miaox@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [patch] mm: remove obsoleted alloc_pages cpuset comment
Message-ID: <alpine.DEB.2.00.0906251346540.6083@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cpuset's nodemask is updated, all attached tasks have their cached
task->mems_allowed updated by a heap instead of requiring an explicit
call to cpuset_update_task_memory_state(), which has since been removed
in 58568d2a8215cb6f55caf2332017d7bdff954e1c.

Remove the obsoleted comment from the page allocator.

Cc: Paul Menage <menage@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5d714f8..8670fb7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1620,10 +1620,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
-
-	/*
-	 * The task's cpuset might have expanded its set of allowable nodes
-	 */
 	p->flags |= PF_MEMALLOC;
 	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
