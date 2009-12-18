Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbZLRTE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbZLRTE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbZLRTEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:04:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:35511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbZLRTEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:04:24 -0500
Date: Fri, 18 Dec 2009 19:03:35 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1261161358-23959-1-git-send-email-acme@infradead.org>
References: <1261161358-23959-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf diff: Fix usage array, it must end with a NULL entry
Message-ID: <tip-0422a4fc2c6a41c3d4184984797512af2650014e@git.kernel.org>
Git-Commit-ID: 0422a4fc2c6a41c3d4184984797512af2650014e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0422a4fc2c6a41c3d4184984797512af2650014e
Gitweb:     http://git.kernel.org/tip/0422a4fc2c6a41c3d4184984797512af2650014e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 18 Dec 2009 16:35:58 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Dec 2009 20:01:52 +0100

perf diff: Fix usage array, it must end with a NULL entry

Fixing this:

 [acme@doppio linux-2.6-tip]$ perf diff --hell
   Error: unknown option `hell'

  usage: perf diff [<options>] [old_file] [new_file]
 Segmentation fault
 [acme@doppio linux-2.6-tip]$

Also go over the other such arrays to check if they all were OK,
they are, but there were some minor changes to do like making
one static and renaming another to match the command it refers
to.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1261161358-23959-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-buildid-list.c |    2 +-
 tools/perf/builtin-diff.c         |    3 ++-
 tools/perf/builtin-report.c       |    3 +--
 tools/perf/builtin-trace.c        |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index e693e67..1e99ac8 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -17,7 +17,7 @@
 static char const *input_name = "perf.data";
 static int force;
 
-static const char *const buildid_list_usage[] = {
+static const char * const buildid_list_usage[] = {
 	"perf buildid-list [<options>]",
 	NULL
 };
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4d33b55..bd71b8c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -189,8 +189,9 @@ out_delete:
 	return ret;
 }
 
-static const char *const diff_usage[] = {
+static const char * const diff_usage[] = {
 	"perf diff [<options>] [old_file] [new_file]",
+	NULL,
 };
 
 static const struct option options[] = {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5c2ab53..db10c0e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -294,8 +294,7 @@ setup:
 	return 0;
 }
 
-//static const char * const report_usage[] = {
-const char * const report_usage[] = {
+static const char * const report_usage[] = {
 	"perf report [<options>] <command>",
 	NULL
 };
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index e2285e2..574a215 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -512,7 +512,7 @@ static char *get_script_path(const char *script_root, const char *suffix)
 	return path;
 }
 
-static const char * const annotate_usage[] = {
+static const char * const trace_usage[] = {
 	"perf trace [<options>] <command>",
 	NULL
 };
@@ -581,7 +581,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 
 	setup_scripting();
 
-	argc = parse_options(argc, argv, options, annotate_usage,
+	argc = parse_options(argc, argv, options, trace_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 
 	if (symbol__init() < 0)
