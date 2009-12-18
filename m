Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZLRSgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZLRSgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZLRSgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:36:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:41465 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZLRSgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:36:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1 v2] perf diff: Fix usage array, it must end with a NULL entry
Date: Fri, 18 Dec 2009 16:35:58 -0200
Message-Id: <1261161358-23959-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Fixing this:

[acme@doppio linux-2.6-tip]$ perf diff --hell
  Error: unknown option `hell'

 usage: perf diff [<options>] [old_file] [new_file]
Segmentation fault
[acme@doppio linux-2.6-tip]$

Also go over the other such arrays to check if they all were OK, they
are, but there were some minor changes to do like making one static and
renaming another to match the command it refers to.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.2.5

