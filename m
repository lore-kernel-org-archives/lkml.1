Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZDHGz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZDHGz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZDHGzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:55:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:35328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbZDHGzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:55:16 -0400
Date: Wed, 8 Apr 2009 06:54:39 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <49CC7870.9000309@cn.fujitsu.com>
References: <49CC7870.9000309@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing: use macros to denote usec and nsec per second
Message-ID: <tip-a5dec5573f3c7e63f2f9b5852b9759ea342a5ff9@git.kernel.org>
Git-Commit-ID: a5dec5573f3c7e63f2f9b5852b9759ea342a5ff9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 06:54:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5dec5573f3c7e63f2f9b5852b9759ea342a5ff9
Gitweb:     http://git.kernel.org/tip/a5dec5573f3c7e63f2f9b5852b9759ea342a5ff9
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 27 Mar 2009 14:55:44 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 14:43:06 +0200

tracing: use macros to denote usec and nsec per second

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
 
