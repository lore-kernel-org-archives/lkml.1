Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYKHDt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYKHDt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYKHDrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:47:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYKHDru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:47:50 -0500
Message-Id: <20081108034749.526805788@goodmis.org>
References: <20081108034605.289816911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 22:46:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 05/10] ftrace: enable trace_printk by default
Content-Disposition: inline; filename=0005-ftrace-enable-trace_printk-by-default.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: have the ftrace_printk enabled on startup

It is confusing to have to "echo trace_printk > /debug/tracing/iter_ctrl"
after adding ftrace_printk in the kernel.

Currently the trace_printk is set to off by default. ftrace_printk
should only be in open kernel code when used for debugging, and thus
it should be enabled by default.

It may also be used to record data within a tracer, but those ftrace_printks
should be within wrappers that are either enabled by trace_points or
have a variable protecting the code path from being entered when the
tracer is disabled.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d55ccfc..dbbdacf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -205,7 +205,7 @@ static DEFINE_MUTEX(trace_types_lock);
 static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
 /* trace_flags holds iter_ctrl options */
-unsigned long trace_flags = TRACE_ITER_PRINT_PARENT;
+unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK;
 
 /**
  * trace_wake_up - wake up tasks waiting for trace input
-- 
1.5.6.5

-- 
