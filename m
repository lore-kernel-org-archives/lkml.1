Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711Ab0AQMWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0AQMWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 07:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246Ab0AQMWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 07:22:25 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42781 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0AQMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 07:22:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sHPlmSL6sgscV60hrFDkwIHbl3eU0gt7rfqywdOKvuukrt7LWOw0nrxp/2xFY6OTPJ
         XKMog+nfca8m7cAHsod4/yx8t66lf7BuJM/PRkhus0ybtJzSBHizbU1jfxFz7oftnvKp
         Bwr5t1Kn7DgS8+QA/HrHC/x8hGcsfC6ueNyRA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/4] perf: Make __perf_event_sched_out static
Date: Sun, 17 Jan 2010 13:22:12 +0100
Message-Id: <1263730935-9770-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
References: <1263730935-9770-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__perf_event_sched_out doesn't need to be globally available, make
it static.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---
 kernel/perf_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index eae6ff6..c4e90b8 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1049,8 +1049,8 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 	return 0;
 }
 
-void __perf_event_sched_out(struct perf_event_context *ctx,
-			      struct perf_cpu_context *cpuctx)
+static void __perf_event_sched_out(struct perf_event_context *ctx,
+				   struct perf_cpu_context *cpuctx)
 {
 	struct perf_event *event;
 
-- 
1.6.2.3

