Return-Path: <linux-kernel-owner+w=401wt.eu-S967253AbXEGXcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967253AbXEGXcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967244AbXEGXcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:32:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60525
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S967219AbXEGXbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:31:55 -0400
Date: Mon, 07 May 2007 16:31:58 -0700 (PDT)
Message-Id: <20070507.163158.15266850.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org
Subject: [PATCH]: Fix printk format warnings in timer_list.c
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


u64 and s64 are not necessarily 'long long' on some 64-bit
platforms, so explicit the type to kill the compiler warnings.

Also consistently use '%Lu' which is unsigned.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 59df5e8..d7ed3a1 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -70,7 +70,7 @@ print_timer(struct seq_file *m, struct hrtimer *timer, int idx, u64 now)
 	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
 #endif
 	SEQ_printf(m, "\n");
-	SEQ_printf(m, " # expires at %Ld nsecs [in %Ld nsecs]\n",
+	SEQ_printf(m, " # expires at %Lu nsecs [in %Lu nsecs]\n",
 		(unsigned long long)ktime_to_ns(timer->expires),
 		(unsigned long long)(ktime_to_ns(timer->expires) - now));
 }
@@ -116,14 +116,14 @@ print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
 {
 	SEQ_printf(m, "  .index:      %d\n",
 			base->index);
-	SEQ_printf(m, "  .resolution: %Ld nsecs\n",
+	SEQ_printf(m, "  .resolution: %Lu nsecs\n",
 			(unsigned long long)ktime_to_ns(base->resolution));
 	SEQ_printf(m,   "  .get_time:   ");
 	print_name_offset(m, base->get_time);
 	SEQ_printf(m,   "\n");
 #ifdef CONFIG_HIGH_RES_TIMERS
-	SEQ_printf(m, "  .offset:     %Ld nsecs\n",
-			ktime_to_ns(base->offset));
+	SEQ_printf(m, "  .offset:     %Lu nsecs\n",
+		   (unsigned long long) ktime_to_ns(base->offset));
 #endif
 	SEQ_printf(m,   "active timers:\n");
 	print_active_timers(m, base, now);
@@ -140,10 +140,11 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		print_base(m, cpu_base->clock_base + i, now);
 	}
 #define P(x) \
-	SEQ_printf(m, "  .%-15s: %Ld\n", #x, (u64)(cpu_base->x))
+	SEQ_printf(m, "  .%-15s: %Lu\n", #x, \
+		   (unsigned long long)(cpu_base->x))
 #define P_ns(x) \
-	SEQ_printf(m, "  .%-15s: %Ld nsecs\n", #x, \
-		(u64)(ktime_to_ns(cpu_base->x)))
+	SEQ_printf(m, "  .%-15s: %Lu nsecs\n", #x, \
+		   (unsigned long long)(ktime_to_ns(cpu_base->x)))
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 	P_ns(expires_next);
@@ -155,10 +156,11 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 
 #ifdef CONFIG_TICK_ONESHOT
 # define P(x) \
-	SEQ_printf(m, "  .%-15s: %Ld\n", #x, (u64)(ts->x))
+	SEQ_printf(m, "  .%-15s: %Lu\n", #x, \
+		   (unsigned long long)(ts->x))
 # define P_ns(x) \
-	SEQ_printf(m, "  .%-15s: %Ld nsecs\n", #x, \
-		(u64)(ktime_to_ns(ts->x)))
+	SEQ_printf(m, "  .%-15s: %Lu nsecs\n", #x, \
+		   (unsigned long long)(ktime_to_ns(ts->x)))
 	{
 		struct tick_sched *ts = tick_get_tick_sched(cpu);
 		P(nohz_mode);
@@ -172,7 +174,8 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		P(last_jiffies);
 		P(next_jiffies);
 		P_ns(idle_expires);
-		SEQ_printf(m, "jiffies: %Ld\n", (u64)jiffies);
+		SEQ_printf(m, "jiffies: %Lu\n",
+			   (unsigned long long)jiffies);
 	}
 #endif
 
