Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZIBTcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZIBTcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 15:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZIBTcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 15:32:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:33063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZIBTcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 15:32:41 -0400
Date: Wed, 2 Sep 2009 19:31:51 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, lizf@cn.fujitsu.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf trace: Sample the CPU too
Message-ID: <tip-cd6feeeafddbef6abfe4d90fb26e42fd844d34ed@git.kernel.org>
Git-Commit-ID: cd6feeeafddbef6abfe4d90fb26e42fd844d34ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 19:31:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd6feeeafddbef6abfe4d90fb26e42fd844d34ed
Gitweb:     http://git.kernel.org/tip/cd6feeeafddbef6abfe4d90fb26e42fd844d34ed
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 2 Sep 2009 20:20:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Sep 2009 21:28:50 +0200

perf trace: Sample the CPU too

Sample, record, parse and print the CPU field - it had all zeroes before.

Before (watch the second column, the CPU values):

            perf-32685 [000]     0.000000: sched_wakeup_new: task perf:32686 [120] success=1 [011]
            perf-32685 [000]     0.000000: sched_migrate_task: task perf:32685 [120] from: 1  to: 11
            perf-32685 [000]     0.000000: sched_process_fork: parent perf:32685  child perf:32686
            true-32686 [000]     0.000000: sched_wakeup: task migration/11:25 [0] success=1 [011]
            true-32686 [000]     0.000000: sched_wakeup: task distccd:12793 [125] success=1 [015]
            true-32686 [000]     0.000000: sched_wakeup: task distccd:12793 [125] success=1 [015]
            perf-32685 [000]     0.000000: sched_switch: task perf:32685 [120] (S) ==> swapper:0 [140]
            true-32686 [000]     0.000000: sched_switch: task perf:32686 [120] (R) ==> migration/11:25 [0]
            true-32686 [000]     0.000000: sched_switch: task perf:32686 [120] (R) ==> distccd:12793 [125]
            true-32686 [000]     0.000000: sched_switch: task true:32686 [120] (R) ==> distccd:12793 [125]
            true-32686 [000]     0.000000: sched_process_exit: task true:32686 [120]
            true-32686 [000]     0.000000: sched_stat_wait: task: distccd:12793 wait: 6767985949080 [ns]
            true-32686 [000]     0.000000: sched_stat_wait: task: distccd:12793 wait: 6767986139446 [ns]
            true-32686 [000]     0.000000: sched_stat_sleep: task: distccd:12793 sleep: 132844 [ns]
            true-32686 [000]     0.000000: sched_stat_sleep: task: distccd:12793 sleep: 131724 [ns]

After:

            perf-32685 [001]     0.000000: sched_wakeup_new: task perf:32686 [120] success=1 [011]
            perf-32685 [001]     0.000000: sched_migrate_task: task perf:32685 [120] from: 1  to: 11
            perf-32685 [001]     0.000000: sched_process_fork: parent perf:32685  child perf:32686
            true-32686 [011]     0.000000: sched_wakeup: task migration/11:25 [0] success=1 [011]
            true-32686 [015]     0.000000: sched_wakeup: task distccd:12793 [125] success=1 [015]
            true-32686 [015]     0.000000: sched_wakeup: task distccd:12793 [125] success=1 [015]
            perf-32685 [001]     0.000000: sched_switch: task perf:32685 [120] (S) ==> swapper:0 [140]
            true-32686 [011]     0.000000: sched_switch: task perf:32686 [120] (R) ==> migration/11:25 [0]
            true-32686 [015]     0.000000: sched_switch: task perf:32686 [120] (R) ==> distccd:12793 [125]
            true-32686 [015]     0.000000: sched_switch: task true:32686 [120] (R) ==> distccd:12793 [125]
            true-32686 [015]     0.000000: sched_process_exit: task true:32686 [120]
            true-32686 [015]     0.000000: sched_stat_wait: task: distccd:12793 wait: 6767985949080 [ns]
            true-32686 [015]     0.000000: sched_stat_wait: task: distccd:12793 wait: 6767986139446 [ns]
            true-32686 [015]     0.000000: sched_stat_sleep: task: distccd:12793 sleep: 132844 [ns]
            true-32686 [015]     0.000000: sched_stat_sleep: task: distccd:12793 sleep: 131724 [ns]

So we can now see how this workload migrated between CPUs.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-record.c |    4 +++-
 tools/perf/builtin-trace.c  |    9 ++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index add514d..ff93f8e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -403,8 +403,10 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
-	if (raw_samples)
+	if (raw_samples) {
 		attr->sample_type	|= PERF_SAMPLE_RAW;
+		attr->sample_type	|= PERF_SAMPLE_CPU;
+	}
 
 	attr->mmap		= track;
 	attr->comm		= track;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8247fd0..bbe4c44 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -58,12 +58,19 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 	struct dso *dso = NULL;
 	struct thread *thread;
 	u64 ip = event->ip.ip;
+	u32 cpu = -1;
 	u64 period = 1;
 	void *more_data = event->ip.__more_data;
 	int cpumode;
 
 	thread = threads__findnew(event->ip.pid, &threads, &last_match);
 
+	if (sample_type & PERF_SAMPLE_CPU) {
+		cpu = *(u32 *)more_data;
+		more_data += sizeof(u32);
+		more_data += sizeof(u32); /* reserved */
+	}
+
 	if (sample_type & PERF_SAMPLE_PERIOD) {
 		period = *(u64 *)more_data;
 		more_data += sizeof(u64);
@@ -120,7 +127,7 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		 * field, although it should be the same than this perf
 		 * event pid
 		 */
-		print_event(0, raw->data, raw->size, 0, thread->comm);
+		print_event(cpu, raw->data, raw->size, 0, thread->comm);
 	}
 	total += period;
 
