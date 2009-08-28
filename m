Return-Path: <linux-kernel-owner+w=401wt.eu-S1751745AbZH1GCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbZH1GCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 02:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZH1GCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 02:02:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:53118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbZH1GCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 02:02:15 -0400
Date: Fri, 28 Aug 2009 06:01:45 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1251427567-10551-2-git-send-email-fweisbec@gmail.com>
References: <1251427567-10551-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/tracing] perf tools: Fix missing string field printing in perf trace
Message-ID: <tip-d498bc1f6261dd6f655440eb2f1c7fa25694d3ba@git.kernel.org>
Git-Commit-ID: d498bc1f6261dd6f655440eb2f1c7fa25694d3ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 06:01:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d498bc1f6261dd6f655440eb2f1c7fa25694d3ba
Gitweb:     http://git.kernel.org/tip/d498bc1f6261dd6f655440eb2f1c7fa25694d3ba
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 28 Aug 2009 04:46:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 28 Aug 2009 07:58:11 +0200

perf tools: Fix missing string field printing in perf trace

Some string fields are not printed because of a missing printf
in the post-processing.

Before:
	    perf-10070 [000]     0.000000: sched_switch: task :10070 [120] (R) ==> :5720 [120]
           geany-5720  [000]     0.000000: sched_switch: task :5720 [120] (S) ==> :10070 [120]
            perf-10070 [000]     0.000000: sched_switch: task :10070 [120] (R) ==> :5720 [120]
           geany-5720  [000]     0.000000: sched_switch: task :5720 [120] (S) ==> :10070 [120]
          <idle>-0     [000]     0.000000: sched_switch: task :0 [140] (R) ==> :361 [115]

After:
	    perf-10070 [000]     0.000000: sched_switch: task perf:10070 [120] (R) ==> geany:5720 [120]
           geany-5720  [000]     0.000000: sched_switch: task geany:5720 [120] (S) ==> perf:10070 [120]
            perf-10070 [000]     0.000000: sched_switch: task perf:10070 [120] (R) ==> geany:5720 [120]
           geany-5720  [000]     0.000000: sched_switch: task geany:5720 [120] (S) ==> perf:10070 [120]
          <idle>-0     [000]     0.000000: sched_switch: task swapper:0 [140] (R) ==> kondemand/1:361 [115]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1251427567-10551-2-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/trace-event-parse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index a6577cd..96c5e97 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1997,6 +1997,7 @@ static void print_str_arg(void *data, int size,
 		memcpy(str, data + arg->field.field->offset,
 		       arg->field.field->size);
 		str[arg->field.field->size] = 0;
+		printf("%s", str);
 		free(str);
 		break;
 	case PRINT_FLAGS:
