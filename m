Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbYKNXFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbYKNXFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbYKNXA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:57 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:57272 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYKNXA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:56 -0500
Message-Id: <20081114224949.592960129@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 15/16] Tracepoints : documentation fix teardown
Content-Disposition: inline; filename=tracepoints-documentation-fix-teardown.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need a tracepoint_synchronize_unregister() before the end of exit() to make sure
every probe callers have exited the non preemptible section and thus are not
executing the probe code anymore.

Impact: documentation update.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/tracepoints.txt |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/Documentation/tracepoints.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/tracepoints.txt	2008-11-14 17:18:59.000000000 -0500
+++ linux-2.6-lttng/Documentation/tracepoints.txt	2008-11-14 17:19:05.000000000 -0500
@@ -70,10 +70,12 @@ Where :
 Connecting a function (probe) to a tracepoint is done by providing a probe
 (function to call) for the specific tracepoint through
 register_trace_subsys_eventname().  Removing a probe is done through
-unregister_trace_subsys_eventname(); it will remove the probe sure there is no
-caller left using the probe when it returns. Probe removal is preempt-safe
-because preemption is disabled around the probe call. See the "Probe example"
-section below for a sample probe module.
+unregister_trace_subsys_eventname(); it will remove the probe.
+marker_synchronize_unregister() must be called before the end of the module exit
+function to make sure there is no caller left using the probe. This, and the
+fact that preemption is disabled around the probe call, make sure that probe
+removal and module unload are safe. See the "Probe example" section below for a
+sample probe module.
 
 The tracepoint mechanism supports inserting multiple instances of the same
 tracepoint, but a single definition must be made of a given tracepoint name over

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
