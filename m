Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYJWNju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYJWNju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYJWNhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:37:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52124 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbYJWNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:37:25 -0400
Message-Id: <20081023133724.000266038@goodmis.org>
References: <20081023133256.926296694@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Oct 2008 09:33:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 08/12 v3] ftrace: disable dynamic ftrace for all archs that use daemon
Content-Disposition: inline; filename=ftrace-remove-non-x86-dynamic-ftrace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ftrace daemon is complex and can cause nasty races if something goes
wrong. Since it affects all of the kernel, this patch disables dynamic 
ftrace from any arch that depends on the daemon. Until the archs are
ported over to the new MCOUNT_RECORD method, I am disabling dynamic
ftrace from them.

Note: I am leaving in the arch/<arch>/kernel/ftrace.c code alone since
that can be used when the arch is ported to MCOUNT_RECORD. To port
the arch to MCOUNT_RECORD, the scripts/recordmcount.pl needs to be
updated. I will make that easier to do for 2.6.29. For 28, we will keep
the archs disabled.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/arm/Kconfig     |    1 -
 arch/powerpc/Kconfig |    1 -
 arch/sparc64/Kconfig |    1 -
 3 files changed, 3 deletions(-)

Index: linux-compile.git/arch/arm/Kconfig
===================================================================
--- linux-compile.git.orig/arch/arm/Kconfig	2008-10-22 13:10:52.000000000 -0400
+++ linux-compile.git/arch/arm/Kconfig	2008-10-22 13:20:55.000000000 -0400
@@ -17,7 +17,6 @@ config ARM
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FTRACE if (!XIP_KERNEL)
-	select HAVE_DYNAMIC_FTRACE if (HAVE_FTRACE)
 	select HAVE_GENERIC_DMA_COHERENT
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
Index: linux-compile.git/arch/powerpc/Kconfig
===================================================================
--- linux-compile.git.orig/arch/powerpc/Kconfig	2008-10-22 13:10:52.000000000 -0400
+++ linux-compile.git/arch/powerpc/Kconfig	2008-10-22 13:20:55.000000000 -0400
@@ -111,7 +111,6 @@ config ARCH_NO_VIRT_TO_BUS
 config PPC
 	bool
 	default y
-	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE
Index: linux-compile.git/arch/sparc64/Kconfig
===================================================================
--- linux-compile.git.orig/arch/sparc64/Kconfig	2008-10-22 13:10:52.000000000 -0400
+++ linux-compile.git/arch/sparc64/Kconfig	2008-10-22 13:20:55.000000000 -0400
@@ -11,7 +11,6 @@ config SPARC
 config SPARC64
 	bool
 	default y
-	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_IDE
 	select HAVE_LMB

-- 
