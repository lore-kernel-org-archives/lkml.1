Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYJFXMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYJFXMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYJFXLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:11:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36979 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYJFXLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:11:50 -0400
Message-Id: <20081006231149.000824346@goodmis.org>
References: <20081006230610.024517480@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Oct 2008 19:06:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ftrace: fix depends
Content-Disposition: inline; filename=ftrace-fix-depends.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of tracers have HAVE_FTRACE as a dependent config where it
really should not. The HAVE_FTRACE is a misnomer (soon to be fixed)
and describes if the architecture has the function tracer (mcount)
implemented. The ftrace infrastructure is implemented in all archs.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/Kconfig |    5 -----
 1 file changed, 5 deletions(-)

Index: linux-tip.git/kernel/trace/Kconfig
===================================================================
--- linux-tip.git.orig/kernel/trace/Kconfig	2008-10-06 18:34:13.000000000 -0400
+++ linux-tip.git/kernel/trace/Kconfig	2008-10-06 18:34:26.000000000 -0400
@@ -49,7 +49,6 @@ config IRQSOFF_TRACER
 	default n
 	depends on TRACE_IRQFLAGS_SUPPORT
 	depends on GENERIC_TIME
-	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACE_IRQFLAGS
 	select TRACING
@@ -73,7 +72,6 @@ config PREEMPT_TRACER
 	default n
 	depends on GENERIC_TIME
 	depends on PREEMPT
-	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACING
 	select TRACER_MAX_TRACE
@@ -101,7 +99,6 @@ config SYSPROF_TRACER
 
 config SCHED_TRACER
 	bool "Scheduling Latency Tracer"
-	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACING
 	select CONTEXT_SWITCH_TRACER
@@ -112,7 +109,6 @@ config SCHED_TRACER
 
 config CONTEXT_SWITCH_TRACER
 	bool "Trace process context switches"
-	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACING
 	select MARKERS
@@ -122,7 +118,6 @@ config CONTEXT_SWITCH_TRACER
 
 config BOOT_TRACER
 	bool "Trace boot initcalls"
-	depends on HAVE_FTRACE
 	depends on DEBUG_KERNEL
 	select TRACING
 	help

-- 
