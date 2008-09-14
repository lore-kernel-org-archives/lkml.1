Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbYINPNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbYINPNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYINPNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:13:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49829 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYINPNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:13:11 -0400
Date: Sun, 14 Sep 2008 17:12:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
Message-ID: <20080914151251.GA28507@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com> <20080914150651.GK12522@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914150651.GK12522@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a couple of fixlets below, pointed out by scripts/checkpatch.pl.

	Ingo

---------->
>From 5ce73a4a5a4893a1aa4cdeed1b1a5a6de42c43b6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 14 Sep 2008 17:11:46 +0200
Subject: [PATCH] timers: fix itimer/many thread hang, cleanups

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h     |    2 +-
 kernel/posix-cpu-timers.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ed355f0..7ce8d4e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -430,7 +430,7 @@ struct pacct_struct {
  * @utime:		time spent in user mode, in &cputime_t units
  * @stime:		time spent in kernel mode, in &cputime_t units
  * @sum_exec_runtime:	total time spent on the CPU, in nanoseconds
- * 
+ *
  * This structure groups together three kinds of CPU time that are
  * tracked for threads and thread groups.  Most things considering
  * CPU time want to group these counts together and treat all three
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index dba1c33..9a7ea04 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -94,7 +94,7 @@ void update_rlimit_cpu(unsigned long rlim_new)
 
 	cputime = secs_to_cputime(rlim_new);
 	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
-            cputime_lt(current->signal->it_prof_expires, cputime)) {
+	    cputime_lt(current->signal->it_prof_expires, cputime)) {
 		spin_lock_irq(&current->sighand->siglock);
 		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
 		spin_unlock_irq(&current->sighand->siglock);
@@ -1372,9 +1372,9 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	 * tsk->signal is non-NULL; this probably can't happen but cover the
 	 * possibility anyway.
 	 */
-	if (unlikely(!sig) || !fastpath_timer_check(tsk, sig)) {
+	if (unlikely(!sig) || !fastpath_timer_check(tsk, sig))
 		return;
-	}
+
 	sighand = lock_task_sighand(tsk, &flags);
 	if (likely(sighand)) {
 		/*
