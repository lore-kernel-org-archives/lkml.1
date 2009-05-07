Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbZEGDQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbZEGDQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 23:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbZEGDOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 23:14:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37859 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbZEGDOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 23:14:34 -0400
Message-Id: <20090507031434.406435870@goodmis.org>
References: <20090507031335.815354104@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 23:13:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/7] tracing: update sample with TRACE_INCLUDE_FILE
Content-Disposition: inline; filename=0005-tracing-update-sample-with-TRACE_INCLUDE_FILE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When creating trace events for ftrace, the header file with the TRACE_EVENT
macros must also have a macro called TRACE_SYSTEM. This macro describes
the name of the system the TRACE_EVENTS are defined for. It also doubles
as a way for the define_trace.h file to include the file that included
it.

For example:

in irq.h

 #define TRACE_SYSTEM irq

[...]

 #include <trace/define_trace.h>

The define_trace will use TRACE_SYSTEM to include irq.h. But if the name
of the trace system does not match the name of the trace header file,
one can override it with:

Which will change define_trace.h to inclued foo_trace.h instead of foo.h

The sample comments this, but people that use the sample code will more
likely use the code and not read the comments. This patch changes the
sample code to use the TRACE_INCLUDE_FILE to better show developers how to
use it.

[ Impact: make sample less confusing to developers ]

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 samples/trace_events/trace-events-sample.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index eab4644..128a897 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -31,7 +31,7 @@
  *
  */
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM trace-events-sample
+#define TRACE_SYSTEM sample
 
 /*
  * The TRACE_EVENT macro is broken up into 5 parts.
@@ -120,5 +120,10 @@ TRACE_EVENT(foo_bar,
  * result.
  */
 #undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
 #define TRACE_INCLUDE_PATH .
+/*
+ * TRACE_INCLUDE_FILE is not needed if the filename and TRACE_SYSTEM are equal
+ */
+#define TRACE_INCLUDE_FILE trace-events-sample
 #include <trace/define_trace.h>
-- 
1.6.2.4

-- 
