Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZL3MXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZL3MXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 07:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZL3MXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 07:23:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:42517 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbZL3MXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 07:23:41 -0500
Date: Wed, 30 Dec 2009 12:22:51 GMT
From: tip-bot for Liming Wang <liming.wang@windriver.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, liming.wang@windriver.com, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, liming.wang@windriver.com, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <1262075829-16257-1-git-send-email-liming.wang@windriver.com>
References: <1262075829-16257-1-git-send-email-liming.wang@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Unify event type description
Message-ID: <tip-41bdcb23dab22bf27361c5f2d89fe895d8904915@git.kernel.org>
Git-Commit-ID: 41bdcb23dab22bf27361c5f2d89fe895d8904915
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41bdcb23dab22bf27361c5f2d89fe895d8904915
Gitweb:     http://git.kernel.org/tip/41bdcb23dab22bf27361c5f2d89fe895d8904915
Author:     Liming Wang <liming.wang@windriver.com>
AuthorDate: Tue, 29 Dec 2009 16:37:07 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 11:58:53 +0100

perf tools: Unify event type description

make event type description to a unified array and
the array index consistent to perf_type_id.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1262075829-16257-1-git-send-email-liming.wang@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
