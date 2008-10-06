Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYJFOdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYJFOdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 10:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYJFOdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 10:33:04 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:32943 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbYJFOdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:33:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEAFO56UhMQWq+/2dsb2JhbACBcblegWo
Date: Mon, 6 Oct 2008 10:33:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Tracepoints synchronize unregister static inline
Message-ID: <20081006143300.GB1366@Krystal>
References: <20081003190133.GA12685@Krystal> <20081004124538.GF3728@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081004124538.GF3728@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:29:16 up 123 days, 19:09,  8 users,  load average: 0.14, 0.28,
	0.31
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Ingo, could you pull the following patch into -tip ?
> 
> sure - but it does not apply to tip/master. Some missing dependencies?
> 
> 	Ingo

Hi Ingo,

"Tracepoints synchronize unregister static inline"
applies on top of
"Tracepoints : tracepoint_synchronize_unregister()"

I posted earlier but does not seem to be in tip/master. Here is a repost
:

Tracepoints : tracepoint_synchronize_unregister()

Create tracepoint_synchronize_unregister() which must be called before the end
of exit() to make sure every probe callers have exited the non preemptible
section and thus are not executing the probe code anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/tracepoint.h	2008-07-31 09:21:40.000000000 -0400
+++ linux-2.6-lttng/include/linux/tracepoint.h	2008-07-31 09:22:27.000000000 -0400
@@ -124,4 +124,11 @@ extern void tracepoint_iter_reset(struct
 extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
 	struct tracepoint *begin, struct tracepoint *end);
 
+/*
+ * tracepoint_synchronize_unregister must be called between the last tracepoint
+ * probe unregistration and the end of module exit to make sure there is no
+ * caller executing a probe when it is freed.
+ */
+#define tracepoint_synchronize_unregister() synchronize_sched()
+
 #endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
