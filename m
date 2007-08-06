Return-Path: <linux-kernel-owner+w=401wt.eu-S1762590AbXHFD1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590AbXHFD1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 23:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758948AbXHFD1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 23:27:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650AbXHFD1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 23:27:03 -0400
Date: Mon, 6 Aug 2007 04:26:59 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] take sched_debug.c out of nasal demon territory
Message-ID: <20070806032659.GX21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	C99 6.10.3[11]: preprocessing directive within the argument list
of macro invocation => undefined behaviour.  Don't do that...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 1c61e53..8421b93 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -36,24 +36,24 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p, u64 now)
 	else
 		SEQ_printf(m, " ");
 
-	SEQ_printf(m, "%15s %5d %15Ld %13Ld %13Ld %9Ld %5d "
-		      "%15Ld %15Ld %15Ld %15Ld %15Ld\n",
+	SEQ_printf(m, "%15s %5d %15Ld %13Ld %13Ld %9Ld %5d ",
 		p->comm, p->pid,
 		(long long)p->se.fair_key,
 		(long long)(p->se.fair_key - rq->cfs.fair_clock),
 		(long long)p->se.wait_runtime,
 		(long long)(p->nvcsw + p->nivcsw),
-		p->prio,
+		p->prio);
 #ifdef CONFIG_SCHEDSTATS
+	SEQ_printf(m, "%15Ld %15Ld %15Ld %15Ld %15Ld\n",
 		(long long)p->se.sum_exec_runtime,
 		(long long)p->se.sum_wait_runtime,
 		(long long)p->se.sum_sleep_runtime,
 		(long long)p->se.wait_runtime_overruns,
-		(long long)p->se.wait_runtime_underruns
+		(long long)p->se.wait_runtime_underruns);
 #else
-		0LL, 0LL, 0LL, 0LL, 0LL
+	SEQ_printf(m, "%15Ld %15Ld %15Ld %15Ld %15Ld\n",
+		0LL, 0LL, 0LL, 0LL, 0LL);
 #endif
-	);
 }
 
 static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu, u64 now)
