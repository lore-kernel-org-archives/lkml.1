Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYHJHv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYHJHv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755954AbYHJHja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:39:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:3148 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbYHJHj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JHDT2Eef0eYYxUs2QDBHss2SJM1Y5B6/vqfYswf+ifIm3ZdAAuds7Yp2+1S3QsfRqW
         KyA+a530oejsyqUChVWYLALVELwY8HFjKXnil1cFnCEHaLd1W4CtVNfChPx2wtOrGjDs
         dToEdEEIh84ViSizYP7AhlrQNzpchTzdaC5ls=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 40/43] seperate irq_descX with irq_descX_free
Date: Sun, 10 Aug 2008 00:36:29 -0700
Message-Id: <1218353792-3355-41-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-40-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-5-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-6-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-7-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-10-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-11-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-12-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-13-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-14-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-15-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-16-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-17-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-18-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-19-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-20-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-21-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-22-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-23-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-24-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-25-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-26-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-27-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-28-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-29-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-30-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-31-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-32-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-33-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-34-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-35-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-36-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-37-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-38-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-39-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-40-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so later don't need compare with -1U

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 include/linux/irq.h |    2 +-
 kernel/irq/handle.c |  113 ++++++++++++++++++++++++++------------------------
 2 files changed, 60 insertions(+), 55 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 979ef9e..b9b56fe 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -221,7 +221,7 @@ extern struct irq_desc *irq_descX;
 
 extern struct irq_desc *irq_descX;
 #define for_each_irq_desc(irqX, desc)		\
-	for (desc = irq_descX, irqX = desc->irq; desc && irqX != -1U; desc = desc->next, irqX = desc ? desc->irq : -1U)
+	for (desc = irq_descX, irqX = desc->irq; desc; desc = desc->next, irqX = desc ? desc->irq : -1U)
 
 #endif
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 7703ba6..c540b9d 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -111,6 +111,11 @@ static void init_kstat_irqs(struct irq_desc *desc, int nr_desc, int nr)
 	}
 }
 
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+static struct irq_desc *irq_descX_free;
+struct irq_desc *irq_descX;
+#endif
+
 static void __init init_work(void *data)
 {
 	struct dyn_array *da = data;
@@ -126,13 +131,16 @@ static void __init init_work(void *data)
 #endif
 	}
 
+	/* init kstat_irqs, nr_cpu_ids is ready already */
+	init_kstat_irqs(desc, *da->nr, nr_cpu_ids);
+
 #ifdef CONFIG_HAVE_SPARSE_IRQ
 	for (i = 1; i < *da->nr; i++)
 		desc[i-1].next = &desc[i];
-#endif
 
-	/* init kstat_irqs, nr_cpu_ids is ready already */
-	init_kstat_irqs(desc, *da->nr, nr_cpu_ids);
+	irq_descX_free = irq_descX;
+	irq_descX = NULL;
+#endif
 }
 
 #ifdef CONFIG_HAVE_SPARSE_IRQ
@@ -147,23 +155,17 @@ static int __init parse_nr_irq_desc(char *arg)
 
 early_param("nr_irq_desc", parse_nr_irq_desc);
 
-struct irq_desc *irq_descX;
 DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
 
 struct irq_desc *irq_desc(unsigned int irq)
 {
 	struct irq_desc *desc;
 
-	BUG_ON(irq == -1U);
-
-	desc = &irq_descX[0];
+	desc = irq_descX;
 	while (desc) {
 		if (desc->irq == irq)
 			return desc;
 
-		if (desc->irq == -1U)
-			return NULL;
-
 		desc = desc->next;
 	}
 	return NULL;
@@ -173,21 +175,12 @@ struct irq_desc *irq_desc_with_new(unsigned int irq)
 	struct irq_desc *desc, *desc_pri;
 	int i;
 	int count = 0;
-	unsigned long phys;
-	unsigned long total_bytes;
-
-	BUG_ON(irq == -1U);
 
-	desc_pri = desc = &irq_descX[0];
+	desc_pri = desc = irq_descX;
 	while (desc) {
 		if (desc->irq == irq)
 			return desc;
 
-		if (desc->irq == -1U) {
-			desc->irq = irq;
-			printk(KERN_DEBUG "found new irq_desc for irq %d\n", desc->irq);
-			return desc;
-		}
 		desc_pri = desc;
 		desc = desc->next;
 		count++;
@@ -196,48 +189,60 @@ struct irq_desc *irq_desc_with_new(unsigned int irq)
 	/*
 	 *  we run out of pre-allocate ones, allocate more
 	 */
-	printk(KERN_DEBUG "try to get more irq_desc %d\n", nr_irq_desc);
-	{
-		/* double check if some one mess up the list */
-		struct irq_desc *desc;
-		int count = 0;
-
-		desc = &irq_descX[0];
-		while (desc) {
-			printk(KERN_DEBUG "found irq_desc for irq %d\n", desc->irq);
-			if (desc->next)
-				printk(KERN_DEBUG "found irq_desc for irq %d and next will be irq %d\n", desc->irq, desc->next->irq);
-			desc = desc->next;
-			count++;
-		}
-		printk(KERN_DEBUG "all preallocted %d\n", count);
-	}
+	if (!irq_descX_free) {
+		unsigned long phys;
+		unsigned long total_bytes;
 
-	total_bytes = sizeof(struct irq_desc) * nr_irq_desc;
-	if (after_bootmem)
-		desc = kzalloc(total_bytes, GFP_ATOMIC);
-	else
-		desc = __alloc_bootmem_nopanic(total_bytes, PAGE_SIZE, 0);
+		printk(KERN_DEBUG "try to get more irq_desc %d\n", nr_irq_desc);
 
-	if (!desc)
-		panic("please boot with nr_irq_desc= %d\n", count * 2);
+		total_bytes = sizeof(struct irq_desc) * nr_irq_desc;
+		if (after_bootmem)
+			desc = kzalloc(total_bytes, GFP_ATOMIC);
+		else
+			desc = __alloc_bootmem_nopanic(total_bytes, PAGE_SIZE, 0);
 
-	phys = __pa(desc);
-	printk(KERN_DEBUG "irq_desc ==> [%#lx - %#lx]\n", phys, phys + total_bytes);
+		if (!desc)
+			panic("please boot with nr_irq_desc= %d\n", count * 2);
 
-	for (i = 0; i < nr_irq_desc; i++)
-		init_one_irq_desc(&desc[i]);
+		phys = __pa(desc);
+		printk(KERN_DEBUG "irq_desc ==> [%#lx - %#lx]\n", phys, phys + total_bytes);
 
-	for (i = 1; i < nr_irq_desc; i++)
-		desc[i-1].next = &desc[i];
+		for (i = 0; i < nr_irq_desc; i++)
+			init_one_irq_desc(&desc[i]);
 
-	/* init kstat_irqs, nr_cpu_ids is ready already */
-	init_kstat_irqs(desc, nr_irq_desc, nr_cpu_ids);
+		for (i = 1; i < nr_irq_desc; i++)
+			desc[i-1].next = &desc[i];
 
-	desc->irq = irq;
-	desc_pri->next = desc;
-	printk(KERN_DEBUG "1 found new irq_desc for irq %d and pri will be irq %d\n", desc->irq, desc_pri->irq);
+		/* init kstat_irqs, nr_cpu_ids is ready already */
+		init_kstat_irqs(desc, nr_irq_desc, nr_cpu_ids);
+
+		irq_descX_free = desc;
+	}
 
+	desc = irq_descX_free;
+	irq_descX_free = irq_descX_free->next;
+	desc->next = NULL;
+	if (desc_pri)
+		desc_pri->next = desc;
+	else
+		irq_descX = desc;
+	desc->irq = irq;
+	printk(KERN_DEBUG "found new irq_desc for irq %d\n", desc->irq);
+	{
+		/* dump the results */
+		struct irq_desc *desc;
+		unsigned long phys;
+		unsigned long bytes = sizeof(struct irq_desc);
+		unsigned int irqx;
+
+		printk(KERN_DEBUG "=========================== %d\n", irq);
+		printk(KERN_DEBUG "irq_desc dump after get that for %d\n", irq);
+		for_each_irq_desc(irqx, desc) {
+			phys = __pa(desc);
+			printk(KERN_DEBUG "irq_desc %d ==> [%#lx - %#lx]\n", irqx, phys, phys + bytes);
+		}
+		printk(KERN_DEBUG "===========================\n");
+	}
 	return desc;
 }
 #else
-- 
1.5.4.5

