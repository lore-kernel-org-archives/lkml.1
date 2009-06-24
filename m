Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbZFXM7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbZFXM7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbZFXM6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:58:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:58793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbZFXM6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:58:51 -0400
Date: Wed, 24 Jun 2009 12:57:58 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, peterz@infradead.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1245847774.2681.2.camel@ht.satnam>
References: <1245847774.2681.2.camel@ht.satnam>
Subject: [tip:perfcounters/urgent] perf stat: Remove dead code
Message-ID: <tip-3d63259583278262d9153316094e315f73ebfcb5@git.kernel.org>
Git-Commit-ID: 3d63259583278262d9153316094e315f73ebfcb5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 12:58:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d63259583278262d9153316094e315f73ebfcb5
Gitweb:     http://git.kernel.org/tip/3d63259583278262d9153316094e315f73ebfcb5
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 24 Jun 2009 18:19:34 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 14:55:45 +0200

perf stat: Remove dead code

Remove dead code and do some code alignment.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1245847774.2681.2.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |   44 +++++++++++++-------------------------------
 1 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5e04fcc..8420ec5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -59,42 +59,27 @@ static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
 
 };
 
+#define MAX_RUN			100
+
 static int			system_wide			=  0;
-static int			inherit				=  1;
 static int			verbose				=  0;
-
-static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
-
-static int			target_pid			= -1;
 static int			nr_cpus				=  0;
-static unsigned int		page_size;
+static int			run_idx				=  0;
 
+static int			run_count			=  1;
+static int			inherit				=  1;
 static int			scale				=  1;
+static int			target_pid			= -1;
 
-static const unsigned int default_count[] = {
-	1000000,
-	1000000,
-	  10000,
-	  10000,
-	1000000,
-	  10000,
-};
-
-#define MAX_RUN 100
-
-static int			run_count		=  1;
-static int			run_idx			=  0;
-
-static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
-static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
-
-//static u64			event_hist[MAX_RUN][MAX_COUNTERS][3];
-
+static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static u64			runtime_nsecs[MAX_RUN];
 static u64			walltime_nsecs[MAX_RUN];
 static u64			runtime_cycles[MAX_RUN];
 
+static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
+static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
+
 static u64			event_res_avg[MAX_COUNTERS][3];
 static u64			event_res_noise[MAX_COUNTERS][3];
 
@@ -109,7 +94,6 @@ static u64			walltime_nsecs_noise;
 static u64			runtime_cycles_avg;
 static u64			runtime_cycles_noise;
 
-
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n"
 
@@ -470,9 +454,9 @@ static const struct option options[] = {
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "stat events on existing pid"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
-			    "system-wide collection from all CPUs"),
+		    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('S', "scale", &scale,
-			    "scale/normalize counters"),
+		    "scale/normalize counters"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_INTEGER('r', "repeat", &run_count,
@@ -484,8 +468,6 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 {
 	int status;
 
-	page_size = sysconf(_SC_PAGE_SIZE);
-
 	memcpy(attrs, default_attrs, sizeof(attrs));
 
 	argc = parse_options(argc, argv, options, stat_usage, 0);
@@ -515,7 +497,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 	status = 0;
 	for (run_idx = 0; run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
-			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx+1);
+			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx + 1);
 		status = run_perf_stat(argc, argv);
 	}
 
