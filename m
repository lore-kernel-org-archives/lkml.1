Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZIOJgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZIOJgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZIOJgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:36:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:57403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbZIOJf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:35:58 -0400
Date: Tue, 15 Sep 2009 09:35:26 GMT
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
Subject: [tip:perfcounters/core] perf sched: Add 'perf sched trace', improve documentation
Message-ID: <tip-c13f0d3c8165e9592102687fa999da0a0d9c3724@git.kernel.org>
Git-Commit-ID: c13f0d3c8165e9592102687fa999da0a0d9c3724
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:35:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c13f0d3c8165e9592102687fa999da0a0d9c3724
Gitweb:     http://git.kernel.org/tip/c13f0d3c8165e9592102687fa999da0a0d9c3724
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 13 Sep 2009 16:51:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 17:55:23 +0200

perf sched: Add 'perf sched trace', improve documentation

Alias 'perf sched trace' to 'perf trace', for workflow completeness.

Add a bit of documentation for perf sched.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-sched.txt |   22 +++++++++++++++++++---
 tools/perf/builtin-sched.c              |    7 ++++++-
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
index 056320e..1ce7919 100644
--- a/tools/perf/Documentation/perf-sched.txt
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -3,16 +3,32 @@ perf-sched(1)
 
 NAME
 ----
-perf-sched - Read perf.data (created by perf record) and display sched output
+perf-sched - Tool to trace/measure scheduler properties (latencies)
 
 SYNOPSIS
 --------
 [verse]
-'perf sched' [-i <file> | --input=file] symbol_name
+'perf sched' {record|latency|replay|trace}
 
 DESCRIPTION
 -----------
-This command reads the input file and displays the latencies recorded.
+There's four variants of perf sched:
+
+  'perf sched record <command>' to record the scheduling events
+  of an arbitrary workload.
+
+  'perf sched latency' to report the per task scheduling latencies
+  and other scheduling properties of the workload.
+
+  'perf sched trace' to see a detailed trace of the workload that
+  was recorded.
+
+  'perf sched replay' to simulate the workload that was recorded
+  via perf sched record. (this is done by starting up mockup threads
+  that mimic the workload based on the events in the trace. These
+  threads can then replay the timings (CPU runtime and sleep patterns)
+  of the workload as it occured when it was recorded - and can repeat
+  it a number of times, measuring its performance.)
 
 OPTIONS
 -------
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index ede40c1..8db0fd2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1597,7 +1597,7 @@ more:
 }
 
 static const char * const sched_usage[] = {
-	"perf sched [<options>] {record|latency|replay}",
+	"perf sched [<options>] {record|latency|replay|trace}",
 	NULL
 };
 
@@ -1719,6 +1719,11 @@ int cmd_sched(int argc, const char **argv, const char *prefix __used)
 				usage_with_options(replay_usage, replay_options);
 		}
 		__cmd_replay();
+	} else if (!strcmp(argv[0], "trace")) {
+		/*
+		 * Aliased to 'perf trace' for now:
+		 */
+		return cmd_trace(argc, argv, prefix);
 	} else {
 		usage_with_options(sched_usage, sched_options);
 	}
