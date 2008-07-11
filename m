Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbYGKMfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbYGKMfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYGKMfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:35:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYGKMfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:35:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix inc_rt_tasks() to not declare variable 'rq' if it's not
	needed
To: mingo@elte.hu, ghaskins@novell.com, akpm@linux-foundation.org
Cc: dhowells@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 13:34:54 +0100
Message-ID: <20080711123454.10475.33099.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix inc_rt_tasks() to not declare variable 'rq' if it's not needed.  It is
declared if CONFIG_SMP or CONFIG_RT_GROUP_SCHED, but only used if CONFIG_SMP.

This is a consequence of patch 1f11eb6a8bc92536d9e93ead48fa3ffbd1478571 plus
patch 1100ac91b6af02d8639d518fad5b434b1bf44ed6.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/sched_rt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index acba8eb..ec19ce5 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -505,7 +505,9 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	rt_rq->rt_nr_running++;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
+#ifdef CONFIG_SMP
 		struct rq *rq = rq_of_rt_rq(rt_rq);
+#endif
 
 		rt_rq->highest_prio = rt_se_prio(rt_se);
 #ifdef CONFIG_SMP

