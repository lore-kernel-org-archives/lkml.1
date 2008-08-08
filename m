Return-Path: <linux-kernel-owner+w=401wt.eu-S932479AbYHHWJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbYHHWJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760115AbYHHVzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762321AbYHHVzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qSGDRM9QjaeKZgtOGhzI6ePR59MWV4LsPwH+KYOzRu+RRiYeDZfQGvBSIZaCOH8yeU
         R45rDkdQCVo/flSgM8k6uLQh6z1kFO8IvUysOIRIrQk0fgDXk/3/tj9CeCrSIi6SUCGY
         7AQMq+dc08fARiHtSKQKorQz/db1514alIusc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 38/42] seperate irq_descX with irq_descX_free
Date: Fri,  8 Aug 2008 14:52:44 -0700
Message-Id: <1218232368-31228-39-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-38-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-18-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-19-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-20-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-21-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-22-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-23-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-24-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-25-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-26-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-27-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-28-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-29-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-30-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-31-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-32-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-33-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-34-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-35-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-36-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-37-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-38-git-send-email-yhlu.kernel@gmail.com>
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
index 0d9578e..d130119 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -223,7 +223,7 @@ extern struct irq_desc *irq_descX;
 
 extern struct irq_desc *irq_descX;
 #define for_each_irq_desc(irqX, desc)		\
-	for (desc = irq_descX, irqX = desc->irq; desc && irqX != -1U; desc = desc->next, irqX = desc ? desc->irq: -1U)
+	for (desc = irq_descX, irqX = desc->irq; desc; desc = desc->next, irqX = desc ? desc->irq: -1U)
 
 #endif
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 194d815..0f5ea0c 100644
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
-			printk("found new irq_desc for irq %d\n", desc->irq);
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
-			printk("found irq_desc for irq %d\n", desc->irq);
-			if (desc->next)
-				printk("found irq_desc for irq %d and next will be irq %d\n", desc->irq, desc->next->irq);
-			desc = desc->next;
-			count++;
-		}
-		printk("all preallocted %d\n", count);
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
 
-        if (!desc)
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
-	printk("1 found new irq_desc for irq %d and pri will be irq %d\n", desc->irq, desc_pri->irq);
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
+	printk("found new irq_desc for irq %d\n", desc->irq);
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

