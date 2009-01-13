Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbZAMGN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbZAMGN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbZAMGLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:11:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52452 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbZAMGLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:11:49 -0500
Message-Id: <20090113061147.545128781@goodmis.org>
References: <20090113061110.856268617@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 13 Jan 2009 01:11:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       u.kleine-koenig@pengutronix.de, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/9] ftrace, ia64: Add macro for ftrace_caller
Content-Disposition: inline; filename=0003-ftrace-ia64-Add-macro-for-ftrace_caller.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

Define FTRACE_ADDR. In IA64, a function pointer isn't a 'unsigned long' but a
'struct {unsigned long ip, unsigned long gp}'.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    4 ++++
 kernel/trace/ftrace.c  |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 677432b..0547214 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -126,6 +126,10 @@ extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
 extern void ftrace_call(void);
 extern void mcount_call(void);
+
+#ifndef FTRACE_ADDR
+#define FTRACE_ADDR ((unsigned long)ftrace_caller)
+#endif
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern void ftrace_graph_caller(void);
 extern int ftrace_enable_ftrace_graph_caller(void);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 76bb884..9f53610 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -455,7 +455,7 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	unsigned long ip, fl;
 	unsigned long ftrace_addr;
 
-	ftrace_addr = (unsigned long)ftrace_caller;
+	ftrace_addr = (unsigned long)FTRACE_ADDR;
 
 	ip = rec->ip;
 
-- 
1.5.6.5

-- 
