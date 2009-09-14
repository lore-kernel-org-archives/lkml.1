Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZINQen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZINQen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZINQeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:34:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36423 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbZINQed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:34:33 -0400
Message-Id: <20090914163435.952042625@goodmis.org>
References: <20090914163355.162375454@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 14 Sep 2009 12:33:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: [PATCH 1/6] tracing: add static to generated TRACE_EVENT functions
Content-Disposition: inline; filename=0001-tracing-add-static-to-generated-TRACE_EVENT-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Some of the generated functions used in the TRACE_EVENT macros are
not declared static, but they are not global.

Discovered by sparse.

Reported-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h      |    4 ++--
 kernel/trace/trace_events.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 308bafd..fa8ce03 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -254,7 +254,7 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-enum print_line_t							\
+static enum print_line_t						\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 {									\
 	struct trace_seq *s = &iter->seq;				\
@@ -317,7 +317,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
-int									\
+static int								\
 ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
 	struct ftrace_raw_##call field;					\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index adbed12..0fa8f9f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1154,7 +1154,7 @@ static int trace_module_notify(struct notifier_block *self,
 }
 #endif /* CONFIG_MODULES */
 
-struct notifier_block trace_module_nb = {
+static struct notifier_block trace_module_nb = {
 	.notifier_call = trace_module_notify,
 	.priority = 0,
 };
-- 
1.6.3.3

-- 
