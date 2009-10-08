Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbZJHRcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbZJHRcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758936AbZJHRcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:32:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:41100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758844AbZJHRcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:32:50 -0400
Date: Thu, 8 Oct 2009 17:31:36 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1254923340-4870-1-git-send-email-acme@redhat.com>
References: <1254923340-4870-1-git-send-email-acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Up the verbose level for some really verbose stuff
Message-ID: <tip-da21d1b547cbaa2c026cf645753651c25d340923@git.kernel.org>
Git-Commit-ID: da21d1b547cbaa2c026cf645753651c25d340923
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 17:31:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da21d1b547cbaa2c026cf645753651c25d340923
Gitweb:     http://git.kernel.org/tip/da21d1b547cbaa2c026cf645753651c25d340923
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 7 Oct 2009 10:49:00 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Oct 2009 19:27:10 +0200

perf tools: Up the verbose level for some really verbose stuff

Like printing every symbol created.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1254923340-4870-1-git-send-email-acme@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-annotate.c |    4 ++--
 tools/perf/builtin-report.c   |    4 ++--
 tools/perf/util/symbol.c      |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 35ed97b..8c84320 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -658,10 +658,10 @@ more:
 	if (dump_trace)
 		return 0;
 
-	if (verbose >= 3)
+	if (verbose > 3)
 		threads__fprintf(stdout, &threads);
 
-	if (verbose >= 2)
+	if (verbose > 2)
 		dsos__fprintf(stdout);
 
 	collapse__resort();
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 87c4582..f57a23b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -880,10 +880,10 @@ static int __cmd_report(void)
 	if (dump_trace)
 		return 0;
 
-	if (verbose >= 3)
+	if (verbose > 3)
 		threads__fprintf(stdout, &threads);
 
-	if (verbose >= 2)
+	if (verbose > 2)
 		dsos__fprintf(stdout);
 
 	collapse__resort();
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 582ce72..a6887f9 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -74,7 +74,7 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name,
 	if (!self)
 		return NULL;
 
-	if (v >= 2)
+	if (v > 2)
 		printf("new symbol: %016Lx [%08lx]: %s, hist: %p\n",
 			start, (unsigned long)len, name, self->hist);
 
@@ -685,7 +685,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 		}
 
 		if (self->adjust_symbols) {
-			if (v >= 2)
+			if (v > 2)
 				printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
 					(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
 
