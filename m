Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZGJKmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZGJKmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZGJKmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:42:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:53287 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbZGJKmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:42:11 -0400
Date: Fri, 10 Jul 2009 10:41:26 GMT
From: tip-bot for Fabio Checconi <fchecconi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, fchecconi@gmail.com, fabio@gandalf.sssup.it,
       tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fchecconi@gmail.com, fabio@gandalf.sssup.it,
       tglx@linutronix.de, ghaskins@novell.com, mingo@elte.hu
In-Reply-To: <20090615185638.GK21741@gandalf.sssup.it>
References: <20090615185638.GK21741@gandalf.sssup.it>
Subject: [tip:sched/urgent] sched: Fix rt_rq->pushable_tasks initialization in init_rt_rq()
Message-ID: <tip-c20b08e3986c2dbfa6df1e880bf4f7159994d199@git.kernel.org>
Git-Commit-ID: c20b08e3986c2dbfa6df1e880bf4f7159994d199
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:41:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c20b08e3986c2dbfa6df1e880bf4f7159994d199
Gitweb:     http://git.kernel.org/tip/c20b08e3986c2dbfa6df1e880bf4f7159994d199
Author:     Fabio Checconi <fchecconi@gmail.com>
AuthorDate: Mon, 15 Jun 2009 20:56:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 10:43:30 +0200

sched: Fix rt_rq->pushable_tasks initialization in init_rt_rq()

init_rt_rq() initializes only rq->rt.pushable_tasks, and not the
pushable_tasks field of the passed rt_rq.  The plist is not used
uninitialized since the only pushable_tasks plists used are the
ones of root rt_rqs; anyway reinitializing the list on every group
creation corrupts the root plist, losing its previous contents.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090615185638.GK21741@gandalf.sssup.it>
CC: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c4549bd..efecfda 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9093,7 +9093,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
-	plist_head_init(&rq->rt.pushable_tasks, &rq->lock);
+	plist_head_init(&rt_rq->pushable_tasks, &rq->lock);
 #endif
 
 	rt_rq->rt_time = 0;
