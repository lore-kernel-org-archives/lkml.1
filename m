Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbYICVsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbYICVsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYICVr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:47:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49025 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYICVr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:47:56 -0400
Message-Id: <20080903214754.130440561@goodmis.org>
References: <20080903214249.661170580@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 17:42:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ftrace: binary and not logical for continue test
Content-Disposition: inline; filename=ftrace-printk-and-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra provided me with a nice brown paper bag while letting me know
that I was doing a logical AND and not a binary one, making a condition
true more often than it should be.

Luckily, a false true is handled by the calling function and no harm is
done. But this needs to be fixed regardless.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-09-03 16:46:28.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-09-03 16:46:30.000000000 -0400
@@ -1655,7 +1655,7 @@ print_lat_fmt(struct trace_iterator *ite
 	case TRACE_PRINT:
 		seq_print_ip_sym(s, field->print.ip, sym_flags);
 		trace_seq_printf(s, ": %s", field->print.buf);
-		if (field->flags && TRACE_FLAG_CONT)
+		if (field->flags & TRACE_FLAG_CONT)
 			trace_seq_print_cont(s, iter);
 		break;
 	default:
@@ -1768,7 +1768,7 @@ static int print_trace_fmt(struct trace_
 	case TRACE_PRINT:
 		seq_print_ip_sym(s, field->print.ip, sym_flags);
 		trace_seq_printf(s, ": %s", field->print.buf);
-		if (field->flags && TRACE_FLAG_CONT)
+		if (field->flags & TRACE_FLAG_CONT)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
@@ -1833,7 +1833,7 @@ static int print_raw_fmt(struct trace_it
 	case TRACE_PRINT:
 		trace_seq_printf(s, "# %lx %s",
 				 field->print.ip, field->print.buf);
-		if (field->flags && TRACE_FLAG_CONT)
+		if (field->flags & TRACE_FLAG_CONT)
 			trace_seq_print_cont(s, iter);
 		break;
 	}

-- 
