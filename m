Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYJQNdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYJQNdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 09:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYJQNd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 09:33:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:37086 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753897AbYJQNdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 09:33:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18nxFE06dsnIAULG9YBYasvx9niTeaXvRxAuueA7N
	gKn+qw93YrPiCA
Subject: [patchlet] sched: minor fast-path overhead reduction
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 15:33:21 +0200
Message-Id: <1224250401.5226.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

103638d added a bit of avoidable overhead to the fast-path.

Use sysctl_sched_min_granularity instead of sched_slice() to restrict buddy wakeups.

Signed-off-by: Mike Galbraith <efault@gmx.de>
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 18fd171..6708493 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -747,7 +747,7 @@ pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	struct rq *rq = rq_of(cfs_rq);
 	u64 pair_slice = rq->clock - cfs_rq->pair_start;
 
-	if (!cfs_rq->next || pair_slice > sched_slice(cfs_rq, cfs_rq->next)) {
+	if (!cfs_rq->next || pair_slice > sysctl_sched_min_granularity) {
 		cfs_rq->pair_start = rq->clock;
 		return se;
 	}


