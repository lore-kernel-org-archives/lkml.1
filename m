Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbZBLBOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbZBLBOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbZBLBNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:13:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZBLBNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:13:47 -0500
Message-Id: <20090212011343.947092143@goodmis.org>
References: <20090212011051.265346435@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 11 Feb 2009 20:10:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 7/7][RFC] powerpc32, ftrace: dynamic function graph tracer
Content-Disposition: inline; filename=0007-powerpc32-ftrace-dynamic-function-graph-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@gollum.(none)>

This patch gets function graph tracing working with dynamic function
tracer on PowerPC32.

Signed-off-by: Steven Rostedt <rostedt@gollum.(none)>
---
 arch/powerpc/Kconfig           |    2 +-
 arch/powerpc/kernel/entry_32.S |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9e4bd20..40b7981 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -111,7 +111,7 @@ config PPC
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_GRAPH_TRACER if PPC64 || !DYNAMIC_FTRACE
+	select HAVE_FUNCTION_GRAPH_TRACER
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 9cf7083..529bfbb 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -1183,7 +1183,12 @@ _GLOBAL(ftrace_caller)
 ftrace_call:
 	bl	ftrace_stub
 	nop
-
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+.globl ftrace_graph_call
+ftrace_graph_call:
+	b	ftrace_graph_stub
+_GLOBAL(ftrace_graph_stub)
+#endif
 	MCOUNT_RESTORE_FRAME
 	/* old link register ends up in ctr reg */
 	bctr
@@ -1205,7 +1210,6 @@ _GLOBAL(_mcount)
 	b	ftrace_graph_caller
 #endif
 	MCOUNT_RESTORE_FRAME
-	
 	bctr
 #endif
 
-- 
1.5.6.5

-- 
