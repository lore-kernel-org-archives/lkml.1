Return-Path: <linux-kernel-owner+w=401wt.eu-S1161627AbXD2XvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161627AbXD2XvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161613AbXD2Xq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:46:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:38505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161616AbXD2Xqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Randy Dunlap <rdunlap@xenotime.net>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [18/26] i386: Update smp_call_function* comments
Message-Id: <20070429234627.E1E55150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Update documentation for i386 smp_call_function* functions.

As reported by Randy Dunlap <rdunlap@xenotime.net>

[ I've posted this before but it seems to have been lost along the way. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>

---
 arch/i386/kernel/smp.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -554,8 +554,10 @@ static void __smp_call_function(void (*f
  * @info: An arbitrary pointer to pass to the function.
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
- * Returns 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have finished.
+  * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
@@ -617,11 +619,13 @@ int native_smp_call_function_mask(cpumas
  * smp_call_function(): Run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: currently unused.
+ * @nonatomic: Unused.
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
- * Returns 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have executed.
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
@@ -633,17 +637,18 @@ int smp_call_function(void (*func) (void
 }
 EXPORT_SYMBOL(smp_call_function);
 
-/*
+/**
  * smp_call_function_single - Run a function on another CPU
+ * @cpu: The target CPU.  Cannot be the calling CPU.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Currently unused.
+ * @nonatomic: Unused.
  * @wait: If true, wait until function has completed on other CPUs.
  *
- * Retrurns 0 on success, else a negative status code.
+ * Returns 0 on success, else a negative status code.
  *
- * Does not return until the remote CPU is nearly ready to execute <func>
- * or is or has executed.
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
  */
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			     int nonatomic, int wait)
