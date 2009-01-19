Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZASJ3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZASJ3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbZASJ3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:29:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:41818 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095AbZASJ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:29:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,288,1231142400"; 
   d="scan'208";a="423536672"
Date: Mon, 19 Jan 2009 10:29:16 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       srostedt@redhat.com
Subject: [patch 2/6] x86, ftrace, hw-branch-tracer: change trace format
Message-ID: <20090119102916.A18795@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the hw-branch-tracer format.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/kernel/trace/trace_hw_branches.c
===================================================================
--- ftrace.orig/kernel/trace/trace_hw_branches.c	2009-01-14 15:25:42.000000000 +0100
+++ ftrace/kernel/trace/trace_hw_branches.c	2009-01-14 15:26:07.000000000 +0100
@@ -142,10 +142,7 @@
 
 static void bts_trace_print_header(struct seq_file *m)
 {
-	seq_puts(m,
-		 "# CPU#        FROM                   TO         FUNCTION\n");
-	seq_puts(m,
-		 "#  |           |                     |             |\n");
+	seq_puts(m, "# CPU#        TO  <-  FROM\n");
 }
 
 static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
@@ -153,15 +150,15 @@
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
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

