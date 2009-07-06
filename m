Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZGFVRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZGFVRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZGFVRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:17:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41599 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbZGFVRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:17:05 -0400
Date: Mon, 6 Jul 2009 17:11:57 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, fweisbec@gmail.com
Message-Id: <8fb0db1f14501b8a4b5c38374fc84c5ac03bd5aa.1246912068.git.jbaron@redhat.com>
In-Reply-To: <cover.1246912068.git.jbaron@redhat.com>
References: <cover.1246912068.git.jbaron@redhat.com>
Subject: [PATCH 1/2] perf_counter: cleanup kernel perf counter support for tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



cleanup EVENT_PROFILE support to that it compiles and support tracepoint tracing
from the 'perf' tool. 


Signed-off-by: Jason Baron <jbaron@redhat.com>


---
 init/Kconfig          |    2 +-
 kernel/perf_counter.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 0e8784e..13473ac 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -955,7 +955,7 @@ config PERF_COUNTERS
 
 config EVENT_PROFILE
 	bool "Tracepoint profile sources"
-	depends on PERF_COUNTERS && EVENT_TRACER
+	depends on PERF_COUNTERS && EVENT_TRACING
 	default y
 
 endmenu
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d55a50d..a6d9759 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3671,7 +3671,7 @@ static const struct pmu perf_ops_task_clock = {
 void perf_tpcounter_event(int event_id)
 {
 	struct perf_sample_data data = {
-		.regs = get_irq_regs();
+		.regs = get_irq_regs(),
 		.addr = 0,
 	};
 
@@ -3687,12 +3687,12 @@ extern void ftrace_profile_disable(int);
 
 static void tp_perf_counter_destroy(struct perf_counter *counter)
 {
-	ftrace_profile_disable(perf_event_id(&counter->attr));
+	ftrace_profile_disable(counter->attr.config);
 }
 
 static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 {
-	int event_id = perf_event_id(&counter->attr);
+	int event_id = counter->attr.config;
 	int ret;
 
 	ret = ftrace_profile_enable(event_id);
-- 
1.6.0.6

