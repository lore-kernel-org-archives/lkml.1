Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbZGRHRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbZGRHRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 03:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932589AbZGRHRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 03:17:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:50569 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbZGRHRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 03:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Yj+i3xInGYR6gyUjgprHXddyL+TkkgcqSAj17w0xSjGsNdthcBUtoe7Ya88bDmtxA/
         Kk0G9gUQvFsTP8JxALcpzkzhgv4On5kryW1kVv/7mU7pZXkuVRFyNeytWdOAsqjJoA25
         dym52Fr48UvzlEyUOmYLsMUQBQeWPzHMJXn3E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/4] tracing/trace_stack: Cleanup for trace_lookup_stack()
Date: Sat, 18 Jul 2009 03:17:00 -0400
Message-Id: <1247901421-6389-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
References: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

We can directly use %pF input format instead of sprint_symbol()
and %s input format.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_stack.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index e644af9..a4dc8d9 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -234,15 +234,8 @@ static void t_stop(struct seq_file *m, void *p)
 static int trace_lookup_stack(struct seq_file *m, long i)
 {
 	unsigned long addr = stack_dump_trace[i];
-#ifdef CONFIG_KALLSYMS
-	char str[KSYM_SYMBOL_LEN];
 
-	sprint_symbol(str, addr);
-
-	return seq_printf(m, "%s\n", str);
-#else
-	return seq_printf(m, "%p\n", (void*)addr);
-#endif
+	return seq_printf(m, "%pF\n", (void *)addr);
 }
 
 static void print_disabled(struct seq_file *m)
-- 
1.6.2.3

