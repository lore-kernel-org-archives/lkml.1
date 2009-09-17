Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbZIQHrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbZIQHrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZIQHru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:47:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:48471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759293AbZIQHrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:47:47 -0400
Date: Thu, 17 Sep 2009 07:47:25 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4AADF6E6.3080606@cn.fujitsu.com>
References: <4AADF6E6.3080606@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: remove some unused macros
Message-ID: <tip-20a58a77231c5f5f61470932503b889303e8d4f3@git.kernel.org>
Git-Commit-ID: 20a58a77231c5f5f61470932503b889303e8d4f3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 07:47:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20a58a77231c5f5f61470932503b889303e8d4f3
Gitweb:     http://git.kernel.org/tip/20a58a77231c5f5f61470932503b889303e8d4f3
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 14 Sep 2009 15:55:18 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 14 Sep 2009 11:43:24 -0400

tracing: remove some unused macros

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
