Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZJIFsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZJIFsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZJIFsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:48:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754773AbZJIFs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:48:29 -0400
Subject: [PATCH][GIT PULL][for 2.6.32] tracing: fix trace_vprintk call
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 09 Oct 2009 01:47:21 -0400
Message-Id: <1255067241.1696.1196.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (1):
      tracing: fix trace_vprintk call

----
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit a813a159766ee9d36aa1fc717c60d63325a6d077
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Oct 9 01:41:35 2009 -0400

    tracing: fix trace_vprintk call
    
    The addition of trace_array_{v}printk used the wrong function for
    trace_vprintk to call. This broke trace_marker and trace_vprintk
    itself. Although trace_printk may not have been affected by those
    that end up calling trace_vbprintk.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4506826..c820b03 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1393,7 +1393,7 @@ int trace_array_vprintk(struct trace_array *tr,
 
 int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 {
-	return trace_array_printk(&global_trace, ip, fmt, args);
+	return trace_array_vprintk(&global_trace, ip, fmt, args);
 }
 EXPORT_SYMBOL_GPL(trace_vprintk);
 


