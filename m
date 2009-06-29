Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZF2FpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZF2FpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 01:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZF2FpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 01:45:09 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50375 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZF2FpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 01:45:08 -0400
Date: Mon, 29 Jun 2009 14:44:57 +0900 (JST)
Message-Id: <20090629.144457.886429910353660979.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: [PATCH] sched: Hide runqueues from direct refer at source code
 level for __raw_get_cpu_var()
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20090629041104.GB13117@elte.hu>
References: <20090623.132920.886429909279624487.mitake@dcl.info.waseda.ac.jp>
	<20090629.125902.886429909480974646.mitake@dcl.info.waseda.ac.jp>
	<20090629041104.GB13117@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


description:

My previous patch (Commit-ID of tip tree d11ad9b3631b942b0d2e5b754a6c62158efb799f) hides
direct refers at source code level into macros.
This will hide the rest part, __raw_get_cpu_var().
After appling this, all of the direct refer to runqueues will be in macros in the close place.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

diff --git a/kernel/sched.c b/kernel/sched.c
index 7c9098d..d1d3599 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -692,6 +692,7 @@ static inline int cpu_of(struct rq *rq)
 #define this_rq()		(&__get_cpu_var(runqueues))
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+#define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
 inline void update_rq_clock(struct rq *rq)
 {
@@ -6631,7 +6632,7 @@ EXPORT_SYMBOL(yield);
  */
 void __sched io_schedule(void)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = raw_rq();
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
@@ -6643,7 +6644,7 @@ EXPORT_SYMBOL(io_schedule);
 
 long __sched io_schedule_timeout(long timeout)
 {
-	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	struct rq *rq = raw_rq();
 	long ret;
 
 	delayacct_blkio_start();
