Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYBJHXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYBJHXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbYBJHUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:20:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929AbYBJHUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:37 -0500
Date: Sun, 10 Feb 2008 08:20:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [08/19] ftrace: annotate core code that should not be traced
Message-ID: <20080210072026.GI4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Mark with "notrace" functions in core code that should not be
traced.  The "notrace" attribute will prevent gcc from adding
a call to ftrace on the annotated funtions.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/smp_processor_id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/lib/smp_processor_id.c
===================================================================
--- linux.orig/lib/smp_processor_id.c
+++ linux/lib/smp_processor_id.c
@@ -7,7 +7,7 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>
 
-unsigned int debug_smp_processor_id(void)
+notrace unsigned int debug_smp_processor_id(void)
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
