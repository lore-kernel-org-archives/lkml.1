Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbZCJVFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbZCJVFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbZCJVFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:05:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbZCJVFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:05:35 -0400
Message-Id: <20090310210531.096862962@goodmis.org>
References: <20090310210408.419131392@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 17:04:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/7] tracing: add back the available_events file
Content-Disposition: inline; filename=0003-tracing-add-back-the-available_events-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The event directory files type and available_types were no longer
needed with the new TRACE_EVENT_FORMAT macros, they were deleted.
But by accident the available_events file was also removed.
This patch brings it back.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 85ec10f..769dfd0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -428,6 +428,13 @@ static const struct seq_operations show_set_event_seq_ops = {
 	.stop = t_stop,
 };
 
+static const struct file_operations ftrace_avail_fops = {
+	.open = ftrace_event_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
 static const struct file_operations ftrace_set_event_fops = {
 	.open = ftrace_event_seq_open,
 	.read = seq_read,
@@ -569,6 +576,13 @@ static __init int event_trace_init(void)
 	if (!d_tracer)
 		return 0;
 
+	entry = debugfs_create_file("available_events", 0444, d_tracer,
+				    (void *)&show_event_seq_ops,
+				    &ftrace_avail_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'available_events' entry\n");
+
 	entry = debugfs_create_file("set_event", 0644, d_tracer,
 				    (void *)&show_set_event_seq_ops,
 				    &ftrace_set_event_fops);
-- 
1.6.1.3

-- 
