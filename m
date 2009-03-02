Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZCBUbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZCBUbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZCBUab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:30:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34247 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZCBUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:30:27 -0500
Message-Id: <20090302203025.346098400@goodmis.org>
References: <20090302202925.364437449@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 15:29:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 7/7] tracing: add print format to event trace format files
Content-Disposition: inline; filename=0007-tracing-add-print-format-to-event-trace-format-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds the internal print format used to print the raw events
to the event trace point format file.

 # cat /debug/tracing/events/sched/sched_switch/format
name: sched_switch
ID: 29
format:
        field:unsigned char type;       offset:0;       size:1;
        field:unsigned char flags;      offset:1;       size:1;
        field:unsigned char preempt_count;      offset:2;       size:1;
        field:int pid;  offset:4;       size:4;
        field:int tgid; offset:8;       size:4;

        field:pid_t prev_pid;   offset:12;      size:4;
        field:int prev_prio;    offset:16;      size:4;
        field special:char next_comm[TASK_COMM_LEN];    offset:20;      size:16;
        field:pid_t next_pid;   offset:36;      size:4;
        field:int next_prio;    offset:40;      size:4;

print fmt: "prev %d:%d ==> next %s:%d:%d"

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events_stage_2.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index 3a80ea4..b1cebba 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -122,6 +122,8 @@ ftrace_format_##call(struct trace_seq *s)				\
 									\
 	tstruct;							\
 									\
+	trace_seq_printf(s, "\nprint fmt: \"%s\"\n", tpfmt);		\
+									\
 	return ret;							\
 }
 
-- 
1.5.6.5

-- 
