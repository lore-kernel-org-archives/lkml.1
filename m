Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbZF0Ec0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbZF0Ec0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 00:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZF0Eb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 00:31:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:57559 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbZF0Ebz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 00:31:55 -0400
Date: Sat, 27 Jun 2009 04:31:25 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf stat: Add -n/--null option to run without counters
Message-ID: <tip-0cfb7a13b8e4e0afd4b856156ab16a182de7505b@git.kernel.org>
Git-Commit-ID: 0cfb7a13b8e4e0afd4b856156ab16a182de7505b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 27 Jun 2009 04:31:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cfb7a13b8e4e0afd4b856156ab16a182de7505b
Gitweb:     http://git.kernel.org/tip/0cfb7a13b8e4e0afd4b856156ab16a182de7505b
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sat, 27 Jun 2009 06:10:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 27 Jun 2009 06:11:24 +0200

perf stat: Add -n/--null option to run without counters

Allow a no-counters run. This can be useful to measure just
elapsed wall-clock time - or to assess the raw overhead of perf
stat itself, without running any counters.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-stat.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8420ec5..cdcd058 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -70,6 +70,7 @@ static int			run_count			=  1;
 static int			inherit				=  1;
 static int			scale				=  1;
 static int			target_pid			= -1;
+static int			null_run			=  0;
 
 static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
@@ -461,6 +462,8 @@ static const struct option options[] = {
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_INTEGER('r', "repeat", &run_count,
 		    "repeat command and print average + stddev (max: 100)"),
+	OPT_BOOLEAN('n', "null", &null_run,
+		    "null run - dont start any counters"),
 	OPT_END()
 };
 
@@ -476,7 +479,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 	if (run_count <= 0 || run_count > MAX_RUN)
 		usage_with_options(stat_usage, options);
 
-	if (!nr_counters)
+	if (!null_run && !nr_counters)
 		nr_counters = 8;
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
