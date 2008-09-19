Return-Path: <linux-kernel-owner+w=401wt.eu-S1751408AbYISHNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbYISHNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 03:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYISHND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 03:13:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:36998 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbYISHNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 03:13:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=e2hL9fqsusm9VeuWD5UFdjmPcpAuo/J3MaVvrH0uIaNAXVcruH4ub7LW1EXVj/GbNx
         RjQCJFFRvpXRNgfrBMsmhGZ2FZeCMq5DcAbPJddZYrNRqBfq/Xr3wnGBHqYocZ73Jptm
         4FpUJV+ZoA0bywWox8ay58PFEphUnZN6pfBvA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] sparseirq: remove some debug print out
Date: Fri, 19 Sep 2008 00:12:26 -0700
Message-Id: <1221808346-15812-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 6ce5873..01419fd 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -277,23 +277,6 @@ static struct irq_cfg *irq_cfg_alloc(unsigned int irq)
 
 	spin_unlock_irqrestore(&irq_cfg_lock, flags);
 
-	printk(KERN_DEBUG "found new irq_cfg for irq %d\n", cfg->irq);
-#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
-	{
-		/* dump the results */
-		struct irq_cfg *cfg;
-		unsigned long phys;
-		unsigned long bytes = sizeof(struct irq_cfg);
-
-		printk(KERN_DEBUG "=========================== %d\n", irq);
-		printk(KERN_DEBUG "irq_cfg dump after get that for %d\n", irq);
-		for_each_irq_cfg(cfg) {
-			phys = __pa(cfg);
-			printk(KERN_DEBUG "irq_cfg %d ==> [%#lx - %#lx]\n", cfg->irq, phys, phys + bytes);
-		}
-		printk(KERN_DEBUG "===========================\n");
-	}
-#endif
 	return cfg;
 }
 #else
@@ -597,7 +580,6 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 		cfg->irq_2_pin = entry;
 		entry->apic = apic;
 		entry->pin = pin;
-		printk(KERN_DEBUG " 0 add_pin_to_irq: irq %d --> apic %d pin %d\n", irq, apic, pin);
 		return;
 	}
 
@@ -613,7 +595,6 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 	entry = entry->next;
 	entry->apic = apic;
 	entry->pin = pin;
-	printk(KERN_DEBUG " x add_pin_to_irq: irq %d --> apic %d pin %d\n", irq, apic, pin);
 }
 
 /*
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index eae6937..710db0e 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -238,24 +238,6 @@ struct irq_desc *irq_to_desc_alloc(unsigned int irq)
 
 	spin_unlock_irqrestore(&sparse_irq_lock, flags);
 
-	printk(KERN_DEBUG "found new irq_desc for irq %d\n", desc->irq);
-#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
-	{
-		/* dump the results */
-		struct irq_desc *desc;
-		unsigned long phys;
-		unsigned long bytes = sizeof(struct irq_desc);
-		unsigned int irqx;
-
-		printk(KERN_DEBUG "=========================== %d\n", irq);
-		printk(KERN_DEBUG "irq_desc dump after get that for %d\n", irq);
-		for_each_irq_desc(irqx, desc) {
-			phys = __pa(desc);
-			printk(KERN_DEBUG "irq_desc %d ==> [%#lx - %#lx]\n", irqx, phys, phys + bytes);
-		}
-		printk(KERN_DEBUG "===========================\n");
-	}
-#endif
 	return desc;
 }
 #else
