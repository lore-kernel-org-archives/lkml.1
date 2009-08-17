Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZHQOo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZHQOo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZHQOo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:44:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:56386 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbZHQOo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:44:26 -0400
Date: Mon, 17 Aug 2009 14:43:21 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, acme@redhat.com, mingo@redhat.com,
       williams@redhat.com, efault@gmx.de, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, jonathan@jonmasters.org,
       jbaron@redhat.com, tglx@linutronix.de, mhiramat@redhat.com,
       laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, anton@samba.org,
       jiayingz@google.com, paulus@samba.org, fche@redhat.com, hpa@zytor.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       hch@infradead.org, roland@redhat.com, mingo@elte.hu, lclaudio@uudg.org
Reply-To: mingo@redhat.com, acme@redhat.com, mathieu.desnoyers@polymtl.ca,
       williams@redhat.com, peterz@infradead.org, efault@gmx.de,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, jonathan@jonmasters.org,
       tglx@linutronix.de, jbaron@redhat.com, laijs@cn.fujitsu.com,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, anton@samba.org, jiayingz@google.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       hch@infradead.org, roland@redhat.com, lclaudio@uudg.org, mingo@elte.hu
In-Reply-To: <1250518688-7207-4-git-send-email-fweisbec@gmail.com>
References: <1250518688-7207-4-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/tracing] perf tools: Add perf trace
Message-ID: <tip-5f9c39dca52d3e639ac899e169f408c6fd8396cc@git.kernel.org>
Git-Commit-ID: 5f9c39dca52d3e639ac899e169f408c6fd8396cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 14:43:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f9c39dca52d3e639ac899e169f408c6fd8396cc
Gitweb:     http://git.kernel.org/tip/5f9c39dca52d3e639ac899e169f408c6fd8396cc
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 17 Aug 2009 16:18:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 16:32:39 +0200

perf tools: Add perf trace

This adds perf trace into the set of perf tools.

It is written to fetch the tracepoint samples from perf events
and display them, according to the events information given by
the debugfs files through the util/trace* tools.

It is a rough first shot and doesn't yet handle the cpu,
timestamps fields and some other things.

Example:

 perf record -f -e workqueue:workqueue_execution:record -F 1 -a
 perf trace

       kblockd/0-236   [000]     0.000000: workqueue_execution: thread=:236 func=cfq_kick_queue+0x0
     kondemand/0-360   [000]     0.000000: workqueue_execution: thread=:360 func=do_dbs_timer+0x0
     kondemand/0-360   [000]     0.000000: workqueue_execution: thread=:360 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0
     kondemand/1-361   [000]     0.000000: workqueue_execution: thread=:361 func=do_dbs_timer+0x0

Todo:

- A lot of things!

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Jon Masters <jonathan@jonmasters.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Anton Blanchard <anton@samba.org>
LKML-Reference: <1250518688-7207-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile         |    4 +
 tools/perf/builtin-record.c |    4 +
 tools/perf/builtin-trace.c  |  277 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/perf.c           |    1 +
 tools/perf/util/util.h      |    1 +
 5 files changed, 287 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5d54ddb..c481a51 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -347,6 +347,9 @@ LIB_OBJS += util/values.o
 LIB_OBJS += util/debug.o
 LIB_OBJS += util/map.o
 LIB_OBJS += util/thread.o
+LIB_OBJS += util/trace-event-parse.o
+LIB_OBJS += util/trace-event-read.o
+LIB_OBJS += util/trace-event-info.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
@@ -355,6 +358,7 @@ BUILTIN_OBJS += builtin-record.o
 BUILTIN_OBJS += builtin-report.o
 BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
+BUILTIN_OBJS += builtin-trace.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6a5db67..3ce2f03 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -17,6 +17,7 @@
 #include "util/header.h"
 #include "util/event.h"
 #include "util/debug.h"
+#include "util/trace-event.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -519,6 +520,9 @@ static int __cmd_record(int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
+	if (raw_samples)
+		read_tracing_data();
+
 	if (!stat(output_name, &st) && st.st_size) {
 		if (!force && !append_file) {
 			fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
new file mode 100644
index 0000000..b160a9f
--- /dev/null
+++ b/tools/perf/builtin-trace.c
@@ -0,0 +1,277 @@
+#include "builtin.h"
+
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/header.h"
+
+#include "util/parse-options.h"
+
+#include "perf.h"
+#include "util/debug.h"
+
+#include "util/trace-event.h"
+
+static char		const *input_name = "perf.data";
+static int		input;
+static unsigned long	page_size;
+static unsigned long	mmap_window = 32;
+
+static unsigned long	total = 0;
+static unsigned long	total_comm = 0;
+
+static struct rb_root	threads;
+static struct thread	*last_match;
+
+static struct perf_header *header;
+static u64		sample_type;
+
+
+static int
+process_comm_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct thread *thread;
+
+	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+
+	dump_printf("%p [%p]: PERF_EVENT_COMM: %s:%d\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->comm.comm, event->comm.pid);
+
+	if (thread == NULL ||
+	    thread__set_comm(thread, event->comm.comm)) {
+		dump_printf("problem processing PERF_EVENT_COMM, skipping event.\n");
+		return -1;
+	}
+	total_comm++;
+
+	return 0;
+}
+
+static int
+process_sample_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	char level;
+	int show = 0;
+	struct dso *dso = NULL;
+	struct thread *thread;
+	u64 ip = event->ip.ip;
+	u64 period = 1;
+	void *more_data = event->ip.__more_data;
+	int cpumode;
+
+	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+
+	if (sample_type & PERF_SAMPLE_PERIOD) {
+		period = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
+
+	dump_printf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->header.misc,
+		event->ip.pid, event->ip.tid,
+		(void *)(long)ip,
+		(long long)period);
+
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
+	if (thread == NULL) {
+		eprintf("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	cpumode = event->header.misc & PERF_EVENT_MISC_CPUMODE_MASK;
+
+	if (cpumode == PERF_EVENT_MISC_KERNEL) {
+		show = SHOW_KERNEL;
+		level = 'k';
+
+		dso = kernel_dso;
+
+		dump_printf(" ...... dso: %s\n", dso->name);
+
+	} else if (cpumode == PERF_EVENT_MISC_USER) {
+
+		show = SHOW_USER;
+		level = '.';
+
+	} else {
+		show = SHOW_HV;
+		level = 'H';
+
+		dso = hypervisor_dso;
+
+		dump_printf(" ...... dso: [hypervisor]\n");
+	}
+
+	if (sample_type & PERF_SAMPLE_RAW) {
+		struct {
+			u32 size;
+			char data[0];
+		} *raw = more_data;
+
+		/*
+		 * FIXME: better resolve from pid from the struct trace_entry
+		 * field, although it should be the same than this perf
+		 * event pid
+		 */
+		print_event(0, raw->data, raw->size, 0, thread->comm);
+	}
+	total += period;
+
+	return 0;
+}
+
+static int
+process_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	trace_event(event);
+
+	switch (event->header.type) {
+	case PERF_EVENT_MMAP ... PERF_EVENT_LOST:
+		return 0;
+
+	case PERF_EVENT_COMM:
+		return process_comm_event(event, offset, head);
+
+	case PERF_EVENT_EXIT ... PERF_EVENT_READ:
+		return 0;
+
+	case PERF_EVENT_SAMPLE:
+		return process_sample_event(event, offset, head);
+
+	case PERF_EVENT_MAX:
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int __cmd_trace(void)
+{
+	int ret, rc = EXIT_FAILURE;
+	unsigned long offset = 0;
+	unsigned long head = 0;
+	struct stat perf_stat;
+	event_t *event;
+	uint32_t size;
+	char *buf;
+
+	trace_report();
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+	header = perf_header__read(input);
+	sample_type = perf_header__sample_type(header);
+
+	if (load_kernel() < 0) {
+		perror("failed to load kernel symbols");
+		return EXIT_FAILURE;
+	}
+
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	size = event->header.size;
+	if (!size)
+		size = 8;
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		unsigned long shift = page_size * (head / page_size);
+		int res;
+
+		res = munmap(buf, page_size * mmap_window);
+		assert(res == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+
+	if (!size || process_event(event, offset, head) < 0) {
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	if (offset + head < (unsigned long)perf_stat.st_size)
+		goto more;
+
+	rc = EXIT_SUCCESS;
+	close(input);
+
+	return rc;
+}
+
+static const char * const annotate_usage[] = {
+	"perf trace [<options>] <command>",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+};
+
+int cmd_trace(int argc, const char **argv, const char *prefix __used)
+{
+	symbol__init();
+	page_size = getpagesize();
+
+	argc = parse_options(argc, argv, options, annotate_usage, 0);
+	if (argc) {
+		/*
+		 * Special case: if there's an argument left then assume tha
+		 * it's a symbol filter:
+		 */
+		if (argc > 1)
+			usage_with_options(annotate_usage, options);
+	}
+
+
+	setup_pager();
+
+	return __cmd_trace();
+}
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 31982ad..fe4589d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -292,6 +292,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "top", cmd_top, 0 },
 		{ "annotate", cmd_annotate, 0 },
 		{ "version", cmd_version, 0 },
+		{ "trace", cmd_trace, 0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index d61a6f0..c62ef97 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -311,6 +311,7 @@ static inline int has_extension(const char *filename, const char *ext)
 #undef isspace
 #undef isdigit
 #undef isalpha
+#undef isprint
 #undef isalnum
 #undef tolower
 #undef toupper
