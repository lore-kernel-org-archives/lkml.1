Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbXKUBUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbXKUBUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763805AbXKUBOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:14:04 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:61538 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765434AbXKUBNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:13:50 -0500
Message-Id: <20071121011251.590599229@goodmis.org>
References: <20071121010054.663842380@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 20:01:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v4 17/20] RT: restore the migratable conditional
Content-Disposition: inline; filename=sched-renable-migratable-factor.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

We don't need to bother searching if the task cannot be migrated

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-20 19:53:11.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-20 19:53:13.000000000 -0500
@@ -173,7 +173,8 @@ static int select_task_rq_rt(struct task
 	 * that is just being woken and probably will have
 	 * cold cache anyway.
 	 */
-	if (unlikely(rt_task(rq->curr))) {
+	if (unlikely(rt_task(rq->curr)) &&
+	    (p->nr_cpus_allowed > 1)) {
 		int cpu = find_lowest_rq(p);
 
 		return (cpu == -1) ? task_cpu(p) : cpu;

-- 
