Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbXGQMXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbXGQMXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbXGQMWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:22:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54893 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759292AbXGQMWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:22:35 -0400
Date: Tue, 17 Jul 2007 14:22:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch] softlockup watchdog: style cleanups
Message-ID: <20070717122229.GA16229@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: softlockup watchdog: style cleanups
From: Ingo Molnar <mingo@elte.hu>

kernel/softirq.c grew a few style uncleanlinesses in the past few 
months, clean that up. No functional changes:

   text    data     bss     dec     hex filename
   1126      76       4    1206     4b6 softlockup.o.before
   1129      76       4    1209     4b9 softlockup.o.after

( the 3 bytes .text increase is due to the "<1>" appended to one of
  the printk messages. )

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -22,7 +22,7 @@ static DEFINE_PER_CPU(unsigned long, tou
 static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
-static int did_panic = 0;
+static int did_panic;
 
 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -121,7 +121,7 @@ void softlockup_tick(void)
 /*
  * The watchdog thread - runs every second and touches the timestamp.
  */
-static int watchdog(void * __bind_cpu)
+static int watchdog(void *__bind_cpu)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
@@ -160,13 +160,13 @@ cpu_callback(struct notifier_block *nfb,
 		BUG_ON(per_cpu(watchdog_task, hotcpu));
 		p = kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
 		if (IS_ERR(p)) {
-			printk("watchdog for %i failed\n", hotcpu);
+			printk(KERN_ERR "watchdog for %i failed\n", hotcpu);
 			return NOTIFY_BAD;
 		}
-  		per_cpu(touch_timestamp, hotcpu) = 0;
-  		per_cpu(watchdog_task, hotcpu) = p;
+		per_cpu(touch_timestamp, hotcpu) = 0;
+		per_cpu(watchdog_task, hotcpu) = p;
 		kthread_bind(p, hotcpu);
- 		break;
+		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		wake_up_process(per_cpu(watchdog_task, hotcpu));
@@ -186,7 +186,7 @@ cpu_callback(struct notifier_block *nfb,
 		kthread_stop(p);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
- 	}
+	}
 	return NOTIFY_OK;
 }
 
