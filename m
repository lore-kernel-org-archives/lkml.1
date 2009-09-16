Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbZIPOqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbZIPOqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZIPOqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:46:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:33446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZIPOqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:46:21 -0400
Date: Wed, 16 Sep 2009 14:45:46 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf sched: Add 'perf sched map' scheduling event map printout
Message-ID: <tip-0ec04e16d08b69d8da46abbcfa3e3f2cd9738852@git.kernel.org>
Git-Commit-ID: 0ec04e16d08b69d8da46abbcfa3e3f2cd9738852
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 14:45:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ec04e16d08b69d8da46abbcfa3e3f2cd9738852
Gitweb:     http://git.kernel.org/tip/0ec04e16d08b69d8da46abbcfa3e3f2cd9738852
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 16 Sep 2009 17:40:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Sep 2009 16:41:30 +0200

perf sched: Add 'perf sched map' scheduling event map printout

This prints a textual context-switching outline of workload
captured via perf sched record.

For example, on a 16 CPU box it outputs:

   N1  O1  .   .   .   S1  .   .   .   B0  .  *I0  C1  .   M1  .    23002.773423 secs
   N1  O1  .  *Q0  .   S1  .   .   .   B0  .   I0  C1  .   M1  .    23002.773423 secs
   N1  O1  .   Q0  .   S1  .   .   .   B0  .  *R1  C1  .   M1  .    23002.773485 secs
   N1  O1  .   Q0  .   S1  .  *S0  .   B0  .   R1  C1  .   M1  .    23002.773478 secs
  *L0  O1  .   Q0  .   S1  .   S0  .   B0  .   R1  C1  .   M1  .    23002.773523 secs
   L0  O1  .  *.   .   S1  .   S0  .   B0  .   R1  C1  .   M1  .    23002.773531 secs
   L0  O1  .   .   .   S1  .   S0  .   B0  .   R1  C1 *T1  M1  .    23002.773547 secs T1 => irqbalance:2089
   L0  O1  .   .   .   S1  .   S0  .  *P0  .   R1  C1  T1  M1  .    23002.773549 secs
  *N1  O1  .   .   .   S1  .   S0  .   P0  .   R1  C1  T1  M1  .    23002.773566 secs
   N1  O1  .   .   .  *J0  .   S0  .   P0  .   R1  C1  T1  M1  .    23002.773571 secs
   N1  O1  .   .   .   J0  .   S0 *B0  P0  .   R1  C1  T1  M1  .    23002.773592 secs
   N1  O1  .   .   .   J0  .  *U0  B0  P0  .   R1  C1  T1  M1  .    23002.773582 secs
   N1  O1  .   .   .  *S1  .   U0  B0  P0  .   R1  C1  T1  M1  .    23002.773604 secs
   N1  O1  .   .   .   S1  .   U0  B0 *.   .   R1  C1  T1  M1  .    23002.773615 secs
   N1  O1  .   .   .   S1  .   U0  B0  .   .  *K0  C1  T1  M1  .    23002.773631 secs
   N1  O1  .  *M0  .   S1  .   U0  B0  .   .   K0  C1  T1  M1  .    23002.773624 secs
   N1  O1  .   M0  .   S1  .   U0 *.   .   .   K0  C1  T1  M1  .    23002.773644 secs
   N1  O1  .   M0  .   S1  .   U0  .   .   .  *R1  C1  T1  M1  .    23002.773662 secs
   N1  O1  .   M0  .   S1  .  *.   .   .   .   R1  C1  T1  M1  .    23002.773648 secs
   N1  O1  .  *.   .   S1  .   .   .   .   .   R1  C1  T1  M1  .    23002.773680 secs
   N1  O1  .   .   .  *L0  .   .   .   .   .   R1  C1  T1  M1  .    23002.773717 secs
  *N0  O1  .   .   .   L0  .   .   .   .   .   R1  C1  T1  M1  .    23002.773709 secs
  *N1  O1  .   .   .   L0  .   .   .   .   .   R1  C1  T1  M1  .    23002.773747 secs

Columns stand for individual CPUs, from CPU0 to CPU15, and the
two-letter shortcuts stand for tasks that are running on a CPU.

'*' denotes the CPU that had the event.

A dot signals an idle CPU.

New tasks are assigned new two-letter shortcuts - when they occur
first they are printed. In the above example 'T1' stood for irqbalance:

      T1 => irqbalance:2089

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-sched.c |  312 ++++++++++++++++++++++++++++++--------------
 tools/perf/util/thread.c   |    2 +-
 tools/perf/util/thread.h   |    1 +
 3 files changed, 214 insertions(+), 101 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index da8f674..f67e351 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -159,8 +159,6 @@ static struct rb_root		atom_root, sorted_atom_root;
 static u64			all_runtime;
 static u64			all_count;
 
-static int read_events(void);
-
 
 static u64 get_nsecs(void)
 {
@@ -634,38 +632,6 @@ static void test_calibrations(void)
 	printf("the sleep test took %Ld nsecs\n", T1-T0);
 }
 
-static void __cmd_replay(void)
-{
-	unsigned long i;
-
-	calibrate_run_measurement_overhead();
-	calibrate_sleep_measurement_overhead();
-
-	test_calibrations();
-
-	read_events();
-
-	printf("nr_run_events:        %ld\n", nr_run_events);
-	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
-	printf("nr_wakeup_events:     %ld\n", nr_wakeup_events);
-
-	if (targetless_wakeups)
-		printf("target-less wakeups:  %ld\n", targetless_wakeups);
-	if (multitarget_wakeups)
-		printf("multi-target wakeups: %ld\n", multitarget_wakeups);
-	if (nr_run_events_optimized)
-		printf("run atoms optimized: %ld\n",
-			nr_run_events_optimized);
-
-	print_task_traces();
-	add_cross_task_wakeups();
-
-	create_tasks();
-	printf("------------------------------------------------------------\n");
-	for (i = 0; i < replay_repeat; i++)
-		run_one_test();
-}
-
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
@@ -1354,64 +1320,6 @@ static void sort_lat(void)
 	}
 }
 
-static void __cmd_lat(void)
-{
-	struct rb_node *next;
-
-	setup_pager();
-	read_events();
-	sort_lat();
-
-	printf("\n -----------------------------------------------------------------------------------------\n");
-	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |\n");
-	printf(" -----------------------------------------------------------------------------------------\n");
-
-	next = rb_first(&sorted_atom_root);
-
-	while (next) {
-		struct work_atoms *work_list;
-
-		work_list = rb_entry(next, struct work_atoms, node);
-		output_lat_thread(work_list);
-		next = rb_next(next);
-	}
-
-	printf(" -----------------------------------------------------------------------------------------\n");
-	printf("  TOTAL:                |%11.3f ms |%9Ld |\n",
-		(double)all_runtime/1e6, all_count);
-
-	printf(" ---------------------------------------------------\n");
-	if (nr_unordered_timestamps && nr_timestamps) {
-		printf("  INFO: %.3f%% unordered timestamps (%ld out of %ld)\n",
-			(double)nr_unordered_timestamps/(double)nr_timestamps*100.0,
-			nr_unordered_timestamps, nr_timestamps);
-	} else {
-	}
-	if (nr_lost_events && nr_events) {
-		printf("  INFO: %.3f%% lost events (%ld out of %ld, in %ld chunks)\n",
-			(double)nr_lost_events/(double)nr_events*100.0,
-			nr_lost_events, nr_events, nr_lost_chunks);
-	}
-	if (nr_state_machine_bugs && nr_timestamps) {
-		printf("  INFO: %.3f%% state machine bugs (%ld out of %ld)",
-			(double)nr_state_machine_bugs/(double)nr_timestamps*100.0,
-			nr_state_machine_bugs, nr_timestamps);
-		if (nr_lost_events)
-			printf(" (due to lost events?)");
-		printf("\n");
-	}
-	if (nr_context_switch_bugs && nr_timestamps) {
-		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
-			(double)nr_context_switch_bugs/(double)nr_timestamps*100.0,
-			nr_context_switch_bugs, nr_timestamps);
-		if (nr_lost_events)
-			printf(" (due to lost events?)");
-		printf("\n");
-	}
-	printf("\n");
-
-}
-
 static struct trace_sched_handler *trace_handler;
 
 static void
@@ -1431,19 +1339,106 @@ process_sched_wakeup_event(struct raw_event_sample *raw,
 	FILL_FIELD(wakeup_event, success, event, raw->data);
 	FILL_FIELD(wakeup_event, cpu, event, raw->data);
 
-	trace_handler->wakeup_event(&wakeup_event, event, cpu, timestamp, thread);
+	if (trace_handler->wakeup_event)
+		trace_handler->wakeup_event(&wakeup_event, event, cpu, timestamp, thread);
 }
 
 /*
  * Track the current task - that way we can know whether there's any
  * weird events, such as a task being switched away that is not current.
  */
+static int max_cpu = 15;
+
 static u32 curr_pid[MAX_CPUS] = { [0 ... MAX_CPUS-1] = -1 };
 
+static struct thread *curr_thread[MAX_CPUS];
+
+static char next_shortname1 = 'A';
+static char next_shortname2 = '0';
+
+static void
+map_switch_event(struct trace_switch_event *switch_event,
+		 struct event *event __used,
+		 int this_cpu,
+		 u64 timestamp,
+		 struct thread *thread __used)
+{
+	struct thread *sched_out, *sched_in;
+	int new_shortname;
+	u64 timestamp0;
+	s64 delta;
+	int cpu;
+
+	BUG_ON(this_cpu >= MAX_CPUS || this_cpu < 0);
+
+	if (this_cpu > max_cpu)
+		max_cpu = this_cpu;
+
+	timestamp0 = cpu_last_switched[this_cpu];
+	cpu_last_switched[this_cpu] = timestamp;
+	if (timestamp0)
+		delta = timestamp - timestamp0;
+	else
+		delta = 0;
+
+	if (delta < 0)
+		die("hm, delta: %Ld < 0 ?\n", delta);
+
+
+	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
+	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
+
+	curr_thread[this_cpu] = sched_in;
+
+	printf("  ");
+
+	new_shortname = 0;
+	if (!sched_in->shortname[0]) {
+		sched_in->shortname[0] = next_shortname1;
+		sched_in->shortname[1] = next_shortname2;
+
+		if (next_shortname1 < 'Z') {
+			next_shortname1++;
+		} else {
+			next_shortname1='A';
+			if (next_shortname2 < '9') {
+				next_shortname2++;
+			} else {
+				next_shortname2='0';
+			}
+		}
+		new_shortname = 1;
+	}
+
+	for (cpu = 0; cpu <= max_cpu; cpu++) {
+		if (cpu != this_cpu)
+			printf(" ");
+		else
+			printf("*");
+
+		if (curr_thread[cpu]) {
+			if (curr_thread[cpu]->pid)
+				printf("%2s ", curr_thread[cpu]->shortname);
+			else
+				printf(".  ");
+		} else
+			printf("   ");
+	}
+
+	printf("  %12.6f secs ", (double)timestamp/1e9);
+	if (new_shortname) {
+		printf("%s => %s:%d\n",
+			sched_in->shortname, sched_in->comm, sched_in->pid);
+	} else {
+		printf("\n");
+	}
+}
+
+
 static void
 process_sched_switch_event(struct raw_event_sample *raw,
 			   struct event *event,
-			   int cpu,
+			   int this_cpu,
 			   u64 timestamp __used,
 			   struct thread *thread __used)
 {
@@ -1459,17 +1454,18 @@ process_sched_switch_event(struct raw_event_sample *raw,
 	FILL_FIELD(switch_event, next_pid, event, raw->data);
 	FILL_FIELD(switch_event, next_prio, event, raw->data);
 
-	if (curr_pid[cpu] != (u32)-1) {
+	if (curr_pid[this_cpu] != (u32)-1) {
 		/*
 		 * Are we trying to switch away a PID that is
 		 * not current?
 		 */
-		if (curr_pid[cpu] != switch_event.prev_pid)
+		if (curr_pid[this_cpu] != switch_event.prev_pid)
 			nr_context_switch_bugs++;
 	}
-	curr_pid[cpu] = switch_event.next_pid;
+	if (trace_handler->switch_event)
+		trace_handler->switch_event(&switch_event, event, this_cpu, timestamp, thread);
 
-	trace_handler->switch_event(&switch_event, event, cpu, timestamp, thread);
+	curr_pid[this_cpu] = switch_event.next_pid;
 }
 
 static void
@@ -1486,7 +1482,8 @@ process_sched_runtime_event(struct raw_event_sample *raw,
 	FILL_FIELD(runtime_event, runtime, event, raw->data);
 	FILL_FIELD(runtime_event, vruntime, event, raw->data);
 
-	trace_handler->runtime_event(&runtime_event, event, cpu, timestamp, thread);
+	if (trace_handler->runtime_event)
+		trace_handler->runtime_event(&runtime_event, event, cpu, timestamp, thread);
 }
 
 static void
@@ -1505,7 +1502,8 @@ process_sched_fork_event(struct raw_event_sample *raw,
 	FILL_ARRAY(fork_event, child_comm, event, raw->data);
 	FILL_FIELD(fork_event, child_pid, event, raw->data);
 
-	trace_handler->fork_event(&fork_event, event, cpu, timestamp, thread);
+	if (trace_handler->fork_event)
+		trace_handler->fork_event(&fork_event, event, cpu, timestamp, thread);
 }
 
 static void
@@ -1748,6 +1746,116 @@ more:
 	return rc;
 }
 
+static void print_bad_events(void)
+{
+	if (nr_unordered_timestamps && nr_timestamps) {
+		printf("  INFO: %.3f%% unordered timestamps (%ld out of %ld)\n",
+			(double)nr_unordered_timestamps/(double)nr_timestamps*100.0,
+			nr_unordered_timestamps, nr_timestamps);
+	}
+	if (nr_lost_events && nr_events) {
+		printf("  INFO: %.3f%% lost events (%ld out of %ld, in %ld chunks)\n",
+			(double)nr_lost_events/(double)nr_events*100.0,
+			nr_lost_events, nr_events, nr_lost_chunks);
+	}
+	if (nr_state_machine_bugs && nr_timestamps) {
+		printf("  INFO: %.3f%% state machine bugs (%ld out of %ld)",
+			(double)nr_state_machine_bugs/(double)nr_timestamps*100.0,
+			nr_state_machine_bugs, nr_timestamps);
+		if (nr_lost_events)
+			printf(" (due to lost events?)");
+		printf("\n");
+	}
+	if (nr_context_switch_bugs && nr_timestamps) {
+		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
+			(double)nr_context_switch_bugs/(double)nr_timestamps*100.0,
+			nr_context_switch_bugs, nr_timestamps);
+		if (nr_lost_events)
+			printf(" (due to lost events?)");
+		printf("\n");
+	}
+}
+
+static void __cmd_lat(void)
+{
+	struct rb_node *next;
+
+	setup_pager();
+	read_events();
+	sort_lat();
+
+	printf("\n -----------------------------------------------------------------------------------------\n");
+	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |\n");
+	printf(" -----------------------------------------------------------------------------------------\n");
+
+	next = rb_first(&sorted_atom_root);
+
+	while (next) {
+		struct work_atoms *work_list;
+
+		work_list = rb_entry(next, struct work_atoms, node);
+		output_lat_thread(work_list);
+		next = rb_next(next);
+	}
+
+	printf(" -----------------------------------------------------------------------------------------\n");
+	printf("  TOTAL:                |%11.3f ms |%9Ld |\n",
+		(double)all_runtime/1e6, all_count);
+
+	printf(" ---------------------------------------------------\n");
+
+	print_bad_events();
+	printf("\n");
+
+}
+
+static struct trace_sched_handler map_ops  = {
+	.wakeup_event		= NULL,
+	.switch_event		= map_switch_event,
+	.runtime_event		= NULL,
+	.fork_event		= NULL,
+};
+
+static void __cmd_map(void)
+{
+	setup_pager();
+	read_events();
+	print_bad_events();
+}
+
+static void __cmd_replay(void)
+{
+	unsigned long i;
+
+	calibrate_run_measurement_overhead();
+	calibrate_sleep_measurement_overhead();
+
+	test_calibrations();
+
+	read_events();
+
+	printf("nr_run_events:        %ld\n", nr_run_events);
+	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
+	printf("nr_wakeup_events:     %ld\n", nr_wakeup_events);
+
+	if (targetless_wakeups)
+		printf("target-less wakeups:  %ld\n", targetless_wakeups);
+	if (multitarget_wakeups)
+		printf("multi-target wakeups: %ld\n", multitarget_wakeups);
+	if (nr_run_events_optimized)
+		printf("run atoms optimized: %ld\n",
+			nr_run_events_optimized);
+
+	print_task_traces();
+	add_cross_task_wakeups();
+
+	create_tasks();
+	printf("------------------------------------------------------------\n");
+	for (i = 0; i < replay_repeat; i++)
+		run_one_test();
+}
+
+
 static const char * const sched_usage[] = {
 	"perf sched [<options>] {record|latency|replay|trace}",
 	NULL
@@ -1867,6 +1975,10 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 		}
 		setup_sorting();
 		__cmd_lat();
+	} else if (!strcmp(argv[0], "map")) {
+		trace_handler = &map_ops;
+		setup_sorting();
+		__cmd_map();
 	} else if (!strncmp(argv[0], "rep", 3)) {
 		trace_handler = &replay_ops;
 		if (argc) {
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 12c4341..45efb5d 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -8,7 +8,7 @@
 
 static struct thread *thread__new(pid_t pid)
 {
-	struct thread *self = malloc(sizeof(*self));
+	struct thread *self = calloc(1, sizeof(*self));
 
 	if (self != NULL) {
 		self->pid = pid;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 665d1f3..32aea3c 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -7,6 +7,7 @@ struct thread {
 	struct rb_node		rb_node;
 	struct list_head	maps;
 	pid_t			pid;
+	char			shortname[3];
 	char			*comm;
 };
 
