Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbZDCK3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbZDCK3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759357AbZDCK31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:29:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59274 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762158AbZDCK30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:29:26 -0400
Message-ID: <49D5E44B.3080104@cn.fujitsu.com>
Date: Fri, 03 Apr 2009 18:26:19 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Steven Rostedt ;" <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ftrace: Code cleanup for kernel/trace/trace_events_stage_*.h
References: <49D5E3EE.70201@cn.fujitsu.com>
In-Reply-To: <49D5E3EE.70201@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TRACE_FORMAT's define for trace_events_stage_2.h.
Although it is already defined in trace_events_stage_1.h, we should make each
function independence.

Move TP_fast_assign's define from trace_events_stage_2.h to
trace_events_stage_3.h because it is used there.

Unify TRACE_EVENT's 5th argument's name to "assign"

Impact: cleanup, no functionality changed

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_events_stage_2.h |    8 ++++----
 kernel/trace/trace_events_stage_3.h |    3 +++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index 30743f7..9e47c39 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -32,6 +32,9 @@
  * in binary.
  */
 
+#undef TRACE_FORMAT
+#define TRACE_FORMAT(call, proto, args, fmt)
+
 #undef __entry
 #define __entry field
 
@@ -110,11 +113,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #undef TP_printk
 #define TP_printk(fmt, args...) "%s, %s\n", #fmt, #args
 
-#undef TP_fast_assign
-#define TP_fast_assign(args...) args
-
 #undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
 static int								\
 ftrace_format_##call(struct trace_seq *s)				\
 {									\
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 9d2fa78..49b305a 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -193,6 +193,9 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	_TRACE_PROFILE_INIT(call)					\
 }
 
+#undef TP_fast_assign
+#define TP_fast_assign(args...) args
+
 #undef __entry
 #define __entry entry
 
-- 
1.5.5.3


