Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbYAUPZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbYAUPZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 10:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758336AbYAUPYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 10:24:07 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:62563 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYAUPX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 10:23:59 -0500
Message-Id: <20080121152351.202275460@goodmis.org>
References: <20080121152231.579118762@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 10:22:33 -0500
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
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 02/23 -v4] Annotate core code that should not be traced
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

Index: linux-mcount.git/lib/smp_processor_id.c
===================================================================
--- linux-mcount.git.orig/lib/smp_processor_id.c	2008-01-17 20:33:16.000000000 -0500
+++ linux-mcount.git/lib/smp_processor_id.c	2008-01-17 20:33:31.000000000 -0500
@@ -7,7 +7,7 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-unsigned int debug_smp_processor_id(void)
+notrace unsigned int debug_smp_processor_id(void)
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();

-- 
