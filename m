Return-Path: <linux-kernel-owner+w=401wt.eu-S1764104AbZATAY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764104AbZATAY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764822AbZATARo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:17:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764785AbZATARe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:17:34 -0500
Message-Id: <20090120001732.994680098@goodmis.org>
References: <20090120001542.687427797@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 19 Jan 2009 19:15:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Markus Metzger <markus.t.metzger@intel.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/8] x86, ftrace, hw-branch-tracer: change trace format
Content-Disposition: inline; filename=0004-x86-ftrace-hw-branch-tracer-change-trace-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Metzger <markus.t.metzger@intel.com>

Change the hw-branch-tracer format.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_hw_branches.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 372b47a..fff3545 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -146,10 +146,7 @@ static void bts_trace_reset(struct trace_array *tr)
 
 static void bts_trace_print_header(struct seq_file *m)
 {
-	seq_puts(m,
-		 "# CPU#        FROM                   TO         FUNCTION\n");
-	seq_puts(m,
-		 "#  |           |                     |             |\n");
+	seq_puts(m, "# CPU#        TO  <-  FROM\n");
 }
 
 static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
@@ -157,15 +154,15 @@ static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *seq = &iter->seq;
 	struct hw_branch_entry *it;
+	unsigned long symflags = TRACE_ITER_SYM_OFFSET;
 
 	trace_assign_type(it, entry);
 
 	if (entry->type == TRACE_HW_BRANCHES) {
 		if (trace_seq_printf(seq, "%4d  ", entry->cpu) &&
-		    trace_seq_printf(seq, "0x%016llx -> 0x%016llx ",
-				     it->from, it->to) &&
-		    (!it->from ||
-		     seq_print_ip_sym(seq, it->from, /* sym_flags = */ 0)) &&
+		    seq_print_ip_sym(seq, it->to, symflags) &&
+		    trace_seq_printf(seq, "\t  <-  ") &&
+		    seq_print_ip_sym(seq, it->from, symflags) &&
 		    trace_seq_printf(seq, "\n"))
 			return TRACE_TYPE_HANDLED;
 		return TRACE_TYPE_PARTIAL_LINE;;
-- 
1.5.6.5

-- 
