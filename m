Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbZCHQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbZCHQC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZCHQCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:02:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:44384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZCHQCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:02:19 -0400
Date: Sun, 8 Mar 2009 16:00:28 GMT
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <20090308124421.23C3.A69D9226@jp.fujitsu.com>
References: <20090308124421.23C3.A69D9226@jp.fujitsu.com>
Subject: [tip:tracing/ftrace] ftrace: tracing header should put '#' at the beginning of a line
Message-ID: <tip-888b55dc314d26239d84c3b187dae555a81c1605@git.kernel.org>
Git-Commit-ID: 888b55dc314d26239d84c3b187dae555a81c1605
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 16:00:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  888b55dc314d26239d84c3b187dae555a81c1605
Gitweb:     http://git.kernel.org/tip/888b55dc314d26239d84c3b187dae555a81c1605
Author:     "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Sun, 8 Mar 2009 13:12:43 +0900
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Mar 2009 16:57:22 +0100

ftrace: tracing header should put '#' at the beginning of a line

In a recent discussion, Andrew Morton pointed out that tracing header
should put '#' at the beginning of a line.

Then, we can easily filtered the header by following grep usage:

  cat trace | grep -v '^#'

Wakeup trace also has the same header problem.

Comparison of headers displayed:

before this patch:

 # tracer: wakeup
 #
 wakeup latency trace v1.1.5 on 2.6.29-rc7-tip-tip
 --------------------------------------------------------------------
  latency: 19059 us, #21277/21277, CPU#1 | (M:desktop VP:0, KP:0, SP:0 HP:0 #P:4)
     -----------------
     | task: kondemand/1-1644 (uid:0 nice:-5 policy:0 rt_prio:0)
     -----------------

 #                  _------=> CPU#
 #                 / _-----=> irqs-off
 #                | / _----=> need-resched
 #                || / _---=> hardirq/softirq
 #                ||| / _--=> preempt-depth
 #                |||| /
 #                |||||     delay
 #  cmd     pid   ||||| time  |   caller
 #     \   /      |||||   \   |   /
 irqbalan-1887    1d.s.    0us :   1887:120:R   + [001]  1644:115:S kondemand/1
 irqbalan-1887    1d.s.    1us : default_wake_function <-autoremove_wake_function
 irqbalan-1887    1d.s.    2us : check_preempt_wakeup <-try_to_wake_up

after this patch:

 # tracer: wakeup
 #
 # wakeup latency trace v1.1.5 on 2.6.29-rc7-tip-tip
 # --------------------------------------------------------------------
 # latency: 529 us, #530/530, CPU#0 | (M:desktop VP:0, KP:0, SP:0 HP:0 #P:4)
 #    -----------------
 #    | task: kondemand/0-1641 (uid:0 nice:-5 policy:0 rt_prio:0)
 #    -----------------
 #
 #                  _------=> CPU#
 #                 / _-----=> irqs-off
 #                | / _----=> need-resched
 #                || / _---=> hardirq/softirq
 #                ||| / _--=> preempt-depth
 #                |||| /
 #                |||||     delay
 #  cmd     pid   ||||| time  |   caller
 #     \   /      |||||   \   |   /
     sshd-2496    0d.s.    0us :   2496:120:R   + [000]  1641:115:S kondemand/0
     sshd-2496    0d.s.    1us : default_wake_function <-autoremove_wake_function
     sshd-2496    0d.s.    1us : check_preempt_wakeup <-try_to_wake_up

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20090308124421.23C3.A69D9226@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cc94f86..e5b5619 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1466,11 +1466,11 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 	total = entries +
 		ring_buffer_overruns(iter->tr->buffer);
 
-	seq_printf(m, "%s latency trace v1.1.5 on %s\n",
+	seq_printf(m, "# %s latency trace v1.1.5 on %s\n",
 		   name, UTS_RELEASE);
-	seq_puts(m, "-----------------------------------"
+	seq_puts(m, "# -----------------------------------"
 		 "---------------------------------\n");
-	seq_printf(m, " latency: %lu us, #%lu/%lu, CPU#%d |"
+	seq_printf(m, "# latency: %lu us, #%lu/%lu, CPU#%d |"
 		   " (M:%s VP:%d, KP:%d, SP:%d HP:%d",
 		   nsecs_to_usecs(data->saved_latency),
 		   entries,
@@ -1492,24 +1492,24 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 #else
 	seq_puts(m, ")\n");
 #endif
-	seq_puts(m, "    -----------------\n");
-	seq_printf(m, "    | task: %.16s-%d "
+	seq_puts(m, "#    -----------------\n");
+	seq_printf(m, "#    | task: %.16s-%d "
 		   "(uid:%d nice:%ld policy:%ld rt_prio:%ld)\n",
 		   data->comm, data->pid, data->uid, data->nice,
 		   data->policy, data->rt_priority);
-	seq_puts(m, "    -----------------\n");
+	seq_puts(m, "#    -----------------\n");
 
 	if (data->critical_start) {
-		seq_puts(m, " => started at: ");
+		seq_puts(m, "#  => started at: ");
 		seq_print_ip_sym(&iter->seq, data->critical_start, sym_flags);
 		trace_print_seq(m, &iter->seq);
-		seq_puts(m, "\n => ended at:   ");
+		seq_puts(m, "\n#  => ended at:   ");
 		seq_print_ip_sym(&iter->seq, data->critical_end, sym_flags);
 		trace_print_seq(m, &iter->seq);
-		seq_puts(m, "\n");
+		seq_puts(m, "#\n");
 	}
 
-	seq_puts(m, "\n");
+	seq_puts(m, "#\n");
 }
 
 static void test_cpu_buff_start(struct trace_iterator *iter)
