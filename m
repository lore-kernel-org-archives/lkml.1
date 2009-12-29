Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZL2JFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZL2JFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 04:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbZL2JE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 04:04:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:57432 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZL2JEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 04:04:51 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 1/3] perf tools: unify event type description
Date: Tue, 29 Dec 2009 16:37:07 +0800
Message-Id: <1262075829-16257-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
X-OriginalArrivalTime: 29 Dec 2009 09:03:39.0308 (UTC) FILETIME=[CFD026C0:01CA8865]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make event type description to a unified array and
the array index consistent to perf_type_id.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 tools/perf/util/parse-events.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e5bc0fb..dc585a8 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -835,11 +835,12 @@ int parse_filter(const struct option *opt __used, const char *str,
 }
 
 static const char * const event_type_descriptors[] = {
-	"",
 	"Hardware event",
 	"Software event",
 	"Tracepoint event",
 	"Hardware cache event",
+	"Raw hardware event descriptor",
+	"Hardware breakpoint",
 };
 
 /*
@@ -872,7 +873,7 @@ static void print_tracepoint_events(void)
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
 			printf("  %-42s [%s]\n", evt_path,
-				event_type_descriptors[PERF_TYPE_TRACEPOINT+1]);
+				event_type_descriptors[PERF_TYPE_TRACEPOINT]);
 		}
 		closedir(evt_dir);
 	}
@@ -892,9 +893,7 @@ void print_events(void)
 	printf("List of pre-defined events (to be used in -e):\n");
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
-		type = syms->type + 1;
-		if (type >= ARRAY_SIZE(event_type_descriptors))
-			type = 0;
+		type = syms->type;
 
 		if (type != prev_type)
 			printf("\n");
@@ -919,17 +918,19 @@ void print_events(void)
 			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
 				printf("  %-42s [%s]\n",
 					event_cache_name(type, op, i),
-					event_type_descriptors[4]);
+					event_type_descriptors[PERF_TYPE_HW_CACHE]);
 			}
 		}
 	}
 
 	printf("\n");
-	printf("  %-42s [raw hardware event descriptor]\n",
-		"rNNN");
+	printf("  %-42s [%s]\n",
+		"rNNN", event_type_descriptors[PERF_TYPE_RAW]);
 	printf("\n");
 
-	printf("  %-42s [hardware breakpoint]\n", "mem:<addr>[:access]");
+	printf("  %-42s [%s]\n",
+			"mem:<addr>[:access]",
+			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
 	printf("\n");
 
 	print_tracepoint_events();
-- 
1.6.0.3

