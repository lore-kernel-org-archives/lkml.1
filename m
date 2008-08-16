Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYHPBrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYHPBrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 21:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYHPBqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 21:46:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55160 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYHPBqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 21:46:49 -0400
Message-Id: <20080816014647.236269927@goodmis.org>
References: <20080816014003.978160137@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 15 Aug 2008 21:40:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ftrace: do not init module on ftrace disabled
Content-Disposition: inline; filename=ftrace-failures.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one of the self tests of ftrace has disabled the function tracer,
do not run the code to convert the mcount calls in modules.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-08-15 11:22:19.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-08-15 12:56:37.000000000 -0400
@@ -307,7 +307,7 @@ void ftrace_release(void *start, unsigne
 	unsigned long e = s + size;
 	int i;
 
-	if (!start)
+	if (ftrace_disabled || !start)
 		return;
 
 	/* No interrupt should call this */
@@ -1574,7 +1574,7 @@ static int ftrace_convert_nops(unsigned 
 
 void ftrace_init_module(unsigned long *start, unsigned long *end)
 {
-	if (start == end)
+	if (ftrace_disabled || start == end)
 		return;
 	ftrace_convert_nops(start, end);
 }

-- 
