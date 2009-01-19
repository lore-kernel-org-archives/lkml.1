Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbZASJds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbZASJds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZASJdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:33:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:47452 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbZASJdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:33:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,288,1231142400"; 
   d="scan'208";a="379581484"
Date: Mon, 19 Jan 2009 10:33:31 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       srostedt@redhat.com
Subject: [patch 4/6] x86, ftrace, hw-branch-tracer: reset trace buffer on close
Message-ID: <20090119103331.A18837@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset the ftrace buffer on close. Since we use cyclic buffers, the
trace is not contiguous, anyway.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/kernel/trace/trace_hw_branches.c
===================================================================
--- ftrace.orig/kernel/trace/trace_hw_branches.c	2009-01-16 16:20:04.000000000 +0100
+++ ftrace/kernel/trace/trace_hw_branches.c	2009-01-19 09:18:54.000000000 +0100
@@ -270,6 +270,11 @@ static void trace_bts_prepare(struct tra
 	mutex_unlock(&bts_tracer_mutex);
 }
 
+static void trace_bts_close(struct trace_iterator *iter)
+{
+	tracing_reset_online_cpus(iter->tr);
+}
+
 void trace_hw_branch_oops(void)
 {
 	mutex_lock(&bts_tracer_mutex);
@@ -288,7 +293,8 @@ struct tracer bts_tracer __read_mostly =
 	.print_line	= bts_trace_print_line,
 	.start		= bts_trace_start,
 	.stop		= bts_trace_stop,
-	.open		= trace_bts_prepare
+	.open		= trace_bts_prepare,
+	.close		= trace_bts_close
 };
 
 __init static int init_bts_trace(void)
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

