Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbZCMFJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbZCMFJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbZCMFF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:05:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64862 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbZCMFFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:05:24 -0400
Message-Id: <20090313050521.300766632@goodmis.org>
References: <20090313050446.277065036@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 01:04:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/4] tracing: add comment for use of double __builtin_consant_p
Content-Disposition: inline; filename=0002-tracing-add-comment-for-use-of-double-__builtin_con.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: documentation

The use of the double __builtin_contant_p checks in the event_trace_printk
can be confusing to developers and reviewers. This patch adds a comment
to explain why it is there.

Requested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
LKML-Reference: <20090313122235.43EB.A69D9226@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 35cfa7b..67595b8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -776,6 +776,11 @@ extern struct ftrace_event_call __stop_ftrace_events[];
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
+/*
+ * The double __builtin_constant_p is because gcc will give us an error
+ * if we try to allocate the static variable to fmt if it is not a
+ * constant. Even with the outer if statement optimizing out.
+ */
 #define event_trace_printk(ip, fmt, args...)				\
 do {									\
 	__trace_printk_check_format(fmt, ##args);			\
-- 
1.6.1.3

-- 
