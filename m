Return-Path: <linux-kernel-owner+w=401wt.eu-S1762970AbZLPTTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762970AbZLPTTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935273AbZLPTTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:19:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760928AbZLPTTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:19:49 -0500
Date: Wed, 16 Dec 2009 20:18:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC GIT PULL] perf updates/fixes
Message-ID: <20091216191858.GA8554@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please consider pulling the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

I marked it RFC because it includes a fair amount of last-minute activity:

  - performance fixes for inherited recording on lots of CPUs

  - usability fixes and enhancements to perf probe

  - fixes to the perf trace scripting engine

  - new 'perf diff' tool - compares the profiles of the last two
    "perf record -f" sessions

95% of the changes are to tools/perf/, not to the kernel itself.

The reason we'd like this to happen still in this cycle is that 'perf diff' is 
both tempting from a feature POV and wide from a patch surface POV. (ok, i'll 
admit the former reason weighs more heavily for me :-/ )

It has passed the regular cross-build and x86 runtime tests we do.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (25):
      perf session: Pass the perf_session to the event handling operations
      perf session: Ditch register_perf_file_handler
      perf session: Register the idle thread in perf_session__process_events
      perf session: Reduce the number of parms to perf_session__process_events
      perf session: Move the global threads list to perf_session
      perf session: Move kmaps to perf_session
      perf tools: No need for three rb_trees for sorting hist entries
      perf session: Move the hist_entries rb tree to perf_session
      perf session: Adopt resolve_callchain
      perf session: Adopt the sample_type variable
      perf session: Event statistics also are per session
      perf util: Remove setup_sorting dups
      perf record: Rename perf.data to perf.data.old if --force/-f is used
      perf diff: Introduce tool to show performance difference
      perf diff: Fix documentation
      perf symbols: Make symbol_conf global
      perf symbols: Adopt the strlists for dso, comm
      perf symbols: Move symbol filtering to event__preprocess_sample()
      perf report: Generalize perf_session__fprintf_hists()
      perf tools: Move hist entries printing routines from perf report
      perf session: Move perf report specific hits out of perf_session__fprintf_hists
      perf report: Fix cut'n'paste error recently introduced
      perf diff: Use perf_session__fprintf_hists just like 'perf record'
      perf diff: Change the default sort order to "dso,symbol"
      perf diff: Percent calcs should use double values

Frederic Weisbecker (1):
      perf tools: Make symbol_conf static

Ingo Molnar (1):
      perf diff: Improve the help text

Masami Hiramatsu (14):
      perf probe: Cleanup struct session in builtin-probe.c
      perf probe: Check the result of e_snprintf()
      perf probe: Check hyphen only argument
      perf probe: Show need-dwarf message only if it is really needed
      perf probe: Fix --del to show info instead of warning
      perf probe: Fix --del to update current event list
      perf tools: Add for_each macros for strlist
      perf probe: Use strlist__for_each macros in probe-event.c
      perf probe: Add glob matching support on --del
      perf probe: Support event name for --add option
      perf probe: Reject second attempt of adding same-name event
      perf probe: Check build-id of vmlinux
      perf probe: Check symbols in symtab/kallsyms
      perf probe: Fix to show which probe point is not found

Paul Mackerras (1):
      perf_event: Fix incorrect range check on cpu number

Peter Zijlstra (4):
      perf_events: Fix perf_event_attr layout
      perf events: Allow per-task-per-cpu counters
      perf record: Properly synchronize child creation
      perf record: Use per-task-per-cpu events for inherited events

Tom Zanussi (6):
      perf trace/scripting: Add support for script args
      perf trace/scripting: Don't install unneeded files
      perf trace/scripting: Check return val of perl_run()
      perf trace/scripting: List available scripts
      perf trace/scripting: Add 'record' and 'report' options
      perf trace/scripting: Update Documentation


 include/linux/perf_event.h                         |   12 +-
 kernel/perf_event.c                                |   15 +-
 tools/perf/Documentation/perf-diff.txt             |   55 ++
 tools/perf/Documentation/perf-probe.txt            |    3 +-
 tools/perf/Documentation/perf-report.txt           |    4 +
 tools/perf/Documentation/perf-trace.txt            |   27 +-
 tools/perf/Makefile                                |    4 +-
 tools/perf/builtin-annotate.c                      |   66 +--
 tools/perf/builtin-buildid-list.c                  |    4 +-
 tools/perf/builtin-diff.c                          |  248 +++++++
 tools/perf/builtin-kmem.c                          |   64 +-
 tools/perf/builtin-probe.c                         |  141 +++--
 tools/perf/builtin-record.c                        |  141 +++--
 tools/perf/builtin-report.c                        |  723 ++------------------
 tools/perf/builtin-sched.c                         |   93 ++--
 tools/perf/builtin-timechart.c                     |   59 +-
 tools/perf/builtin-top.c                           |   45 +-
 tools/perf/builtin-trace.c                         |  349 +++++++++--
 tools/perf/builtin.h                               |    1 +
 tools/perf/command-list.txt                        |    1 +
 tools/perf/perf.c                                  |    1 +
 .../perf/scripts/perl/bin/check-perf-trace-report  |    1 +
 tools/perf/scripts/perl/bin/rw-by-file-report      |    4 +-
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    1 +
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    1 +
 tools/perf/scripts/perl/bin/workqueue-stats-report |    1 +
 tools/perf/scripts/perl/rw-by-file.pl              |    5 +-
 tools/perf/util/data_map.c                         |   96 ++--
 tools/perf/util/data_map.h                         |   29 -
 tools/perf/util/event.c                            |  142 +++-
 tools/perf/util/event.h                            |   36 +-
 tools/perf/util/header.c                           |    2 +-
 tools/perf/util/hist.c                             |  518 +++++++++++++-
 tools/perf/util/hist.h                             |   55 +--
 tools/perf/util/map.c                              |   18 +-
 tools/perf/util/probe-event.c                      |  207 ++++--
 tools/perf/util/probe-event.h                      |   11 +-
 tools/perf/util/probe-finder.c                     |    4 +-
 tools/perf/util/probe-finder.h                     |    3 +
 tools/perf/util/session.c                          |   84 +++-
 tools/perf/util/session.h                          |   45 ++
 tools/perf/util/sort.c                             |   26 +
 tools/perf/util/sort.h                             |   12 +-
 tools/perf/util/string.c                           |   25 +
 tools/perf/util/string.h                           |    2 +
 tools/perf/util/strlist.c                          |    6 +-
 tools/perf/util/strlist.h                          |   41 ++-
 tools/perf/util/symbol.c                           |  144 +++--
 tools/perf/util/symbol.h                           |   34 +-
 tools/perf/util/thread.c                           |   37 +-
 tools/perf/util/thread.h                           |   16 +-
 tools/perf/util/trace-event-perl.c                 |   42 +-
 tools/perf/util/trace-event.h                      |    2 +-
 53 files changed, 2293 insertions(+), 1413 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-diff.txt
 create mode 100644 tools/perf/builtin-diff.c
 delete mode 100644 tools/perf/util/data_map.h

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 64a53f7..5fcbf7d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -211,17 +211,11 @@ struct perf_event_attr {
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
 
-	struct { /* Hardware breakpoint info */
-		__u64		bp_addr;
-		__u32		bp_type;
-		__u32		bp_len;
-		__u64		__bp_reserved_1;
-		__u64		__bp_reserved_2;
-	};
-
 	__u32			__reserved_2;
 
-	__u64			__reserved_3;
+	__u64			bp_addr;
+	__u32			bp_type;
+	__u32			bp_len;
 };
 
 /*
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index d891ec4..2e0aaa3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -782,6 +782,9 @@ static void __perf_install_in_context(void *info)
 
 	add_event_to_ctx(event, ctx);
 
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		goto unlock;
+
 	/*
 	 * Don't put the event on if it is disabled or if
 	 * it is in a group and the group isn't on.
@@ -925,6 +928,9 @@ static void __perf_event_enable(void *info)
 		goto unlock;
 	__perf_event_mark_enabled(event, ctx);
 
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		goto unlock;
+
 	/*
 	 * If the event is in a group and isn't the group leader,
 	 * then don't put it on unless the group is on.
@@ -1595,15 +1601,12 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
 	unsigned long flags;
 	int err;
 
-	/*
-	 * If cpu is not a wildcard then this is a percpu event:
-	 */
-	if (cpu != -1) {
+	if (pid == -1 && cpu != -1) {
 		/* Must be root to operate on a CPU event: */
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
 
-		if (cpu < 0 || cpu > num_possible_cpus())
+		if (cpu < 0 || cpu >= nr_cpumask_bits)
 			return ERR_PTR(-EINVAL);
 
 		/*
@@ -4564,7 +4567,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (attr->type >= PERF_TYPE_MAX)
 		return -EINVAL;
 
-	if (attr->__reserved_1 || attr->__reserved_2 || attr->__reserved_3)
+	if (attr->__reserved_1 || attr->__reserved_2)
 		return -EINVAL;
 
 	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))
diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
new file mode 100644
index 0000000..8974e20
--- /dev/null
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -0,0 +1,55 @@
+perf-diff(1)
+==============
+
+NAME
+----
+perf-diff - Read two perf.data files and display the differential profile
+
+SYNOPSIS
+--------
+[verse]
+'perf diff' [oldfile] [newfile]
+
+DESCRIPTION
+-----------
+This command displays the performance difference amongst two perf.data files
+captured via perf record.
+
+If no parameters are passed it will assume perf.data.old and perf.data.
+
+OPTIONS
+-------
+-d::
+--dsos=::
+	Only consider symbols in these dsos. CSV that understands
+	file://filename entries.
+
+-C::
+--comms=::
+	Only consider symbols in these comms. CSV that understands
+	file://filename entries.
+
+-S::
+--symbols=::
+	Only consider these symbols. CSV that understands
+	file://filename entries.
+
+-s::
+--sort=::
+	Sort by key(s): pid, comm, dso, symbol.
+
+-t::
+--field-separator=::
+
+	Use a special separator character and don't pad with spaces, replacing
+	all occurances of this separator in symbol names (and other output)
+	with a '.' character, that thus it's the only non valid separator.
+
+-v::
+--verbose::
+	Be verbose, for instance, show the raw counts in addition to the
+	diff.
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 8fa6bf9..250e391 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -49,8 +49,9 @@ PROBE SYNTAX
 ------------
 Probe points are defined by following syntax.
 
- "FUNC[+OFFS|:RLN|%return][@SRC]|SRC:ALN [ARG ...]"
+ "[EVENT=]FUNC[+OFFS|:RLN|%return][@SRC]|SRC:ALN [ARG ...]"
 
+'EVENT' specifies the name of new event, if omitted, it will be set the name of the probed function. Currently, event group name is set as 'probe'.
 'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, 'RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. In addition, 'SRC' specifies a source file which has that function.
 It is also possible to specify a probe point by the source line number by using 'SRC:ALN' syntax, where 'SRC' is the source file path and 'ALN' is the line number.
 'ARG' specifies the arguments of this probe point. You can use the name of local variable, or kprobe-tracer argument format (e.g. $retval, %ax, etc).
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 9dccb18..abfabe9 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -39,6 +39,10 @@ OPTIONS
 	Only consider these symbols. CSV that understands
 	file://filename entries.
 
+-s::
+--sort=::
+	Sort by key(s): pid, comm, dso, symbol, parent.
+
 -w::
 --field-width=::
 	Force each column width to the provided list, for large terminal
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 07065ef..60e5900 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -8,18 +8,43 @@ perf-trace - Read perf.data (created by perf record) and display trace output
 SYNOPSIS
 --------
 [verse]
-'perf trace' [-i <file> | --input=file] symbol_name
+'perf trace' {record <script> | report <script> [args] }
 
 DESCRIPTION
 -----------
 This command reads the input file and displays the trace recorded.
 
+There are several variants of perf trace:
+
+  'perf trace' to see a detailed trace of the workload that was
+  recorded.
+
+  'perf trace record <script>' to record the events required for 'perf
+  trace report'.  <script> is the name displayed in the output of
+  'perf trace --list' i.e. the actual script name minus any language
+  extension.
+
+  'perf trace report <script>' to run and display the results of
+  <script>.  <script> is the name displayed in the output of 'perf
+  trace --list' i.e. the actual script name minus any language
+  extension.  The perf.data output from a previous run of 'perf trace
+  record <script>' is used and should be present for this command to
+  succeed.
+
 OPTIONS
 -------
 -D::
 --dump-raw-trace=::
         Display verbose dump of the trace data.
 
+-L::
+--Latency=::
+        Show latency attributes (irqs/preemption disabled, etc).
+
+-l::
+--list=::
+        Display a list of available trace scripts.
+
 -s::
 --script=::
         Process trace data with the given script ([lang]:script[.ext]).
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4069996..7814dbb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -370,7 +370,6 @@ LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
-LIB_H += util/data_map.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 
@@ -428,6 +427,7 @@ BUILTIN_OBJS += bench/sched-messaging.o
 BUILTIN_OBJS += bench/sched-pipe.o
 BUILTIN_OBJS += bench/mem-memcpy.o
 
+BUILTIN_OBJS += builtin-diff.o
 BUILTIN_OBJS += builtin-help.o
 BUILTIN_OBJS += builtin-sched.o
 BUILTIN_OBJS += builtin-buildid-list.o
@@ -996,8 +996,6 @@ install: all
 	$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
 	$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
-	$(INSTALL) scripts/perl/Perf-Trace-Util/Makefile.PL -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util'
-	$(INSTALL) scripts/perl/Perf-Trace-Util/README -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util'
 ifdef BUILT_INS
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(BUILT_INS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 21a78d3..593ff25 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -26,7 +26,6 @@
 #include "util/sort.h"
 #include "util/hist.h"
 #include "util/session.h"
-#include "util/data_map.h"
 
 static char		const *input_name = "perf.data";
 
@@ -52,11 +51,6 @@ struct sym_priv {
 	struct sym_ext	*ext;
 };
 
-static struct symbol_conf symbol_conf = {
-	.priv_size	  = sizeof(struct sym_priv),
-	.try_vmlinux_path = true,
-};
-
 static const char *sym_hist_filter;
 
 static int symbol_filter(struct map *map __used, struct symbol *sym)
@@ -122,30 +116,32 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 			h->ip[offset]);
 }
 
-static int hist_entry__add(struct addr_location *al, u64 count)
+static int perf_session__add_hist_entry(struct perf_session *self,
+					struct addr_location *al, u64 count)
 {
 	bool hit;
-	struct hist_entry *he = __hist_entry__add(al, NULL, count, &hit);
+	struct hist_entry *he = __perf_session__add_hist_entry(self, al, NULL,
+							       count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
 	hist_hit(he, al->addr);
 	return 0;
 }
 
-static int process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct addr_location al;
 
 	dump_printf("(IP, %d): %d: %p\n", event->header.misc,
 		    event->ip.pid, (void *)(long)event->ip.ip);
 
-	if (event__preprocess_sample(event, &al, symbol_filter) < 0) {
+	if (event__preprocess_sample(event, session, &al, symbol_filter) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
 
-	if (hist_entry__add(&al, 1)) {
+	if (!al.filtered && perf_session__add_hist_entry(session, &al, 1)) {
 		fprintf(stderr, "problem incrementing symbol count, "
 				"skipping event\n");
 		return -1;
@@ -429,11 +425,11 @@ static void annotate_sym(struct hist_entry *he)
 		free_source_line(he, len);
 }
 
-static void find_annotations(void)
+static void perf_session__find_annotations(struct perf_session *self)
 {
 	struct rb_node *nd;
 
-	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
 		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
 		struct sym_priv *priv;
 
@@ -454,7 +450,7 @@ static void find_annotations(void)
 	}
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_mmap_event	= event__process_mmap,
 	.process_comm_event	= event__process_comm,
@@ -463,17 +459,14 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_annotate(void)
 {
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, force);
-	struct thread *idle;
 	int ret;
+	struct perf_session *session;
 
+	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
 		return -ENOMEM;
 
-	idle = register_idle_thread();
-	register_perf_file_handler(&file_handler);
-
-	ret = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
 
@@ -483,15 +476,14 @@ static int __cmd_annotate(void)
 	}
 
 	if (verbose > 3)
-		threads__fprintf(stdout);
+		perf_session__fprintf(session, stdout);
 
 	if (verbose > 2)
 		dsos__fprintf(stdout);
 
-	collapse__resort();
-	output__resort(event__total[0]);
-
-	find_annotations();
+	perf_session__collapse_resort(session);
+	perf_session__output_resort(session, session->event_total[0]);
+	perf_session__find_annotations(session);
 out_delete:
 	perf_session__delete(session);
 
@@ -524,29 +516,17 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-static void setup_sorting(void)
+int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 {
-	char *tmp, *tok, *str = strdup(sort_order);
-
-	for (tok = strtok_r(str, ", ", &tmp);
-			tok; tok = strtok_r(NULL, ", ", &tmp)) {
-		if (sort_dimension__add(tok) < 0) {
-			error("Unknown --sort key: `%s'", tok);
-			usage_with_options(annotate_usage, options);
-		}
-	}
+	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
-	free(str);
-}
+	symbol_conf.priv_size = sizeof(struct sym_priv);
+	symbol_conf.try_vmlinux_path = true;
 
-int cmd_annotate(int argc, const char **argv, const char *prefix __used)
-{
-	if (symbol__init(&symbol_conf) < 0)
+	if (symbol__init() < 0)
 		return -1;
 
-	argc = parse_options(argc, argv, options, annotate_usage, 0);
-
-	setup_sorting();
+	setup_sorting(annotate_usage, options);
 
 	if (argc) {
 		/*
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index bfd16a1..e693e67 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -9,7 +9,6 @@
 #include "builtin.h"
 #include "perf.h"
 #include "util/cache.h"
-#include "util/data_map.h"
 #include "util/debug.h"
 #include "util/parse-options.h"
 #include "util/session.h"
@@ -55,8 +54,9 @@ static int perf_file_section__process_buildids(struct perf_file_section *self,
 static int __cmd_buildid_list(void)
 {
 	int err = -1;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, force);
+	struct perf_session *session;
 
+	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
 		return -1;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
new file mode 100644
index 0000000..4d33b55
--- /dev/null
+++ b/tools/perf/builtin-diff.c
@@ -0,0 +1,248 @@
+/*
+ * builtin-diff.c
+ *
+ * Builtin diff command: Analyze two perf.data input files, look up and read
+ * DSOs and symbol information, sort them and produce a diff.
+ */
+#include "builtin.h"
+
+#include "util/debug.h"
+#include "util/event.h"
+#include "util/hist.h"
+#include "util/session.h"
+#include "util/sort.h"
+#include "util/symbol.h"
+#include "util/util.h"
+
+#include <stdlib.h>
+
+static char const *input_old = "perf.data.old",
+		  *input_new = "perf.data";
+static char	  diff__default_sort_order[] = "dso,symbol";
+static int  force;
+static bool show_displacement;
+
+static int perf_session__add_hist_entry(struct perf_session *self,
+					struct addr_location *al, u64 count)
+{
+	bool hit;
+	struct hist_entry *he = __perf_session__add_hist_entry(self, al, NULL,
+							       count, &hit);
+	if (he == NULL)
+		return -ENOMEM;
+
+	if (hit)
+		he->count += count;
+
+	return 0;
+}
+
+static int diff__process_sample_event(event_t *event, struct perf_session *session)
+{
+	struct addr_location al;
+	struct sample_data data = { .period = 1, };
+
+	dump_printf("(IP, %d): %d: %p\n", event->header.misc,
+		    event->ip.pid, (void *)(long)event->ip.ip);
+
+	if (event__preprocess_sample(event, session, &al, NULL) < 0) {
+		pr_warning("problem processing %d event, skipping it.\n",
+			   event->header.type);
+		return -1;
+	}
+
+	if (al.filtered)
+		return 0;
+
+	event__parse_sample(event, session->sample_type, &data);
+
+	if (al.sym && perf_session__add_hist_entry(session, &al, data.period)) {
+		pr_warning("problem incrementing symbol count, skipping event\n");
+		return -1;
+	}
+
+	session->events_stats.total += data.period;
+	return 0;
+}
+
+static struct perf_event_ops event_ops = {
+	.process_sample_event = diff__process_sample_event,
+	.process_mmap_event   = event__process_mmap,
+	.process_comm_event   = event__process_comm,
+	.process_exit_event   = event__process_task,
+	.process_fork_event   = event__process_task,
+	.process_lost_event   = event__process_lost,
+};
+
+static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
+						    struct hist_entry *he)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct hist_entry *iter;
+
+	while (*p != NULL) {
+		int cmp;
+		parent = *p;
+		iter = rb_entry(parent, struct hist_entry, rb_node);
+
+		cmp = strcmp(he->map->dso->name, iter->map->dso->name);
+		if (cmp > 0)
+			p = &(*p)->rb_left;
+		else if (cmp < 0)
+			p = &(*p)->rb_right;
+		else {
+			cmp = strcmp(he->sym->name, iter->sym->name);
+			if (cmp > 0)
+				p = &(*p)->rb_left;
+			else
+				p = &(*p)->rb_right;
+		}
+	}
+
+	rb_link_node(&he->rb_node, parent, p);
+	rb_insert_color(&he->rb_node, root);
+}
+
+static void perf_session__resort_by_name(struct perf_session *self)
+{
+	unsigned long position = 1;
+	struct rb_root tmp = RB_ROOT;
+	struct rb_node *next = rb_first(&self->hists);
+
+	while (next != NULL) {
+		struct hist_entry *n = rb_entry(next, struct hist_entry, rb_node);
+
+		next = rb_next(&n->rb_node);
+		rb_erase(&n->rb_node, &self->hists);
+		n->position = position++;
+		perf_session__insert_hist_entry_by_name(&tmp, n);
+	}
+
+	self->hists = tmp;
+}
+
+static struct hist_entry *
+perf_session__find_hist_entry_by_name(struct perf_session *self,
+				      struct hist_entry *he)
+{
+	struct rb_node *n = self->hists.rb_node;
+
+	while (n) {
+		struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
+		int cmp = strcmp(he->map->dso->name, iter->map->dso->name);
+
+		if (cmp > 0)
+			n = n->rb_left;
+		else if (cmp < 0)
+			n = n->rb_right;
+		else {
+			cmp = strcmp(he->sym->name, iter->sym->name);
+			if (cmp > 0)
+				n = n->rb_left;
+			else if (cmp < 0)
+				n = n->rb_right;
+			else
+				return iter;
+		}
+	}
+
+	return NULL;
+}
+
+static void perf_session__match_hists(struct perf_session *old_session,
+				      struct perf_session *new_session)
+{
+	struct rb_node *nd;
+
+	perf_session__resort_by_name(old_session);
+
+	for (nd = rb_first(&new_session->hists); nd; nd = rb_next(nd)) {
+		struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node);
+		pos->pair = perf_session__find_hist_entry_by_name(old_session, pos);
+	}
+}
+
+static int __cmd_diff(void)
+{
+	int ret, i;
+	struct perf_session *session[2];
+
+	session[0] = perf_session__new(input_old, O_RDONLY, force);
+	session[1] = perf_session__new(input_new, O_RDONLY, force);
+	if (session[0] == NULL || session[1] == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < 2; ++i) {
+		ret = perf_session__process_events(session[i], &event_ops);
+		if (ret)
+			goto out_delete;
+		perf_session__output_resort(session[i], session[i]->events_stats.total);
+	}
+
+	perf_session__match_hists(session[0], session[1]);
+	perf_session__fprintf_hists(session[1], session[0],
+				    show_displacement, stdout);
+out_delete:
+	for (i = 0; i < 2; ++i)
+		perf_session__delete(session[i]);
+	return ret;
+}
+
+static const char *const diff_usage[] = {
+	"perf diff [<options>] [old_file] [new_file]",
+};
+
+static const struct option options[] = {
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('m', "displacement", &show_displacement,
+		    "Show position displacement relative to baseline"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
+		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
+	OPT_BOOLEAN('P', "full-paths", &event_ops.full_paths,
+		    "Don't shorten the pathnames taking into account the cwd"),
+	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
+		   "only consider symbols in these dsos"),
+	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
+		   "only consider symbols in these comms"),
+	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
+		   "only consider these symbols"),
+	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
+		   "sort by key(s): pid, comm, dso, symbol, parent"),
+	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
+		   "separator for columns, no spaces will be added between "
+		   "columns '.' is reserved."),
+	OPT_END()
+};
+
+int cmd_diff(int argc, const char **argv, const char *prefix __used)
+{
+	sort_order = diff__default_sort_order;
+	argc = parse_options(argc, argv, options, diff_usage, 0);
+	if (argc) {
+		if (argc > 2)
+			usage_with_options(diff_usage, options);
+		if (argc == 2) {
+			input_old = argv[0];
+			input_new = argv[1];
+		} else
+			input_new = argv[0];
+	}
+
+	symbol_conf.exclude_other = false;
+	if (symbol__init() < 0)
+		return -1;
+
+	setup_sorting(diff_usage, options);
+	setup_pager();
+
+	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", NULL);
+	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", NULL);
+	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", NULL);
+
+	return __cmd_diff();
+}
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 2071d24..fc21ad7 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -12,7 +12,6 @@
 #include "util/trace-event.h"
 
 #include "util/debug.h"
-#include "util/data_map.h"
 
 #include <linux/rbtree.h>
 
@@ -21,8 +20,6 @@ typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
 
 static char const		*input_name = "perf.data";
 
-static u64			sample_type;
-
 static int			alloc_flag;
 static int			caller_flag;
 
@@ -312,7 +309,7 @@ process_raw_event(event_t *raw_event __used, void *data,
 	}
 }
 
-static int process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data;
 	struct thread *thread;
@@ -322,7 +319,7 @@ static int process_sample_event(event_t *event)
 	data.cpu = -1;
 	data.period = 1;
 
-	event__parse_sample(event, sample_type, &data);
+	event__parse_sample(event, session->sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
@@ -330,7 +327,7 @@ static int process_sample_event(event_t *event)
 		(void *)(long)data.ip,
 		(long long)data.period);
 
-	thread = threads__findnew(event->ip.pid);
+	thread = perf_session__findnew(session, event->ip.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -345,11 +342,9 @@ static int process_sample_event(event_t *event)
 	return 0;
 }
 
-static int sample_type_check(u64 type)
+static int sample_type_check(struct perf_session *session)
 {
-	sample_type = type;
-
-	if (!(sample_type & PERF_SAMPLE_RAW)) {
+	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
 		fprintf(stderr,
 			"No trace sample to read. Did you call perf record "
 			"without -R?");
@@ -359,28 +354,12 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
 	.sample_type_check	= sample_type_check,
 };
 
-static int read_events(void)
-{
-	int err;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
-
-	if (session == NULL)
-		return -ENOMEM;
-
-	register_idle_thread();
-	register_perf_file_handler(&file_handler);
-
-	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
-	perf_session__delete(session);
-	return err;
-}
-
 static double fragmentation(unsigned long n_req, unsigned long n_alloc)
 {
 	if (n_alloc == 0)
@@ -389,7 +368,8 @@ static double fragmentation(unsigned long n_req, unsigned long n_alloc)
 		return 100.0 - (100.0 * n_req / n_alloc);
 }
 
-static void __print_result(struct rb_root *root, int n_lines, int is_caller)
+static void __print_result(struct rb_root *root, struct perf_session *session,
+			   int n_lines, int is_caller)
 {
 	struct rb_node *next;
 
@@ -410,7 +390,7 @@ static void __print_result(struct rb_root *root, int n_lines, int is_caller)
 		if (is_caller) {
 			addr = data->call_site;
 			if (!raw_ip)
-				sym = map_groups__find_function(kmaps, addr, NULL);
+				sym = map_groups__find_function(&session->kmaps, session, addr, NULL);
 		} else
 			addr = data->ptr;
 
@@ -451,12 +431,12 @@ static void print_summary(void)
 	printf("Cross CPU allocations: %lu/%lu\n", nr_cross_allocs, nr_allocs);
 }
 
-static void print_result(void)
+static void print_result(struct perf_session *session)
 {
 	if (caller_flag)
-		__print_result(&root_caller_sorted, caller_lines, 1);
+		__print_result(&root_caller_sorted, session, caller_lines, 1);
 	if (alloc_flag)
-		__print_result(&root_alloc_sorted, alloc_lines, 0);
+		__print_result(&root_alloc_sorted, session, alloc_lines, 0);
 	print_summary();
 }
 
@@ -524,12 +504,20 @@ static void sort_result(void)
 
 static int __cmd_kmem(void)
 {
+	int err;
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
+	if (session == NULL)
+		return -ENOMEM;
+
 	setup_pager();
-	read_events();
+	err = perf_session__process_events(session, &event_ops);
+	if (err != 0)
+		goto out_delete;
 	sort_result();
-	print_result();
-
-	return 0;
+	print_result(session);
+out_delete:
+	perf_session__delete(session);
+	return err;
 }
 
 static const char * const kmem_usage[] = {
@@ -778,13 +766,13 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_kmem(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init(0);
-
 	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
 
 	if (!argc)
 		usage_with_options(kmem_usage, kmem_options);
 
+	symbol__init();
+
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strcmp(argv[0], "stat")) {
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 5a47c1e..7e741f5 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -38,34 +38,29 @@
 #include "util/strlist.h"
 #include "util/event.h"
 #include "util/debug.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/session.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"	/* For debugfs_path */
 #include "util/probe-finder.h"
 #include "util/probe-event.h"
 
-/* Default vmlinux search paths */
-#define NR_SEARCH_PATH 4
-const char *default_search_path[NR_SEARCH_PATH] = {
-"/lib/modules/%s/build/vmlinux",		/* Custom build kernel */
-"/usr/lib/debug/lib/modules/%s/vmlinux",	/* Red Hat debuginfo */
-"/boot/vmlinux-debug-%s",			/* Ubuntu */
-"./vmlinux",					/* CWD */
-};
-
 #define MAX_PATH_LEN 256
 #define MAX_PROBES 128
 
 /* Session management structure */
 static struct {
-	char *vmlinux;
-	char *release;
-	int need_dwarf;
+	bool need_dwarf;
+	bool list_events;
+	bool force_add;
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
 	struct strlist *dellist;
+	struct perf_session *psession;
+	struct map *kmap;
 } session;
 
-static bool listing;
 
 /* Parse an event definition. Note that any error must die. */
 static void parse_probe_event(const char *str)
@@ -77,7 +72,7 @@ static void parse_probe_event(const char *str)
 		die("Too many probes (> %d) are specified.", MAX_PROBES);
 
 	/* Parse perf-probe event into probe_point */
-	session.need_dwarf = parse_perf_probe_event(str, pp);
+	parse_perf_probe_event(str, pp, &session.need_dwarf);
 
 	pr_debug("%d arguments\n", pp->nr_args);
 }
@@ -120,34 +115,26 @@ static int opt_del_probe_event(const struct option *opt __used,
 	return 0;
 }
 
+/* Currently just checking function name from symbol map */
+static void evaluate_probe_point(struct probe_point *pp)
+{
+	struct symbol *sym;
+	sym = map__find_symbol_by_name(session.kmap, pp->function,
+				       session.psession, NULL);
+	if (!sym)
+		die("Kernel symbol \'%s\' not found - probe not added.",
+		    pp->function);
+}
+
 #ifndef NO_LIBDWARF
-static int open_default_vmlinux(void)
+static int open_vmlinux(void)
 {
-	struct utsname uts;
-	char fname[MAX_PATH_LEN];
-	int fd, ret, i;
-
-	ret = uname(&uts);
-	if (ret) {
-		pr_debug("uname() failed.\n");
-		return -errno;
-	}
-	session.release = uts.release;
-	for (i = 0; i < NR_SEARCH_PATH; i++) {
-		ret = snprintf(fname, MAX_PATH_LEN,
-			       default_search_path[i], session.release);
-		if (ret >= MAX_PATH_LEN || ret < 0) {
-			pr_debug("Filename(%d,%s) is too long.\n", i,
-				uts.release);
-			errno = E2BIG;
-			return -E2BIG;
-		}
-		pr_debug("try to open %s\n", fname);
-		fd = open(fname, O_RDONLY);
-		if (fd >= 0)
-			break;
+	if (map__load(session.kmap, session.psession, NULL) < 0) {
+		pr_debug("Failed to load kernel map.\n");
+		return -EINVAL;
 	}
-	return fd;
+	pr_debug("Try to open %s\n", session.kmap->dso->long_name);
+	return open(session.kmap->dso->long_name, O_RDONLY);
 }
 #endif
 
@@ -163,21 +150,22 @@ static const struct option options[] = {
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
 #ifndef NO_LIBDWARF
-	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
-		"vmlinux/module pathname"),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
 #endif
-	OPT_BOOLEAN('l', "list", &listing, "list up current probe events"),
+	OPT_BOOLEAN('l', "list", &session.list_events,
+		    "list up current probe events"),
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
 #ifdef NO_LIBDWARF
-		"FUNC[+OFFS|%return] [ARG ...]",
+		"[EVENT=]FUNC[+OFFS|%return] [ARG ...]",
 #else
-		"FUNC[+OFFS|%return|:RLN][@SRC]|SRC:ALN [ARG ...]",
+		"[EVENT=]FUNC[+OFFS|%return|:RLN][@SRC]|SRC:ALN [ARG ...]",
 #endif
 		"probe point definition, where\n"
-		"\t\tGRP:\tGroup name (optional)\n"
-		"\t\tNAME:\tEvent name\n"
+		"\t\tGROUP:\tGroup name (optional)\n"
+		"\t\tEVENT:\tEvent name\n"
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFFS:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
@@ -191,6 +179,8 @@ static const struct option options[] = {
 #endif
 		"\t\t\tkprobe-tracer argument format.)\n",
 		opt_add_probe_event),
+	OPT_BOOLEAN('f', "force", &session.force_add, "forcibly add events"
+		    " with existing name"),
 	OPT_END()
 };
 
@@ -204,13 +194,18 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 	argc = parse_options(argc, argv, options, probe_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
-	if (argc > 0)
+	if (argc > 0) {
+		if (strcmp(argv[0], "-") == 0) {
+			pr_warning("  Error: '-' is not supported.\n");
+			usage_with_options(probe_usage, options);
+		}
 		parse_probe_event_argv(argc, argv);
+	}
 
-	if ((session.nr_probe == 0 && !session.dellist && !listing))
+	if ((!session.nr_probe && !session.dellist && !session.list_events))
 		usage_with_options(probe_usage, options);
 
-	if (listing) {
+	if (session.list_events) {
 		if (session.nr_probe != 0 || session.dellist) {
 			pr_warning("  Error: Don't use --list with"
 				   " --add/--del.\n");
@@ -227,17 +222,28 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			return 0;
 	}
 
+	/* Initialize symbol maps for vmlinux */
+	symbol_conf.sort_by_name = true;
+	if (symbol_conf.vmlinux_name == NULL)
+		symbol_conf.try_vmlinux_path = true;
+	if (symbol__init() < 0)
+		die("Failed to init symbol map.");
+	session.psession = perf_session__new(NULL, O_WRONLY, false);
+	if (session.psession == NULL)
+		die("Failed to init perf_session.");
+	session.kmap = map_groups__find_by_name(&session.psession->kmaps,
+						MAP__FUNCTION,
+						"[kernel.kallsyms]");
+	if (!session.kmap)
+		die("Could not find kernel map.\n");
+
 	if (session.need_dwarf)
 #ifdef NO_LIBDWARF
 		die("Debuginfo-analysis is not supported");
 #else	/* !NO_LIBDWARF */
 		pr_debug("Some probes require debuginfo.\n");
 
-	if (session.vmlinux) {
-		pr_debug("Try to open %s.", session.vmlinux);
-		fd = open(session.vmlinux, O_RDONLY);
-	} else
-		fd = open_default_vmlinux();
+	fd = open_vmlinux();
 	if (fd < 0) {
 		if (session.need_dwarf)
 			die("Could not open debuginfo file.");
@@ -255,15 +261,22 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 		lseek(fd, SEEK_SET, 0);
 		ret = find_probepoint(fd, pp);
-		if (ret < 0) {
-			if (session.need_dwarf)
-				die("Could not analyze debuginfo.");
-
-			pr_warning("An error occurred in debuginfo analysis. Try to use symbols.\n");
-			break;
+		if (ret > 0)
+			continue;
+		if (ret == 0) {	/* No error but failed to find probe point. */
+			synthesize_perf_probe_point(pp);
+			die("Probe point '%s' not found. - probe not added.",
+			    pp->probes[0]);
+		}
+		/* Error path */
+		if (session.need_dwarf) {
+			if (ret == -ENOENT)
+				pr_warning("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO=y.\n");
+			die("Could not analyze debuginfo.");
 		}
-		if (ret == 0)	/* No error but failed to find probe point. */
-			die("No probe point found.");
+		pr_debug("An error occurred in debuginfo analysis."
+			 " Try to use symbols.\n");
+		break;
 	}
 	close(fd);
 
@@ -276,6 +289,7 @@ end_dwarf:
 		if (pp->found)	/* This probe is already found. */
 			continue;
 
+		evaluate_probe_point(pp);
 		ret = synthesize_trace_kprobe_event(pp);
 		if (ret == -E2BIG)
 			die("probe point definition becomes too long.");
@@ -284,7 +298,8 @@ end_dwarf:
 	}
 
 	/* Settng up probe points */
-	add_trace_kprobe_events(session.probes, session.nr_probe);
+	add_trace_kprobe_events(session.probes, session.nr_probe,
+				session.force_add);
 	return 0;
 }
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4decbd1..63136d0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -123,7 +123,8 @@ static void write_event(event_t *buf, size_t size)
 	write_output(buf, size);
 }
 
-static int process_synthesized_event(event_t *event)
+static int process_synthesized_event(event_t *event,
+				     struct perf_session *self __used)
 {
 	write_event(event, event->header.size);
 	return 0;
@@ -277,7 +278,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
 
 	attr->mmap		= track;
 	attr->comm		= track;
-	attr->inherit		= (cpu < 0) && inherit;
+	attr->inherit		= inherit;
 	attr->disabled		= 1;
 
 try_again:
@@ -401,7 +402,7 @@ static void atexit_header(void)
 	perf_header__write(&session->header, output, true);
 }
 
-static int __cmd_record(int argc, const char **argv)
+static int __cmd_record(int argc __used, const char **argv)
 {
 	int i, counter;
 	struct stat st;
@@ -409,6 +410,8 @@ static int __cmd_record(int argc, const char **argv)
 	int flags;
 	int err;
 	unsigned long waking = 0;
+	int child_ready_pipe[2], go_pipe[2];
+	char buf;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
@@ -419,11 +422,25 @@ static int __cmd_record(int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
+	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
+		perror("failed to create pipes");
+		exit(-1);
+	}
+
 	if (!stat(output_name, &st) && st.st_size) {
-		if (!force && !append_file) {
-			fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
-					output_name);
-			exit(-1);
+		if (!force) {
+			if (!append_file) {
+				pr_err("Error, output file %s exists, use -A "
+				       "to append or -f to overwrite.\n",
+				       output_name);
+				exit(-1);
+			}
+		} else {
+			char oldname[PATH_MAX];
+			snprintf(oldname, sizeof(oldname), "%s.old",
+				 output_name);
+			unlink(oldname);
+			rename(output_name, oldname);
 		}
 	} else {
 		append_file = 0;
@@ -466,19 +483,65 @@ static int __cmd_record(int argc, const char **argv)
 
 	atexit(atexit_header);
 
-	if (!system_wide) {
-		pid = target_pid;
-		if (pid == -1)
-			pid = getpid();
+	if (target_pid == -1) {
+		pid = fork();
+		if (pid < 0) {
+			perror("failed to fork");
+			exit(-1);
+		}
 
-		open_counters(profile_cpu, pid);
-	} else {
-		if (profile_cpu != -1) {
-			open_counters(profile_cpu, target_pid);
-		} else {
-			for (i = 0; i < nr_cpus; i++)
-				open_counters(i, target_pid);
+		if (!pid) {
+			close(child_ready_pipe[0]);
+			close(go_pipe[1]);
+			fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
+
+			/*
+			 * Do a dummy execvp to get the PLT entry resolved,
+			 * so we avoid the resolver overhead on the real
+			 * execvp call.
+			 */
+			execvp("", (char **)argv);
+
+			/*
+			 * Tell the parent we're ready to go
+			 */
+			close(child_ready_pipe[1]);
+
+			/*
+			 * Wait until the parent tells us to go.
+			 */
+			if (read(go_pipe[0], &buf, 1) == -1)
+				perror("unable to read pipe");
+
+			execvp(argv[0], (char **)argv);
+
+			perror(argv[0]);
+			exit(-1);
 		}
+
+		child_pid = pid;
+
+		if (!system_wide)
+			target_pid = pid;
+
+		close(child_ready_pipe[1]);
+		close(go_pipe[0]);
+		/*
+		 * wait for child to settle
+		 */
+		if (read(child_ready_pipe[0], &buf, 1) == -1) {
+			perror("unable to read pipe");
+			exit(-1);
+		}
+		close(child_ready_pipe[0]);
+	}
+
+
+	if ((!system_wide && !inherit) || profile_cpu != -1) {
+		open_counters(profile_cpu, target_pid);
+	} else {
+		for (i = 0; i < nr_cpus; i++)
+			open_counters(i, target_pid);
 	}
 
 	if (file_new) {
@@ -488,33 +551,10 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (!system_wide)
-		event__synthesize_thread(pid, process_synthesized_event);
+		event__synthesize_thread(pid, process_synthesized_event,
+					 session);
 	else
-		event__synthesize_threads(process_synthesized_event);
-
-	if (target_pid == -1 && argc) {
-		pid = fork();
-		if (pid < 0)
-			die("failed to fork");
-
-		if (!pid) {
-			if (execvp(argv[0], (char **)argv)) {
-				perror(argv[0]);
-				exit(-1);
-			}
-		} else {
-			/*
-			 * Wait a bit for the execv'ed child to appear
-			 * and be updated in /proc
-			 * FIXME: Do you know a less heuristical solution?
-			 */
-			usleep(1000);
-			event__synthesize_thread(pid,
-						 process_synthesized_event);
-		}
-
-		child_pid = pid;
-	}
+		event__synthesize_threads(process_synthesized_event, session);
 
 	if (realtime_prio) {
 		struct sched_param param;
@@ -526,6 +566,11 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
+	/*
+	 * Let the child rip
+	 */
+	close(go_pipe[1]);
+
 	for (;;) {
 		int hits = samples;
 
@@ -620,13 +665,13 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
-	symbol__init(0);
-
 	argc = parse_options(argc, argv, options, record_usage,
-		PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && target_pid == -1 && !system_wide)
+			    PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc && target_pid == -1 && (!system_wide || profile_cpu == -1))
 		usage_with_options(record_usage, options);
 
+	symbol__init();
+
 	if (!nr_counters) {
 		nr_counters	= 1;
 		attrs[0].type	= PERF_TYPE_HARDWARE;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e2ec49a..e50a6b1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -27,467 +27,41 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 
-#include "util/data_map.h"
 #include "util/thread.h"
 #include "util/sort.h"
 #include "util/hist.h"
 
 static char		const *input_name = "perf.data";
 
-static char		*dso_list_str, *comm_list_str, *sym_list_str,
-			*col_width_list_str;
-static struct strlist	*dso_list, *comm_list, *sym_list;
-
 static int		force;
 
-static int		full_paths;
-static int		show_nr_samples;
-
 static int		show_threads;
 static struct perf_read_values	show_threads_values;
 
 static char		default_pretty_printing_style[] = "normal";
 static char		*pretty_printing_style = default_pretty_printing_style;
 
-static int		exclude_other = 1;
-
 static char		callchain_default_opt[] = "fractal,0.5";
 
-static struct perf_session *session;
-
-static u64		sample_type;
-
-struct symbol_conf	symbol_conf;
-
-
-static size_t
-callchain__fprintf_left_margin(FILE *fp, int left_margin)
-{
-	int i;
-	int ret;
-
-	ret = fprintf(fp, "            ");
-
-	for (i = 0; i < left_margin; i++)
-		ret += fprintf(fp, " ");
-
-	return ret;
-}
-
-static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
-					  int left_margin)
-{
-	int i;
-	size_t ret = 0;
-
-	ret += callchain__fprintf_left_margin(fp, left_margin);
-
-	for (i = 0; i < depth; i++)
-		if (depth_mask & (1 << i))
-			ret += fprintf(fp, "|          ");
-		else
-			ret += fprintf(fp, "           ");
-
-	ret += fprintf(fp, "\n");
-
-	return ret;
-}
-static size_t
-ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain, int depth,
-		       int depth_mask, int count, u64 total_samples,
-		       int hits, int left_margin)
-{
-	int i;
-	size_t ret = 0;
-
-	ret += callchain__fprintf_left_margin(fp, left_margin);
-	for (i = 0; i < depth; i++) {
-		if (depth_mask & (1 << i))
-			ret += fprintf(fp, "|");
-		else
-			ret += fprintf(fp, " ");
-		if (!count && i == depth - 1) {
-			double percent;
-
-			percent = hits * 100.0 / total_samples;
-			ret += percent_color_fprintf(fp, "--%2.2f%%-- ", percent);
-		} else
-			ret += fprintf(fp, "%s", "          ");
-	}
-	if (chain->sym)
-		ret += fprintf(fp, "%s\n", chain->sym->name);
-	else
-		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
-
-	return ret;
-}
-
-static struct symbol *rem_sq_bracket;
-static struct callchain_list rem_hits;
-
-static void init_rem_hits(void)
-{
-	rem_sq_bracket = malloc(sizeof(*rem_sq_bracket) + 6);
-	if (!rem_sq_bracket) {
-		fprintf(stderr, "Not enough memory to display remaining hits\n");
-		return;
-	}
-
-	strcpy(rem_sq_bracket->name, "[...]");
-	rem_hits.sym = rem_sq_bracket;
-}
-
-static size_t
-__callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
-			   u64 total_samples, int depth, int depth_mask,
-			   int left_margin)
-{
-	struct rb_node *node, *next;
-	struct callchain_node *child;
-	struct callchain_list *chain;
-	int new_depth_mask = depth_mask;
-	u64 new_total;
-	u64 remaining;
-	size_t ret = 0;
-	int i;
-
-	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = self->children_hit;
-	else
-		new_total = total_samples;
-
-	remaining = new_total;
-
-	node = rb_first(&self->rb_root);
-	while (node) {
-		u64 cumul;
-
-		child = rb_entry(node, struct callchain_node, rb_node);
-		cumul = cumul_hits(child);
-		remaining -= cumul;
-
-		/*
-		 * The depth mask manages the output of pipes that show
-		 * the depth. We don't want to keep the pipes of the current
-		 * level for the last child of this depth.
-		 * Except if we have remaining filtered hits. They will
-		 * supersede the last child
-		 */
-		next = rb_next(node);
-		if (!next && (callchain_param.mode != CHAIN_GRAPH_REL || !remaining))
-			new_depth_mask &= ~(1 << (depth - 1));
-
-		/*
-		 * But we keep the older depth mask for the line seperator
-		 * to keep the level link until we reach the last child
-		 */
-		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask,
-						   left_margin);
-		i = 0;
-		list_for_each_entry(chain, &child->val, list) {
-			if (chain->ip >= PERF_CONTEXT_MAX)
-				continue;
-			ret += ipchain__fprintf_graph(fp, chain, depth,
-						      new_depth_mask, i++,
-						      new_total,
-						      cumul,
-						      left_margin);
-		}
-		ret += __callchain__fprintf_graph(fp, child, new_total,
-						  depth + 1,
-						  new_depth_mask | (1 << depth),
-						  left_margin);
-		node = next;
-	}
-
-	if (callchain_param.mode == CHAIN_GRAPH_REL &&
-		remaining && remaining != new_total) {
-
-		if (!rem_sq_bracket)
-			return ret;
-
-		new_depth_mask &= ~(1 << (depth - 1));
-
-		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
-					      new_depth_mask, 0, new_total,
-					      remaining, left_margin);
-	}
-
-	return ret;
-}
-
-
-static size_t
-callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
-			 u64 total_samples, int left_margin)
-{
-	struct callchain_list *chain;
-	bool printed = false;
-	int i = 0;
-	int ret = 0;
-
-	list_for_each_entry(chain, &self->val, list) {
-		if (chain->ip >= PERF_CONTEXT_MAX)
-			continue;
-
-		if (!i++ && sort__first_dimension == SORT_SYM)
-			continue;
-
-		if (!printed) {
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-			ret += fprintf(fp, "|\n");
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-			ret += fprintf(fp, "---");
-
-			left_margin += 3;
-			printed = true;
-		} else
-			ret += callchain__fprintf_left_margin(fp, left_margin);
-
-		if (chain->sym)
-			ret += fprintf(fp, " %s\n", chain->sym->name);
-		else
-			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
-	}
-
-	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1, left_margin);
-
-	return ret;
-}
-
-static size_t
-callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
-			u64 total_samples)
-{
-	struct callchain_list *chain;
-	size_t ret = 0;
-
-	if (!self)
-		return 0;
-
-	ret += callchain__fprintf_flat(fp, self->parent, total_samples);
-
-
-	list_for_each_entry(chain, &self->val, list) {
-		if (chain->ip >= PERF_CONTEXT_MAX)
-			continue;
-		if (chain->sym)
-			ret += fprintf(fp, "                %s\n", chain->sym->name);
-		else
-			ret += fprintf(fp, "                %p\n",
-					(void *)(long)chain->ip);
-	}
-
-	return ret;
-}
-
-static size_t
-hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
-			      u64 total_samples, int left_margin)
-{
-	struct rb_node *rb_node;
-	struct callchain_node *chain;
-	size_t ret = 0;
-
-	rb_node = rb_first(&self->sorted_chain);
-	while (rb_node) {
-		double percent;
-
-		chain = rb_entry(rb_node, struct callchain_node, rb_node);
-		percent = chain->hit * 100.0 / total_samples;
-		switch (callchain_param.mode) {
-		case CHAIN_FLAT:
-			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
-						     percent);
-			ret += callchain__fprintf_flat(fp, chain, total_samples);
-			break;
-		case CHAIN_GRAPH_ABS: /* Falldown */
-		case CHAIN_GRAPH_REL:
-			ret += callchain__fprintf_graph(fp, chain, total_samples,
-							left_margin);
-		case CHAIN_NONE:
-		default:
-			break;
-		}
-		ret += fprintf(fp, "\n");
-		rb_node = rb_next(rb_node);
-	}
-
-	return ret;
-}
-
-static size_t
-hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
-{
-	struct sort_entry *se;
-	size_t ret;
-
-	if (exclude_other && !self->parent)
-		return 0;
-
-	if (total_samples)
-		ret = percent_color_fprintf(fp,
-					    field_sep ? "%.2f" : "   %6.2f%%",
-					(self->count * 100.0) / total_samples);
-	else
-		ret = fprintf(fp, field_sep ? "%lld" : "%12lld ", self->count);
-
-	if (show_nr_samples) {
-		if (field_sep)
-			fprintf(fp, "%c%lld", *field_sep, self->count);
-		else
-			fprintf(fp, "%11lld", self->count);
-	}
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		fprintf(fp, "%s", field_sep ?: "  ");
-		ret += se->print(fp, self, se->width ? *se->width : 0);
-	}
-
-	ret += fprintf(fp, "\n");
-
-	if (callchain) {
-		int left_margin = 0;
-
-		if (sort__first_dimension == SORT_COMM) {
-			se = list_first_entry(&hist_entry__sort_list, typeof(*se),
-						list);
-			left_margin = se->width ? *se->width : 0;
-			left_margin -= thread__comm_len(self->thread);
-		}
-
-		hist_entry_callchain__fprintf(fp, self, total_samples,
-					      left_margin);
-	}
-
-	return ret;
-}
-
-/*
- *
- */
-
-static void dso__calc_col_width(struct dso *self)
-{
-	if (!col_width_list_str && !field_sep &&
-	    (!dso_list || strlist__has_entry(dso_list, self->name))) {
-		unsigned int slen = strlen(self->name);
-		if (slen > dsos__col_width)
-			dsos__col_width = slen;
-	}
-
-	self->slen_calculated = 1;
-}
-
-static void thread__comm_adjust(struct thread *self)
-{
-	char *comm = self->comm;
-
-	if (!col_width_list_str && !field_sep &&
-	    (!comm_list || strlist__has_entry(comm_list, comm))) {
-		unsigned int slen = strlen(comm);
-
-		if (slen > comms__col_width) {
-			comms__col_width = slen;
-			threads__col_width = slen + 6;
-		}
-	}
-}
-
-static int thread__set_comm_adjust(struct thread *self, const char *comm)
-{
-	int ret = thread__set_comm(self, comm);
-
-	if (ret)
-		return ret;
-
-	thread__comm_adjust(self);
-
-	return 0;
-}
-
-static int call__match(struct symbol *sym)
-{
-	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
-		return 1;
-
-	return 0;
-}
-
-static struct symbol **resolve_callchain(struct thread *thread,
-					 struct ip_callchain *chain,
-					 struct symbol **parent)
-{
-	u8 cpumode = PERF_RECORD_MISC_USER;
-	struct symbol **syms = NULL;
-	unsigned int i;
-
-	if (callchain) {
-		syms = calloc(chain->nr, sizeof(*syms));
-		if (!syms) {
-			fprintf(stderr, "Can't allocate memory for symbols\n");
-			exit(-1);
-		}
-	}
-
-	for (i = 0; i < chain->nr; i++) {
-		u64 ip = chain->ips[i];
-		struct addr_location al;
-
-		if (ip >= PERF_CONTEXT_MAX) {
-			switch (ip) {
-			case PERF_CONTEXT_HV:
-				cpumode = PERF_RECORD_MISC_HYPERVISOR;	break;
-			case PERF_CONTEXT_KERNEL:
-				cpumode = PERF_RECORD_MISC_KERNEL;	break;
-			case PERF_CONTEXT_USER:
-				cpumode = PERF_RECORD_MISC_USER;	break;
-			default:
-				break;
-			}
-			continue;
-		}
-
-		thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
-					   ip, &al, NULL);
-		if (al.sym != NULL) {
-			if (sort__has_parent && !*parent &&
-			    call__match(al.sym))
-				*parent = al.sym;
-			if (!callchain)
-				break;
-			syms[i] = al.sym;
-		}
-	}
-
-	return syms;
-}
-
-/*
- * collect histogram counts
- */
-
-static int hist_entry__add(struct addr_location *al,
-			   struct ip_callchain *chain, u64 count)
+static int perf_session__add_hist_entry(struct perf_session *self,
+					struct addr_location *al,
+					struct ip_callchain *chain, u64 count)
 {
 	struct symbol **syms = NULL, *parent = NULL;
 	bool hit;
 	struct hist_entry *he;
 
-	if ((sort__has_parent || callchain) && chain)
-		syms = resolve_callchain(al->thread, chain, &parent);
-
-	he = __hist_entry__add(al, parent, count, &hit);
+	if ((sort__has_parent || symbol_conf.use_callchain) && chain)
+		syms = perf_session__resolve_callchain(self, al->thread,
+						       chain, &parent);
+	he = __perf_session__add_hist_entry(self, al, parent, count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
 
 	if (hit)
 		he->count += count;
 
-	if (callchain) {
+	if (symbol_conf.use_callchain) {
 		if (!hit)
 			callchain_init(&he->callchain);
 		append_chain(&he->callchain, chain, syms);
@@ -497,100 +71,6 @@ static int hist_entry__add(struct addr_location *al,
 	return 0;
 }
 
-static size_t output__fprintf(FILE *fp, u64 total_samples)
-{
-	struct hist_entry *pos;
-	struct sort_entry *se;
-	struct rb_node *nd;
-	size_t ret = 0;
-	unsigned int width;
-	char *col_width = col_width_list_str;
-	int raw_printing_style;
-
-	raw_printing_style = !strcmp(pretty_printing_style, "raw");
-
-	init_rem_hits();
-
-	fprintf(fp, "# Samples: %Ld\n", (u64)total_samples);
-	fprintf(fp, "#\n");
-
-	fprintf(fp, "# Overhead");
-	if (show_nr_samples) {
-		if (field_sep)
-			fprintf(fp, "%cSamples", *field_sep);
-		else
-			fputs("  Samples  ", fp);
-	}
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-		if (field_sep) {
-			fprintf(fp, "%c%s", *field_sep, se->header);
-			continue;
-		}
-		width = strlen(se->header);
-		if (se->width) {
-			if (col_width_list_str) {
-				if (col_width) {
-					*se->width = atoi(col_width);
-					col_width = strchr(col_width, ',');
-					if (col_width)
-						++col_width;
-				}
-			}
-			width = *se->width = max(*se->width, width);
-		}
-		fprintf(fp, "  %*s", width, se->header);
-	}
-	fprintf(fp, "\n");
-
-	if (field_sep)
-		goto print_entries;
-
-	fprintf(fp, "# ........");
-	if (show_nr_samples)
-		fprintf(fp, " ..........");
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		unsigned int i;
-
-		if (se->elide)
-			continue;
-
-		fprintf(fp, "  ");
-		if (se->width)
-			width = *se->width;
-		else
-			width = strlen(se->header);
-		for (i = 0; i < width; i++)
-			fprintf(fp, ".");
-	}
-	fprintf(fp, "\n");
-
-	fprintf(fp, "#\n");
-
-print_entries:
-	for (nd = rb_first(&output_hists); nd; nd = rb_next(nd)) {
-		pos = rb_entry(nd, struct hist_entry, rb_node);
-		ret += hist_entry__fprintf(fp, pos, total_samples);
-	}
-
-	if (sort_order == default_sort_order &&
-			parent_pattern == default_parent_pattern) {
-		fprintf(fp, "#\n");
-		fprintf(fp, "# (For a higher level overview, try: perf report --sort comm,dso)\n");
-		fprintf(fp, "#\n");
-	}
-	fprintf(fp, "\n");
-
-	free(rem_sq_bracket);
-
-	if (show_threads)
-		perf_read_values_display(fp, &show_threads_values,
-					 raw_printing_style);
-
-	return ret;
-}
-
 static int validate_chain(struct ip_callchain *chain, event_t *event)
 {
 	unsigned int chain_size;
@@ -604,17 +84,12 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 	return 0;
 }
 
-static int process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
-	struct sample_data data;
-	int cpumode;
+	struct sample_data data = { .period = 1, };
 	struct addr_location al;
-	struct thread *thread;
-
-	memset(&data, 0, sizeof(data));
-	data.period = 1;
 
-	event__parse_sample(event, sample_type, &data);
+	event__parse_sample(event, session->sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
@@ -622,7 +97,7 @@ static int process_sample_event(event_t *event)
 		(void *)(long)data.ip,
 		(long long)data.period);
 
-	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
+	if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
 		unsigned int i;
 
 		dump_printf("... chain: nr:%Lu\n", data.callchain->nr);
@@ -640,65 +115,25 @@ static int process_sample_event(event_t *event)
 		}
 	}
 
-	thread = threads__findnew(data.pid);
-	if (thread == NULL) {
-		pr_debug("problem processing %d event, skipping it.\n",
+	if (event__preprocess_sample(event, session, &al, NULL) < 0) {
+		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
 	}
 
-	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
-
-	if (comm_list && !strlist__has_entry(comm_list, thread->comm))
-		return 0;
-
-	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-
-	thread__find_addr_location(thread, cpumode,
-				   MAP__FUNCTION, data.ip, &al, NULL);
-	/*
-	 * We have to do this here as we may have a dso with no symbol hit that
-	 * has a name longer than the ones with symbols sampled.
-	 */
-	if (al.map && !sort_dso.elide && !al.map->dso->slen_calculated)
-		dso__calc_col_width(al.map->dso);
-
-	if (dso_list &&
-	    (!al.map || !al.map->dso ||
-	     !(strlist__has_entry(dso_list, al.map->dso->short_name) ||
-	       (al.map->dso->short_name != al.map->dso->long_name &&
-		strlist__has_entry(dso_list, al.map->dso->long_name)))))
-		return 0;
-
-	if (sym_list && al.sym && !strlist__has_entry(sym_list, al.sym->name))
+	if (al.filtered)
 		return 0;
 
-	if (hist_entry__add(&al, data.callchain, data.period)) {
+	if (perf_session__add_hist_entry(session, &al, data.callchain, data.period)) {
 		pr_debug("problem incrementing symbol count, skipping event\n");
 		return -1;
 	}
 
-	event__stats.total += data.period;
-
+	session->events_stats.total += data.period;
 	return 0;
 }
 
-static int process_comm_event(event_t *event)
-{
-	struct thread *thread = threads__findnew(event->comm.pid);
-
-	dump_printf(": %s:%d\n", event->comm.comm, event->comm.pid);
-
-	if (thread == NULL ||
-	    thread__set_comm_adjust(thread, event->comm.comm)) {
-		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
-		return -1;
-	}
-
-	return 0;
-}
-
-static int process_read_event(event_t *event)
+static int process_read_event(event_t *event, struct perf_session *session __used)
 {
 	struct perf_event_attr *attr;
 
@@ -721,25 +156,23 @@ static int process_read_event(event_t *event)
 	return 0;
 }
 
-static int sample_type_check(u64 type)
+static int sample_type_check(struct perf_session *session)
 {
-	sample_type = type;
-
-	if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
+	if (!(session->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
 			fprintf(stderr, "selected --sort parent, but no"
 					" callchain data. Did you call"
 					" perf record without -g?\n");
 			return -1;
 		}
-		if (callchain) {
+		if (symbol_conf.use_callchain) {
 			fprintf(stderr, "selected -g but no callchain data."
 					" Did you call perf record without"
 					" -g?\n");
 			return -1;
 		}
-	} else if (callchain_param.mode != CHAIN_NONE && !callchain) {
-			callchain = 1;
+	} else if (callchain_param.mode != CHAIN_NONE && !symbol_conf.use_callchain) {
+			symbol_conf.use_callchain = true;
 			if (register_callchain_param(&callchain_param) < 0) {
 				fprintf(stderr, "Can't register callchain"
 						" params\n");
@@ -750,10 +183,10 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_mmap_event	= event__process_mmap,
-	.process_comm_event	= process_comm_event,
+	.process_comm_event	= event__process_comm,
 	.process_exit_event	= event__process_task,
 	.process_fork_event	= event__process_task,
 	.process_lost_event	= event__process_lost,
@@ -764,23 +197,17 @@ static struct perf_file_handler file_handler = {
 
 static int __cmd_report(void)
 {
-	struct thread *idle;
 	int ret;
+	struct perf_session *session;
 
 	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
 		return -ENOMEM;
 
-	idle = register_idle_thread();
-	thread__comm_adjust(idle);
-
 	if (show_threads)
 		perf_read_values_init(&show_threads_values);
 
-	register_perf_file_handler(&file_handler);
-
-	ret = perf_session__process_events(session, full_paths,
-					   &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
 
@@ -790,17 +217,25 @@ static int __cmd_report(void)
 	}
 
 	if (verbose > 3)
-		threads__fprintf(stdout);
+		perf_session__fprintf(session, stdout);
 
 	if (verbose > 2)
 		dsos__fprintf(stdout);
 
-	collapse__resort();
-	output__resort(event__stats.total);
-	output__fprintf(stdout, event__stats.total);
+	perf_session__collapse_resort(session);
+	perf_session__output_resort(session, session->events_stats.total);
+	fprintf(stdout, "# Samples: %ld\n#\n", session->events_stats.total);
+	perf_session__fprintf_hists(session, NULL, false, stdout);
+	if (sort_order == default_sort_order &&
+	    parent_pattern == default_parent_pattern)
+		fprintf(stdout, "#\n# (For a higher level overview, try: perf report --sort comm,dso)\n#\n");
 
-	if (show_threads)
+	if (show_threads) {
+		bool raw_printing_style = !strcmp(pretty_printing_style, "raw");
+		perf_read_values_display(stdout, &show_threads_values,
+					 raw_printing_style);
 		perf_read_values_destroy(&show_threads_values);
+	}
 out_delete:
 	perf_session__delete(session);
 	return ret;
@@ -813,7 +248,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	char *tok;
 	char *endptr;
 
-	callchain = 1;
+	symbol_conf.use_callchain = true;
 
 	if (!arg)
 		return 0;
@@ -834,7 +269,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 
 	else if (!strncmp(tok, "none", strlen(arg))) {
 		callchain_param.mode = CHAIN_NONE;
-		callchain = 0;
+		symbol_conf.use_callchain = true;
 
 		return 0;
 	}
@@ -877,7 +312,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('m', "modules", &symbol_conf.use_modules,
 		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
-	OPT_BOOLEAN('n', "show-nr-samples", &show_nr_samples,
+	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
 	OPT_BOOLEAN('T', "threads", &show_threads,
 		    "Show per-thread event counters"),
@@ -885,78 +320,46 @@ static const struct option options[] = {
 		   "pretty printing style key: normal raw"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
-	OPT_BOOLEAN('P', "full-paths", &full_paths,
+	OPT_BOOLEAN('P', "full-paths", &event_ops.full_paths,
 		    "Don't shorten the pathnames taking into account the cwd"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
 		   "regex filter to identify parent, see: '--sort parent'"),
-	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
+	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
 		     "Display callchains using output_type and min percent threshold. "
 		     "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
-	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
+	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
-	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
+	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
 		   "only consider symbols in these comms"),
-	OPT_STRING('S', "symbols", &sym_list_str, "symbol[,symbol...]",
+	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
-	OPT_STRING('w', "column-widths", &col_width_list_str,
+	OPT_STRING('w', "column-widths", &symbol_conf.col_width_list_str,
 		   "width[,width...]",
 		   "don't try to adjust column width, use these fixed values"),
-	OPT_STRING('t', "field-separator", &field_sep, "separator",
+	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
 		   "columns '.' is reserved."),
 	OPT_END()
 };
 
-static void setup_sorting(void)
+int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
-	char *tmp, *tok, *str = strdup(sort_order);
-
-	for (tok = strtok_r(str, ", ", &tmp);
-			tok; tok = strtok_r(NULL, ", ", &tmp)) {
-		if (sort_dimension__add(tok) < 0) {
-			error("Unknown --sort key: `%s'", tok);
-			usage_with_options(report_usage, options);
-		}
-	}
-
-	free(str);
-}
+	argc = parse_options(argc, argv, options, report_usage, 0);
 
-static void setup_list(struct strlist **list, const char *list_str,
-		       struct sort_entry *se, const char *list_name,
-		       FILE *fp)
-{
-	if (list_str) {
-		*list = strlist__new(true, list_str);
-		if (!*list) {
-			fprintf(stderr, "problems parsing %s list\n",
-				list_name);
-			exit(129);
-		}
-		if (strlist__nr_entries(*list) == 1) {
-			fprintf(fp, "# %s: %s\n", list_name,
-				strlist__entry(*list, 0)->s);
-			se->elide = true;
-		}
-	}
-}
+	setup_pager();
 
-int cmd_report(int argc, const char **argv, const char *prefix __used)
-{
-	if (symbol__init(&symbol_conf) < 0)
+	if (symbol__init() < 0)
 		return -1;
 
-	argc = parse_options(argc, argv, options, report_usage, 0);
-
-	setup_sorting();
+	setup_sorting(report_usage, options);
 
 	if (parent_pattern != default_parent_pattern) {
 		sort_dimension__add("parent");
 		sort_parent.elide = 1;
 	} else
-		exclude_other = 0;
+		symbol_conf.exclude_other = false;
 
 	/*
 	 * Any (unrecognized) arguments left?
@@ -964,17 +367,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (argc)
 		usage_with_options(report_usage, options);
 
-	setup_pager();
-
-	setup_list(&dso_list, dso_list_str, &sort_dso, "dso", stdout);
-	setup_list(&comm_list, comm_list_str, &sort_comm, "comm", stdout);
-	setup_list(&sym_list, sym_list_str, &sort_sym, "symbol", stdout);
-
-	if (field_sep && *field_sep == '.') {
-		fputs("'.' is the only non valid --field-separator argument\n",
-		      stderr);
-		exit(129);
-	}
+	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
+	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
+	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
 
 	return __cmd_report();
 }
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 65021fe..80209df 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -12,7 +12,6 @@
 #include "util/trace-event.h"
 
 #include "util/debug.h"
-#include "util/data_map.h"
 
 #include <sys/prctl.h>
 
@@ -22,8 +21,6 @@
 
 static char			const *input_name = "perf.data";
 
-static u64			sample_type;
-
 static char			default_sort_order[] = "avg, max, switch, runtime";
 static char			*sort_order = default_sort_order;
 
@@ -731,18 +728,21 @@ struct trace_migrate_task_event {
 
 struct trace_sched_handler {
 	void (*switch_event)(struct trace_switch_event *,
+			     struct perf_session *,
 			     struct event *,
 			     int cpu,
 			     u64 timestamp,
 			     struct thread *thread);
 
 	void (*runtime_event)(struct trace_runtime_event *,
+			      struct perf_session *,
 			      struct event *,
 			      int cpu,
 			      u64 timestamp,
 			      struct thread *thread);
 
 	void (*wakeup_event)(struct trace_wakeup_event *,
+			     struct perf_session *,
 			     struct event *,
 			     int cpu,
 			     u64 timestamp,
@@ -755,6 +755,7 @@ struct trace_sched_handler {
 			   struct thread *thread);
 
 	void (*migrate_task_event)(struct trace_migrate_task_event *,
+			   struct perf_session *session,
 			   struct event *,
 			   int cpu,
 			   u64 timestamp,
@@ -764,6 +765,7 @@ struct trace_sched_handler {
 
 static void
 replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
+		    struct perf_session *session __used,
 		    struct event *event,
 		    int cpu __used,
 		    u64 timestamp __used,
@@ -790,6 +792,7 @@ static u64 cpu_last_switched[MAX_CPUS];
 
 static void
 replay_switch_event(struct trace_switch_event *switch_event,
+		    struct perf_session *session __used,
 		    struct event *event,
 		    int cpu,
 		    u64 timestamp,
@@ -1023,6 +1026,7 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 
 static void
 latency_switch_event(struct trace_switch_event *switch_event,
+		     struct perf_session *session,
 		     struct event *event __used,
 		     int cpu,
 		     u64 timestamp,
@@ -1046,8 +1050,8 @@ latency_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
 
-	sched_out = threads__findnew(switch_event->prev_pid);
-	sched_in = threads__findnew(switch_event->next_pid);
+	sched_out = perf_session__findnew(session, switch_event->prev_pid);
+	sched_in = perf_session__findnew(session, switch_event->next_pid);
 
 	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
 	if (!out_events) {
@@ -1075,12 +1079,13 @@ latency_switch_event(struct trace_switch_event *switch_event,
 
 static void
 latency_runtime_event(struct trace_runtime_event *runtime_event,
+		     struct perf_session *session,
 		     struct event *event __used,
 		     int cpu,
 		     u64 timestamp,
 		     struct thread *this_thread __used)
 {
-	struct thread *thread = threads__findnew(runtime_event->pid);
+	struct thread *thread = perf_session__findnew(session, runtime_event->pid);
 	struct work_atoms *atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
 
 	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
@@ -1097,6 +1102,7 @@ latency_runtime_event(struct trace_runtime_event *runtime_event,
 
 static void
 latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
+		     struct perf_session *session,
 		     struct event *__event __used,
 		     int cpu __used,
 		     u64 timestamp,
@@ -1110,7 +1116,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 	if (!wakeup_event->success)
 		return;
 
-	wakee = threads__findnew(wakeup_event->pid);
+	wakee = perf_session__findnew(session, wakeup_event->pid);
 	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(wakee);
@@ -1144,6 +1150,7 @@ latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
 
 static void
 latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
+		     struct perf_session *session,
 		     struct event *__event __used,
 		     int cpu __used,
 		     u64 timestamp,
@@ -1159,7 +1166,7 @@ latency_migrate_task_event(struct trace_migrate_task_event *migrate_task_event,
 	if (profile_cpu == -1)
 		return;
 
-	migrant = threads__findnew(migrate_task_event->pid);
+	migrant = perf_session__findnew(session, migrate_task_event->pid);
 	atoms = thread_atoms_search(&atom_root, migrant, &cmp_pid);
 	if (!atoms) {
 		thread_atoms_insert(migrant);
@@ -1354,7 +1361,7 @@ static void sort_lat(void)
 static struct trace_sched_handler *trace_handler;
 
 static void
-process_sched_wakeup_event(void *data,
+process_sched_wakeup_event(void *data, struct perf_session *session,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1371,7 +1378,8 @@ process_sched_wakeup_event(void *data,
 	FILL_FIELD(wakeup_event, cpu, event, data);
 
 	if (trace_handler->wakeup_event)
-		trace_handler->wakeup_event(&wakeup_event, event, cpu, timestamp, thread);
+		trace_handler->wakeup_event(&wakeup_event, session, event,
+					    cpu, timestamp, thread);
 }
 
 /*
@@ -1389,6 +1397,7 @@ static char next_shortname2 = '0';
 
 static void
 map_switch_event(struct trace_switch_event *switch_event,
+		 struct perf_session *session,
 		 struct event *event __used,
 		 int this_cpu,
 		 u64 timestamp,
@@ -1416,8 +1425,8 @@ map_switch_event(struct trace_switch_event *switch_event,
 		die("hm, delta: %Ld < 0 ?\n", delta);
 
 
-	sched_out = threads__findnew(switch_event->prev_pid);
-	sched_in = threads__findnew(switch_event->next_pid);
+	sched_out = perf_session__findnew(session, switch_event->prev_pid);
+	sched_in = perf_session__findnew(session, switch_event->next_pid);
 
 	curr_thread[this_cpu] = sched_in;
 
@@ -1467,7 +1476,7 @@ map_switch_event(struct trace_switch_event *switch_event,
 
 
 static void
-process_sched_switch_event(void *data,
+process_sched_switch_event(void *data, struct perf_session *session,
 			   struct event *event,
 			   int this_cpu,
 			   u64 timestamp __used,
@@ -1494,13 +1503,14 @@ process_sched_switch_event(void *data,
 			nr_context_switch_bugs++;
 	}
 	if (trace_handler->switch_event)
-		trace_handler->switch_event(&switch_event, event, this_cpu, timestamp, thread);
+		trace_handler->switch_event(&switch_event, session, event,
+					    this_cpu, timestamp, thread);
 
 	curr_pid[this_cpu] = switch_event.next_pid;
 }
 
 static void
-process_sched_runtime_event(void *data,
+process_sched_runtime_event(void *data, struct perf_session *session,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1514,7 +1524,7 @@ process_sched_runtime_event(void *data,
 	FILL_FIELD(runtime_event, vruntime, event, data);
 
 	if (trace_handler->runtime_event)
-		trace_handler->runtime_event(&runtime_event, event, cpu, timestamp, thread);
+		trace_handler->runtime_event(&runtime_event, session, event, cpu, timestamp, thread);
 }
 
 static void
@@ -1534,7 +1544,8 @@ process_sched_fork_event(void *data,
 	FILL_FIELD(fork_event, child_pid, event, data);
 
 	if (trace_handler->fork_event)
-		trace_handler->fork_event(&fork_event, event, cpu, timestamp, thread);
+		trace_handler->fork_event(&fork_event, event,
+					  cpu, timestamp, thread);
 }
 
 static void
@@ -1548,7 +1559,7 @@ process_sched_exit_event(struct event *event,
 }
 
 static void
-process_sched_migrate_task_event(void *data,
+process_sched_migrate_task_event(void *data, struct perf_session *session,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1564,12 +1575,13 @@ process_sched_migrate_task_event(void *data,
 	FILL_FIELD(migrate_task_event, cpu, event, data);
 
 	if (trace_handler->migrate_task_event)
-		trace_handler->migrate_task_event(&migrate_task_event, event, cpu, timestamp, thread);
+		trace_handler->migrate_task_event(&migrate_task_event, session,
+						 event, cpu, timestamp, thread);
 }
 
 static void
-process_raw_event(event_t *raw_event __used, void *data,
-		  int cpu, u64 timestamp, struct thread *thread)
+process_raw_event(event_t *raw_event __used, struct perf_session *session,
+		  void *data, int cpu, u64 timestamp, struct thread *thread)
 {
 	struct event *event;
 	int type;
@@ -1579,27 +1591,27 @@ process_raw_event(event_t *raw_event __used, void *data,
 	event = trace_find_event(type);
 
 	if (!strcmp(event->name, "sched_switch"))
-		process_sched_switch_event(data, event, cpu, timestamp, thread);
+		process_sched_switch_event(data, session, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_stat_runtime"))
-		process_sched_runtime_event(data, event, cpu, timestamp, thread);
+		process_sched_runtime_event(data, session, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup"))
-		process_sched_wakeup_event(data, event, cpu, timestamp, thread);
+		process_sched_wakeup_event(data, session, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_wakeup_new"))
-		process_sched_wakeup_event(data, event, cpu, timestamp, thread);
+		process_sched_wakeup_event(data, session, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_fork"))
 		process_sched_fork_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_process_exit"))
 		process_sched_exit_event(event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "sched_migrate_task"))
-		process_sched_migrate_task_event(data, event, cpu, timestamp, thread);
+		process_sched_migrate_task_event(data, session, event, cpu, timestamp, thread);
 }
 
-static int process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data;
 	struct thread *thread;
 
-	if (!(sample_type & PERF_SAMPLE_RAW))
+	if (!(session->sample_type & PERF_SAMPLE_RAW))
 		return 0;
 
 	memset(&data, 0, sizeof(data));
@@ -1607,7 +1619,7 @@ static int process_sample_event(event_t *event)
 	data.cpu = -1;
 	data.period = -1;
 
-	event__parse_sample(event, sample_type, &data);
+	event__parse_sample(event, session->sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
@@ -1615,7 +1627,7 @@ static int process_sample_event(event_t *event)
 		(void *)(long)data.ip,
 		(long long)data.period);
 
-	thread = threads__findnew(data.pid);
+	thread = perf_session__findnew(session, data.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -1627,12 +1639,13 @@ static int process_sample_event(event_t *event)
 	if (profile_cpu != -1 && profile_cpu != (int)data.cpu)
 		return 0;
 
-	process_raw_event(event, data.raw_data, data.cpu, data.time, thread);
+	process_raw_event(event, session, data.raw_data, data.cpu, data.time, thread);
 
 	return 0;
 }
 
-static int process_lost_event(event_t *event __used)
+static int process_lost_event(event_t *event __used,
+			      struct perf_session *session __used)
 {
 	nr_lost_chunks++;
 	nr_lost_events += event->lost.lost;
@@ -1640,11 +1653,9 @@ static int process_lost_event(event_t *event __used)
 	return 0;
 }
 
-static int sample_type_check(u64 type)
+static int sample_type_check(struct perf_session *session __used)
 {
-	sample_type = type;
-
-	if (!(sample_type & PERF_SAMPLE_RAW)) {
+	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
 		fprintf(stderr,
 			"No trace sample to read. Did you call perf record "
 			"without -R?");
@@ -1654,7 +1665,7 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
 	.process_lost_event	= process_lost_event,
@@ -1665,14 +1676,10 @@ static int read_events(void)
 {
 	int err;
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0);
-
 	if (session == NULL)
 		return -ENOMEM;
 
-	register_idle_thread();
-	register_perf_file_handler(&file_handler);
-
-	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	err = perf_session__process_events(session, &event_ops);
 	perf_session__delete(session);
 	return err;
 }
@@ -1904,7 +1911,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 	if (!strcmp(argv[0], "trace"))
 		return cmd_trace(argc, argv, prefix);
 
-	symbol__init(0);
+	symbol__init();
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "lat", 3)) {
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 759dd2b..a589a43 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -30,15 +30,12 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/event.h"
-#include "util/data_map.h"
+#include "util/session.h"
 #include "util/svghelper.h"
 
 static char		const *input_name = "perf.data";
 static char		const *output_name = "output.svg";
 
-
-static u64		sample_type;
-
 static unsigned int	numcpus;
 static u64		min_freq;	/* Lowest CPU frequency seen */
 static u64		max_freq;	/* Highest CPU frequency seen */
@@ -281,21 +278,19 @@ static int cpus_cstate_state[MAX_CPUS];
 static u64 cpus_pstate_start_times[MAX_CPUS];
 static u64 cpus_pstate_state[MAX_CPUS];
 
-static int
-process_comm_event(event_t *event)
+static int process_comm_event(event_t *event, struct perf_session *session __used)
 {
 	pid_set_comm(event->comm.pid, event->comm.comm);
 	return 0;
 }
-static int
-process_fork_event(event_t *event)
+
+static int process_fork_event(event_t *event, struct perf_session *session __used)
 {
 	pid_fork(event->fork.pid, event->fork.ppid, event->fork.time);
 	return 0;
 }
 
-static int
-process_exit_event(event_t *event)
+static int process_exit_event(event_t *event, struct perf_session *session __used)
 {
 	pid_exit(event->fork.pid, event->fork.time);
 	return 0;
@@ -480,17 +475,16 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 }
 
 
-static int
-process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data;
 	struct trace_entry *te;
 
 	memset(&data, 0, sizeof(data));
 
-	event__parse_sample(event, sample_type, &data);
+	event__parse_sample(event, session->sample_type, &data);
 
-	if (sample_type & PERF_SAMPLE_TIME) {
+	if (session->sample_type & PERF_SAMPLE_TIME) {
 		if (!first_time || first_time > data.time)
 			first_time = data.time;
 		if (last_time < data.time)
@@ -498,7 +492,7 @@ process_sample_event(event_t *event)
 	}
 
 	te = (void *)data.raw_data;
-	if (sample_type & PERF_SAMPLE_RAW && data.raw_size > 0) {
+	if (session->sample_type & PERF_SAMPLE_RAW && data.raw_size > 0) {
 		char *event_str;
 		struct power_entry *pe;
 
@@ -575,16 +569,16 @@ static void end_sample_processing(void)
 	}
 }
 
-static u64 sample_time(event_t *event)
+static u64 sample_time(event_t *event, const struct perf_session *session)
 {
 	int cursor;
 
 	cursor = 0;
-	if (sample_type & PERF_SAMPLE_IP)
+	if (session->sample_type & PERF_SAMPLE_IP)
 		cursor++;
-	if (sample_type & PERF_SAMPLE_TID)
+	if (session->sample_type & PERF_SAMPLE_TID)
 		cursor++;
-	if (sample_type & PERF_SAMPLE_TIME)
+	if (session->sample_type & PERF_SAMPLE_TIME)
 		return event->sample.array[cursor];
 	return 0;
 }
@@ -594,8 +588,7 @@ static u64 sample_time(event_t *event)
  * We first queue all events, sorted backwards by insertion.
  * The order will get flipped later.
  */
-static int
-queue_sample_event(event_t *event)
+static int queue_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_wrapper *copy, *prev;
 	int size;
@@ -609,7 +602,7 @@ queue_sample_event(event_t *event)
 	memset(copy, 0, size);
 
 	copy->next = NULL;
-	copy->timestamp = sample_time(event);
+	copy->timestamp = sample_time(event, session);
 
 	memcpy(&copy->data, event, event->sample.header.size);
 
@@ -1021,7 +1014,7 @@ static void write_svg_file(const char *filename)
 	svg_close();
 }
 
-static void process_samples(void)
+static void process_samples(struct perf_session *session)
 {
 	struct sample_wrapper *cursor;
 	event_t *event;
@@ -1032,15 +1025,13 @@ static void process_samples(void)
 	while (cursor) {
 		event = (void *)&cursor->data;
 		cursor = cursor->next;
-		process_sample_event(event);
+		process_sample_event(event, session);
 	}
 }
 
-static int sample_type_check(u64 type)
+static int sample_type_check(struct perf_session *session)
 {
-	sample_type = type;
-
-	if (!(sample_type & PERF_SAMPLE_RAW)) {
+	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
 		fprintf(stderr, "No trace samples found in the file.\n"
 				"Have you used 'perf timechart record' to record it?\n");
 		return -1;
@@ -1049,7 +1040,7 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_comm_event	= process_comm_event,
 	.process_fork_event	= process_fork_event,
 	.process_exit_event	= process_exit_event,
@@ -1065,13 +1056,11 @@ static int __cmd_timechart(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	register_perf_file_handler(&file_handler);
-
-	ret = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
+	ret = perf_session__process_events(session, &event_ops);
 	if (ret)
 		goto out_delete;
 
-	process_samples();
+	process_samples(session);
 
 	end_sample_processing();
 
@@ -1148,11 +1137,11 @@ static const struct option options[] = {
 
 int cmd_timechart(int argc, const char **argv, const char *prefix __used)
 {
-	symbol__init(0);
-
 	argc = parse_options(argc, argv, options, timechart_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
 
+	symbol__init();
+
 	if (argc && !strncmp(argv[0], "rec", 3))
 		return __cmd_record(argc, argv);
 	else if (argc)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e0a374d..ddc584b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -20,8 +20,9 @@
 
 #include "perf.h"
 
-#include "util/symbol.h"
 #include "util/color.h"
+#include "util/session.h"
+#include "util/symbol.h"
 #include "util/thread.h"
 #include "util/util.h"
 #include <linux/rbtree.h>
@@ -79,7 +80,6 @@ static int			dump_symtab                     =      0;
 static bool			hide_kernel_symbols		=  false;
 static bool			hide_user_symbols		=  false;
 static struct winsize		winsize;
-struct symbol_conf		symbol_conf;
 
 /*
  * Source
@@ -926,7 +926,8 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 	return 0;
 }
 
-static void event__process_sample(const event_t *self, int counter)
+static void event__process_sample(const event_t *self,
+				 struct perf_session *session, int counter)
 {
 	u64 ip = self->ip.ip;
 	struct sym_entry *syme;
@@ -946,8 +947,8 @@ static void event__process_sample(const event_t *self, int counter)
 		return;
 	}
 
-	if (event__preprocess_sample(self, &al, symbol_filter) < 0 ||
-	    al.sym == NULL)
+	if (event__preprocess_sample(self, session, &al, symbol_filter) < 0 ||
+	    al.sym == NULL || al.filtered)
 		return;
 
 	syme = symbol__priv(al.sym);
@@ -965,14 +966,14 @@ static void event__process_sample(const event_t *self, int counter)
 	}
 }
 
-static int event__process(event_t *event)
+static int event__process(event_t *event, struct perf_session *session)
 {
 	switch (event->header.type) {
 	case PERF_RECORD_COMM:
-		event__process_comm(event);
+		event__process_comm(event, session);
 		break;
 	case PERF_RECORD_MMAP:
-		event__process_mmap(event);
+		event__process_mmap(event, session);
 		break;
 	default:
 		break;
@@ -999,7 +1000,8 @@ static unsigned int mmap_read_head(struct mmap_data *md)
 	return head;
 }
 
-static void mmap_read_counter(struct mmap_data *md)
+static void perf_session__mmap_read_counter(struct perf_session *self,
+					    struct mmap_data *md)
 {
 	unsigned int head = mmap_read_head(md);
 	unsigned int old = md->prev;
@@ -1052,9 +1054,9 @@ static void mmap_read_counter(struct mmap_data *md)
 		}
 
 		if (event->header.type == PERF_RECORD_SAMPLE)
-			event__process_sample(event, md->counter);
+			event__process_sample(event, self, md->counter);
 		else
-			event__process(event);
+			event__process(event, self);
 		old += size;
 	}
 
@@ -1064,13 +1066,13 @@ static void mmap_read_counter(struct mmap_data *md)
 static struct pollfd event_array[MAX_NR_CPUS * MAX_COUNTERS];
 static struct mmap_data mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
 
-static void mmap_read(void)
+static void perf_session__mmap_read(struct perf_session *self)
 {
 	int i, counter;
 
 	for (i = 0; i < nr_cpus; i++) {
 		for (counter = 0; counter < nr_counters; counter++)
-			mmap_read_counter(&mmap_array[i][counter]);
+			perf_session__mmap_read_counter(self, &mmap_array[i][counter]);
 	}
 }
 
@@ -1155,11 +1157,18 @@ static int __cmd_top(void)
 	pthread_t thread;
 	int i, counter;
 	int ret;
+	/*
+	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
+	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
+	 */
+	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false);
+	if (session == NULL)
+		return -ENOMEM;
 
 	if (target_pid != -1)
-		event__synthesize_thread(target_pid, event__process);
+		event__synthesize_thread(target_pid, event__process, session);
 	else
-		event__synthesize_threads(event__process);
+		event__synthesize_threads(event__process, session);
 
 	for (i = 0; i < nr_cpus; i++) {
 		group_fd = -1;
@@ -1170,7 +1179,7 @@ static int __cmd_top(void)
 	/* Wait for a minimal set of events before starting the snapshot */
 	poll(event_array, nr_poll, 100);
 
-	mmap_read();
+	perf_session__mmap_read(session);
 
 	if (pthread_create(&thread, NULL, display_thread, NULL)) {
 		printf("Could not create display thread.\n");
@@ -1190,7 +1199,7 @@ static int __cmd_top(void)
 	while (1) {
 		int hits = samples;
 
-		mmap_read();
+		perf_session__mmap_read(session);
 
 		if (hits == samples)
 			ret = poll(event_array, nr_poll, 100);
@@ -1273,7 +1282,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 				 (nr_counters + 1) * sizeof(unsigned long));
 	if (symbol_conf.vmlinux_name == NULL)
 		symbol_conf.try_vmlinux_path = true;
-	if (symbol__init(&symbol_conf) < 0)
+	if (symbol__init() < 0)
 		return -1;
 
 	if (delay_secs < 1)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0756664..e2285e2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -12,7 +12,9 @@
 static char const		*script_name;
 static char const		*generate_script_lang;
 
-static int default_start_script(const char *script __attribute((unused)))
+static int default_start_script(const char *script __unused,
+				int argc __unused,
+				const char **argv __unused)
 {
 	return 0;
 }
@@ -22,7 +24,7 @@ static int default_stop_script(void)
 	return 0;
 }
 
-static int default_generate_script(const char *outfile __attribute ((unused)))
+static int default_generate_script(const char *outfile __unused)
 {
 	return 0;
 }
@@ -57,15 +59,11 @@ static int cleanup_scripting(void)
 #include "util/debug.h"
 
 #include "util/trace-event.h"
-#include "util/data_map.h"
 #include "util/exec_cmd.h"
 
 static char const		*input_name = "perf.data";
 
-static struct perf_session 	*session;
-static u64			sample_type;
-
-static int process_sample_event(event_t *event)
+static int process_sample_event(event_t *event, struct perf_session *session)
 {
 	struct sample_data data;
 	struct thread *thread;
@@ -75,7 +73,7 @@ static int process_sample_event(event_t *event)
 	data.cpu = -1;
 	data.period = 1;
 
-	event__parse_sample(event, sample_type, &data);
+	event__parse_sample(event, session->sample_type, &data);
 
 	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
 		event->header.misc,
@@ -83,14 +81,14 @@ static int process_sample_event(event_t *event)
 		(void *)(long)data.ip,
 		(long long)data.period);
 
-	thread = threads__findnew(event->ip.pid);
+	thread = perf_session__findnew(session, event->ip.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
 		return -1;
 	}
 
-	if (sample_type & PERF_SAMPLE_RAW) {
+	if (session->sample_type & PERF_SAMPLE_RAW) {
 		/*
 		 * FIXME: better resolve from pid from the struct trace_entry
 		 * field, although it should be the same than this perf
@@ -100,16 +98,14 @@ static int process_sample_event(event_t *event)
 					     data.raw_size,
 					     data.time, thread->comm);
 	}
-	event__stats.total += data.period;
 
+	session->events_stats.total += data.period;
 	return 0;
 }
 
-static int sample_type_check(u64 type)
+static int sample_type_check(struct perf_session *session)
 {
-	sample_type = type;
-
-	if (!(sample_type & PERF_SAMPLE_RAW)) {
+	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
 		fprintf(stderr,
 			"No trace sample to read. Did you call perf record "
 			"without -R?");
@@ -119,26 +115,15 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-static struct perf_file_handler file_handler = {
+static struct perf_event_ops event_ops = {
 	.process_sample_event	= process_sample_event,
 	.process_comm_event	= event__process_comm,
 	.sample_type_check	= sample_type_check,
 };
 
-static int __cmd_trace(void)
+static int __cmd_trace(struct perf_session *session)
 {
-	int err;
-
-	session = perf_session__new(input_name, O_RDONLY, 0);
-	if (session == NULL)
-		return -ENOMEM;
-
-	register_idle_thread();
-	register_perf_file_handler(&file_handler);
-
-	err = perf_session__process_events(session, 0, &event__cwdlen, &event__cwd);
-	perf_session__delete(session);
-	return err;
+	return perf_session__process_events(session, &event_ops);
 }
 
 struct script_spec {
@@ -289,6 +274,244 @@ static int parse_scriptname(const struct option *opt __used,
 	return 0;
 }
 
+#define for_each_lang(scripts_dir, lang_dirent, lang_next)		\
+	while (!readdir_r(scripts_dir, &lang_dirent, &lang_next) &&	\
+	       lang_next)						\
+		if (lang_dirent.d_type == DT_DIR &&			\
+		    (strcmp(lang_dirent.d_name, ".")) &&		\
+		    (strcmp(lang_dirent.d_name, "..")))
+
+#define for_each_script(lang_dir, script_dirent, script_next)		\
+	while (!readdir_r(lang_dir, &script_dirent, &script_next) &&	\
+	       script_next)						\
+		if (script_dirent.d_type != DT_DIR)
+
+
+#define RECORD_SUFFIX			"-record"
+#define REPORT_SUFFIX			"-report"
+
+struct script_desc {
+	struct list_head	node;
+	char			*name;
+	char			*half_liner;
+	char			*args;
+};
+
+LIST_HEAD(script_descs);
+
+static struct script_desc *script_desc__new(const char *name)
+{
+	struct script_desc *s = zalloc(sizeof(*s));
+
+	if (s != NULL)
+		s->name = strdup(name);
+
+	return s;
+}
+
+static void script_desc__delete(struct script_desc *s)
+{
+	free(s->name);
+	free(s);
+}
+
+static void script_desc__add(struct script_desc *s)
+{
+	list_add_tail(&s->node, &script_descs);
+}
+
+static struct script_desc *script_desc__find(const char *name)
+{
+	struct script_desc *s;
+
+	list_for_each_entry(s, &script_descs, node)
+		if (strcasecmp(s->name, name) == 0)
+			return s;
+	return NULL;
+}
+
+static struct script_desc *script_desc__findnew(const char *name)
+{
+	struct script_desc *s = script_desc__find(name);
+
+	if (s)
+		return s;
+
+	s = script_desc__new(name);
+	if (!s)
+		goto out_delete_desc;
+
+	script_desc__add(s);
+
+	return s;
+
+out_delete_desc:
+	script_desc__delete(s);
+
+	return NULL;
+}
+
+static char *ends_with(char *str, const char *suffix)
+{
+	size_t suffix_len = strlen(suffix);
+	char *p = str;
+
+	if (strlen(str) > suffix_len) {
+		p = str + strlen(str) - suffix_len;
+		if (!strncmp(p, suffix, suffix_len))
+			return p;
+	}
+
+	return NULL;
+}
+
+static char *ltrim(char *str)
+{
+	int len = strlen(str);
+
+	while (len && isspace(*str)) {
+		len--;
+		str++;
+	}
+
+	return str;
+}
+
+static int read_script_info(struct script_desc *desc, const char *filename)
+{
+	char line[BUFSIZ], *p;
+	FILE *fp;
+
+	fp = fopen(filename, "r");
+	if (!fp)
+		return -1;
+
+	while (fgets(line, sizeof(line), fp)) {
+		p = ltrim(line);
+		if (strlen(p) == 0)
+			continue;
+		if (*p != '#')
+			continue;
+		p++;
+		if (strlen(p) && *p == '!')
+			continue;
+
+		p = ltrim(p);
+		if (strlen(p) && p[strlen(p) - 1] == '\n')
+			p[strlen(p) - 1] = '\0';
+
+		if (!strncmp(p, "description:", strlen("description:"))) {
+			p += strlen("description:");
+			desc->half_liner = strdup(ltrim(p));
+			continue;
+		}
+
+		if (!strncmp(p, "args:", strlen("args:"))) {
+			p += strlen("args:");
+			desc->args = strdup(ltrim(p));
+			continue;
+		}
+	}
+
+	fclose(fp);
+
+	return 0;
+}
+
+static int list_available_scripts(const struct option *opt __used,
+				  const char *s __used, int unset __used)
+{
+	struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
+	char scripts_path[MAXPATHLEN];
+	DIR *scripts_dir, *lang_dir;
+	char script_path[MAXPATHLEN];
+	char lang_path[MAXPATHLEN];
+	struct script_desc *desc;
+	char first_half[BUFSIZ];
+	char *script_root;
+	char *str;
+
+	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
+
+	scripts_dir = opendir(scripts_path);
+	if (!scripts_dir)
+		return -1;
+
+	for_each_lang(scripts_dir, lang_dirent, lang_next) {
+		snprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
+			 lang_dirent.d_name);
+		lang_dir = opendir(lang_path);
+		if (!lang_dir)
+			continue;
+
+		for_each_script(lang_dir, script_dirent, script_next) {
+			script_root = strdup(script_dirent.d_name);
+			str = ends_with(script_root, REPORT_SUFFIX);
+			if (str) {
+				*str = '\0';
+				desc = script_desc__findnew(script_root);
+				snprintf(script_path, MAXPATHLEN, "%s/%s",
+					 lang_path, script_dirent.d_name);
+				read_script_info(desc, script_path);
+			}
+			free(script_root);
+		}
+	}
+
+	fprintf(stdout, "List of available trace scripts:\n");
+	list_for_each_entry(desc, &script_descs, node) {
+		sprintf(first_half, "%s %s", desc->name,
+			desc->args ? desc->args : "");
+		fprintf(stdout, "  %-36s %s\n", first_half,
+			desc->half_liner ? desc->half_liner : "");
+	}
+
+	exit(0);
+}
+
+static char *get_script_path(const char *script_root, const char *suffix)
+{
+	struct dirent *script_next, *lang_next, script_dirent, lang_dirent;
+	char scripts_path[MAXPATHLEN];
+	char script_path[MAXPATHLEN];
+	DIR *scripts_dir, *lang_dir;
+	char lang_path[MAXPATHLEN];
+	char *str, *__script_root;
+	char *path = NULL;
+
+	snprintf(scripts_path, MAXPATHLEN, "%s/scripts", perf_exec_path());
+
+	scripts_dir = opendir(scripts_path);
+	if (!scripts_dir)
+		return NULL;
+
+	for_each_lang(scripts_dir, lang_dirent, lang_next) {
+		snprintf(lang_path, MAXPATHLEN, "%s/%s/bin", scripts_path,
+			 lang_dirent.d_name);
+		lang_dir = opendir(lang_path);
+		if (!lang_dir)
+			continue;
+
+		for_each_script(lang_dir, script_dirent, script_next) {
+			__script_root = strdup(script_dirent.d_name);
+			str = ends_with(__script_root, suffix);
+			if (str) {
+				*str = '\0';
+				if (strcmp(__script_root, script_root))
+					continue;
+				snprintf(script_path, MAXPATHLEN, "%s/%s",
+					 lang_path, script_dirent.d_name);
+				path = strdup(script_path);
+				free(__script_root);
+				break;
+			}
+			free(__script_root);
+		}
+	}
+
+	return path;
+}
+
 static const char * const annotate_usage[] = {
 	"perf trace [<options>] <command>",
 	NULL
@@ -299,8 +522,10 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('l', "latency", &latency_format,
+	OPT_BOOLEAN('L', "Latency", &latency_format,
 		    "show latency attributes (irqs/preemption disabled, etc)"),
+	OPT_CALLBACK_NOOPT('l', "list", NULL, NULL, "list available scripts",
+			   list_available_scripts),
 	OPT_CALLBACK('s', "script", NULL, "name",
 		     "script file name (lang:script name, script name, or *)",
 		     parse_scriptname),
@@ -312,24 +537,61 @@ static const struct option options[] = {
 
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
-	int err;
+	struct perf_session *session;
+	const char *suffix = NULL;
+	const char **__argv;
+	char *script_path;
+	int i, err;
+
+	if (argc >= 2 && strncmp(argv[1], "rec", strlen("rec")) == 0) {
+		if (argc < 3) {
+			fprintf(stderr,
+				"Please specify a record script\n");
+			return -1;
+		}
+		suffix = RECORD_SUFFIX;
+	}
 
-	symbol__init(0);
+	if (argc >= 2 && strncmp(argv[1], "rep", strlen("rep")) == 0) {
+		if (argc < 3) {
+			fprintf(stderr,
+				"Please specify a report script\n");
+			return -1;
+		}
+		suffix = REPORT_SUFFIX;
+	}
 
-	setup_scripting();
+	if (suffix) {
+		script_path = get_script_path(argv[2], suffix);
+		if (!script_path) {
+			fprintf(stderr, "script not found\n");
+			return -1;
+		}
 
-	argc = parse_options(argc, argv, options, annotate_usage, 0);
-	if (argc) {
-		/*
-		 * Special case: if there's an argument left then assume tha
-		 * it's a symbol filter:
-		 */
-		if (argc > 1)
-			usage_with_options(annotate_usage, options);
+		__argv = malloc((argc + 1) * sizeof(const char *));
+		__argv[0] = "/bin/sh";
+		__argv[1] = script_path;
+		for (i = 3; i < argc; i++)
+			__argv[i - 1] = argv[i];
+		__argv[argc - 1] = NULL;
+
+		execvp("/bin/sh", (char **)__argv);
+		exit(-1);
 	}
 
+	setup_scripting();
+
+	argc = parse_options(argc, argv, options, annotate_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (symbol__init() < 0)
+		return -1;
 	setup_pager();
 
+	session = perf_session__new(input_name, O_RDONLY, 0);
+	if (session == NULL)
+		return -ENOMEM;
+
 	if (generate_script_lang) {
 		struct stat perf_stat;
 
@@ -362,13 +624,14 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 	}
 
 	if (script_name) {
-		err = scripting_ops->start_script(script_name);
+		err = scripting_ops->start_script(script_name, argc, argv);
 		if (err)
 			goto out;
 	}
 
-	err = __cmd_trace();
+	err = __cmd_trace(session);
 
+	perf_session__delete(session);
 	cleanup_scripting();
 out:
 	return err;
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index a3d8bf6..18035b1 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -17,6 +17,7 @@ extern int check_pager_config(const char *cmd);
 extern int cmd_annotate(int argc, const char **argv, const char *prefix);
 extern int cmd_bench(int argc, const char **argv, const char *prefix);
 extern int cmd_buildid_list(int argc, const char **argv, const char *prefix);
+extern int cmd_diff(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
 extern int cmd_sched(int argc, const char **argv, const char *prefix);
 extern int cmd_list(int argc, const char **argv, const char *prefix);
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 02b09ea..71dc7c3 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -5,6 +5,7 @@
 perf-annotate			mainporcelain common
 perf-bench			mainporcelain common
 perf-buildid-list		mainporcelain common
+perf-diff			mainporcelain common
 perf-list			mainporcelain common
 perf-sched			mainporcelain common
 perf-record			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index cf64049..873e55f 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -286,6 +286,7 @@ static void handle_internal_command(int argc, const char **argv)
 	const char *cmd = argv[0];
 	static struct cmd_struct commands[] = {
 		{ "buildid-list", cmd_buildid_list, 0 },
+		{ "diff",	cmd_diff,	0 },
 		{ "help",	cmd_help,	0 },
 		{ "list",	cmd_list,	0 },
 		{ "record",	cmd_record,	0 },
diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-report b/tools/perf/scripts/perl/bin/check-perf-trace-report
index 89948b0..7fc4a03 100644
--- a/tools/perf/scripts/perl/bin/check-perf-trace-report
+++ b/tools/perf/scripts/perl/bin/check-perf-trace-report
@@ -1,4 +1,5 @@
 #!/bin/bash
+# description: useless but exhaustive test script
 perf trace -s ~/libexec/perf-core/scripts/perl/check-perf-trace.pl
 
 
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-report b/tools/perf/scripts/perl/bin/rw-by-file-report
index f5dcf9c..eddb9cc 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-report
+++ b/tools/perf/scripts/perl/bin/rw-by-file-report
@@ -1,5 +1,7 @@
 #!/bin/bash
-perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl
+# description: r/w activity for a program, by file
+# args: <comm>
+perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl $1
 
 
 
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-report b/tools/perf/scripts/perl/bin/rw-by-pid-report
index cea16f7..7f44c25 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-report
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-report
@@ -1,4 +1,5 @@
 #!/bin/bash
+# description: system-wide r/w activity
 perf trace -s ~/libexec/perf-core/scripts/perl/rw-by-pid.pl
 
 
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-report b/tools/perf/scripts/perl/bin/wakeup-latency-report
index 85769dc..fce3adc 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-report
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-report
@@ -1,4 +1,5 @@
 #!/bin/bash
+# description: system-wide min/max/avg wakeup latency
 perf trace -s ~/libexec/perf-core/scripts/perl/wakeup-latency.pl
 
 
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-report b/tools/perf/scripts/perl/bin/workqueue-stats-report
index aa68435..71cfbd1 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-report
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-report
@@ -1,4 +1,5 @@
 #!/bin/bash
+# description: workqueue stats (ins/exe/create/destroy)
 perf trace -s ~/libexec/perf-core/scripts/perl/workqueue-stats.pl
 
 
diff --git a/tools/perf/scripts/perl/rw-by-file.pl b/tools/perf/scripts/perl/rw-by-file.pl
index 61f9156..2a39097 100644
--- a/tools/perf/scripts/perl/rw-by-file.pl
+++ b/tools/perf/scripts/perl/rw-by-file.pl
@@ -18,8 +18,9 @@ use lib "./Perf-Trace-Util/lib";
 use Perf::Trace::Core;
 use Perf::Trace::Util;
 
-# change this to the comm of the program you're interested in
-my $for_comm = "perf";
+my $usage = "perf trace -s rw-by-file.pl <comm>\n";
+
+my $for_comm = shift or die $usage;
 
 my %reads;
 my %writes;
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index 6d46dda..b557b83 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -1,20 +1,17 @@
-#include "data_map.h"
 #include "symbol.h"
 #include "util.h"
 #include "debug.h"
+#include "thread.h"
+#include "session.h"
 
-
-static struct perf_file_handler *curr_handler;
-static unsigned long	mmap_window = 32;
-static char		__cwd[PATH_MAX];
-
-static int process_event_stub(event_t *event __used)
+static int process_event_stub(event_t *event __used,
+			      struct perf_session *session __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
 }
 
-void register_perf_file_handler(struct perf_file_handler *handler)
+static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 {
 	if (!handler->process_sample_event)
 		handler->process_sample_event = process_event_stub;
@@ -34,8 +31,6 @@ void register_perf_file_handler(struct perf_file_handler *handler)
 		handler->process_throttle_event = process_event_stub;
 	if (!handler->process_unthrottle_event)
 		handler->process_unthrottle_event = process_event_stub;
-
-	curr_handler = handler;
 }
 
 static const char *event__name[] = {
@@ -61,8 +56,9 @@ void event__print_totals(void)
 			event__name[i], event__total[i]);
 }
 
-static int
-process_event(event_t *event, unsigned long offset, unsigned long head)
+static int process_event(event_t *event, struct perf_session *session,
+			 struct perf_event_ops *ops,
+			 unsigned long offset, unsigned long head)
 {
 	trace_event(event);
 
@@ -77,25 +73,25 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-		return curr_handler->process_sample_event(event);
+		return ops->process_sample_event(event, session);
 	case PERF_RECORD_MMAP:
-		return curr_handler->process_mmap_event(event);
+		return ops->process_mmap_event(event, session);
 	case PERF_RECORD_COMM:
-		return curr_handler->process_comm_event(event);
+		return ops->process_comm_event(event, session);
 	case PERF_RECORD_FORK:
-		return curr_handler->process_fork_event(event);
+		return ops->process_fork_event(event, session);
 	case PERF_RECORD_EXIT:
-		return curr_handler->process_exit_event(event);
+		return ops->process_exit_event(event, session);
 	case PERF_RECORD_LOST:
-		return curr_handler->process_lost_event(event);
+		return ops->process_lost_event(event, session);
 	case PERF_RECORD_READ:
-		return curr_handler->process_read_event(event);
+		return ops->process_read_event(event, session);
 	case PERF_RECORD_THROTTLE:
-		return curr_handler->process_throttle_event(event);
+		return ops->process_throttle_event(event, session);
 	case PERF_RECORD_UNTHROTTLE:
-		return curr_handler->process_unthrottle_event(event);
+		return ops->process_unthrottle_event(event, session);
 	default:
-		curr_handler->total_unknown++;
+		ops->total_unknown++;
 		return -1;
 	}
 }
@@ -129,44 +125,58 @@ out:
 	return err;
 }
 
+static struct thread *perf_session__register_idle_thread(struct perf_session *self)
+{
+	struct thread *thread = perf_session__findnew(self, 0);
+
+	if (!thread || thread__set_comm(thread, "swapper")) {
+		pr_err("problem inserting idle task.\n");
+		thread = NULL;
+	}
+
+	return thread;
+}
+
 int perf_session__process_events(struct perf_session *self,
-				 int full_paths, int *cwdlen, char **cwd)
+				 struct perf_event_ops *ops)
 {
 	int err;
 	unsigned long head, shift;
 	unsigned long offset = 0;
 	size_t	page_size;
-	u64 sample_type;
 	event_t *event;
 	uint32_t size;
 	char *buf;
 
-	if (curr_handler == NULL) {
-		pr_debug("Forgot to register perf file handler\n");
-		return -EINVAL;
-	}
+	if (perf_session__register_idle_thread(self) == NULL)
+		return -ENOMEM;
+
+	perf_event_ops__fill_defaults(ops);
 
 	page_size = getpagesize();
 
 	head = self->header.data_offset;
-	sample_type = perf_header__sample_type(&self->header);
+	self->sample_type = perf_header__sample_type(&self->header);
 
 	err = -EINVAL;
-	if (curr_handler->sample_type_check &&
-	    curr_handler->sample_type_check(sample_type) < 0)
+	if (ops->sample_type_check && ops->sample_type_check(self) < 0)
 		goto out_err;
 
-	if (!full_paths) {
-		if (getcwd(__cwd, sizeof(__cwd)) == NULL) {
-			pr_err("failed to get the current directory\n");
+	if (!ops->full_paths) {
+		char bf[PATH_MAX];
+
+		if (getcwd(bf, sizeof(bf)) == NULL) {
 			err = -errno;
+out_getcwd_err:
+			pr_err("failed to get the current directory\n");
 			goto out_err;
 		}
-		*cwd = __cwd;
-		*cwdlen = strlen(*cwd);
-	} else {
-		*cwd = NULL;
-		*cwdlen = 0;
+		self->cwd = strdup(bf);
+		if (self->cwd == NULL) {
+			err = -ENOMEM;
+			goto out_getcwd_err;
+		}
+		self->cwdlen = strlen(self->cwd);
 	}
 
 	shift = page_size * (head / page_size);
@@ -174,7 +184,7 @@ int perf_session__process_events(struct perf_session *self,
 	head -= shift;
 
 remap:
-	buf = mmap(NULL, page_size * mmap_window, PROT_READ,
+	buf = mmap(NULL, page_size * self->mmap_window, PROT_READ,
 		   MAP_SHARED, self->fd, offset);
 	if (buf == MAP_FAILED) {
 		pr_err("failed to mmap file\n");
@@ -189,12 +199,12 @@ more:
 	if (!size)
 		size = 8;
 
-	if (head + event->header.size >= page_size * mmap_window) {
+	if (head + event->header.size >= page_size * self->mmap_window) {
 		int munmap_ret;
 
 		shift = page_size * (head / page_size);
 
-		munmap_ret = munmap(buf, page_size * mmap_window);
+		munmap_ret = munmap(buf, page_size * self->mmap_window);
 		assert(munmap_ret == 0);
 
 		offset += shift;
@@ -209,7 +219,7 @@ more:
 			(void *)(long)event->header.size,
 			event->header.type);
 
-	if (!size || process_event(event, offset, head) < 0) {
+	if (!size || process_event(event, self, ops, offset, head) < 0) {
 
 		dump_printf("%p [%p]: skipping unknown header type: %d\n",
 			(void *)(offset + head),
diff --git a/tools/perf/util/data_map.h b/tools/perf/util/data_map.h
deleted file mode 100644
index 98c5b82..0000000
--- a/tools/perf/util/data_map.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef __PERF_DATAMAP_H
-#define __PERF_DATAMAP_H
-
-#include "event.h"
-#include "header.h"
-#include "session.h"
-
-typedef int (*event_type_handler_t)(event_t *);
-
-struct perf_file_handler {
-	event_type_handler_t	process_sample_event;
-	event_type_handler_t	process_mmap_event;
-	event_type_handler_t	process_comm_event;
-	event_type_handler_t	process_fork_event;
-	event_type_handler_t	process_exit_event;
-	event_type_handler_t	process_lost_event;
-	event_type_handler_t	process_read_event;
-	event_type_handler_t	process_throttle_event;
-	event_type_handler_t	process_unthrottle_event;
-	int			(*sample_type_check)(u64 sample_type);
-	unsigned long		total_unknown;
-};
-
-void register_perf_file_handler(struct perf_file_handler *handler);
-int perf_session__process_events(struct perf_session *self,
-				 int full_paths, int *cwdlen, char **cwd);
-int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
-
-#endif
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index ba0de90..bb0fd6d 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,11 +1,16 @@
 #include <linux/types.h>
 #include "event.h"
 #include "debug.h"
+#include "session.h"
+#include "sort.h"
 #include "string.h"
+#include "strlist.h"
 #include "thread.h"
 
 static pid_t event__synthesize_comm(pid_t pid, int full,
-				    int (*process)(event_t *event))
+				    int (*process)(event_t *event,
+						   struct perf_session *session),
+				    struct perf_session *session)
 {
 	event_t ev;
 	char filename[PATH_MAX];
@@ -54,7 +59,7 @@ out_race:
 	if (!full) {
 		ev.comm.tid = pid;
 
-		process(&ev);
+		process(&ev, session);
 		goto out_fclose;
 	}
 
@@ -72,7 +77,7 @@ out_race:
 
 		ev.comm.tid = pid;
 
-		process(&ev);
+		process(&ev, session);
 	}
 	closedir(tasks);
 
@@ -86,7 +91,9 @@ out_failure:
 }
 
 static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
-					 int (*process)(event_t *event))
+					 int (*process)(event_t *event,
+							struct perf_session *session),
+					 struct perf_session *session)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
@@ -141,7 +148,7 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 			ev.mmap.pid = tgid;
 			ev.mmap.tid = pid;
 
-			process(&ev);
+			process(&ev, session);
 		}
 	}
 
@@ -149,15 +156,20 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 	return 0;
 }
 
-int event__synthesize_thread(pid_t pid, int (*process)(event_t *event))
+int event__synthesize_thread(pid_t pid,
+			     int (*process)(event_t *event,
+					    struct perf_session *session),
+			     struct perf_session *session)
 {
-	pid_t tgid = event__synthesize_comm(pid, 1, process);
+	pid_t tgid = event__synthesize_comm(pid, 1, process, session);
 	if (tgid == -1)
 		return -1;
-	return event__synthesize_mmap_events(pid, tgid, process);
+	return event__synthesize_mmap_events(pid, tgid, process, session);
 }
 
-void event__synthesize_threads(int (*process)(event_t *event))
+void event__synthesize_threads(int (*process)(event_t *event,
+					      struct perf_session *session),
+			       struct perf_session *session)
 {
 	DIR *proc;
 	struct dirent dirent, *next;
@@ -171,24 +183,47 @@ void event__synthesize_threads(int (*process)(event_t *event))
 		if (*end) /* only interested in proper numerical dirents */
 			continue;
 
-		event__synthesize_thread(pid, process);
+		event__synthesize_thread(pid, process, session);
 	}
 
 	closedir(proc);
 }
 
-char *event__cwd;
-int  event__cwdlen;
+static void thread__comm_adjust(struct thread *self)
+{
+	char *comm = self->comm;
 
-struct events_stats event__stats;
+	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
+	    (!symbol_conf.comm_list ||
+	     strlist__has_entry(symbol_conf.comm_list, comm))) {
+		unsigned int slen = strlen(comm);
 
-int event__process_comm(event_t *self)
+		if (slen > comms__col_width) {
+			comms__col_width = slen;
+			threads__col_width = slen + 6;
+		}
+	}
+}
+
+static int thread__set_comm_adjust(struct thread *self, const char *comm)
 {
-	struct thread *thread = threads__findnew(self->comm.pid);
+	int ret = thread__set_comm(self, comm);
+
+	if (ret)
+		return ret;
+
+	thread__comm_adjust(self);
+
+	return 0;
+}
+
+int event__process_comm(event_t *self, struct perf_session *session)
+{
+	struct thread *thread = perf_session__findnew(session, self->comm.pid);
 
 	dump_printf(": %s:%d\n", self->comm.comm, self->comm.pid);
 
-	if (thread == NULL || thread__set_comm(thread, self->comm.comm)) {
+	if (thread == NULL || thread__set_comm_adjust(thread, self->comm.comm)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
 		return -1;
 	}
@@ -196,18 +231,18 @@ int event__process_comm(event_t *self)
 	return 0;
 }
 
-int event__process_lost(event_t *self)
+int event__process_lost(event_t *self, struct perf_session *session)
 {
 	dump_printf(": id:%Ld: lost:%Ld\n", self->lost.id, self->lost.lost);
-	event__stats.lost += self->lost.lost;
+	session->events_stats.lost += self->lost.lost;
 	return 0;
 }
 
-int event__process_mmap(event_t *self)
+int event__process_mmap(event_t *self, struct perf_session *session)
 {
-	struct thread *thread = threads__findnew(self->mmap.pid);
+	struct thread *thread = perf_session__findnew(session, self->mmap.pid);
 	struct map *map = map__new(&self->mmap, MAP__FUNCTION,
-				   event__cwd, event__cwdlen);
+				   session->cwd, session->cwdlen);
 
 	dump_printf(" %d/%d: [%p(%p) @ %p]: %s\n",
 		    self->mmap.pid, self->mmap.tid,
@@ -224,10 +259,10 @@ int event__process_mmap(event_t *self)
 	return 0;
 }
 
-int event__process_task(event_t *self)
+int event__process_task(event_t *self, struct perf_session *session)
 {
-	struct thread *thread = threads__findnew(self->fork.pid);
-	struct thread *parent = threads__findnew(self->fork.ppid);
+	struct thread *thread = perf_session__findnew(session, self->fork.pid);
+	struct thread *parent = perf_session__findnew(session, self->fork.ppid);
 
 	dump_printf("(%d:%d):(%d:%d)\n", self->fork.pid, self->fork.tid,
 		    self->fork.ppid, self->fork.ptid);
@@ -249,7 +284,8 @@ int event__process_task(event_t *self)
 	return 0;
 }
 
-void thread__find_addr_location(struct thread *self, u8 cpumode,
+void thread__find_addr_location(struct thread *self,
+				struct perf_session *session, u8 cpumode,
 				enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter)
@@ -261,7 +297,7 @@ void thread__find_addr_location(struct thread *self, u8 cpumode,
 
 	if (cpumode & PERF_RECORD_MISC_KERNEL) {
 		al->level = 'k';
-		mg = kmaps;
+		mg = &session->kmaps;
 	} else if (cpumode & PERF_RECORD_MISC_USER)
 		al->level = '.';
 	else {
@@ -282,33 +318,73 @@ try_again:
 		 * "[vdso]" dso, but for now lets use the old trick of looking
 		 * in the whole kernel symbol list.
 		 */
-		if ((long long)al->addr < 0 && mg != kmaps) {
-			mg = kmaps;
+		if ((long long)al->addr < 0 && mg != &session->kmaps) {
+			mg = &session->kmaps;
 			goto try_again;
 		}
 		al->sym = NULL;
 	} else {
 		al->addr = al->map->map_ip(al->map, al->addr);
-		al->sym = map__find_symbol(al->map, al->addr, filter);
+		al->sym = map__find_symbol(al->map, session, al->addr, filter);
 	}
 }
 
-int event__preprocess_sample(const event_t *self, struct addr_location *al,
-			     symbol_filter_t filter)
+static void dso__calc_col_width(struct dso *self)
+{
+	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
+	    (!symbol_conf.dso_list ||
+	     strlist__has_entry(symbol_conf.dso_list, self->name))) {
+		unsigned int slen = strlen(self->name);
+		if (slen > dsos__col_width)
+			dsos__col_width = slen;
+	}
+
+	self->slen_calculated = 1;
+}
+
+int event__preprocess_sample(const event_t *self, struct perf_session *session,
+			     struct addr_location *al, symbol_filter_t filter)
 {
 	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = threads__findnew(self->ip.pid);
+	struct thread *thread = perf_session__findnew(session, self->ip.pid);
 
 	if (thread == NULL)
 		return -1;
 
+	if (symbol_conf.comm_list &&
+	    !strlist__has_entry(symbol_conf.comm_list, thread->comm))
+		goto out_filtered;
+
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
+	thread__find_addr_location(thread, session, cpumode, MAP__FUNCTION,
 				   self->ip.ip, al, filter);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
+	/*
+	 * We have to do this here as we may have a dso with no symbol hit that
+	 * has a name longer than the ones with symbols sampled.
+	 */
+	if (al->map && !sort_dso.elide && !al->map->dso->slen_calculated)
+		dso__calc_col_width(al->map->dso);
+
+	if (symbol_conf.dso_list &&
+	    (!al->map || !al->map->dso ||
+	     !(strlist__has_entry(symbol_conf.dso_list, al->map->dso->short_name) ||
+	       (al->map->dso->short_name != al->map->dso->long_name &&
+		strlist__has_entry(symbol_conf.dso_list, al->map->dso->long_name)))))
+		goto out_filtered;
+
+	if (symbol_conf.sym_list && al->sym &&
+	    !strlist__has_entry(symbol_conf.sym_list, al->sym->name))
+		goto out_filtered;
+
+	al->filtered = false;
+	return 0;
+
+out_filtered:
+	al->filtered = true;
 	return 0;
 }
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 51a96c2..8027309 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -149,29 +149,35 @@ void map__delete(struct map *self);
 struct map *map__clone(struct map *self);
 int map__overlap(struct map *l, struct map *r);
 size_t map__fprintf(struct map *self, FILE *fp);
-struct symbol *map__find_symbol(struct map *self, u64 addr,
-				symbol_filter_t filter);
+
+struct perf_session;
+
+int map__load(struct map *self, struct perf_session *session,
+	      symbol_filter_t filter);
+struct symbol *map__find_symbol(struct map *self, struct perf_session *session,
+				u64 addr, symbol_filter_t filter);
 struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					struct perf_session *session,
 					symbol_filter_t filter);
 void map__fixup_start(struct map *self);
 void map__fixup_end(struct map *self);
 
-int event__synthesize_thread(pid_t pid, int (*process)(event_t *event));
-void event__synthesize_threads(int (*process)(event_t *event));
-
-extern char *event__cwd;
-extern int  event__cwdlen;
-extern struct events_stats event__stats;
-extern unsigned long event__total[PERF_RECORD_MAX];
+int event__synthesize_thread(pid_t pid,
+			     int (*process)(event_t *event,
+					    struct perf_session *session),
+			     struct perf_session *session);
+void event__synthesize_threads(int (*process)(event_t *event,
+					      struct perf_session *session),
+			       struct perf_session *session);
 
-int event__process_comm(event_t *self);
-int event__process_lost(event_t *self);
-int event__process_mmap(event_t *self);
-int event__process_task(event_t *self);
+int event__process_comm(event_t *self, struct perf_session *session);
+int event__process_lost(event_t *self, struct perf_session *session);
+int event__process_mmap(event_t *self, struct perf_session *session);
+int event__process_task(event_t *self, struct perf_session *session);
 
 struct addr_location;
-int event__preprocess_sample(const event_t *self, struct addr_location *al,
-			     symbol_filter_t filter);
+int event__preprocess_sample(const event_t *self, struct perf_session *session,
+			     struct addr_location *al, symbol_filter_t filter);
 int event__parse_sample(event_t *event, u64 type, struct sample_data *data);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f2e8d87..8a0bca5 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -8,8 +8,8 @@
 #include "header.h"
 #include "../perf.h"
 #include "trace-event.h"
+#include "session.h"
 #include "symbol.h"
-#include "data_map.h"
 #include "debug.h"
 
 /*
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 0ebf6ee..e8daf5c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,9 +1,7 @@
 #include "hist.h"
-
-struct rb_root hist;
-struct rb_root collapse_hists;
-struct rb_root output_hists;
-int callchain;
+#include "session.h"
+#include "sort.h"
+#include <math.h>
 
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
@@ -14,11 +12,12 @@ struct callchain_param	callchain_param = {
  * histogram, sorted on item, collects counts
  */
 
-struct hist_entry *__hist_entry__add(struct addr_location *al,
-				     struct symbol *sym_parent,
-				     u64 count, bool *hit)
+struct hist_entry *__perf_session__add_hist_entry(struct perf_session *self,
+						  struct addr_location *al,
+						  struct symbol *sym_parent,
+						  u64 count, bool *hit)
 {
-	struct rb_node **p = &hist.rb_node;
+	struct rb_node **p = &self->hists.rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
 	struct hist_entry entry = {
@@ -54,7 +53,7 @@ struct hist_entry *__hist_entry__add(struct addr_location *al,
 		return NULL;
 	*he = entry;
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &hist);
+	rb_insert_color(&he->rb_node, &self->hists);
 	*hit = false;
 	return he;
 }
@@ -102,9 +101,9 @@ void hist_entry__free(struct hist_entry *he)
  * collapse the histogram
  */
 
-void collapse__insert_entry(struct hist_entry *he)
+static void collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 {
-	struct rb_node **p = &collapse_hists.rb_node;
+	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 	int64_t cmp;
@@ -128,38 +127,45 @@ void collapse__insert_entry(struct hist_entry *he)
 	}
 
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &collapse_hists);
+	rb_insert_color(&he->rb_node, root);
 }
 
-void collapse__resort(void)
+void perf_session__collapse_resort(struct perf_session *self)
 {
+	struct rb_root tmp;
 	struct rb_node *next;
 	struct hist_entry *n;
 
 	if (!sort__need_collapse)
 		return;
 
-	next = rb_first(&hist);
+	tmp = RB_ROOT;
+	next = rb_first(&self->hists);
+
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, &hist);
-		collapse__insert_entry(n);
+		rb_erase(&n->rb_node, &self->hists);
+		collapse__insert_entry(&tmp, n);
 	}
+
+	self->hists = tmp;
 }
 
 /*
  * reverse the map, sort on count.
  */
 
-void output__insert_entry(struct hist_entry *he, u64 min_callchain_hits)
+static void perf_session__insert_output_hist_entry(struct rb_root *root,
+						   struct hist_entry *he,
+						   u64 min_callchain_hits)
 {
-	struct rb_node **p = &output_hists.rb_node;
+	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
-	if (callchain)
+	if (symbol_conf.use_callchain)
 		callchain_param.sort(&he->sorted_chain, &he->callchain,
 				      min_callchain_hits, &callchain_param);
 
@@ -174,29 +180,483 @@ void output__insert_entry(struct hist_entry *he, u64 min_callchain_hits)
 	}
 
 	rb_link_node(&he->rb_node, parent, p);
-	rb_insert_color(&he->rb_node, &output_hists);
+	rb_insert_color(&he->rb_node, root);
 }
 
-void output__resort(u64 total_samples)
+void perf_session__output_resort(struct perf_session *self, u64 total_samples)
 {
+	struct rb_root tmp;
 	struct rb_node *next;
 	struct hist_entry *n;
-	struct rb_root *tree = &hist;
 	u64 min_callchain_hits;
 
 	min_callchain_hits =
 		total_samples * (callchain_param.min_percent / 100);
 
-	if (sort__need_collapse)
-		tree = &collapse_hists;
-
-	next = rb_first(tree);
+	tmp = RB_ROOT;
+	next = rb_first(&self->hists);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
 		next = rb_next(&n->rb_node);
 
-		rb_erase(&n->rb_node, tree);
-		output__insert_entry(n, min_callchain_hits);
+		rb_erase(&n->rb_node, &self->hists);
+		perf_session__insert_output_hist_entry(&tmp, n,
+						       min_callchain_hits);
+	}
+
+	self->hists = tmp;
+}
+
+static size_t callchain__fprintf_left_margin(FILE *fp, int left_margin)
+{
+	int i;
+	int ret = fprintf(fp, "            ");
+
+	for (i = 0; i < left_margin; i++)
+		ret += fprintf(fp, " ");
+
+	return ret;
+}
+
+static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
+					  int left_margin)
+{
+	int i;
+	size_t ret = callchain__fprintf_left_margin(fp, left_margin);
+
+	for (i = 0; i < depth; i++)
+		if (depth_mask & (1 << i))
+			ret += fprintf(fp, "|          ");
+		else
+			ret += fprintf(fp, "           ");
+
+	ret += fprintf(fp, "\n");
+
+	return ret;
+}
+
+static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
+				     int depth, int depth_mask, int count,
+				     u64 total_samples, int hits,
+				     int left_margin)
+{
+	int i;
+	size_t ret = 0;
+
+	ret += callchain__fprintf_left_margin(fp, left_margin);
+	for (i = 0; i < depth; i++) {
+		if (depth_mask & (1 << i))
+			ret += fprintf(fp, "|");
+		else
+			ret += fprintf(fp, " ");
+		if (!count && i == depth - 1) {
+			double percent;
+
+			percent = hits * 100.0 / total_samples;
+			ret += percent_color_fprintf(fp, "--%2.2f%%-- ", percent);
+		} else
+			ret += fprintf(fp, "%s", "          ");
+	}
+	if (chain->sym)
+		ret += fprintf(fp, "%s\n", chain->sym->name);
+	else
+		ret += fprintf(fp, "%p\n", (void *)(long)chain->ip);
+
+	return ret;
+}
+
+static struct symbol *rem_sq_bracket;
+static struct callchain_list rem_hits;
+
+static void init_rem_hits(void)
+{
+	rem_sq_bracket = malloc(sizeof(*rem_sq_bracket) + 6);
+	if (!rem_sq_bracket) {
+		fprintf(stderr, "Not enough memory to display remaining hits\n");
+		return;
+	}
+
+	strcpy(rem_sq_bracket->name, "[...]");
+	rem_hits.sym = rem_sq_bracket;
+}
+
+static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+					 u64 total_samples, int depth,
+					 int depth_mask, int left_margin)
+{
+	struct rb_node *node, *next;
+	struct callchain_node *child;
+	struct callchain_list *chain;
+	int new_depth_mask = depth_mask;
+	u64 new_total;
+	u64 remaining;
+	size_t ret = 0;
+	int i;
+
+	if (callchain_param.mode == CHAIN_GRAPH_REL)
+		new_total = self->children_hit;
+	else
+		new_total = total_samples;
+
+	remaining = new_total;
+
+	node = rb_first(&self->rb_root);
+	while (node) {
+		u64 cumul;
+
+		child = rb_entry(node, struct callchain_node, rb_node);
+		cumul = cumul_hits(child);
+		remaining -= cumul;
+
+		/*
+		 * The depth mask manages the output of pipes that show
+		 * the depth. We don't want to keep the pipes of the current
+		 * level for the last child of this depth.
+		 * Except if we have remaining filtered hits. They will
+		 * supersede the last child
+		 */
+		next = rb_next(node);
+		if (!next && (callchain_param.mode != CHAIN_GRAPH_REL || !remaining))
+			new_depth_mask &= ~(1 << (depth - 1));
+
+		/*
+		 * But we keep the older depth mask for the line seperator
+		 * to keep the level link until we reach the last child
+		 */
+		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask,
+						   left_margin);
+		i = 0;
+		list_for_each_entry(chain, &child->val, list) {
+			if (chain->ip >= PERF_CONTEXT_MAX)
+				continue;
+			ret += ipchain__fprintf_graph(fp, chain, depth,
+						      new_depth_mask, i++,
+						      new_total,
+						      cumul,
+						      left_margin);
+		}
+		ret += __callchain__fprintf_graph(fp, child, new_total,
+						  depth + 1,
+						  new_depth_mask | (1 << depth),
+						  left_margin);
+		node = next;
+	}
+
+	if (callchain_param.mode == CHAIN_GRAPH_REL &&
+		remaining && remaining != new_total) {
+
+		if (!rem_sq_bracket)
+			return ret;
+
+		new_depth_mask &= ~(1 << (depth - 1));
+
+		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
+					      new_depth_mask, 0, new_total,
+					      remaining, left_margin);
+	}
+
+	return ret;
+}
+
+static size_t callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
+				       u64 total_samples, int left_margin)
+{
+	struct callchain_list *chain;
+	bool printed = false;
+	int i = 0;
+	int ret = 0;
+
+	list_for_each_entry(chain, &self->val, list) {
+		if (chain->ip >= PERF_CONTEXT_MAX)
+			continue;
+
+		if (!i++ && sort__first_dimension == SORT_SYM)
+			continue;
+
+		if (!printed) {
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+			ret += fprintf(fp, "|\n");
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+			ret += fprintf(fp, "---");
+
+			left_margin += 3;
+			printed = true;
+		} else
+			ret += callchain__fprintf_left_margin(fp, left_margin);
+
+		if (chain->sym)
+			ret += fprintf(fp, " %s\n", chain->sym->name);
+		else
+			ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
+	}
+
+	ret += __callchain__fprintf_graph(fp, self, total_samples, 1, 1, left_margin);
+
+	return ret;
+}
+
+static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
+				      u64 total_samples)
+{
+	struct callchain_list *chain;
+	size_t ret = 0;
+
+	if (!self)
+		return 0;
+
+	ret += callchain__fprintf_flat(fp, self->parent, total_samples);
+
+
+	list_for_each_entry(chain, &self->val, list) {
+		if (chain->ip >= PERF_CONTEXT_MAX)
+			continue;
+		if (chain->sym)
+			ret += fprintf(fp, "                %s\n", chain->sym->name);
+		else
+			ret += fprintf(fp, "                %p\n",
+					(void *)(long)chain->ip);
+	}
+
+	return ret;
+}
+
+static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
+					    u64 total_samples, int left_margin)
+{
+	struct rb_node *rb_node;
+	struct callchain_node *chain;
+	size_t ret = 0;
+
+	rb_node = rb_first(&self->sorted_chain);
+	while (rb_node) {
+		double percent;
+
+		chain = rb_entry(rb_node, struct callchain_node, rb_node);
+		percent = chain->hit * 100.0 / total_samples;
+		switch (callchain_param.mode) {
+		case CHAIN_FLAT:
+			ret += percent_color_fprintf(fp, "           %6.2f%%\n",
+						     percent);
+			ret += callchain__fprintf_flat(fp, chain, total_samples);
+			break;
+		case CHAIN_GRAPH_ABS: /* Falldown */
+		case CHAIN_GRAPH_REL:
+			ret += callchain__fprintf_graph(fp, chain, total_samples,
+							left_margin);
+		case CHAIN_NONE:
+		default:
+			break;
+		}
+		ret += fprintf(fp, "\n");
+		rb_node = rb_next(rb_node);
+	}
+
+	return ret;
+}
+
+static size_t hist_entry__fprintf(struct hist_entry *self,
+				  struct perf_session *session,
+				  struct perf_session *pair_session,
+				  bool show_displacement,
+				  long displacement, FILE *fp)
+{
+	struct sort_entry *se;
+	u64 count, total;
+	const char *sep = symbol_conf.field_sep;
+	size_t ret;
+
+	if (symbol_conf.exclude_other && !self->parent)
+		return 0;
+
+	if (pair_session) {
+		count = self->pair ? self->pair->count : 0;
+		total = pair_session->events_stats.total;
+	} else {
+		count = self->count;
+		total = session->events_stats.total;
+	}
+
+	if (total)
+		ret = percent_color_fprintf(fp, sep ? "%.2f" : "   %6.2f%%",
+					    (count * 100.0) / total);
+	else
+		ret = fprintf(fp, sep ? "%lld" : "%12lld ", count);
+
+	if (symbol_conf.show_nr_samples) {
+		if (sep)
+			fprintf(fp, "%c%lld", *sep, count);
+		else
+			fprintf(fp, "%11lld", count);
+	}
+
+	if (pair_session) {
+		char bf[32];
+		double old_percent = 0, new_percent = 0, diff;
+
+		if (total > 0)
+			old_percent = (count * 100.0) / total;
+		if (session->events_stats.total > 0)
+			new_percent = (self->count * 100.0) / session->events_stats.total;
+
+		diff = new_percent - old_percent;
+
+		if (fabs(diff) >= 0.01)
+			snprintf(bf, sizeof(bf), "%+4.2F%%", diff);
+		else
+			snprintf(bf, sizeof(bf), " ");
+
+		if (sep)
+			ret += fprintf(fp, "%c%s", *sep, bf);
+		else
+			ret += fprintf(fp, "%11.11s", bf);
+
+		if (show_displacement) {
+			if (displacement)
+				snprintf(bf, sizeof(bf), "%+4ld", displacement);
+			else
+				snprintf(bf, sizeof(bf), " ");
+
+			if (sep)
+				fprintf(fp, "%c%s", *sep, bf);
+			else
+				fprintf(fp, "%6.6s", bf);
+		}
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+
+		fprintf(fp, "%s", sep ?: "  ");
+		ret += se->print(fp, self, se->width ? *se->width : 0);
+	}
+
+	ret += fprintf(fp, "\n");
+
+	if (symbol_conf.use_callchain) {
+		int left_margin = 0;
+
+		if (sort__first_dimension == SORT_COMM) {
+			se = list_first_entry(&hist_entry__sort_list, typeof(*se),
+						list);
+			left_margin = se->width ? *se->width : 0;
+			left_margin -= thread__comm_len(self->thread);
+		}
+
+		hist_entry_callchain__fprintf(fp, self, session->events_stats.total,
+					      left_margin);
+	}
+
+	return ret;
+}
+
+size_t perf_session__fprintf_hists(struct perf_session *self,
+				   struct perf_session *pair,
+				   bool show_displacement, FILE *fp)
+{
+	struct sort_entry *se;
+	struct rb_node *nd;
+	size_t ret = 0;
+	unsigned long position = 1;
+	long displacement = 0;
+	unsigned int width;
+	const char *sep = symbol_conf.field_sep;
+	char *col_width = symbol_conf.col_width_list_str;
+
+	init_rem_hits();
+
+	fprintf(fp, "# %s", pair ? "Baseline" : "Overhead");
+
+	if (symbol_conf.show_nr_samples) {
+		if (sep)
+			fprintf(fp, "%cSamples", *sep);
+		else
+			fputs("  Samples  ", fp);
+	}
+
+	if (pair) {
+		if (sep)
+			ret += fprintf(fp, "%cDelta", *sep);
+		else
+			ret += fprintf(fp, "  Delta    ");
+
+		if (show_displacement) {
+			if (sep)
+				ret += fprintf(fp, "%cDisplacement", *sep);
+			else
+				ret += fprintf(fp, " Displ");
+		}
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (se->elide)
+			continue;
+		if (sep) {
+			fprintf(fp, "%c%s", *sep, se->header);
+			continue;
+		}
+		width = strlen(se->header);
+		if (se->width) {
+			if (symbol_conf.col_width_list_str) {
+				if (col_width) {
+					*se->width = atoi(col_width);
+					col_width = strchr(col_width, ',');
+					if (col_width)
+						++col_width;
+				}
+			}
+			width = *se->width = max(*se->width, width);
+		}
+		fprintf(fp, "  %*s", width, se->header);
+	}
+	fprintf(fp, "\n");
+
+	if (sep)
+		goto print_entries;
+
+	fprintf(fp, "# ........");
+	if (symbol_conf.show_nr_samples)
+		fprintf(fp, " ..........");
+	if (pair) {
+		fprintf(fp, " ..........");
+		if (show_displacement)
+			fprintf(fp, " .....");
+	}
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		unsigned int i;
+
+		if (se->elide)
+			continue;
+
+		fprintf(fp, "  ");
+		if (se->width)
+			width = *se->width;
+		else
+			width = strlen(se->header);
+		for (i = 0; i < width; i++)
+			fprintf(fp, ".");
+	}
+
+	fprintf(fp, "\n#\n");
+
+print_entries:
+	for (nd = rb_first(&self->hists); nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (show_displacement) {
+			if (h->pair != NULL)
+				displacement = ((long)h->pair->position -
+					        (long)position);
+			else
+				displacement = 0;
+			++position;
+		}
+		ret += hist_entry__fprintf(h, self, pair, show_displacement,
+					   displacement, fp);
 	}
+
+	free(rem_sq_bracket);
+
+	return ret;
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 3020db0..e5f99b2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -1,50 +1,27 @@
 #ifndef __PERF_HIST_H
 #define __PERF_HIST_H
-#include "../builtin.h"
 
-#include "util.h"
-
-#include "color.h"
-#include <linux/list.h>
-#include "cache.h"
-#include <linux/rbtree.h>
-#include "symbol.h"
-#include "string.h"
+#include <linux/types.h>
 #include "callchain.h"
-#include "strlist.h"
-#include "values.h"
-
-#include "../perf.h"
-#include "debug.h"
-#include "header.h"
-
-#include "parse-options.h"
-#include "parse-events.h"
 
-#include "thread.h"
-#include "sort.h"
-
-extern struct rb_root hist;
-extern struct rb_root collapse_hists;
-extern struct rb_root output_hists;
-extern int callchain;
 extern struct callchain_param callchain_param;
-extern unsigned long total;
-extern unsigned long total_mmap;
-extern unsigned long total_comm;
-extern unsigned long total_fork;
-extern unsigned long total_unknown;
-extern unsigned long total_lost;
 
-struct hist_entry *__hist_entry__add(struct addr_location *al,
-				     struct symbol *parent,
-				     u64 count, bool *hit);
+struct perf_session;
+struct hist_entry;
+struct addr_location;
+struct symbol;
+
+struct hist_entry *__perf_session__add_hist_entry(struct perf_session *self,
+						  struct addr_location *al,
+						  struct symbol *parent,
+						  u64 count, bool *hit);
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
-extern void hist_entry__free(struct hist_entry *);
-extern void collapse__insert_entry(struct hist_entry *);
-extern void collapse__resort(void);
-extern void output__insert_entry(struct hist_entry *, u64);
-extern void output__resort(u64);
+void hist_entry__free(struct hist_entry *);
 
+void perf_session__output_resort(struct perf_session *self, u64 total_samples);
+void perf_session__collapse_resort(struct perf_session *self);
+size_t perf_session__fprintf_hists(struct perf_session *self,
+				   struct perf_session *pair,
+				   bool show_displacement, FILE *fp);
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 76bdca6..c4d55a0 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -104,11 +104,16 @@ void map__fixup_end(struct map *self)
 
 #define DSO__DELETED "(deleted)"
 
-static int map__load(struct map *self, symbol_filter_t filter)
+int map__load(struct map *self, struct perf_session *session,
+	      symbol_filter_t filter)
 {
 	const char *name = self->dso->long_name;
-	int nr = dso__load(self->dso, self, filter);
+	int nr;
 
+	if (dso__loaded(self->dso, self->type))
+		return 0;
+
+	nr = dso__load(self->dso, self, session, filter);
 	if (nr < 0) {
 		if (self->dso->has_build_id) {
 			char sbuild_id[BUILD_ID_SIZE * 2 + 1];
@@ -143,19 +148,20 @@ static int map__load(struct map *self, symbol_filter_t filter)
 	return 0;
 }
 
-struct symbol *map__find_symbol(struct map *self, u64 addr,
-				symbol_filter_t filter)
+struct symbol *map__find_symbol(struct map *self, struct perf_session *session,
+				u64 addr, symbol_filter_t filter)
 {
-	if (!dso__loaded(self->dso, self->type) && map__load(self, filter) < 0)
+	if (map__load(self, session, filter) < 0)
 		return NULL;
 
 	return dso__find_symbol(self->dso, self->type, addr);
 }
 
 struct symbol *map__find_symbol_by_name(struct map *self, const char *name,
+					struct perf_session *session,
 					symbol_filter_t filter)
 {
-	if (!dso__loaded(self->dso, self->type) && map__load(self, filter) < 0)
+	if (map__load(self, session, filter) < 0)
 		return NULL;
 
 	if (!dso__sorted_by_name(self->dso, self->type))
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index d14a458..2ca6215 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -69,10 +69,23 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 	char c, nc = 0;
 	/*
 	 * <Syntax>
-	 * perf probe SRC:LN
-	 * perf probe FUNC[+OFFS|%return][@SRC]
+	 * perf probe [EVENT=]SRC:LN
+	 * perf probe [EVENT=]FUNC[+OFFS|%return][@SRC]
+	 *
+	 * TODO:Group name support
 	 */
 
+	ptr = strchr(arg, '=');
+	if (ptr) {	/* Event name */
+		*ptr = '\0';
+		tmp = ptr + 1;
+		ptr = strchr(arg, ':');
+		if (ptr)	/* Group name is not supported yet. */
+			semantic_error("Group name is not supported yet.");
+		pp->event = strdup(arg);
+		arg = tmp;
+	}
+
 	ptr = strpbrk(arg, ":+@%");
 	if (ptr) {
 		nc = *ptr;
@@ -150,10 +163,13 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 }
 
 /* Parse perf-probe event definition */
-int parse_perf_probe_event(const char *str, struct probe_point *pp)
+void parse_perf_probe_event(const char *str, struct probe_point *pp,
+			    bool *need_dwarf)
 {
 	char **argv;
-	int argc, i, need_dwarf = 0;
+	int argc, i;
+
+	*need_dwarf = false;
 
 	argv = argv_split(str, &argc);
 	if (!argv)
@@ -164,7 +180,7 @@ int parse_perf_probe_event(const char *str, struct probe_point *pp)
 	/* Parse probe point */
 	parse_perf_probe_probepoint(argv[0], pp);
 	if (pp->file || pp->line)
-		need_dwarf = 1;
+		*need_dwarf = true;
 
 	/* Copy arguments and ensure return probe has no C argument */
 	pp->nr_args = argc - 1;
@@ -177,17 +193,15 @@ int parse_perf_probe_event(const char *str, struct probe_point *pp)
 			if (pp->retprobe)
 				semantic_error("You can't specify local"
 						" variable for kretprobe");
-			need_dwarf = 1;
+			*need_dwarf = true;
 		}
 	}
 
 	argv_free(argv);
-	return need_dwarf;
 }
 
 /* Parse kprobe_events event into struct probe_point */
-void parse_trace_kprobe_event(const char *str, char **group, char **event,
-			      struct probe_point *pp)
+void parse_trace_kprobe_event(const char *str, struct probe_point *pp)
 {
 	char pr;
 	char *p;
@@ -203,18 +217,17 @@ void parse_trace_kprobe_event(const char *str, char **group, char **event,
 
 	/* Scan event and group name. */
 	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
-		     &pr, (float *)(void *)group, (float *)(void *)event);
+		     &pr, (float *)(void *)&pp->group,
+		     (float *)(void *)&pp->event);
 	if (ret != 3)
 		semantic_error("Failed to parse event name: %s", argv[0]);
-	pr_debug("Group:%s Event:%s probe:%c\n", *group, *event, pr);
-
-	if (!pp)
-		goto end;
+	pr_debug("Group:%s Event:%s probe:%c\n", pp->group, pp->event, pr);
 
 	pp->retprobe = (pr == 'r');
 
 	/* Scan function name and offset */
-	ret = sscanf(argv[1], "%a[^+]+%d", (float *)(void *)&pp->function, &pp->offset);
+	ret = sscanf(argv[1], "%a[^+]+%d", (float *)(void *)&pp->function,
+		     &pp->offset);
 	if (ret == 1)
 		pp->offset = 0;
 
@@ -233,15 +246,15 @@ void parse_trace_kprobe_event(const char *str, char **group, char **event,
 			die("Failed to copy argument.");
 	}
 
-end:
 	argv_free(argv);
 }
 
-int synthesize_perf_probe_event(struct probe_point *pp)
+/* Synthesize only probe point (not argument) */
+int synthesize_perf_probe_point(struct probe_point *pp)
 {
 	char *buf;
 	char offs[64] = "", line[64] = "";
-	int i, len, ret;
+	int ret;
 
 	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
 	if (!buf)
@@ -262,10 +275,24 @@ int synthesize_perf_probe_event(struct probe_point *pp)
 				 offs, pp->retprobe ? "%return" : "", line);
 	else
 		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s", pp->file, line);
-	if (ret <= 0)
-		goto error;
-	len = ret;
+	if (ret <= 0) {
+error:
+		free(pp->probes[0]);
+		pp->probes[0] = NULL;
+	}
+	return ret;
+}
 
+int synthesize_perf_probe_event(struct probe_point *pp)
+{
+	char *buf;
+	int i, len, ret;
+
+	len = synthesize_perf_probe_point(pp);
+	if (len < 0)
+		return 0;
+
+	buf = pp->probes[0];
 	for (i = 0; i < pp->nr_args; i++) {
 		ret = e_snprintf(&buf[len], MAX_CMDLEN - len, " %s",
 				 pp->args[i]);
@@ -278,6 +305,7 @@ int synthesize_perf_probe_event(struct probe_point *pp)
 	return pp->found;
 error:
 	free(pp->probes[0]);
+	pp->probes[0] = NULL;
 
 	return ret;
 }
@@ -307,6 +335,7 @@ int synthesize_trace_kprobe_event(struct probe_point *pp)
 	return pp->found;
 error:
 	free(pp->probes[0]);
+	pp->probes[0] = NULL;
 
 	return ret;
 }
@@ -366,6 +395,10 @@ static void clear_probe_point(struct probe_point *pp)
 {
 	int i;
 
+	if (pp->event)
+		free(pp->event);
+	if (pp->group)
+		free(pp->group);
 	if (pp->function)
 		free(pp->function);
 	if (pp->file)
@@ -380,13 +413,15 @@ static void clear_probe_point(struct probe_point *pp)
 }
 
 /* Show an event */
-static void show_perf_probe_event(const char *group, const char *event,
-				  const char *place, struct probe_point *pp)
+static void show_perf_probe_event(const char *event, const char *place,
+				  struct probe_point *pp)
 {
-	int i;
+	int i, ret;
 	char buf[128];
 
-	e_snprintf(buf, 128, "%s:%s", group, event);
+	ret = e_snprintf(buf, 128, "%s:%s", pp->group, event);
+	if (ret < 0)
+		die("Failed to copy event: %s", strerror(-ret));
 	printf("  %-40s (on %s", buf, place);
 
 	if (pp->nr_args > 0) {
@@ -400,9 +435,7 @@ static void show_perf_probe_event(const char *group, const char *event,
 /* List up current perf-probe events */
 void show_perf_probe_events(void)
 {
-	unsigned int i;
-	int fd, nr;
-	char *group, *event;
+	int fd;
 	struct probe_point pp;
 	struct strlist *rawlist;
 	struct str_node *ent;
@@ -411,18 +444,12 @@ void show_perf_probe_events(void)
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 	close(fd);
 
-	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
-		ent = strlist__entry(rawlist, i);
-		parse_trace_kprobe_event(ent->s, &group, &event, &pp);
+	strlist__for_each(ent, rawlist) {
+		parse_trace_kprobe_event(ent->s, &pp);
 		/* Synthesize only event probe point */
-		nr = pp.nr_args;
-		pp.nr_args = 0;
-		synthesize_perf_probe_event(&pp);
-		pp.nr_args = nr;
+		synthesize_perf_probe_point(&pp);
 		/* Show an event */
-		show_perf_probe_event(group, event, pp.probes[0], &pp);
-		free(group);
-		free(event);
+		show_perf_probe_event(pp.event, pp.probes[0], &pp);
 		clear_probe_point(&pp);
 	}
 
@@ -432,26 +459,25 @@ void show_perf_probe_events(void)
 /* Get current perf-probe event names */
 static struct strlist *get_perf_event_names(int fd, bool include_group)
 {
-	unsigned int i;
-	char *group, *event;
 	char buf[128];
 	struct strlist *sl, *rawlist;
 	struct str_node *ent;
+	struct probe_point pp;
 
+	memset(&pp, 0, sizeof(pp));
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 
 	sl = strlist__new(true, NULL);
-	for (i = 0; i < strlist__nr_entries(rawlist); i++) {
-		ent = strlist__entry(rawlist, i);
-		parse_trace_kprobe_event(ent->s, &group, &event, NULL);
+	strlist__for_each(ent, rawlist) {
+		parse_trace_kprobe_event(ent->s, &pp);
 		if (include_group) {
-			if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
+			if (e_snprintf(buf, 128, "%s:%s", pp.group,
+				       pp.event) < 0)
 				die("Failed to copy group:event name.");
 			strlist__add(sl, buf);
 		} else
-			strlist__add(sl, event);
-		free(group);
-		free(event);
+			strlist__add(sl, pp.event);
+		clear_probe_point(&pp);
 	}
 
 	strlist__delete(rawlist);
@@ -470,7 +496,7 @@ static void write_trace_kprobe_event(int fd, const char *buf)
 }
 
 static void get_new_event_name(char *buf, size_t len, const char *base,
-			       struct strlist *namelist)
+			       struct strlist *namelist, bool allow_suffix)
 {
 	int i, ret;
 
@@ -481,6 +507,12 @@ static void get_new_event_name(char *buf, size_t len, const char *base,
 	if (!strlist__has_entry(namelist, buf))
 		return;
 
+	if (!allow_suffix) {
+		pr_warning("Error: event \"%s\" already exists. "
+			   "(Use -f to force duplicates.)\n", base);
+		die("Can't add new event.");
+	}
+
 	/* Try to add suffix */
 	for (i = 1; i < MAX_EVENT_INDEX; i++) {
 		ret = e_snprintf(buf, len, "%s_%d", base, i);
@@ -493,13 +525,15 @@ static void get_new_event_name(char *buf, size_t len, const char *base,
 		die("Too many events are on the same function.");
 }
 
-void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
+void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
+			     bool force_add)
 {
 	int i, j, fd;
 	struct probe_point *pp;
 	char buf[MAX_CMDLEN];
 	char event[64];
 	struct strlist *namelist;
+	bool allow_suffix;
 
 	fd = open_kprobe_events(O_RDWR, O_APPEND);
 	/* Get current event names */
@@ -507,21 +541,35 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 
 	for (j = 0; j < nr_probes; j++) {
 		pp = probes + j;
+		if (!pp->event)
+			pp->event = strdup(pp->function);
+		if (!pp->group)
+			pp->group = strdup(PERFPROBE_GROUP);
+		DIE_IF(!pp->event || !pp->group);
+		/* If force_add is true, suffix search is allowed */
+		allow_suffix = force_add;
 		for (i = 0; i < pp->found; i++) {
 			/* Get an unused new event name */
-			get_new_event_name(event, 64, pp->function, namelist);
+			get_new_event_name(event, 64, pp->event, namelist,
+					   allow_suffix);
 			snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s\n",
 				 pp->retprobe ? 'r' : 'p',
-				 PERFPROBE_GROUP, event,
+				 pp->group, event,
 				 pp->probes[i]);
 			write_trace_kprobe_event(fd, buf);
 			printf("Added new event:\n");
 			/* Get the first parameter (probe-point) */
 			sscanf(pp->probes[i], "%s", buf);
-			show_perf_probe_event(PERFPROBE_GROUP, event,
-					      buf, pp);
+			show_perf_probe_event(event, buf, pp);
 			/* Add added event name to namelist */
 			strlist__add(namelist, event);
+			/*
+			 * Probes after the first probe which comes from same
+			 * user input are always allowed to add suffix, because
+			 * there might be several addresses corresponding to
+			 * one code line.
+			 */
+			allow_suffix = true;
 		}
 	}
 	/* Show how to use the event. */
@@ -532,29 +580,55 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes)
 	close(fd);
 }
 
+static void __del_trace_kprobe_event(int fd, struct str_node *ent)
+{
+	char *p;
+	char buf[128];
+
+	/* Convert from perf-probe event to trace-kprobe event */
+	if (e_snprintf(buf, 128, "-:%s", ent->s) < 0)
+		die("Failed to copy event.");
+	p = strchr(buf + 2, ':');
+	if (!p)
+		die("Internal error: %s should have ':' but not.", ent->s);
+	*p = '/';
+
+	write_trace_kprobe_event(fd, buf);
+	printf("Remove event: %s\n", ent->s);
+}
+
 static void del_trace_kprobe_event(int fd, const char *group,
 				   const char *event, struct strlist *namelist)
 {
 	char buf[128];
+	struct str_node *ent, *n;
+	int found = 0;
 
 	if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
 		die("Failed to copy event.");
-	if (!strlist__has_entry(namelist, buf)) {
-		pr_warning("Warning: event \"%s\" is not found.\n", buf);
-		return;
-	}
-	/* Convert from perf-probe event to trace-kprobe event */
-	if (e_snprintf(buf, 128, "-:%s/%s", group, event) < 0)
-		die("Failed to copy event.");
 
-	write_trace_kprobe_event(fd, buf);
-	printf("Remove event: %s:%s\n", group, event);
+	if (strpbrk(buf, "*?")) { /* Glob-exp */
+		strlist__for_each_safe(ent, n, namelist)
+			if (strglobmatch(ent->s, buf)) {
+				found++;
+				__del_trace_kprobe_event(fd, ent);
+				strlist__remove(namelist, ent);
+			}
+	} else {
+		ent = strlist__find(namelist, buf);
+		if (ent) {
+			found++;
+			__del_trace_kprobe_event(fd, ent);
+			strlist__remove(namelist, ent);
+		}
+	}
+	if (found == 0)
+		pr_info("Info: event \"%s\" does not exist, could not remove it.\n", buf);
 }
 
 void del_trace_kprobe_events(struct strlist *dellist)
 {
 	int fd;
-	unsigned int i;
 	const char *group, *event;
 	char *p, *str;
 	struct str_node *ent;
@@ -564,20 +638,21 @@ void del_trace_kprobe_events(struct strlist *dellist)
 	/* Get current event names */
 	namelist = get_perf_event_names(fd, true);
 
-	for (i = 0; i < strlist__nr_entries(dellist); i++) {
-		ent = strlist__entry(dellist, i);
+	strlist__for_each(ent, dellist) {
 		str = strdup(ent->s);
 		if (!str)
 			die("Failed to copy event.");
+		pr_debug("Parsing: %s\n", str);
 		p = strchr(str, ':');
 		if (p) {
 			group = str;
 			*p = '\0';
 			event = p + 1;
 		} else {
-			group = PERFPROBE_GROUP;
+			group = "*";
 			event = str;
 		}
+		pr_debug("Group: %s, Event: %s\n", group, event);
 		del_trace_kprobe_event(fd, group, event, namelist);
 		free(str);
 	}
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index f752159..7f1d499 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -1,15 +1,18 @@
 #ifndef _PROBE_EVENT_H
 #define _PROBE_EVENT_H
 
+#include <stdbool.h>
 #include "probe-finder.h"
 #include "strlist.h"
 
-extern int parse_perf_probe_event(const char *str, struct probe_point *pp);
+extern void parse_perf_probe_event(const char *str, struct probe_point *pp,
+				   bool *need_dwarf);
+extern int synthesize_perf_probe_point(struct probe_point *pp);
 extern int synthesize_perf_probe_event(struct probe_point *pp);
-extern void parse_trace_kprobe_event(const char *str, char **group,
-				     char **event, struct probe_point *pp);
+extern void parse_trace_kprobe_event(const char *str, struct probe_point *pp);
 extern int synthesize_trace_kprobe_event(struct probe_point *pp);
-extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes);
+extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
+				    bool force_add);
 extern void del_trace_kprobe_events(struct strlist *dellist);
 extern void show_perf_probe_events(void);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 4585f1d..4b852c0 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -687,10 +687,8 @@ int find_probepoint(int fd, struct probe_point *pp)
 	struct probe_finder pf = {.pp = pp};
 
 	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
-	if (ret != DW_DLV_OK) {
-		pr_warning("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO.\n");
+	if (ret != DW_DLV_OK)
 		return -ENOENT;
-	}
 
 	pp->found = 0;
 	while (++cu_number) {
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index bdebca6..5e4050c 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -12,6 +12,9 @@ static inline int is_c_varname(const char *name)
 }
 
 struct probe_point {
+	char	*event;		/* Event name */
+	char	*group;		/* Event group */
+
 	/* Inputs */
 	char	*file;		/* File name */
 	int	line;		/* Line number */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 707ce1c..ce3a6c8 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -4,6 +4,7 @@
 #include <sys/types.h>
 
 #include "session.h"
+#include "sort.h"
 #include "util.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
@@ -50,31 +51,100 @@ out_close:
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force)
 {
-	size_t len = strlen(filename) + 1;
+	size_t len = filename ? strlen(filename) + 1 : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
 
 	if (self == NULL)
 		goto out;
 
 	if (perf_header__init(&self->header) < 0)
-		goto out_delete;
+		goto out_free;
 
 	memcpy(self->filename, filename, len);
+	self->threads = RB_ROOT;
+	self->last_match = NULL;
+	self->mmap_window = 32;
+	self->cwd = NULL;
+	self->cwdlen = 0;
+	map_groups__init(&self->kmaps);
+
+	if (perf_session__create_kernel_maps(self) < 0)
+		goto out_delete;
 
-	if (mode == O_RDONLY && perf_session__open(self, force) < 0) {
-		perf_session__delete(self);
-		self = NULL;
-	}
+	if (mode == O_RDONLY && perf_session__open(self, force) < 0)
+		goto out_delete;
 out:
 	return self;
-out_delete:
+out_free:
 	free(self);
 	return NULL;
+out_delete:
+	perf_session__delete(self);
+	return NULL;
 }
 
 void perf_session__delete(struct perf_session *self)
 {
 	perf_header__exit(&self->header);
 	close(self->fd);
+	free(self->cwd);
 	free(self);
 }
+
+static bool symbol__match_parent_regex(struct symbol *sym)
+{
+	if (sym->name && !regexec(&parent_regex, sym->name, 0, NULL, 0))
+		return 1;
+
+	return 0;
+}
+
+struct symbol **perf_session__resolve_callchain(struct perf_session *self,
+						struct thread *thread,
+						struct ip_callchain *chain,
+						struct symbol **parent)
+{
+	u8 cpumode = PERF_RECORD_MISC_USER;
+	struct symbol **syms = NULL;
+	unsigned int i;
+
+	if (symbol_conf.use_callchain) {
+		syms = calloc(chain->nr, sizeof(*syms));
+		if (!syms) {
+			fprintf(stderr, "Can't allocate memory for symbols\n");
+			exit(-1);
+		}
+	}
+
+	for (i = 0; i < chain->nr; i++) {
+		u64 ip = chain->ips[i];
+		struct addr_location al;
+
+		if (ip >= PERF_CONTEXT_MAX) {
+			switch (ip) {
+			case PERF_CONTEXT_HV:
+				cpumode = PERF_RECORD_MISC_HYPERVISOR;	break;
+			case PERF_CONTEXT_KERNEL:
+				cpumode = PERF_RECORD_MISC_KERNEL;	break;
+			case PERF_CONTEXT_USER:
+				cpumode = PERF_RECORD_MISC_USER;	break;
+			default:
+				break;
+			}
+			continue;
+		}
+
+		thread__find_addr_location(thread, self, cpumode,
+					   MAP__FUNCTION, ip, &al, NULL);
+		if (al.sym != NULL) {
+			if (sort__has_parent && !*parent &&
+			    symbol__match_parent_regex(al.sym))
+				*parent = al.sym;
+			if (!symbol_conf.use_callchain)
+				break;
+			syms[i] = al.sym;
+		}
+	}
+
+	return syms;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index f3699c8..32eaa1b 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -1,16 +1,61 @@
 #ifndef __PERF_SESSION_H
 #define __PERF_SESSION_H
 
+#include "event.h"
 #include "header.h"
+#include "thread.h"
+#include <linux/rbtree.h>
+#include "../../../include/linux/perf_event.h"
+
+struct ip_callchain;
+struct thread;
+struct symbol;
 
 struct perf_session {
 	struct perf_header	header;
 	unsigned long		size;
+	unsigned long		mmap_window;
+	struct map_groups	kmaps;
+	struct rb_root		threads;
+	struct thread		*last_match;
+	struct events_stats	events_stats;
+	unsigned long		event_total[PERF_RECORD_MAX];
+	struct rb_root		hists;
+	u64			sample_type;
 	int			fd;
+	int			cwdlen;
+	char			*cwd;
 	char filename[0];
 };
 
+typedef int (*event_op)(event_t *self, struct perf_session *session);
+
+struct perf_event_ops {
+	event_op	process_sample_event;
+	event_op	process_mmap_event;
+	event_op	process_comm_event;
+	event_op	process_fork_event;
+	event_op	process_exit_event;
+	event_op	process_lost_event;
+	event_op	process_read_event;
+	event_op	process_throttle_event;
+	event_op	process_unthrottle_event;
+	int		(*sample_type_check)(struct perf_session *session);
+	unsigned long	total_unknown;
+	bool		full_paths;
+};
+
 struct perf_session *perf_session__new(const char *filename, int mode, bool force);
 void perf_session__delete(struct perf_session *self);
 
+int perf_session__process_events(struct perf_session *self,
+				 struct perf_event_ops *event_ops);
+
+struct symbol **perf_session__resolve_callchain(struct perf_session *self,
+						struct thread *thread,
+						struct ip_callchain *chain,
+						struct symbol **parent);
+
+int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
+
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b490354..cb0f327 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -288,3 +288,29 @@ int sort_dimension__add(const char *tok)
 
 	return -ESRCH;
 }
+
+void setup_sorting(const char * const usagestr[], const struct option *opts)
+{
+	char *tmp, *tok, *str = strdup(sort_order);
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		if (sort_dimension__add(tok) < 0) {
+			error("Unknown --sort key: `%s'", tok);
+			usage_with_options(usagestr, opts);
+		}
+	}
+
+	free(str);
+}
+
+void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
+			     const char *list_name, FILE *fp)
+{
+	if (list && strlist__nr_entries(list) == 1) {
+		if (fp != NULL)
+			fprintf(fp, "# %s: %s\n", list_name,
+				strlist__entry(list, 0)->s);
+		self->elide = true;
+	}
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 333e664..753f9ea 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -49,9 +49,13 @@ struct hist_entry {
 	struct symbol		*sym;
 	u64			ip;
 	char			level;
-	struct symbol		*parent;
+	struct symbol	  *parent;
 	struct callchain_node	callchain;
-	struct rb_root		sorted_chain;
+	union {
+		unsigned long	  position;
+		struct hist_entry *pair;
+		struct rb_root	  sorted_chain;
+	};
 };
 
 enum sort_type {
@@ -81,6 +85,8 @@ struct sort_entry {
 extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
 
+void setup_sorting(const char * const usagestr[], const struct option *opts);
+
 extern int repsep_fprintf(FILE *fp, const char *fmt, ...);
 extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
@@ -95,5 +101,7 @@ extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
 extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
 extern int sort_dimension__add(const char *);
+void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
+			     const char *list_name, FILE *fp);
 
 #endif	/* __PERF_SORT_H */
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index f24a8cc..5352d7d 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -226,3 +226,28 @@ fail:
 	argv_free(argv);
 	return NULL;
 }
+
+/* Glob expression pattern matching */
+bool strglobmatch(const char *str, const char *pat)
+{
+	while (*str && *pat && *pat != '*') {
+		if (*pat == '?') {
+			str++;
+			pat++;
+		} else
+			if (*str++ != *pat++)
+				return false;
+	}
+	/* Check wild card */
+	if (*pat == '*') {
+		while (*pat == '*')
+			pat++;
+		if (!*pat)	/* Tail wild card matches all */
+			return true;
+		while (*str)
+			if (strglobmatch(str++, pat))
+				return true;
+	}
+	return !*str && !*pat;
+}
+
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index bfecec2..02ede58 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -1,6 +1,7 @@
 #ifndef __PERF_STRING_H_
 #define __PERF_STRING_H_
 
+#include <stdbool.h>
 #include "types.h"
 
 int hex2u64(const char *ptr, u64 *val);
@@ -8,6 +9,7 @@ char *strxfrchar(char *s, char from, char to);
 s64 perf_atoll(const char *str);
 char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
+bool strglobmatch(const char *str, const char *pat);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
index 7ad3817..6783a20 100644
--- a/tools/perf/util/strlist.c
+++ b/tools/perf/util/strlist.c
@@ -102,7 +102,7 @@ void strlist__remove(struct strlist *self, struct str_node *sn)
 	str_node__delete(sn, self->dupstr);
 }
 
-bool strlist__has_entry(struct strlist *self, const char *entry)
+struct str_node *strlist__find(struct strlist *self, const char *entry)
 {
 	struct rb_node **p = &self->entries.rb_node;
 	struct rb_node *parent = NULL;
@@ -120,10 +120,10 @@ bool strlist__has_entry(struct strlist *self, const char *entry)
 		else if (rc < 0)
 			p = &(*p)->rb_right;
 		else
-			return true;
+			return sn;
 	}
 
-	return false;
+	return NULL;
 }
 
 static int strlist__parse_list_entry(struct strlist *self, const char *s)
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index cb46593..3ba8390 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -23,7 +23,12 @@ int strlist__load(struct strlist *self, const char *filename);
 int strlist__add(struct strlist *self, const char *str);
 
 struct str_node *strlist__entry(const struct strlist *self, unsigned int idx);
-bool strlist__has_entry(struct strlist *self, const char *entry);
+struct str_node *strlist__find(struct strlist *self, const char *entry);
+
+static inline bool strlist__has_entry(struct strlist *self, const char *entry)
+{
+	return strlist__find(self, entry) != NULL;
+}
 
 static inline bool strlist__empty(const struct strlist *self)
 {
@@ -35,5 +40,39 @@ static inline unsigned int strlist__nr_entries(const struct strlist *self)
 	return self->nr_entries;
 }
 
+/* For strlist iteration */
+static inline struct str_node *strlist__first(struct strlist *self)
+{
+	struct rb_node *rn = rb_first(&self->entries);
+	return rn ? rb_entry(rn, struct str_node, rb_node) : NULL;
+}
+static inline struct str_node *strlist__next(struct str_node *sn)
+{
+	struct rb_node *rn;
+	if (!sn)
+		return NULL;
+	rn = rb_next(&sn->rb_node);
+	return rn ? rb_entry(rn, struct str_node, rb_node) : NULL;
+}
+
+/**
+ * strlist_for_each      - iterate over a strlist
+ * @pos:	the &struct str_node to use as a loop cursor.
+ * @self:	the &struct strlist for loop.
+ */
+#define strlist__for_each(pos, self)	\
+	for (pos = strlist__first(self); pos; pos = strlist__next(pos))
+
+/**
+ * strlist_for_each_safe - iterate over a strlist safe against removal of
+ *                         str_node
+ * @pos:	the &struct str_node to use as a loop cursor.
+ * @n:		another &struct str_node to use as temporary storage.
+ * @self:	the &struct strlist for loop.
+ */
+#define strlist__for_each_safe(pos, n, self)	\
+	for (pos = strlist__first(self), n = strlist__next(pos); pos;\
+	     pos = n, n = strlist__next(n))
+
 int strlist__parse_list(struct strlist *self, const char *s);
 #endif /* __PERF_STRLIST_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d3d9fed..ab92763 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,5 +1,7 @@
 #include "util.h"
 #include "../perf.h"
+#include "session.h"
+#include "sort.h"
 #include "string.h"
 #include "symbol.h"
 #include "thread.h"
@@ -31,19 +33,16 @@ enum dso_origin {
 static void dsos__add(struct list_head *head, struct dso *dso);
 static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				struct map_groups *mg, symbol_filter_t filter);
-unsigned int symbol__priv_size;
+				struct perf_session *session, symbol_filter_t filter);
 static int vmlinux_path__nr_entries;
 static char **vmlinux_path;
 
-static struct symbol_conf symbol_conf__defaults = {
+struct symbol_conf symbol_conf = {
+	.exclude_other	  = true,
 	.use_modules	  = true,
 	.try_vmlinux_path = true,
 };
 
-static struct map_groups kmaps_mem;
-struct map_groups *kmaps = &kmaps_mem;
-
 bool dso__loaded(const struct dso *self, enum map_type type)
 {
 	return self->loaded & (1 << type);
@@ -132,13 +131,13 @@ static void map_groups__fixup_end(struct map_groups *self)
 static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 {
 	size_t namelen = strlen(name) + 1;
-	struct symbol *self = zalloc(symbol__priv_size +
+	struct symbol *self = zalloc(symbol_conf.priv_size +
 				     sizeof(*self) + namelen);
 	if (self == NULL)
 		return NULL;
 
-	if (symbol__priv_size)
-		self = ((void *)self) + symbol__priv_size;
+	if (symbol_conf.priv_size)
+		self = ((void *)self) + symbol_conf.priv_size;
 
 	self->start = start;
 	self->end   = len ? start + len - 1 : start;
@@ -152,7 +151,7 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 
 static void symbol__delete(struct symbol *self)
 {
-	free(((void *)self) - symbol__priv_size);
+	free(((void *)self) - symbol_conf.priv_size);
 }
 
 static size_t symbol__fprintf(struct symbol *self, FILE *fp)
@@ -456,7 +455,7 @@ out_failure:
  * the original ELF section names vmlinux have.
  */
 static int dso__split_kallsyms(struct dso *self, struct map *map,
-			       struct map_groups *mg, symbol_filter_t filter)
+			       struct perf_session *session, symbol_filter_t filter)
 {
 	struct map *curr_map = map;
 	struct symbol *pos;
@@ -473,13 +472,13 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 
 		module = strchr(pos->name, '\t');
 		if (module) {
-			if (!mg->use_modules)
+			if (!symbol_conf.use_modules)
 				goto discard_symbol;
 
 			*module++ = '\0';
 
 			if (strcmp(self->name, module)) {
-				curr_map = map_groups__find_by_name(mg, map->type, module);
+				curr_map = map_groups__find_by_name(&session->kmaps, map->type, module);
 				if (curr_map == NULL) {
 					pr_debug("/proc/{kallsyms,modules} "
 					         "inconsistency!\n");
@@ -510,7 +509,7 @@ static int dso__split_kallsyms(struct dso *self, struct map *map,
 			}
 
 			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
-			map_groups__insert(mg, curr_map);
+			map_groups__insert(&session->kmaps, curr_map);
 			++kernel_range;
 		}
 
@@ -531,7 +530,7 @@ discard_symbol:		rb_erase(&pos->rb_node, root);
 
 
 static int dso__load_kallsyms(struct dso *self, struct map *map,
-			      struct map_groups *mg, symbol_filter_t filter)
+			      struct perf_session *session, symbol_filter_t filter)
 {
 	if (dso__load_all_kallsyms(self, map) < 0)
 		return -1;
@@ -539,14 +538,7 @@ static int dso__load_kallsyms(struct dso *self, struct map *map,
 	symbols__fixup_end(&self->symbols[map->type]);
 	self->origin = DSO__ORIG_KERNEL;
 
-	return dso__split_kallsyms(self, map, mg, filter);
-}
-
-size_t kernel_maps__fprintf(FILE *fp)
-{
-	size_t printed = fprintf(fp, "Kernel maps:\n");
-	printed += map_groups__fprintf_maps(kmaps, fp);
-	return printed + fprintf(fp, "END kernel maps\n");
+	return dso__split_kallsyms(self, map, session, filter);
 }
 
 static int dso__load_perf_map(struct dso *self, struct map *map,
@@ -873,7 +865,7 @@ static bool elf_sec__is_a(GElf_Shdr *self, Elf_Data *secstrs, enum map_type type
 }
 
 static int dso__load_sym(struct dso *self, struct map *map,
-			 struct map_groups *mg, const char *name, int fd,
+			 struct perf_session *session, const char *name, int fd,
 			 symbol_filter_t filter, int kernel, int kmodule)
 {
 	struct map *curr_map = map;
@@ -977,7 +969,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 			snprintf(dso_name, sizeof(dso_name),
 				 "%s%s", self->short_name, section_name);
 
-			curr_map = map_groups__find_by_name(mg, map->type, dso_name);
+			curr_map = map_groups__find_by_name(&session->kmaps, map->type, dso_name);
 			if (curr_map == NULL) {
 				u64 start = sym.st_value;
 
@@ -996,7 +988,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 				curr_map->map_ip = identity__map_ip;
 				curr_map->unmap_ip = identity__map_ip;
 				curr_dso->origin = DSO__ORIG_KERNEL;
-				map_groups__insert(kmaps, curr_map);
+				map_groups__insert(&session->kmaps, curr_map);
 				dsos__add(&dsos__kernel, curr_dso);
 			} else
 				curr_dso = curr_map->dso;
@@ -1211,7 +1203,8 @@ char dso__symtab_origin(const struct dso *self)
 	return origin[self->origin];
 }
 
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
+int dso__load(struct dso *self, struct map *map, struct perf_session *session,
+	      symbol_filter_t filter)
 {
 	int size = PATH_MAX;
 	char *name;
@@ -1222,7 +1215,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	dso__set_loaded(self, map->type);
 
 	if (self->kernel)
-		return dso__load_kernel_sym(self, map, kmaps, filter);
+		return dso__load_kernel_sym(self, map, session, filter);
 
 	name = malloc(size);
 	if (!name)
@@ -1323,7 +1316,7 @@ struct map *map_groups__find_by_name(struct map_groups *self,
 	return NULL;
 }
 
-static int dsos__set_modules_path_dir(char *dirname)
+static int perf_session__set_modules_path_dir(struct perf_session *self, char *dirname)
 {
 	struct dirent *dent;
 	DIR *dir = opendir(dirname);
@@ -1343,7 +1336,7 @@ static int dsos__set_modules_path_dir(char *dirname)
 
 			snprintf(path, sizeof(path), "%s/%s",
 				 dirname, dent->d_name);
-			if (dsos__set_modules_path_dir(path) < 0)
+			if (perf_session__set_modules_path_dir(self, path) < 0)
 				goto failure;
 		} else {
 			char *dot = strrchr(dent->d_name, '.'),
@@ -1357,7 +1350,7 @@ static int dsos__set_modules_path_dir(char *dirname)
 				 (int)(dot - dent->d_name), dent->d_name);
 
 			strxfrchar(dso_name, '-', '_');
-			map = map_groups__find_by_name(kmaps, MAP__FUNCTION, dso_name);
+			map = map_groups__find_by_name(&self->kmaps, MAP__FUNCTION, dso_name);
 			if (map == NULL)
 				continue;
 
@@ -1377,7 +1370,7 @@ failure:
 	return -1;
 }
 
-static int dsos__set_modules_path(void)
+static int perf_session__set_modules_path(struct perf_session *self)
 {
 	struct utsname uts;
 	char modules_path[PATH_MAX];
@@ -1388,7 +1381,7 @@ static int dsos__set_modules_path(void)
 	snprintf(modules_path, sizeof(modules_path), "/lib/modules/%s/kernel",
 		 uts.release);
 
-	return dsos__set_modules_path_dir(modules_path);
+	return perf_session__set_modules_path_dir(self, modules_path);
 }
 
 /*
@@ -1410,7 +1403,7 @@ static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 	return self;
 }
 
-static int map_groups__create_module_maps(struct map_groups *self)
+static int perf_session__create_module_maps(struct perf_session *self)
 {
 	char *line = NULL;
 	size_t n;
@@ -1467,14 +1460,14 @@ static int map_groups__create_module_maps(struct map_groups *self)
 			dso->has_build_id = true;
 
 		dso->origin = DSO__ORIG_KMODULE;
-		map_groups__insert(self, map);
+		map_groups__insert(&self->kmaps, map);
 		dsos__add(&dsos__kernel, dso);
 	}
 
 	free(line);
 	fclose(file);
 
-	return dsos__set_modules_path();
+	return perf_session__set_modules_path(self);
 
 out_delete_line:
 	free(line);
@@ -1483,7 +1476,7 @@ out_failure:
 }
 
 static int dso__load_vmlinux(struct dso *self, struct map *map,
-			     struct map_groups *mg,
+			     struct perf_session *session,
 			     const char *vmlinux, symbol_filter_t filter)
 {
 	int err = -1, fd;
@@ -1517,14 +1510,14 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 		return -1;
 
 	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, mg, self->long_name, fd, filter, 1, 0);
+	err = dso__load_sym(self, map, session, self->long_name, fd, filter, 1, 0);
 	close(fd);
 
 	return err;
 }
 
 static int dso__load_kernel_sym(struct dso *self, struct map *map,
-				struct map_groups *mg, symbol_filter_t filter)
+				struct perf_session *session, symbol_filter_t filter)
 {
 	int err;
 	bool is_kallsyms;
@@ -1534,7 +1527,7 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 		pr_debug("Looking at the vmlinux_path (%d entries long)\n",
 			 vmlinux_path__nr_entries);
 		for (i = 0; i < vmlinux_path__nr_entries; ++i) {
-			err = dso__load_vmlinux(self, map, mg,
+			err = dso__load_vmlinux(self, map, session,
 						vmlinux_path[i], filter);
 			if (err > 0) {
 				pr_debug("Using %s for symbols\n",
@@ -1550,12 +1543,12 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	if (is_kallsyms)
 		goto do_kallsyms;
 
-	err = dso__load_vmlinux(self, map, mg, self->long_name, filter);
+	err = dso__load_vmlinux(self, map, session, self->long_name, filter);
 	if (err <= 0) {
 		pr_info("The file %s cannot be used, "
 			"trying to use /proc/kallsyms...", self->long_name);
 do_kallsyms:
-		err = dso__load_kallsyms(self, map, mg, filter);
+		err = dso__load_kallsyms(self, map, session, filter);
 		if (err > 0 && !is_kallsyms)
                         dso__set_long_name(self, strdup("[kernel.kallsyms]"));
 	}
@@ -1748,32 +1741,69 @@ out_fail:
 	return -1;
 }
 
-int symbol__init(struct symbol_conf *conf)
+static int setup_list(struct strlist **list, const char *list_str,
+		      const char *list_name)
 {
-	const struct symbol_conf *pconf = conf ?: &symbol_conf__defaults;
+	if (list_str == NULL)
+		return 0;
+
+	*list = strlist__new(true, list_str);
+	if (!*list) {
+		pr_err("problems parsing %s list\n", list_name);
+		return -1;
+	}
+	return 0;
+}
 
+int symbol__init(void)
+{
 	elf_version(EV_CURRENT);
-	symbol__priv_size = pconf->priv_size;
-	if (pconf->sort_by_name)
-		symbol__priv_size += (sizeof(struct symbol_name_rb_node) -
-				      sizeof(struct symbol));
-	map_groups__init(kmaps);
+	if (symbol_conf.sort_by_name)
+		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
+					  sizeof(struct symbol));
 
-	if (pconf->try_vmlinux_path && vmlinux_path__init() < 0)
+	if (symbol_conf.try_vmlinux_path && vmlinux_path__init() < 0)
 		return -1;
 
-	if (map_groups__create_kernel_maps(kmaps, pconf->vmlinux_name) < 0) {
-		vmlinux_path__exit();
+	if (symbol_conf.field_sep && *symbol_conf.field_sep == '.') {
+		pr_err("'.' is the only non valid --field-separator argument\n");
 		return -1;
 	}
 
-	kmaps->use_modules = pconf->use_modules;
-	if (pconf->use_modules && map_groups__create_module_maps(kmaps) < 0)
-		pr_debug("Failed to load list of modules in use, "
-			 "continuing...\n");
+	if (setup_list(&symbol_conf.dso_list,
+		       symbol_conf.dso_list_str, "dso") < 0)
+		return -1;
+
+	if (setup_list(&symbol_conf.comm_list,
+		       symbol_conf.comm_list_str, "comm") < 0)
+		goto out_free_dso_list;
+
+	if (setup_list(&symbol_conf.sym_list,
+		       symbol_conf.sym_list_str, "symbol") < 0)
+		goto out_free_comm_list;
+
+	return 0;
+
+out_free_dso_list:
+	strlist__delete(symbol_conf.dso_list);
+out_free_comm_list:
+	strlist__delete(symbol_conf.comm_list);
+	return -1;
+}
+
+int perf_session__create_kernel_maps(struct perf_session *self)
+{
+	if (map_groups__create_kernel_maps(&self->kmaps,
+					   symbol_conf.vmlinux_name) < 0)
+		return -1;
+
+	if (symbol_conf.use_modules &&
+	    perf_session__create_module_maps(self) < 0)
+		pr_debug("Failed to load list of modules for session %s, "
+			 "continuing...\n", self->filename);
 	/*
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
-	map_groups__fixup_end(kmaps);
+	map_groups__fixup_end(&self->kmaps);
 	return 0;
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index cf99f88..8aded23 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -49,19 +49,32 @@ struct symbol {
 	char		name[0];
 };
 
+struct strlist;
+
 struct symbol_conf {
 	unsigned short	priv_size;
 	bool		try_vmlinux_path,
 			use_modules,
-			sort_by_name;
-	const char	*vmlinux_name;
+			sort_by_name,
+			show_nr_samples,
+			use_callchain,
+			exclude_other;
+	const char	*vmlinux_name,
+			*field_sep;
+	char            *dso_list_str,
+			*comm_list_str,
+			*sym_list_str,
+			*col_width_list_str;
+       struct strlist	*dso_list,
+			*comm_list,
+			*sym_list;
 };
 
-extern unsigned int symbol__priv_size;
+extern struct symbol_conf symbol_conf;
 
 static inline void *symbol__priv(struct symbol *self)
 {
-	return ((void *)self) - symbol__priv_size;
+	return ((void *)self) - symbol_conf.priv_size;
 }
 
 struct addr_location {
@@ -70,6 +83,7 @@ struct addr_location {
 	struct symbol *sym;
 	u64	      addr;
 	char	      level;
+	bool	      filtered;
 };
 
 struct dso {
@@ -98,8 +112,11 @@ bool dso__sorted_by_name(const struct dso *self, enum map_type type);
 
 void dso__sort_by_name(struct dso *self, enum map_type type);
 
+struct perf_session;
+
 struct dso *dsos__findnew(const char *name);
-int dso__load(struct dso *self, struct map *map, symbol_filter_t filter);
+int dso__load(struct dso *self, struct map *map, struct perf_session *session,
+	      symbol_filter_t filter);
 void dsos__fprintf(FILE *fp);
 size_t dsos__fprintf_buildid(FILE *fp);
 
@@ -116,12 +133,9 @@ int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool dsos__read_build_ids(void);
 int build_id__sprintf(u8 *self, int len, char *bf);
 
-size_t kernel_maps__fprintf(FILE *fp);
-
-int symbol__init(struct symbol_conf *conf);
+int symbol__init(void);
+int perf_session__create_kernel_maps(struct perf_session *self);
 
-struct map_groups;
-struct map_groups *kmaps;
 extern struct list_head dsos__user, dsos__kernel;
 extern struct dso *vdso;
 #endif /* __PERF_SYMBOL */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index b68a00e..4a08dcf 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -2,13 +2,11 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
+#include "session.h"
 #include "thread.h"
 #include "util.h"
 #include "debug.h"
 
-static struct rb_root threads;
-static struct thread *last_match;
-
 void map_groups__init(struct map_groups *self)
 {
 	int i;
@@ -122,9 +120,9 @@ static size_t thread__fprintf(struct thread *self, FILE *fp)
 	       map_groups__fprintf(&self->mg, fp);
 }
 
-struct thread *threads__findnew(pid_t pid)
+struct thread *perf_session__findnew(struct perf_session *self, pid_t pid)
 {
-	struct rb_node **p = &threads.rb_node;
+	struct rb_node **p = &self->threads.rb_node;
 	struct rb_node *parent = NULL;
 	struct thread *th;
 
@@ -133,15 +131,15 @@ struct thread *threads__findnew(pid_t pid)
 	 * so most of the time we dont have to look up
 	 * the full rbtree:
 	 */
-	if (last_match && last_match->pid == pid)
-		return last_match;
+	if (self->last_match && self->last_match->pid == pid)
+		return self->last_match;
 
 	while (*p != NULL) {
 		parent = *p;
 		th = rb_entry(parent, struct thread, rb_node);
 
 		if (th->pid == pid) {
-			last_match = th;
+			self->last_match = th;
 			return th;
 		}
 
@@ -154,25 +152,13 @@ struct thread *threads__findnew(pid_t pid)
 	th = thread__new(pid);
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
-		rb_insert_color(&th->rb_node, &threads);
-		last_match = th;
+		rb_insert_color(&th->rb_node, &self->threads);
+		self->last_match = th;
 	}
 
 	return th;
 }
 
-struct thread *register_idle_thread(void)
-{
-	struct thread *thread = threads__findnew(0);
-
-	if (!thread || thread__set_comm(thread, "swapper")) {
-		fprintf(stderr, "problem inserting idle task.\n");
-		exit(-1);
-	}
-
-	return thread;
-}
-
 static void map_groups__remove_overlappings(struct map_groups *self,
 					    struct map *map)
 {
@@ -281,12 +267,12 @@ int thread__fork(struct thread *self, struct thread *parent)
 	return 0;
 }
 
-size_t threads__fprintf(FILE *fp)
+size_t perf_session__fprintf(struct perf_session *self, FILE *fp)
 {
 	size_t ret = 0;
 	struct rb_node *nd;
 
-	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
+	for (nd = rb_first(&self->threads); nd; nd = rb_next(nd)) {
 		struct thread *pos = rb_entry(nd, struct thread, rb_node);
 
 		ret += thread__fprintf(pos, fp);
@@ -296,13 +282,14 @@ size_t threads__fprintf(FILE *fp)
 }
 
 struct symbol *map_groups__find_symbol(struct map_groups *self,
+				       struct perf_session *session,
 				       enum map_type type, u64 addr,
 				       symbol_filter_t filter)
 {
 	struct map *map = map_groups__find(self, type, addr);
 
 	if (map != NULL)
-		return map__find_symbol(map, map->map_ip(map, addr), filter);
+		return map__find_symbol(map, session, map->map_ip(map, addr), filter);
 
 	return NULL;
 }
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 1751802..c206f72 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -8,7 +8,6 @@
 struct map_groups {
 	struct rb_root		maps[MAP__NR_TYPES];
 	struct list_head	removed_maps[MAP__NR_TYPES];
-	bool			use_modules;
 };
 
 struct thread {
@@ -23,12 +22,11 @@ struct thread {
 void map_groups__init(struct map_groups *self);
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
-struct thread *threads__findnew(pid_t pid);
-struct thread *register_idle_thread(void);
+struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
 size_t map_groups__fprintf_maps(struct map_groups *self, FILE *fp);
-size_t threads__fprintf(FILE *fp);
+size_t perf_session__fprintf(struct perf_session *self, FILE *fp);
 
 void maps__insert(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
@@ -50,19 +48,21 @@ static inline struct map *thread__find_map(struct thread *self,
 	return self ? map_groups__find(&self->mg, type, addr) : NULL;
 }
 
-void thread__find_addr_location(struct thread *self, u8 cpumode,
+void thread__find_addr_location(struct thread *self,
+				struct perf_session *session, u8 cpumode,
 				enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter);
 struct symbol *map_groups__find_symbol(struct map_groups *self,
+				       struct perf_session *session,
 				       enum map_type type, u64 addr,
 				       symbol_filter_t filter);
 
 static inline struct symbol *
-map_groups__find_function(struct map_groups *self, u64 addr,
-			  symbol_filter_t filter)
+map_groups__find_function(struct map_groups *self, struct perf_session *session,
+			  u64 addr, symbol_filter_t filter)
 {
-	return map_groups__find_symbol(self, MAP__FUNCTION, addr, filter);
+	return map_groups__find_symbol(self, session, MAP__FUNCTION, addr, filter);
 }
 
 struct map *map_groups__find_by_name(struct map_groups *self,
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index a5ffe60..6d6d76b 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -267,7 +267,7 @@ int common_lock_depth(struct scripting_context *context)
 }
 
 static void perl_process_event(int cpu, void *data,
-			       int size __attribute((unused)),
+			       int size __unused,
 			       unsigned long long nsecs, char *comm)
 {
 	struct format_field *field;
@@ -359,28 +359,46 @@ static void run_start_sub(void)
 /*
  * Start trace script
  */
-static int perl_start_script(const char *script)
+static int perl_start_script(const char *script, int argc, const char **argv)
 {
-	const char *command_line[2] = { "", NULL };
+	const char **command_line;
+	int i, err = 0;
 
+	command_line = malloc((argc + 2) * sizeof(const char *));
+	command_line[0] = "";
 	command_line[1] = script;
+	for (i = 2; i < argc + 2; i++)
+		command_line[i] = argv[i - 2];
 
 	my_perl = perl_alloc();
 	perl_construct(my_perl);
 
-	if (perl_parse(my_perl, xs_init, 2, (char **)command_line,
-		       (char **)NULL))
-		return -1;
+	if (perl_parse(my_perl, xs_init, argc + 2, (char **)command_line,
+		       (char **)NULL)) {
+		err = -1;
+		goto error;
+	}
 
-	perl_run(my_perl);
-	if (SvTRUE(ERRSV))
-		return -1;
+	if (perl_run(my_perl)) {
+		err = -1;
+		goto error;
+	}
+
+	if (SvTRUE(ERRSV)) {
+		err = -1;
+		goto error;
+	}
 
 	run_start_sub();
 
+	free(command_line);
 	fprintf(stderr, "perf trace started with Perl script %s\n\n", script);
-
 	return 0;
+error:
+	perl_free(my_perl);
+	free(command_line);
+
+	return err;
 }
 
 /*
@@ -579,7 +597,9 @@ static void print_unsupported_msg(void)
 		"\n  etc.\n");
 }
 
-static int perl_start_script_unsupported(const char *script __unused)
+static int perl_start_script_unsupported(const char *script __unused,
+					 int argc __unused,
+					 const char **argv __unused)
 {
 	print_unsupported_msg();
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 81698d5..6ad4056 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -270,7 +270,7 @@ enum trace_flag_type {
 
 struct scripting_ops {
 	const char *name;
-	int (*start_script) (const char *);
+	int (*start_script) (const char *script, int argc, const char **argv);
 	int (*stop_script) (void);
 	void (*process_event) (int cpu, void *data, int size,
 			       unsigned long long nsecs, char *comm);
