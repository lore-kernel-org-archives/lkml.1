Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYAOUzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYAOUzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757406AbYAOUut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:49 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:51778 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYAOUuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:35 -0500
Message-Id: <20080115205021.610690490@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:09 -0500
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
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 02/30 v3] Annotate core code that should not be traced
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

Index: linux-compile.git/lib/smp_processor_id.c
===================================================================
--- linux-compile.git.orig/lib/smp_processor_id.c	2008-01-14 13:14:03.000000000 -0500
+++ linux-compile.git/lib/smp_processor_id.c	2008-01-14 13:14:13.000000000 -0500
@@ -7,7 +7,7 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-unsigned int debug_smp_processor_id(void)
+notrace unsigned int debug_smp_processor_id(void)
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();

-- 
