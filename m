Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZLNH6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZLNH6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZLNH63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:58:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:58257 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbZLNH62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:58:28 -0500
Date: Mon, 14 Dec 2009 07:57:42 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260691319-4683-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1260691319-4683-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf bench: Add "all" pseudo subsystem and "all" pseudo suite
Message-ID: <tip-2044279d1e07c90edd64324f09c7adf1acfc42e5@git.kernel.org>
Git-Commit-ID: 2044279d1e07c90edd64324f09c7adf1acfc42e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2044279d1e07c90edd64324f09c7adf1acfc42e5
Gitweb:     http://git.kernel.org/tip/2044279d1e07c90edd64324f09c7adf1acfc42e5
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Sun, 13 Dec 2009 17:01:59 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 08:51:19 +0100

perf bench: Add "all" pseudo subsystem and "all" pseudo suite

This patch adds a new "all" pseudo subsystem and an "all" pseudo
suite. These are for testing all subsystem and its all suite, or
all suite of one subsystem.

(This patch also contains a few trivial comment fixes for
bench/* and output style fixes. I judged that there are no
necessity to make them into individual patch.)

Example of use:

| % ./perf bench sched all                      # Test all suites of sched subsystem
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time: 0.414 [sec]
|
| # Running sched/pipe benchmark...
| # Extecuted 1000000 pipe operations between two tasks
|
|      Total time: 10.999 [sec]
|
|       10.999317 usecs/op
|           90914 ops/sec
|
| % ./perf bench all                            # Test all suites of all subsystems
| # Running sched/messaging benchmark...
| # 20 sender and receiver processes per group
| # 10 groups == 400 processes run
|
|      Total time: 0.420 [sec]
|
| # Running sched/pipe benchmark...
| # Extecuted 1000000 pipe operations between two tasks
|
|      Total time: 11.741 [sec]
|
|       11.741346 usecs/op
|           85169 ops/sec
|
| # Running mem/memcpy benchmark...
| # Copying 1MB Bytes from 0x7ff33e920010 to 0x7ff3401ae010 ...
|
|      808.407437 MB/Sec

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1260691319-4683-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/bench/sched-messaging.c |    2 +-
 tools/perf/bench/sched-pipe.c      |    5 ++-
 tools/perf/builtin-bench.c         |   57 +++++++++++++++++++++++++++++++++--
 3 files changed, 57 insertions(+), 7 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index 605a2a9..e249eb2 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -1,6 +1,6 @@
 /*
  *
- * builtin-bench-messaging.c
+ * sched-messaging.c
  *
  * messaging: Benchmark for scheduler and IPC mechanisms
  *
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 238185f..2354f38 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -1,6 +1,6 @@
 /*
  *
- * builtin-bench-pipe.c
+ * sched-pipe.c
  *
  * pipe: Benchmark for pipe()
  *
@@ -87,7 +87,8 @@ int bench_sched_pipe(int argc, const char **argv,
 	if (pid) {
 		retpid = waitpid(pid, &wait_stat, 0);
 		assert((retpid == pid) && WIFEXITED(wait_stat));
-		return 0;
+	} else {
+		exit(0);
 	}
 
 	switch (bench_format) {
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index e043eb8..4699677 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -31,6 +31,9 @@ struct bench_suite {
 	const char *summary;
 	int (*fn)(int, const char **, const char *);
 };
+						\
+/* sentinel: easy for help */
+#define suite_all { "all", "test all suite (pseudo suite)", NULL }
 
 static struct bench_suite sched_suites[] = {
 	{ "messaging",
@@ -39,6 +42,7 @@ static struct bench_suite sched_suites[] = {
 	{ "pipe",
 	  "Flood of communication over pipe() between two processes",
 	  bench_sched_pipe      },
+	suite_all,
 	{ NULL,
 	  NULL,
 	  NULL                  }
@@ -48,6 +52,7 @@ static struct bench_suite mem_suites[] = {
 	{ "memcpy",
 	  "Simple memory copy in various ways",
 	  bench_mem_memcpy },
+	suite_all,
 	{ NULL,
 	  NULL,
 	  NULL             }
@@ -66,6 +71,9 @@ static struct bench_subsys subsystems[] = {
 	{ "mem",
 	  "memory access performance",
 	  mem_suites },
+	{ "all",		/* sentinel: easy for help */
+	  "test all subsystem (pseudo subsystem)",
+	  NULL },
 	{ NULL,
 	  NULL,
 	  NULL       }
@@ -75,11 +83,11 @@ static void dump_suites(int subsys_index)
 {
 	int i;
 
-	printf("List of available suites for %s...\n\n",
+	printf("# List of available suites for %s...\n\n",
 	       subsystems[subsys_index].name);
 
 	for (i = 0; subsystems[subsys_index].suites[i].name; i++)
-		printf("\t%s: %s\n",
+		printf("%14s: %s\n",
 		       subsystems[subsys_index].suites[i].name,
 		       subsystems[subsys_index].suites[i].summary);
 
@@ -110,10 +118,10 @@ static void print_usage(void)
 		printf("\t%s\n", bench_usage[i]);
 	printf("\n");
 
-	printf("List of available subsystems...\n\n");
+	printf("# List of available subsystems...\n\n");
 
 	for (i = 0; subsystems[i].name; i++)
-		printf("\t%s: %s\n",
+		printf("%14s: %s\n",
 		       subsystems[i].name, subsystems[i].summary);
 	printf("\n");
 }
@@ -131,6 +139,37 @@ static int bench_str2int(char *str)
 	return BENCH_FORMAT_UNKNOWN;
 }
 
+static void all_suite(struct bench_subsys *subsys)	  /* FROM HERE */
+{
+	int i;
+	const char *argv[2];
+	struct bench_suite *suites = subsys->suites;
+
+	argv[1] = NULL;
+	/*
+	 * TODO:
+	 * preparing preset parameters for
+	 * embedded, ordinary PC, HPC, etc...
+	 * will be helpful
+	 */
+	for (i = 0; suites[i].fn; i++) {
+		printf("# Running %s/%s benchmark...\n",
+		       subsys->name,
+		       suites[i].name);
+
+		argv[1] = suites[i].name;
+		suites[i].fn(1, argv, NULL);
+		printf("\n");
+	}
+}
+
+static void all_subsystem(void)
+{
+	int i;
+	for (i = 0; subsystems[i].suites; i++)
+		all_suite(&subsystems[i]);
+}
+
 int cmd_bench(int argc, const char **argv, const char *prefix __used)
 {
 	int i, j, status = 0;
@@ -155,6 +194,11 @@ int cmd_bench(int argc, const char **argv, const char *prefix __used)
 		goto end;
 	}
 
+	if (!strcmp(argv[0], "all")) {
+		all_subsystem();
+		goto end;
+	}
+
 	for (i = 0; subsystems[i].name; i++) {
 		if (strcmp(subsystems[i].name, argv[0]))
 			continue;
@@ -165,6 +209,11 @@ int cmd_bench(int argc, const char **argv, const char *prefix __used)
 			goto end;
 		}
 
+		if (!strcmp(argv[1], "all")) {
+			all_suite(&subsystems[i]);
+			goto end;
+		}
+
 		for (j = 0; subsystems[i].suites[j].name; j++) {
 			if (strcmp(subsystems[i].suites[j].name, argv[1]))
 				continue;
