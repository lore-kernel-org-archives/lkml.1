Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZBZN3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZBZN3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZBZN2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:28:48 -0500
Received: from www.tglx.de ([62.245.132.106]:46806 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbZBZN2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:28:47 -0500
Message-Id: <20090226131719.393515463@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 26 Feb 2009 13:28:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: [patch 1/4] genirq: make irqreturn_t an enum
References: <20090226131336.423054348@linutronix.de>
Content-Disposition: inline; filename=genirq-makeirq-return-t-an-enum.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Remove the 2.4 compabiliy cruft

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>

---
 include/linux/irq.h       |    4 ++--
 include/linux/irqreturn.h |   28 ++++++++++------------------
 2 files changed, 12 insertions(+), 20 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -272,7 +272,7 @@ static inline int irq_balancing_disabled
 }
 
 /* Handle irq action chains: */
-extern int handle_IRQ_event(unsigned int irq, struct irqaction *action);
+extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
 
 /*
  * Built-in IRQ handlers for various IRQ types,
@@ -317,7 +317,7 @@ static inline void generic_handle_irq(un
 
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
+typedef enum irqreturn irqreturn_t;
+#define IRQ_RETVAL(x)	((x) != IRQ_NONE)
 
 #endif


