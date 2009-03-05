Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbZCEXWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbZCEXWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbZCEXWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:22:23 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:37465 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767AbZCEXWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:22:22 -0500
Message-Id: <20090305225512.274276534@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:32 -0500
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
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 04/41] LTTng core powerpc
Content-Disposition: inline; filename=lttng-core-powerpc.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds OOPS printing indication of nesting within tracer code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/powerpc/kernel/traps.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6-lttng/arch/powerpc/kernel/traps.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kernel/traps.c	2009-01-09 18:16:47.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/kernel/traps.c	2009-01-09 18:17:23.000000000 -0500
@@ -33,6 +33,7 @@
 #include <linux/backlight.h>
 #include <linux/bug.h>
 #include <linux/kdebug.h>
+#include <linux/ltt-core.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
@@ -138,6 +139,10 @@ int die(const char *str, struct pt_regs 
 #ifdef CONFIG_NUMA
 		printk("NUMA ");
 #endif
+#ifdef CONFIG_LTT
+		printk("LTT NESTING LEVEL : %u ", __get_cpu_var(ltt_nesting));
+		printk("\n");
+#endif
 		printk("%s\n", ppc_md.name ? ppc_md.name : "");
 
 		print_modules();

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
