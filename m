Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZCBUc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZCBUc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZCBUac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:30:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35987 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbZCBUa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:30:28 -0500
Message-Id: <20090302203025.042001098@goodmis.org>
References: <20090302202925.364437449@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 15:29:31 -0500
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
Subject: [PATCH 6/7] tracing: add trace name and id to event formats
Content-Disposition: inline; filename=0006-tracing-add-trace-name-and-id-to-event-formats.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

To be able to identify the trace in the binary format output, the
id of the trace event (which is dynamically assigned) must also be listed.

This patch adds the name of the trace point as well as the id assigned.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index cdcc3ae..210e71f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -487,7 +487,11 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	if (*ppos)
 		return 0;
 
-	/* If this fails, so will the show_format. */
+	/* If any of the first writes fail, so will the show_format. */
+
+	trace_seq_printf(s, "name: %s\n", call->name);
+	trace_seq_printf(s, "ID: %d\n", call->id);
+	trace_seq_printf(s, "format:\n");
 	trace_write_header(s);
 
 	r = call->show_format(s);
-- 
1.5.6.5

-- 
