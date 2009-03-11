Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZCKAvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZCKAvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbZCKAr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:47:28 -0400
Received: from www.tglx.de ([62.245.132.106]:40103 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbZCKAr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:47:28 -0400
Message-Id: <20090311003237.415656241@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:46:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Dike <jdike@addtoit.com>
Subject: [patch 18/18] um: convert obsolete hw_interrupt_type to struct
	irq_chip
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline;
	filename=um-convert-obsolete-hw-interrupt-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_chip.

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


