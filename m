Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZGPGR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZGPGR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbZGPGRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:17:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63608 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756499AbZGPGRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:17:23 -0400
Message-ID: <4A5EC5E7.6080307@cn.fujitsu.com>
Date: Thu, 16 Jul 2009 14:17:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/trace_stack: cleanup for trace_lookup_stack()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use %pF input format instead of sprint_symbol()
and %s input format

Thanks for Li Zefan's offline review.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.6.1.2

