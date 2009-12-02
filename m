Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZLBKpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZLBKpC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:45:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbZLBKo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:44:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:44968 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbZLBKo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:44:57 -0500
Date: Wed, 2 Dec 2009 10:44:25 GMT
From: tip-bot for Liming Wang <liming.wang@windriver.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, liming.wang@windriver.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, liming.wang@windriver.com,
       mingo@elte.hu
In-Reply-To: <1259743374-9950-1-git-send-email-liming.wang@windriver.com>
References: <1259743374-9950-1-git-send-email-liming.wang@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Replace %m with %a in sscanf
Message-ID: <tip-93aaa45a6ad3f983180223601fc663cc551ad499@git.kernel.org>
Git-Commit-ID: 93aaa45a6ad3f983180223601fc663cc551ad499
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93aaa45a6ad3f983180223601fc663cc551ad499
Gitweb:     http://git.kernel.org/tip/93aaa45a6ad3f983180223601fc663cc551ad499
Author:     Liming Wang <liming.wang@windriver.com>
AuthorDate: Wed, 2 Dec 2009 16:42:54 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 10:12:16 +0100

perf tools: Replace %m with %a in sscanf

Not all glibc support %m and it results in a compile error if
%m not supported. Replace it with %a and (float *) casts.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: peterz@infradead.org
Cc: mhiramat@redhat.com
LKML-Reference: <1259743374-9950-1-git-send-email-liming.wang@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index e42f3ac..cd7fbda 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -199,8 +199,8 @@ void parse_trace_kprobe_event(const char *str, char **group, char **event,
 		semantic_error("Too less arguments.");
 
 	/* Scan event and group name. */
-	ret = sscanf(argv[0], "%c:%m[^/ \t]/%m[^ \t]",
-		     &pr, group, event);
+	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
+		     &pr, (float *)(void *)group, (float *)(void *)event);
 	if (ret != 3)
 		semantic_error("Failed to parse event name: %s", argv[0]);
 	pr_debug("Group:%s Event:%s probe:%c\n", *group, *event, pr);
@@ -211,7 +211,7 @@ void parse_trace_kprobe_event(const char *str, char **group, char **event,
 	pp->retprobe = (pr == 'r');
 
 	/* Scan function name and offset */
-	ret = sscanf(argv[1], "%m[^+]+%d", &pp->function, &pp->offset);
+	ret = sscanf(argv[1], "%a[^+]+%d", (float *)(void *)&pp->function, &pp->offset);
 	if (ret == 1)
 		pp->offset = 0;
 
