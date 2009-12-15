Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZLOHm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZLOHm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757344AbZLOHmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:42:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52606 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZLOHkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:40:11 -0500
Message-ID: <4B273D36.8090100@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 15:39:34 +0800
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

FTRACE_ENTRY(bprint) and FTRACE_ENTRY(print) use this __dynamic_array().

Preparing patch for new way of printing format files which uses
defined fields to print formats. So it requires all fields
are added to struct ftrace_event_call->fields.

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




