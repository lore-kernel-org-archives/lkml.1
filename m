Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbZEBUFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbZEBUFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759960AbZEBUCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:02:31 -0400
Received: from www.tglx.de ([62.245.132.106]:58495 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512AbZEBUCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:02:30 -0400
Message-Id: <20090502195926.222302283@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:01:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Dike <jdike@addtoit.com>
Subject: [patch 11/11] um: remove obsolete hw_interrupt_type
References: <20090502195607.539955644@linutronix.de>
Content-Disposition: inline;
	filename=um-remove-obsolete-hw-interrupt-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_chip and remove the
define.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Jeff Dike <jdike@addtoit.com>
---
 arch/um/kernel/irq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/irq.c
+++ linux-2.6/arch/um/kernel/irq.c
@@ -358,7 +358,7 @@ EXPORT_SYMBOL(um_request_irq);
 EXPORT_SYMBOL(reactivate_fd);
 
 /*
- * hw_interrupt_type must define (startup || enable) &&
+ * irq_chip must define (startup || enable) &&
  * (shutdown || disable) && end
  */
 static void dummy(unsigned int irq)
@@ -366,7 +366,7 @@ static void dummy(unsigned int irq)
 }
 
 /* This is used for everything else than the timer. */
-static struct hw_interrupt_type normal_irq_type = {
+static struct irq_chip normal_irq_type = {
 	.typename = "SIGIO",
 	.release = free_irq_by_irq_and_dev,
 	.disable = dummy,
@@ -375,7 +375,7 @@ static struct hw_interrupt_type normal_i
 	.end = dummy
 };
 
-static struct hw_interrupt_type SIGVTALRM_irq_type = {
+static struct irq_chip SIGVTALRM_irq_type = {
 	.typename = "SIGVTALRM",
 	.release = free_irq_by_irq_and_dev,
 	.shutdown = dummy, /* never called */


