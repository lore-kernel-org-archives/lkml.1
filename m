Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZELSgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZELSgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 14:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZELSf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 14:35:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZELSf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 14:35:56 -0400
Date: Tue, 12 May 2009 14:35:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] threaded-irqs: fix comment to say IRQ_WAKE_THREAD
Message-ID: <alpine.DEB.2.00.0905121431020.13338@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Trying to implement a driver to use threaded irqs, I was confused when the 
return value to use that was described in the comment above 
request_threaded_irq was not defined.

Turns out that the enum is IRQ_WAKE_THREAD where as the comment said 
IRQ_THREAD_WAKE.

[Impact: do not confuse developers with wrong comments ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2734eca..eb47f8b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -851,7 +851,7 @@ EXPORT_SYMBOL(free_irq);
  *	still called in hard interrupt context and has to check
  *	whether the interrupt originates from the device. If yes it
  *	needs to disable the interrupt on the device and return
- *	IRQ_THREAD_WAKE which will wake up the handler thread and run
+ *	IRQ_WAKE_THREAD which will wake up the handler thread and run
  *	@thread_fn. This split handler design is necessary to support
  *	shared interrupts.
  *
