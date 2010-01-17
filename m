Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636Ab0AQMWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0AQMWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868Ab0AQMW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:22:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54566 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0AQMWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sDT4NukQLdC2R7mxA6spAGXqy9RXw0OvylNF4vHmj9GB8KZsKKiOtthawM05VrGNBT
         5DFMAJURvJtRE/rf6BE+3QFJLARLekQ1uJPgRY95Mr59XC3j1DoBpSJVnSip1ctRU892
         2uv185WMFbeLVgVrKjBLvKWCM5UMC6E0qhieM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/4] perf: Don't schedule out/in pinned events on task tick
Date: Sun, 17 Jan 2010 13:22:14 +0100
Message-Id: <1263730935-9770-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
References: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to schedule in/out pinned events on task tick,
now that pinned and flexible groups can be scheduled separately.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---
 kernel/perf_event.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index bfc4ee0..a90ae69 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1525,17 +1525,17 @@ void perf_event_task_tick(struct task_struct *curr)
 	if (ctx)
 		perf_ctx_adjust_freq(ctx);
 
-	cpu_ctx_sched_out(cpuctx, EVENT_ALL);
+	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
-		task_ctx_sched_out(ctx, EVENT_ALL);
+		task_ctx_sched_out(ctx, EVENT_FLEXIBLE);
 
 	rotate_ctx(&cpuctx->ctx);
 	if (ctx)
 		rotate_ctx(ctx);
 
-	cpu_ctx_sched_in(cpuctx, EVENT_ALL);
+	cpu_ctx_sched_in(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
-		task_ctx_sched_in(curr, EVENT_ALL);
+		task_ctx_sched_in(curr, EVENT_FLEXIBLE);
 }
 
 static int event_enable_on_exec(struct perf_event *event,
-- 
1.6.2.3

