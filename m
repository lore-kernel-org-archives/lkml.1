Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZBZN3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZBZN3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbZBZN2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:28:49 -0500
Received: from www.tglx.de ([62.245.132.106]:46809 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbZBZN2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:28:47 -0500
Message-Id: <20090226131719.502810659@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 26 Feb 2009 13:28:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: [patch 2/4] genirq: use kzalloc instead of explicit zero
	initialization
References: <20090226131336.423054348@linutronix.de>
Content-Disposition: inline; filename=genirq-kzalloc-irq-action.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: simplification

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/irq/manage.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -714,15 +714,13 @@ int request_irq(unsigned int irq, irq_ha
 	if (!handler)
 		return -EINVAL;
 
-	action = kmalloc(sizeof(struct irqaction), GFP_KERNEL);
+	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
 	if (!action)
 		return -ENOMEM;
 
 	action->handler = handler;
 	action->flags = irqflags;
-	cpus_clear(action->mask);
 	action->name = devname;
-	action->next = NULL;
 	action->dev_id = dev_id;
 
 	retval = __setup_irq(irq, desc, action);


