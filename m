Return-Path: <linux-kernel-owner+w=401wt.eu-S965018AbZLIHRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018AbZLIHRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbZLIHQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:16:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56139 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbZLIHQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:16:09 -0500
Message-ID: <4B1F4E92.1090608@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 15:15:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/10] tracing: __dynamic_array() also defines fields
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dynamic array is also added to struct ftrace_event_call->fields.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 458e5bf..511bc36 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -174,7 +174,12 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
 		return ret;
 
 #undef __dynamic_array
-#define __dynamic_array(type, item)
+#define __dynamic_array(type, item)					\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 0, is_signed_type(type), FILTER_OTHER);\
+	if (ret)							\
+		return ret;
 
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\


