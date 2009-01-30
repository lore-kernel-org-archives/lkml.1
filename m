Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZA3LpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZA3LpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 06:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZA3Lnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 06:43:53 -0500
Received: from www.tglx.de ([62.245.132.106]:40359 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbZA3Lnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 06:43:51 -0500
Message-Id: <20090130114307.040619764@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 30 Jan 2009 11:43:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <cbe@osadl.org>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [patch-rt 4/5] x86: remove redundant local_irq_enable() in
	handle_signal()
References: <20090130114230.100052140@linutronix.de>
Content-Disposition: inline;
	filename=irqs-do-not-need-to-be-enabled-explicitly-in-handle-signal.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQs are already enabled when handle_signal() is called.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/signal_32.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-2.6.26.8/arch/x86/kernel/signal_32.c
===================================================================
--- linux-2.6.26.8.orig/arch/x86/kernel/signal_32.c
+++ linux-2.6.26.8/arch/x86/kernel/signal_32.c
@@ -529,13 +529,6 @@ handle_signal(unsigned long sig, siginfo
 		}
 	}
 
-#ifdef CONFIG_PREEMPT_RT
-	/*
-	 * Fully-preemptible kernel does not need interrupts disabled:
-	 */
-	local_irq_enable();
-	preempt_check_resched();
-#endif
 	/*
 	 * If TF is set due to a debugger (TIF_FORCED_TF), clear the TF
 	 * flag so that register information in the sigcontext is correct.


