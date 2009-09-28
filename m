Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZI1UIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZI1UIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZI1UIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:08:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZI1UIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:08:34 -0400
Date: Mon, 28 Sep 2009 17:08:18 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 tip] perf trace: Remove dead code
Message-ID: <20090928200818.GF3361@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several variables are not used at all, cut'n'paste leftovers.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |   28 ----------------------------
 1 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index e9d256e..2f93888 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -53,16 +53,12 @@ process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	char level;
-	int show = 0;
-	struct dso *dso = NULL;
 	struct thread *thread;
 	u64 ip = event->ip.ip;
 	u64 timestamp = -1;
 	u32 cpu = -1;
 	u64 period = 1;
 	void *more_data = event->ip.__more_data;
-	int cpumode;
 
 	thread = threads__findnew(event->ip.pid, &threads, &last_match);
 
@@ -98,30 +94,6 @@ process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 		return -1;
 	}
 
-	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-
-	if (cpumode == PERF_RECORD_MISC_KERNEL) {
-		show = SHOW_KERNEL;
-		level = 'k';
-
-		dso = kernel_dso;
-
-		dump_printf(" ...... dso: %s\n", dso->name);
-
-	} else if (cpumode == PERF_RECORD_MISC_USER) {
-
-		show = SHOW_USER;
-		level = '.';
-
-	} else {
-		show = SHOW_HV;
-		level = 'H';
-
-		dso = hypervisor_dso;
-
-		dump_printf(" ...... dso: [hypervisor]\n");
-	}
-
 	if (sample_type & PERF_SAMPLE_RAW) {
 		struct {
 			u32 size;
-- 
1.6.2.5


