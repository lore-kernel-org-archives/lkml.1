Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZLBJIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZLBJIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbZLBJIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:08:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:47936 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZLBJIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:08:21 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Ingo Molnar <mingo@elte.hu>, mhiramat@redhat.com, fweisbec@gmail.com
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       Liming Wang <liming.wang@windriver.com>
Subject: [PATCH] perf tools: replace %m with %a in sscanf
Date: Wed,  2 Dec 2009 16:42:54 +0800
Message-Id: <1259743374-9950-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <20091202083120.GA20120@elte.hu>
References: <20091202083120.GA20120@elte.hu>
X-OriginalArrivalTime: 02 Dec 2009 09:08:01.0766 (UTC) FILETIME=[F318D060:01CA732E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all glibc support %m and it results in a compile error if
%m not supported. Replace it with %a and (float *) casts.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
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
 
-- 
1.6.0.3

