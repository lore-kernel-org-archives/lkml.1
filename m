Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZJ0AdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZJ0AdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbZJ0AdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:33:22 -0400
Received: from smtp-out.neti.ee ([194.126.126.34]:56184 "EHLO smtp-out.neti.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbZJ0AdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:33:20 -0400
X-SMTP-Auth-NETI-Businesmail: no
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 2] perf tools: output 'perf list' to stdout not stderr
X-Mercurial-Node: 4ebb59420ef0579721671fb776f0ab73f5cbcacc
Message-Id: <4ebb59420ef057972167.1256603585@localhost>
In-Reply-To: <patchbomb.1256603583@localhost>
References: <patchbomb.1256603583@localhost>
User-Agent: Mercurial-patchbomb/1.3.1
Date: Tue, 27 Oct 2009 00:33:05 -0000
From: Marti Raudsepp <marti@juffo.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marti Raudsepp <marti@juffo.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing to stdout is probably the expected behavior because the user
explicitly asked for a list.

Signed-off-by: Marti Raudsepp <marti@juffo.org>

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -784,7 +784,7 @@
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
-			fprintf(stderr, "  %-42s [%s]\n", evt_path,
+			printf("  %-42s [%s]\n", evt_path,
 				event_type_descriptors[PERF_TYPE_TRACEPOINT+1]);
 		}
 		closedir(evt_dir);
@@ -801,8 +801,8 @@
 	unsigned int i, type, op, prev_type = -1;
 	char name[40];
 
-	fprintf(stderr, "\n");
-	fprintf(stderr, "List of pre-defined events (to be used in -e):\n");
+	printf("\n");
+	printf("List of pre-defined events (to be used in -e):\n");
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
 		type = syms->type + 1;
@@ -810,19 +810,19 @@
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
@@ -830,17 +830,17 @@
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
 
