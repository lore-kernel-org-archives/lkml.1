Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZINQe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZINQe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZINQep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:34:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53309 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbZINQef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:34:35 -0400
Message-Id: <20090914163437.337633992@goodmis.org>
References: <20090914163355.162375454@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 14 Sep 2009 12:34:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/6] tracing: remove some unused macros
Content-Disposition: inline; filename=0005-tracing-remove-some-unused-macros.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

- remove FTRACE_ENTRY_STRUCT_ONLY()
- remove TRACE_XXX() macros

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AADF6E6.3080606@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_entries.h |    9 ---------
 kernel/trace/trace_export.c  |   26 --------------------------
 2 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 0c10095..a431748 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -116,15 +116,6 @@ FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
 	__field(	unsigned char,	next_state	)	\
 	__field(	unsigned int,	next_cpu	)
 
-#if 0
-FTRACE_ENTRY_STRUCT_ONLY(ctx_switch_entry,
-
-	F_STRUCT(
-		FTRACE_CTX_FIELDS
-	)
-);
-#endif
-
 FTRACE_ENTRY(context_switch, ctx_switch_entry,
 
 	TRACE_CTX,
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 2435d55..9753fcc 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -209,32 +209,6 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 #undef __dynamic_array
 #define __dynamic_array(type, item)
 
-
-#undef TRACE_ZERO_CHAR
-#define TRACE_ZERO_CHAR(arg)
-
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)\
-	entry->item = assign;
-
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)\
-	entry->item = assign;
-
-#undef TRACE_FIELD_SIGN
-#define TRACE_FIELD_SIGN(type, item, assign, is_signed)	\
-	TRACE_FIELD(type, item, assign)
-
-#undef TP_CMD
-#define TP_CMD(cmd...)	cmd
-
-#undef TRACE_ENTRY
-#define TRACE_ENTRY	entry
-
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)	\
-	cmd;
-
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, type, tstruct, print)		\
 static int ftrace_raw_init_event_##call(void);				\
-- 
1.6.3.3

-- 
