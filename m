Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbZHKSuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbZHKSuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbZHKStd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:33 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42538 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbZHKStb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C5S7o1rCmgkH3YzzC/Z5QQQPM8M/xfXNqALFyXe3sdya/wJS2ZNPzpAeGS4SotLAe0
         C++v7WyTORqE0axoQbwnubB28qlrI/Upz+pllXQu02SJH8pdH4B8nvf/cPFg+M1CigGJ
         UWw5qW4RLyXow69aw9+6DCtq9mJGDeKpp15y4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 12/16] tracing: Add more namespace area to 'perf list' output
Date: Tue, 11 Aug 2009 20:49:01 +0200
Message-Id: <1250016545-6601-13-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

The new syscall tracepoints names can be too long for the 'perf list'
output.
Add a few more characters.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/parse-events.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4858d83..a5d661b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -606,7 +606,7 @@ static void print_tracepoint_events(void)
 								evt_path, st) {
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
-			fprintf(stderr, "  %-40s [%s]\n", evt_path,
+			fprintf(stderr, "  %-42s [%s]\n", evt_path,
 				event_type_descriptors[PERF_TYPE_TRACEPOINT+1]);
 		}
 		closedir(evt_dir);
@@ -640,7 +640,7 @@ void print_events(void)
 			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
 		else
 			strcpy(name, syms->symbol);
-		fprintf(stderr, "  %-40s [%s]\n", name,
+		fprintf(stderr, "  %-42s [%s]\n", name,
 			event_type_descriptors[type]);
 
 		prev_type = type;
@@ -654,7 +654,7 @@ void print_events(void)
 				continue;
 
 			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
-				fprintf(stderr, "  %-40s [%s]\n",
+				fprintf(stderr, "  %-42s [%s]\n",
 					event_cache_name(type, op, i),
 					event_type_descriptors[4]);
 			}
@@ -662,7 +662,7 @@ void print_events(void)
 	}
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, "  %-40s [raw hardware event descriptor]\n",
+	fprintf(stderr, "  %-42s [raw hardware event descriptor]\n",
 		"rNNN");
 	fprintf(stderr, "\n");
 
-- 
1.6.2.3

