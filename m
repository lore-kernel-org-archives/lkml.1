Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYGXPOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYGXPOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbYGXPOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:14:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46823 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768AbYGXPOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:14:06 -0400
Date: Thu, 24 Jul 2008 17:13:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] core kernel fixes
Message-ID: <20080724151356.GA19686@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest core kernel fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Thanks,

	Ingo

------------------>
Andrew Morton (1):
      arch/mips/kernel/stacktrace.c: Heiko can't type

Heiko Carstens (1):
      fix core/stacktrace changes on avr32, mips, sh

Mike Travis (1):
      kthread: reduce stack pressure in create_kthread and kthreadd


 arch/avr32/kernel/stacktrace.c |    1 +
 arch/mips/kernel/stacktrace.c  |    1 +
 arch/sh/kernel/stacktrace.c    |    1 +
 kernel/kthread.c               |    4 ++--
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/kernel/stacktrace.c b/arch/avr32/kernel/stacktrace.c
index f4bdb44..c09f0d8 100644
--- a/arch/avr32/kernel/stacktrace.c
+++ b/arch/avr32/kernel/stacktrace.c
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 #include <linux/thread_info.h>
+#include <linux/module.h>
 
 register unsigned long current_frame_pointer asm("r7");
 
diff --git a/arch/mips/kernel/stacktrace.c b/arch/mips/kernel/stacktrace.c
index 5eb4681..0632e2a 100644
--- a/arch/mips/kernel/stacktrace.c
+++ b/arch/mips/kernel/stacktrace.c
@@ -7,6 +7,7 @@
  */
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
+#include <linux/module.h>
 #include <asm/stacktrace.h>
 
 /*
diff --git a/arch/sh/kernel/stacktrace.c b/arch/sh/kernel/stacktrace.c
index 1b2ae35..54d1f61 100644
--- a/arch/sh/kernel/stacktrace.c
+++ b/arch/sh/kernel/stacktrace.c
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 #include <linux/thread_info.h>
+#include <linux/module.h>
 #include <asm/ptrace.h>
 
 /*
diff --git a/kernel/kthread.c b/kernel/kthread.c
index ac3fb73..6111c27 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -106,7 +106,7 @@ static void create_kthread(struct kthread_create_info *create)
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed(create->result, CPU_MASK_ALL);
+		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
 	}
 	complete(&create->done);
 }
@@ -233,7 +233,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed(tsk, CPU_MASK_ALL);
+	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
