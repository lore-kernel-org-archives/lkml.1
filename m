Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZLZWOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZLZWOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 17:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZLZWOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 17:14:08 -0500
Received: from toro.web-alm.net ([62.245.132.31]:35238 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZLZWOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 17:14:07 -0500
Message-Id: <20091226214229.782692524@osadl.org>
User-Agent: quilt/0.47-1
Date: Sat, 26 Dec 2009 22:41:16 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-users <linux-rt-users@vger.kernel.org>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 2/2] add-trace_clock-to-ftrace-docs.patch
References: <20091226214114.843059850@osadl.org>
Content-Disposition: inline; filename=add-trace_clock-to-ftrace-docs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an explanation of the trace variable
trace_clock to the ftrace documentation.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

Index: linux-2.6.33-rc2/Documentation/trace/ftrace.txt
===================================================================
--- linux-2.6.33-rc2.orig/Documentation/trace/ftrace.txt
+++ linux-2.6.33-rc2/Documentation/trace/ftrace.txt
@@ -91,6 +91,33 @@ of ftrace. Here is a list of some of the
 	This file holds the output of the trace in a human
 	readable format (described below).
 
+  trace_clock:
+
+	Three different clocks are available for the tracer
+	timestamps, "local", "medium" and "global". For the
+	time being, however, the "medium" clock is disabled
+	in the source code and requires the line
+		{ trace_clock,		"medium" },
+	to be inserted in kernel/trace/trace.c between
+		{ trace_clock_local,	"local" },
+	and
+		{ trace_clock_global,	"global" },
+	- The "local" clock is the simplest and least coherent
+	tracing clock. It is useful for tracing that does not
+	cross to other CPUs nor does it go through idle events.
+	- The "medium" clock is a scalable global clock with
+	some jitter. It is not completely serialized, but not
+	completely incorrect when crossing CPUs either.
+	- The "global" clock is a globally monotonic, serialized
+	clock. It has a higher overhead than the "local" and the
+	"medium" trace clock but is still an order of magnitude
+	faster than a hardware clock based on the gettimeofday()
+	function would be.
+
+	The content of trace_clock displays the available tracer
+	clocks, the name of the currently selected clock is
+	surrounded by square brackets.
+
   trace_pipe:
 
 	The output is the same as the "trace" file but this

