Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZC0Gza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZC0Gza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 02:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZC0GzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 02:55:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49431 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbZC0GzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 02:55:20 -0400
Message-ID: <49CC7870.9000309@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 14:55:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: kill some magic numbers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Use USEC_PER_SEC and NSEC_PER_SEC instead of 1000000 and 1000000000.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.5.4.rc3
