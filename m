Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYKASx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYKASx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 14:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYKASxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 14:53:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:47967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYKASxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 14:53:48 -0400
Subject: [PATCH] ftrace: sysrq-z to dump the buffers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 01 Nov 2008 19:53:34 +0100
Message-Id: <1225565614.21456.48.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows one to force an ftrace dump from sysrq

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index ce0d9da..e20d6db 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -274,6 +274,22 @@ static struct sysrq_key_op sysrq_showstate_blocked_op = {
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
 
+#ifdef CONFIG_FTRACE
+#include <linux/ftrace.h>
+
+static void sysrq_ftrace_dump(int key, struct tty_struct *tty)
+{
+	ftrace_dump();
+}
+static struct sysrq_key_op sysrq_ftrace_dump_op = {
+	.handler	= sysrq_ftrace_dump,
+	.help_msg	= "dumpZ-ftrace-buffer",
+	.action_msg	= "Dump ftrace buffer",
+	.enable_mask	= SYSRQ_ENABLE_DUMP,
+};
+#else
+#define sysrq_ftrace_dump_op (*(struct sysrq_key_op *)0)
+#endif
 
 static void sysrq_handle_showmem(int key, struct tty_struct *tty)
 {
@@ -406,7 +422,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
 	NULL,				/* x */
 	/* y: May be registered on sparc64 for global register dump */
 	NULL,				/* y */
-	NULL				/* z */
+	&sysrq_ftrace_dump_op,		/* z */
 };
 
 /* key2index calculation, -1 on invalid index */


