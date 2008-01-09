Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbYAIXbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbYAIXbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYAIXau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:30:50 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:57453 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbYAIXar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:47 -0500
Message-Id: <20080109233042.545048697@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 02/22 -v2] Annotate core code that should not be traced
Content-Disposition: inline; filename=mcount-annotate-generic-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark with "notrace" functions in core code that should not be
traced.  The "notrace" attribute will prevent gcc from adding
a call to mcount on the annotated funtions.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 lib/smp_processor_id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-compile-i386.git/lib/smp_processor_id.c
===================================================================
--- linux-compile-i386.git.orig/lib/smp_processor_id.c	2008-01-09 14:09:36.000000000 -0500
+++ linux-compile-i386.git/lib/smp_processor_id.c	2008-01-09 14:10:11.000000000 -0500
@@ -7,7 +7,7 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-unsigned int debug_smp_processor_id(void)
+notrace unsigned int debug_smp_processor_id(void)
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();

-- 
