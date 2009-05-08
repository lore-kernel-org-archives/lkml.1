Return-Path: <linux-kernel-owner+w=401wt.eu-S1763668AbZEHUjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763668AbZEHUjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757060AbZEHUie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:38:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150AbZEHUi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:38:29 -0400
Message-Id: <20090508203827.895102458@goodmis.org>
References: <20090508203605.361898511@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 16:36:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2] tracing: add trace_set_clr_event to export event enabling function
Content-Disposition: inline; filename=0002-tracing-add-trace_set_clr_event-to-export-event-ena.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Other parts of the kernel may need to be able to enable or disable
specific events. Especially parts that create trace events.

[ Impact: allow enabling of trace events by those that create the event ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    2 ++
 kernel/trace/trace_events.c  |   17 +++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 662c1be..bae51dd 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -127,6 +127,8 @@ extern int trace_define_field(struct ftrace_event_call *call, char *type,
 
 #define is_signed_type(type)	(((type)(-1)) < 0)
 
+int trace_set_clr_event(const char *system, const char *event, int set);
+
 /*
  * The double __builtin_constant_p is because gcc will give us an error
  * if we try to allocate the static variable to fmt if it is not a
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2eecb87..0eec0c5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -177,6 +177,23 @@ static int ftrace_set_clr_event(char *buf, int set)
 	return __ftrace_set_clr_event(match, sub, event, set);
 }
 
+/**
+ * trace_set_clr_event - enable or disable an event
+ * @system: system name to match (NULL for any system)
+ * @event: event name to match (NULL for all events, within system)
+ * @set: 1 to enable, 0 to disable
+ *
+ * This is a way for other parts of the kernel to enable or disable
+ * event recording.
+ *
+ * Returns 0 on success, -EINVAL if the parameters do not match any
+ * registered events.
+ */
+int trace_set_clr_event(const char *system, const char *event, int set)
+{
+	return __ftrace_set_clr_event(NULL, system, event, set);
+}
+
 /* 128 should be much more than enough */
 #define EVENT_BUF_SIZE		127
 
-- 
1.6.2.4

-- 
