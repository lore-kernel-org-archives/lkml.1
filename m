Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZJ0Nz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZJ0Nz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZJ0NzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:55:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:50392 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbZJ0NzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:55:23 -0400
Date: Tue, 27 Oct 2009 13:54:51 GMT
From: tip-bot for Marti Raudsepp <marti@juffo.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, marti@juffo.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, marti@juffo.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4ebb59420ef057972167.1256603585@localhost>
References: <4ebb59420ef057972167.1256603585@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Output 'perf list' to stdout not stderr
Message-ID: <tip-689d30187828afe1faedf050b2f7593515b90c76@git.kernel.org>
Git-Commit-ID: 689d30187828afe1faedf050b2f7593515b90c76
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  689d30187828afe1faedf050b2f7593515b90c76
Gitweb:     http://git.kernel.org/tip/689d30187828afe1faedf050b2f7593515b90c76
Author:     Marti Raudsepp <marti@juffo.org>
AuthorDate: Tue, 27 Oct 2009 00:33:05 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 27 Oct 2009 14:52:32 +0100

perf tools: Output 'perf list' to stdout not stderr

Writing to stdout is probably the expected behavior because the
user explicitly asked for a list.

Signed-off-by: Marti Raudsepp <marti@juffo.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <4ebb59420ef057972167.1256603585@localhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e9e6d5c..31baa5a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -806,7 +806,7 @@ static void print_tracepoint_events(void)
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
-			fprintf(stderr, "  %-42s [%s]\n", evt_path,
+			printf("  %-42s [%s]\n", evt_path,
 				event_type_descriptors[PERF_TYPE_TRACEPOINT+1]);
 		}
 		closedir(evt_dir);
@@ -823,8 +823,8 @@ void print_events(void)
 	unsigned int i, type, op, prev_type = -1;
 	char name[40];
 
-	fprintf(stderr, "\n");
-	fprintf(stderr, "List of pre-defined events (to be used in -e):\n");
+	printf("\n");
+	printf("List of pre-defined events (to be used in -e):\n");
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
 		type = syms->type + 1;
@@ -832,19 +832,19 @@ void print_events(void)
 			type = 0;
 
 		if (type != prev_type)
-			fprintf(stderr, "\n");
+			printf("\n");
 
 		if (strlen(syms->alias))
 			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
 		else
 			strcpy(name, syms->symbol);
-		fprintf(stderr, "  %-42s [%s]\n", name,
+		printf("  %-42s [%s]\n", name,
 			event_type_descriptors[type]);
 
 		prev_type = type;
 	}
 
-	fprintf(stderr, "\n");
+	printf("\n");
 	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
 		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
 			/* skip invalid cache type */
@@ -852,17 +852,17 @@ void print_events(void)
 				continue;
 
 			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				fprintf(stderr, "  %-42s [%s]\n",
+				printf("  %-42s [%s]\n",
 					event_cache_name(type, op, i),
 					event_type_descriptors[4]);
 			}
 		}
 	}
 
-	fprintf(stderr, "\n");
-	fprintf(stderr, "  %-42s [raw hardware event descriptor]\n",
+	printf("\n");
+	printf("  %-42s [raw hardware event descriptor]\n",
 		"rNNN");
-	fprintf(stderr, "\n");
+	printf("\n");
 
 	print_tracepoint_events();
 
