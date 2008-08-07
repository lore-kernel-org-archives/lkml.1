Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYHGSWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYHGSWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYHGSVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:21:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYHGSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:21:19 -0400
Message-Id: <20080807182117.326234263@goodmis.org>
References: <20080807182013.984175558@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 07 Aug 2008 14:20:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] ftrace: rebuild everything on change to FTRACE_MCOUNT_RECORD
Content-Disposition: inline; filename=ftrace-compile-all-for-mcount-change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabling or disabling CONFIG_FTRACE_MCOUNT_RECORD, we want a full
kernel compile to handle the adding of the __mcount_loc sections.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/kernel.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-tip.git/include/linux/kernel.h
===================================================================
--- linux-tip.git.orig/include/linux/kernel.h	2008-07-28 12:32:01.000000000 -0400
+++ linux-tip.git/include/linux/kernel.h	2008-08-07 13:07:36.000000000 -0400
@@ -480,4 +480,9 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
+#endif
+
 #endif

-- 
