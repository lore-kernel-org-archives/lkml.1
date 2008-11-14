Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbYKNXFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbYKNXFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYKNXA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:58 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:57280 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130AbYKNXA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:57 -0500
Message-Id: <20081114224948.456568009@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 08/16] Tracepoints : Samples fix teardown
Content-Disposition: inline; filename=tracepoints-samples-fix-teardown.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need a tracepoint_synchronize_unregister() before the end of exit() to make sure
every probe callers have exited the non preemptible section and thus are not
executing the probe code anymore.

Impact: bugfix.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 samples/tracepoints/tracepoint-probe-sample.c  |    1 +
 samples/tracepoints/tracepoint-probe-sample2.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6-lttng/samples/tracepoints/tracepoint-probe-sample.c
===================================================================
--- linux-2.6-lttng.orig/samples/tracepoints/tracepoint-probe-sample.c	2008-07-31 09:26:51.000000000 -0400
+++ linux-2.6-lttng/samples/tracepoints/tracepoint-probe-sample.c	2008-07-31 09:26:52.000000000 -0400
@@ -46,6 +46,7 @@ void __exit tp_sample_trace_exit(void)
 {
 	unregister_trace_subsys_eventb(probe_subsys_eventb);
 	unregister_trace_subsys_event(probe_subsys_event);
+	tracepoint_synchronize_unregister();
 }
 
 module_exit(tp_sample_trace_exit);
Index: linux-2.6-lttng/samples/tracepoints/tracepoint-probe-sample2.c
===================================================================
--- linux-2.6-lttng.orig/samples/tracepoints/tracepoint-probe-sample2.c	2008-07-31 09:26:51.000000000 -0400
+++ linux-2.6-lttng/samples/tracepoints/tracepoint-probe-sample2.c	2008-07-31 09:26:52.000000000 -0400
@@ -33,6 +33,7 @@ module_init(tp_sample_trace_init);
 void __exit tp_sample_trace_exit(void)
 {
 	unregister_trace_subsys_event(probe_subsys_event);
+	tracepoint_synchronize_unregister();
 }
 
 module_exit(tp_sample_trace_exit);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
