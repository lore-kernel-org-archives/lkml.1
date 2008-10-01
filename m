Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbYJAXEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbYJAXEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 19:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYJAXDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 19:03:23 -0400
Received: from www.tglx.de ([62.245.132.106]:56530 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYJAXDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 19:03:21 -0400
Message-Id: <20081001223301.787166666@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 01 Oct 2008 23:02:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: [RFC patch 1/5] genirq: make irqreturn_t an enum
References: <20081001223213.078984344@linutronix.de>
Content-Disposition: inline; filename=genirq-makeirq-return-t-an-enum.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the 2.4 compabiliy cruft

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irq.h       |    4 ++--
 include/linux/irqreturn.h |   28 ++++++++++------------------
 2 files changed, 12 insertions(+), 20 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -252,7 +252,7 @@ static inline int irq_balancing_disabled
 }
 
 /* Handle irq action chains: */
-extern int handle_IRQ_event(unsigned int irq, struct irqaction *action);
+extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
 
 /*
  * Built-in IRQ handlers for various IRQ types,
@@ -294,7 +294,7 @@ static inline void generic_handle_irq(un
 
 /* Handling of unhandled and spurious interrupts: */
 extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
-			   int action_ret);
+			   irqreturn_t action_ret);
 
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
Index: linux-2.6-tip/include/linux/irqreturn.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irqreturn.h
+++ linux-2.6-tip/include/linux/irqreturn.h
@@ -1,25 +1,17 @@
-/* irqreturn.h */
 #ifndef _LINUX_IRQRETURN_H
 #define _LINUX_IRQRETURN_H
 
-/*
- * For 2.4.x compatibility, 2.4.x can use
- *
- *	typedef void irqreturn_t;
- *	#define IRQ_NONE
- *	#define IRQ_HANDLED
- *	#define IRQ_RETVAL(x)
- *
- * To mix old-style and new-style irq handler returns.
- *
- * IRQ_NONE means we didn't handle it.
- * IRQ_HANDLED means that we did have a valid interrupt and handled it.
- * IRQ_RETVAL(x) selects on the two depending on x being non-zero (for handled)
+/**
+ * enum irqreturn
+ * @IRQ_NONE		interrupt was not from this device
+ * @IRQ_HANDLED		interrupt was handled by this device
  */
-typedef int irqreturn_t;
+enum irqreturn {
+	IRQ_NONE,
+	IRQ_HANDLED,
+};
 
-#define IRQ_NONE	(0)
-#define IRQ_HANDLED	(1)
-#define IRQ_RETVAL(x)	((x) != 0)
+#define irqreturn_t	enum irqreturn
+#define IRQ_RETVAL(x)	((x) != IRQ_NONE)
 
 #endif


