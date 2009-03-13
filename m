Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZCMCng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZCMCng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbZCMCij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48851 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546AbZCMCia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:30 -0400
Message-Id: <20090313023828.029155950@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 15/16] tracing: show event name in trace for TRACE_EVENT created events
Content-Disposition: inline; filename=0015-tracing-show-event-name-in-trace-for-TRACE_EVENT-cr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Unlike TRACE_FORMAT() macros, the TRACE_EVENT() macros do not show
the event name in the trace file. Knowing the event type in the trace
output is very useful.

Instead of:

   task swapper:0 [140] ==> ntpd:3308 [120]

We now have:

   sched_switch: task swapper:0 [140] ==> ntpd:3308 [120]

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events_stage_2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index ca347af..5117c43 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -57,7 +57,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 									\
 	field = (typeof(field))entry;					\
 									\
-	ret = trace_seq_printf(s, print);				\
+	ret = trace_seq_printf(s, #call ": " print);			\
 	if (!ret)							\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
-- 
1.6.1.3

-- 
