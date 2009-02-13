Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbZBMFcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbZBMFcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 00:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZBMFaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 00:30:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41821 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZBMFaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 00:30:07 -0500
Message-Id: <20090213053006.460814961@goodmis.org>
References: <20090213052358.524970112@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Feb 2009 00:24:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: [PATCH 7/7] powerpc32, ftrace: dynamic function graph tracer
Content-Disposition: inline; filename=0007-powerpc32-ftrace-dynamic-function-graph-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

This patch gets function graph tracing working with dynamic function
tracer on PowerPC32.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
