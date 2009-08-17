Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZHQT2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZHQT2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 15:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbZHQT2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 15:28:35 -0400
Received: from www.tglx.de ([62.245.132.106]:50816 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZHQT2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 15:28:34 -0400
Date: Mon, 17 Aug 2009 21:27:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] irq fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0908172055360.2782@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      genirq: Do not wakeup irq thread from __setup_irq() and set action->irq


 kernel/irq/manage.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d222515..76fa62f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -607,7 +607,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		get_task_struct(t);
 		new->thread = t;
-		wake_up_process(t);
 	}
 
 	/*
@@ -690,6 +689,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 				(int)(new->flags & IRQF_TRIGGER_MASK));
 	}
 
+	new->irq = irq;
 	*old_ptr = new;
 
 	/* Reset broken irq detection when installing new handler */
@@ -707,7 +707,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 	spin_unlock_irqrestore(&desc->lock, flags);
 
-	new->irq = irq;
 	register_irq_proc(irq, desc);
 	new->dir = NULL;
 	register_handler_proc(irq, new);
