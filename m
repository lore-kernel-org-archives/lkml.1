Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbZKXQ5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbZKXQ5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbZKXQ5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:57:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:60335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543AbZKXQ5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:57:44 -0500
Date: Tue, 24 Nov 2009 16:56:36 GMT
From: tip-bot for Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       tim@klingt.org, mingo@elte.hu
In-Reply-To: <4B0BBBB1.2050100@klingt.org>
References: <4B0BBBB1.2050100@klingt.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Optimize branch hint in pick_next_task_fair()
Message-ID: <tip-36ace27e3e60d44ea69ce394b2e45386ae98d9d9@git.kernel.org>
Git-Commit-ID: 36ace27e3e60d44ea69ce394b2e45386ae98d9d9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36ace27e3e60d44ea69ce394b2e45386ae98d9d9
Gitweb:     http://git.kernel.org/tip/36ace27e3e60d44ea69ce394b2e45386ae98d9d9
Author:     Tim Blechmann <tim@klingt.org>
AuthorDate: Tue, 24 Nov 2009 11:55:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 12:18:12 +0100

sched: Optimize branch hint in pick_next_task_fair()

Branch hint profiling on my nehalem machine showed 90%
incorrect branch hints:

  15728471 158903754  90 pick_next_task_fair
  sched_fair.c    1555

Signed-off-by: Tim Blechmann <tim@klingt.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0BBBB1.2050100@klingt.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f28a267..24086e7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1704,7 +1704,7 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
 
-	if (unlikely(!cfs_rq->nr_running))
+	if (!cfs_rq->nr_running)
 		return NULL;
 
 	do {
