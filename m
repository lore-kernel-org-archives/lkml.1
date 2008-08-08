Return-Path: <linux-kernel-owner+w=401wt.eu-S1764220AbYHHWJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764220AbYHHWJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762365AbYHHVzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:58025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762013AbYHHVzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jk2fMuTNzWl+/iJKLmmRGfkKMl5WHhZYUP7XPKt+vyWJhoAMtrEkcgYprcpVMlVUWg
         fgvHeYSL2kBoNF6mepGCJLqZQ81QO42GbJaj8K9H+RKabXLrjC6uA96pegMH9RVKLBFD
         tuzoFsSILgWsGDSw/cemQhffLRIwmkHmaWBzM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 39/42] x86_64: sperate irq_cfgx with irq_cfgx_free
Date: Fri,  8 Aug 2008 14:52:45 -0700
Message-Id: <1218232368-31228-40-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-39-git-send-email-yhlu.kernel@gmail.com>
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
 <1218232368-31228-39-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so later don't need compare with -1U

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |   90 ++++++++++++++++++++++++++---------------
 1 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index f8baf58..305ccb5 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -111,44 +111,44 @@ static void init_one_irq_cfg(struct irq_cfg *cfg)
         memcpy(cfg, &irq_cfg_init, sizeof(struct irq_cfg));
 }
 
+static struct irq_cfg *irq_cfgx;
+static struct irq_cfg *irq_cfgx_free;
 static void __init init_work(void *data)
 {
 	struct dyn_array *da = data;
 	struct irq_cfg *cfg;
+	int legacy_count;
 	int i;
 
 	cfg = *da->name;
 
 	memcpy(cfg, irq_cfg_legacy, sizeof(irq_cfg_legacy));
 
-	i = sizeof(irq_cfg_legacy)/sizeof(irq_cfg_legacy[0]);
-	for (; i < *da->nr; i++)
+	legacy_count = sizeof(irq_cfg_legacy)/sizeof(irq_cfg_legacy[0]);
+	for (i = legacy_count; i < *da->nr; i++)
 		init_one_irq_cfg(&cfg[i]);
 
 	for (i = 1; i < *da->nr; i++)
 		cfg[i-1].next = &cfg[i];
+
+	irq_cfgx_free = &irq_cfgx[legacy_count];
+	irq_cfgx[legacy_count - 1].next = NULL;
 }
 
 #define for_each_irq_cfg(cfg)		\
-	for(cfg = irq_cfgx; cfg && cfg->irq != -1U; cfg = cfg->next)
+	for(cfg = irq_cfgx; cfg; cfg = cfg->next)
 
-static struct irq_cfg *irq_cfgx;
 DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irq_cfg, PAGE_SIZE, init_work);
 
 static struct irq_cfg *irq_cfg(unsigned int irq)
 {
 	struct irq_cfg *cfg;
 
-	BUG_ON(irq == -1U);
-
-	cfg = &irq_cfgx[0];
+	cfg = irq_cfgx;
 	while (cfg) {
 		if (cfg->irq == irq)
 			return cfg;
 
-		if (cfg->irq == -1U) {
-			return NULL;
-		}
 		cfg = cfg->next;
 	}
 
@@ -161,44 +161,68 @@ static struct irq_cfg *irq_cfg_with_new(unsigned int irq)
 	int i;
 	int count = 0;
 
-	BUG_ON(irq == -1U);
-
-	cfg_pri = cfg = &irq_cfgx[0];
+	cfg_pri = cfg = irq_cfgx;
 	while (cfg) {
 		if (cfg->irq == irq)
 			return cfg;
 
-		if (cfg->irq == -1U) {
-			cfg->irq = irq;
-			return cfg;
-		}
 		cfg_pri = cfg;
 		cfg = cfg->next;
 		count++;
 	}
 
-	/*
-	 *  we run out of pre-allocate ones, allocate more
-	 */
-	printk(KERN_DEBUG "try to get more irq_cfg %d\n", nr_irq_cfg);
+	if (!irq_cfgx_free) {
+		unsigned long phys;
+		unsigned long total_bytes;
+		/*
+		 *  we run out of pre-allocate ones, allocate more
+		 */
+		printk(KERN_DEBUG "try to get more irq_cfg %d\n", nr_irq_cfg);
 
-	if (after_bootmem)
-		cfg = kzalloc(sizeof(struct irq_cfg)*nr_irq_cfg, GFP_ATOMIC);
-	else
-		cfg = __alloc_bootmem_nopanic(sizeof(struct irq_cfg)*nr_irq_cfg, PAGE_SIZE, 0);
+		total_bytes = sizeof(struct irq_cfg) * nr_irq_cfg;
+		if (after_bootmem)
+			cfg = kzalloc(total_bytes, GFP_ATOMIC);
+		else
+			cfg = __alloc_bootmem_nopanic(total_bytes, PAGE_SIZE, 0);
 
-	if (!cfg)
-		panic("please boot with nr_irq_cfg= %d\n", count * 2);
+		if (!cfg)
+			panic("please boot with nr_irq_cfg= %d\n", count * 2);
 
-	for (i = 0; i < nr_irq_cfg; i++)
-		init_one_irq_cfg(&cfg[i]);
+		phys = __pa(cfg);
+		printk(KERN_DEBUG "irq_irq ==> [%#lx - %#lx]\n", phys, phys + total_bytes);
 
-	for (i = 1; i < nr_irq_cfg; i++)
-		cfg[i-1].next = &cfg[i];
+		for (i = 0; i < nr_irq_cfg; i++)
+			init_one_irq_cfg(&cfg[i]);
 
-	cfg->irq = irq;
-	cfg_pri->next = cfg;
+		for (i = 1; i < nr_irq_cfg; i++)
+			cfg[i-1].next = &cfg[i];
+
+		irq_cfgx_free = cfg;
+	}
 
+	cfg = irq_cfgx_free;
+	irq_cfgx_free = irq_cfgx_free->next;
+	cfg->next = NULL;
+	if (cfg_pri)
+		cfg_pri->next = cfg;
+	else
+		irq_cfgx = cfg;
+	cfg->irq = irq;
+	printk("found new irq_cfg for irq %d\n", cfg->irq);
+	{
+		/* dump the results */
+		struct irq_cfg *cfg;
+		unsigned long phys;
+		unsigned long bytes = sizeof(struct irq_cfg);
+
+		printk(KERN_DEBUG "=========================== %d\n", irq);
+		printk(KERN_DEBUG "irq_cfg dump after get that for %d\n", irq);
+		for_each_irq_cfg(cfg) {
+			phys = __pa(cfg);
+			printk(KERN_DEBUG "irq_cfg %d ==> [%#lx - %#lx]\n", cfg->irq, phys, phys + bytes);
+		}
+		printk(KERN_DEBUG "===========================\n");
+	}
 	return cfg;
 }
 
-- 
1.5.4.5

