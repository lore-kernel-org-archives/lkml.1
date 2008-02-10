Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbYBJHV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbYBJHV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbYBJHU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:20:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56793 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757883AbYBJHUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:25 -0500
Date: Sun, 10 Feb 2008 08:20:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [05/19] ftrace: make the task state char-string visible to all
Message-ID: <20080210072013.GF4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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

From: Steven Rostedt <srostedt@redhat.com>

The tracer wants to be able to convert the state number
into a user visible character. This patch pulls that conversion
string out the scheduler into the header. This way if it were to
ever change, other parts of the kernel will know.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 ++
 kernel/sched.c        |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -2117,6 +2117,8 @@ static inline void migration_init(void)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -5154,7 +5154,7 @@ out_unlock:
 	return retval;
 }
 
-static const char stat_nam[] = "RSDTtZX";
+static const char stat_nam[] = TASK_STATE_TO_CHAR_STR;
 
 void sched_show_task(struct task_struct *p)
 {
