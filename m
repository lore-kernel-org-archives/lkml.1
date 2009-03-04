Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZCDXlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZCDXlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZCDXlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:41:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45837 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZCDXlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:41:12 -0500
Date: Wed, 4 Mar 2009 18:41:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: [PATCH][GIT PULL] for tip/tracing/ftrace
Message-ID: <alpine.DEB.2.00.0903041835560.19317@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      tracing: add cpu_file intialization for ftrace_dump

----
 kernel/trace/trace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
---------------------------
commit e543ad76914abec1acf6631604a4154cd7a2ca6b
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Mar 4 18:20:36 2009 -0500

    tracing: add cpu_file intialization for ftrace_dump
    
    Impact: fix to ftrace_dump output corruption
    
    The commit: b04cc6b1f6398b0e0b60d37e27ce51b4899672ec
      tracing/core: introduce per cpu tracing files
    
    added a new field to the iterator called cpu_file. This was a handle
    to differentiate between the per cpu trace output files and the
    all cpu "trace" file. The all cpu "trace" file required setting this
    to TRACE_PIPE_ALL_CPU.
    
    The problem is that the ftrace_dump sets up its own iterator but was
    not updated to handle this change. The result was only CPU 0 printing
    out on crash and a lot of "<0>"'s also being printed.
    
    Reported-by: Thomas Gleixner <tglx@linuxtronix.de>
    Tested-by: Darren Hart <dvhtc@us.ibm.com>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c8abbb0..ab5cbca 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3918,8 +3918,10 @@ void ftrace_dump(void)
 
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
+	/* Simulate the iterator */
 	iter.tr = &global_trace;
 	iter.trace = current_trace;
+	iter.cpu_file = TRACE_PIPE_ALL_CPU;
 
 	/*
 	 * We need to stop all tracing on all CPUS to read the

