Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZB1JKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZB1JKB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbZB1JJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60034 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZB1JJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:40 -0500
Message-Id: <20090228090936.874671115@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/10] tracing: move trace point formats to files in include/trace directory
Content-Disposition: inline; filename=0001-tracing-move-trace-point-formats-to-files-in-includ.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

To further facilitate the ease of adding trace points for developers, this
patch creates include/trace/trace_events.h and
include/trace/trace_event_types.h.

The former file will hold the trace/<type>.h files and the latter will hold
the trace/<type>_event_types.h files.

To create new tracepoints and to have them automatically
appear in the event tracer, a developer makes the trace/<type>.h file
which includes <linux/tracepoint.h> and the trace/<type>_event_types.h file.

The trace/<type>_event_types.h file will hold the TRACE_FORMAT
macros.

Then add the trace/<type>.h file to trace/trace_events.h,
and add the trace/<type>_event_types.h to the trace_event_types.h file.

No need to modify files elsewhere.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/trace/trace_event_types.h |    4 ++++
 include/trace/trace_events.h      |    4 ++++
 kernel/trace/events.c             |   10 ++--------
 3 files changed, 10 insertions(+), 8 deletions(-)
 create mode 100644 include/trace/trace_event_types.h
 create mode 100644 include/trace/trace_events.h

diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
new file mode 100644
index 0000000..33c8ed5
--- /dev/null
+++ b/include/trace/trace_event_types.h
@@ -0,0 +1,4 @@
+/* trace/<type>_event_types.h here */
+
+#include <trace/sched_event_types.h>
+#include <trace/irq_event_types.h>
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
new file mode 100644
index 0000000..ea2ef20
--- /dev/null
+++ b/include/trace/trace_events.h
@@ -0,0 +1,4 @@
+/* trace/<type>.h here */
+
+#include <trace/sched.h>
+#include <trace/irq.h>
diff --git a/kernel/trace/events.c b/kernel/trace/events.c
index 3c75623..46e27ad 100644
--- a/kernel/trace/events.c
+++ b/kernel/trace/events.c
@@ -1,15 +1,9 @@
 /*
  * This is the place to register all trace points as events.
- * Include the trace/<type>.h at the top.
- * Include the trace/<type>_event_types.h at the bottom.
  */
 
-/* trace/<type>.h here */
-#include <trace/sched.h>
-#include <trace/irq.h>
+#include <trace/trace_events.h>
 
 #include "trace_events.h"
 
-/* trace/<type>_event_types.h here */
-#include <trace/sched_event_types.h>
-#include <trace/irq_event_types.h>
+#include <trace/trace_event_types.h>
-- 
1.5.6.5

-- 
