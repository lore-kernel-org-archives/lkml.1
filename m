Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZKPXp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZKPXp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZKPXp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:45:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbZKPXp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:45:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] perf buildid-list: Always show the DSO name
Date: Mon, 16 Nov 2009 21:45:25 -0200
Message-Id: <1258415125-15019-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258415125-15019-1-git-send-email-acme@infradead.org>
References: <1258415125-15019-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Porcelain can ignore it, humans can make more sense of it.

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Suggested-by: Ingo Molnar <mingo@elte.hu>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-list.txt |    2 +-
 tools/perf/builtin-buildid-list.c              |    2 +-
 tools/perf/util/symbol.c                       |    5 +----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-buildid-list.txt b/tools/perf/Documentation/perf-buildid-list.txt
index abab34e..01b642c 100644
--- a/tools/perf/Documentation/perf-buildid-list.txt
+++ b/tools/perf/Documentation/perf-buildid-list.txt
@@ -26,7 +26,7 @@ OPTIONS
 	Don't do ownership validation.
 -v::
 --verbose::
-	Be more verbose, showing the name of the DSOs after the buildids.
+	Be more verbose.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 2e377e1..7dee9d1 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -28,7 +28,7 @@ static const struct option options[] = {
 		    "input file name"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
-		    "be more verbose (show counter open errors, etc)"),
+		    "be more verbose"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 53de9c4..1b77e81 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1442,10 +1442,7 @@ size_t dsos__fprintf_buildid(FILE *fp)
 
 	list_for_each_entry(pos, &dsos, node) {
 		ret += dso__fprintf_buildid(pos, fp);
-		if (verbose)
-			ret += fprintf(fp, " %s\n", pos->long_name);
-		else
-			ret += fprintf(fp, "\n");
+		ret += fprintf(fp, " %s\n", pos->long_name);
 	}
 	return ret;
 }
-- 
1.6.2.5

