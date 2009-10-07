Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbZJGNtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbZJGNtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZJGNtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:49:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:45204 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZJGNtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:49:49 -0400
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/1] perf tools: Up the verbose level for some really verbose stuff
Date: Wed,  7 Oct 2009 10:49:00 -0300
Message-Id: <1254923340-4870-1-git-send-email-acme@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <yes>
References: <yes>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like printing every symbol created.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 12f8c86..3f0f1a4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1021,10 +1021,10 @@ done:
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
 
-- 
1.6.2.5

