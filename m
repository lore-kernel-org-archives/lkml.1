Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZF2HZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZF2HZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZF2HZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:25:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:55473 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZF2HZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:25:26 -0400
Date: Mon, 29 Jun 2009 07:24:48 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mitake@dcl.info.waseda.ac.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090629.144457.886429910353660979.mitake@dcl.info.waseda.ac.jp>
References: <20090629.144457.886429910353660979.mitake@dcl.info.waseda.ac.jp>
Subject: [tip:sched/core] sched: Hide runqueues from direct reference at source code level for __raw_get_cpu_var()
Message-ID: <tip-54d35f29f49224d86b994acb6e5969b9ba09022d@git.kernel.org>
Git-Commit-ID: 54d35f29f49224d86b994acb6e5969b9ba09022d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 07:24:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54d35f29f49224d86b994acb6e5969b9ba09022d
Gitweb:     http://git.kernel.org/tip/54d35f29f49224d86b994acb6e5969b9ba09022d
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Mon, 29 Jun 2009 14:44:57 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Jun 2009 09:19:27 +0200

sched: Hide runqueues from direct reference at source code level for __raw_get_cpu_var()

Hide __raw_get_cpu_var() as well - thus all the direct
references to runqueues will abstracted out.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
LKML-Reference: <20090629.144457.886429910353660979.mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 168b268..ebc5151 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -692,6 +692,7 @@ static inline int cpu_of(struct rq *rq)
 #define this_rq()		(&__get_cpu_var(runqueues))
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+#define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
 inline void update_rq_clock(struct rq *rq)
 {
@@ -6669,7 +6670,7 @@ EXPORT_SYMBOL(yield);
  */
 void __sched io_schedule(void)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = raw_rq();
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
@@ -6681,7 +6682,7 @@ EXPORT_SYMBOL(io_schedule);
 
 long __sched io_schedule_timeout(long timeout)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = raw_rq();
 	long ret;
 
 	delayacct_blkio_start();
