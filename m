Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZDFQmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZDFQmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbZDFQja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:39:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbZDFQj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:39:29 -0400
Message-Id: <20090406163830.104444218@goodmis.org>
References: <20090406163706.097842409@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 12:37:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/10] tracing: use macros to denote usec and nsec per second
Content-Disposition: inline; filename=0002-tracing-use-macros-to-denote-usec-and-nsec-per-seco.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Impact: cleanup

Use USEC_PER_SEC and NSEC_PER_SEC instead of 1000000 and 1000000000.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <49CC7870.9000309@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_boot.c      |    5 +++--
 kernel/trace/trace_mmiotrace.c |    6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 7a30fc4..a29ef23 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -9,6 +9,7 @@
 #include <linux/debugfs.h>
 #include <linux/ftrace.h>
 #include <linux/kallsyms.h>
+#include <linux/time.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -67,7 +68,7 @@ initcall_call_print_line(struct trace_iterator *iter)
 	trace_assign_type(field, entry);
 	call = &field->boot_call;
 	ts = iter->ts;
-	nsec_rem = do_div(ts, 1000000000);
+	nsec_rem = do_div(ts, NSEC_PER_SEC);
 
 	ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
 			(unsigned long)ts, nsec_rem, call->func, call->caller);
@@ -92,7 +93,7 @@ initcall_ret_print_line(struct trace_iterator *iter)
 	trace_assign_type(field, entry);
 	init_ret = &field->boot_ret;
 	ts = iter->ts;
-	nsec_rem = do_div(ts, 1000000000);
+	nsec_rem = do_div(ts, NSEC_PER_SEC);
 
 	ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
 			"returned %d after %llu msecs\n",
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 8e37fcd..d53b45e 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -9,6 +9,8 @@
 #include <linux/kernel.h>
 #include <linux/mmiotrace.h>
 #include <linux/pci.h>
+#include <linux/time.h>
+
 #include <asm/atomic.h>
 
 #include "trace.h"
@@ -174,7 +176,7 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 	struct mmiotrace_rw *rw;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
-	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
 
@@ -221,7 +223,7 @@ static enum print_line_t mmio_print_map(struct trace_iterator *iter)
 	struct mmiotrace_map *m;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
-	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
 	int ret;
 
-- 
1.6.2.1

-- 
