Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbZCEXft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbZCEXft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbZCEXfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:35:20 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37223 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758641AbZCEXfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:35:18 -0500
Message-Id: <20090305225512.004585213@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [RFC patch 03/41] LTTng core x86
Content-Disposition: inline; filename=lttng-core-x86.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds OOPS printing indication of nesting within tracer code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/dumpstack.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6-lttng/arch/x86/kernel/dumpstack.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/dumpstack.c	2009-01-30 10:06:43.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/dumpstack.c	2009-01-30 10:07:35.000000000 -0500
@@ -14,6 +14,7 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/sysfs.h>
+#include <linux/ltt-core.h>
 
 #include <asm/stacktrace.h>
 
@@ -254,6 +255,10 @@ int __kprobes __die(const char *str, str
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
+#ifdef CONFIG_LTT
+	printk(KERN_EMERG "LTT NESTING LEVEL : %u", __get_cpu_var(ltt_nesting));
+	printk("\n");
+#endif
 	sysfs_printk_last_file();
 	if (notify_die(DIE_OOPS, str, regs, err,
 			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
