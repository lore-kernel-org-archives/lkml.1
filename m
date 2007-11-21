Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbXKUBVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbXKUBVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763165AbXKUBOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:14:06 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:36621 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760814AbXKUBNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:13:52 -0500
Message-Id: <20071121011250.781898322@goodmis.org>
References: <20071121010054.663842380@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 20:01:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v4 12/20] RT: Allow current_cpu to be included in search
Content-Disposition: inline; filename=sched-include-thiscpu.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

It doesn't hurt if we allow the current CPU to be included in the
search.  We will just simply skip it later if the current CPU turns out
to be the lowest.

We will use this later in the series

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched_rt.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-20 19:53:05.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-20 19:53:07.000000000 -0500
@@ -274,9 +274,6 @@ static int find_lowest_rq(struct task_st
 	for_each_cpu_mask(cpu, *cpu_mask) {
 		struct rq *rq = cpu_rq(cpu);
 
-		if (cpu == rq->cpu)
-			continue;
-
 		/* We look for lowest RT prio or non-rt CPU */
 		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
 			lowest_rq = rq;
@@ -304,7 +301,7 @@ static struct rq *find_lock_lowest_rq(st
 	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
 		cpu = find_lowest_rq(task);
 
-		if (cpu == -1)
+		if ((cpu == -1) || (cpu == rq->cpu))
 			break;
 
 		lowest_rq = cpu_rq(cpu);

-- 
