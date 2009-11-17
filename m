Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZKQGdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZKQGdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 01:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbZKQGdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 01:33:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:58601 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbZKQGdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 01:33:00 -0500
Date: Tue, 17 Nov 2009 06:32:25 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258415125-15019-2-git-send-email-acme@infradead.org>
References: <1258415125-15019-2-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf buildid-list: Always show the DSO name
Message-ID: <tip-1124ba73be6a758965340bd997593b2996649d60@git.kernel.org>
Git-Commit-ID: 1124ba73be6a758965340bd997593b2996649d60
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1124ba73be6a758965340bd997593b2996649d60
Gitweb:     http://git.kernel.org/tip/1124ba73be6a758965340bd997593b2996649d60
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 16 Nov 2009 21:45:25 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:19:54 +0100

perf buildid-list: Always show the DSO name

Porcelain can ignore it, humans can make more sense of it.

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Suggested-by: Ingo Molnar <mingo@elte.hu>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1258415125-15019-2-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
