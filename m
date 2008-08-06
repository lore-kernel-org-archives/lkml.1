Return-Path: <linux-kernel-owner+w=401wt.eu-S1765565AbYHFJEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765565AbYHFJEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761057AbYHFIpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:45:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:13145 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764209AbYHFIpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bQyfp1qPz7Sb+KH8n9UpDKv7YRAavX6FYIJ1og5ZsV3f4Q26rcGVGvBTgxgX3xHTHj
         EqjwxxYUfNxTMRHHDEFZE/j9sLiRLiX76zdfq109DpbHHDz7S5pNlXFBTWdQUw0R1gZk
         qNHwigQ0yrOr/csOUbAzNFnS+PkEz35cga2WU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 31/33] replace loop with nr_irqs with for_each_irq_desc
Date: Wed,  6 Aug 2008 01:43:13 -0700
Message-Id: <1218012195-10429-32-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218012195-10429-31-git-send-email-yhlu.kernel@gmail.com>
References: <1218012195-10429-1-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-2-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-3-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-4-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-5-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-6-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-7-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-8-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-9-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-10-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-11-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-12-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-13-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-14-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-15-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-16-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-17-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-18-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-19-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-20-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-21-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-22-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-23-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-24-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-25-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-26-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-27-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-28-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-29-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-30-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-31-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so don't all get_irq_desc at begining to allocate all.
and only call that when needed

/proc/interrupts related still use old ways... for compatablilty reason.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |   30 +++++++++++++++---------------
 arch/x86/kernel/irq_64.c     |    5 ++---
 arch/x86/kernel/irqinit_64.c |   17 +++++------------
 fs/proc/proc_misc.c          |    7 +++++--
 include/linux/irq.h          |   18 ++++++++++++++++++
 kernel/irq/handle.c          |   31 ++++++++++++++++++++++++++-----
 kernel/irq/internals.h       |    4 ++--
 kernel/irq/manage.c          |    2 +-
 kernel/irq/proc.c            |   10 +++++-----
 9 files changed, 79 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index c8e4613..8bb6565 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -129,6 +129,9 @@ static void __init init_work(void *data)
 		cfg[i-1].next = &cfg[i];
 }
 
+#define for_each_irq_cfg(cfg)		\
+	for(cfg = irq_cfgx; cfg && cfg->irq != -1U; cfg = cfg->next)
+
 static struct irq_cfg *irq_cfgx;
 DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irq_cfg, PAGE_SIZE, init_work);
 
@@ -1063,20 +1066,18 @@ static void __setup_vector_irq(int cpu)
 	/* Initialize vector_irq on a new cpu */
 	/* This function must be called with vector_lock held */
 	int irq, vector;
+	struct irq_cfg *cfg;
 
 	/* Mark the inuse vectors */
-	for (irq = 0; irq < nr_irqs; ++irq) {
-		struct irq_cfg *cfg = get_irq_cfg(irq);
-
+	for_each_irq_cfg(cfg) {
 		if (!cpu_isset(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
+		irq = cfg->irq;
 		per_cpu(vector_irq, cpu)[vector] = irq;
 	}
 	/* Mark the free vectors */
 	for (vector = 0; vector < NR_VECTORS; ++vector) {
-		struct irq_cfg *cfg;
-
 		irq = per_cpu(vector_irq, cpu)[vector];
 		if (irq < 0)
 			continue;
@@ -1312,6 +1313,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	union IO_APIC_reg_01 reg_01;
 	union IO_APIC_reg_02 reg_02;
 	unsigned long flags;
+	struct irq_cfg *cfg;
 
 	if (apic_verbosity == APIC_QUIET)
 		return;
@@ -1380,12 +1382,11 @@ __apicdebuginit(void) print_IO_APIC(void)
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for (i = 0; i < nr_irqs; i++) {
-		struct irq_cfg *cfg = get_irq_cfg(i);
+	for_each_irq_cfg(cfg) {
 		struct irq_pin_list *entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
-		printk(KERN_DEBUG "IRQ%d ", i);
+		printk(KERN_DEBUG "IRQ%d ", cfg->irq);
 		for (;;) {
 			printk("-> %d:%d", entry->apic, entry->pin);
 			if (!entry->next)
@@ -1845,10 +1846,10 @@ unmask:
 
 static void ir_irq_migration(struct work_struct *work)
 {
-	int irq;
+	unsigned int irq;
+	struct irq_desc *desc;
 
-	for (irq = 0; irq < nr_irqs; irq++) {
-		struct irq_desc *desc = get_irq_desc(irq);
+	for_each_irq_desc(irq, desc) {
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
 
@@ -2044,6 +2045,7 @@ static inline void init_IO_APIC_traps(void)
 {
 	int irq;
 	struct irq_desc *desc;
+	struct irq_cfg *cfg;
 
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -2056,10 +2058,8 @@ static inline void init_IO_APIC_traps(void)
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	for (irq = 0; irq < nr_irqs ; irq++) {
-		struct irq_cfg *cfg;
-
-		cfg = get_irq_cfg(irq);
+	for_each_irq_cfg(cfg) {
+		irq = cfg->irq;
 		if (IO_APIC_IRQ(irq) && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index dde7191..c2fe49f 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -224,17 +224,16 @@ void fixup_irqs(cpumask_t map)
 {
 	unsigned int irq;
 	static int warned;
+	struct irq_desc *desc;
 
-	for (irq = 0; irq < nr_irqs; irq++) {
+	for_each_irq_desc(irq, desc) {
 		cpumask_t mask;
 		int break_affinity = 0;
 		int set_affinity = 1;
-		struct irq_desc *desc;
 
 		if (irq == 2)
 			continue;
 
-		desc = get_irq_desc(irq);
 		/* interrupt's are disabled at this point */
 		spin_lock(&desc->lock);
 
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 8a7a5a8..daed12a 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -142,25 +142,18 @@ static void __init init_ISA_irqs (void)
 	init_bsp_APIC();
 	init_8259A(0);
 
-	for (i = 0; i < nr_irqs; i++) {
+	for (i = 0; i < 16; i++) {
 		struct irq_desc *desc = get_irq_desc(i);
 
 		desc->status = IRQ_DISABLED;
 		desc->action = NULL;
 		desc->depth = 1;
 
-		if (i < 16) {
-			/*
-			 * 16 old-style INTA-cycle interrupts:
-			 */
-			set_irq_chip_and_handler_name(i, &i8259A_chip,
+		/*
+		 * 16 old-style INTA-cycle interrupts:
+		 */
+		set_irq_chip_and_handler_name(i, &i8259A_chip,
 						      handle_level_irq, "XT");
-		} else {
-			/*
-			 * 'high' PCI IRQs filled in on demand
-			 */
-			desc->chip = &no_irq_chip;
-		}
 	}
 }
 
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index aeb0a40..32de344 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -502,6 +502,7 @@ static int show_stat(struct seq_file *p, void *v)
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int *per_irq_sum;
+	struct irq_desc *desc;
 
 	per_irq_sum = kzalloc(sizeof(unsigned int)*nr_irqs, GFP_KERNEL);
 	if (!per_irq_sum)
@@ -525,8 +526,10 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for (j = 0; j < nr_irqs; j++) {
-			unsigned int temp = kstat_irqs_cpu(j, i);
+		for_each_irq_desc(j, desc) {
+			unsigned int temp;
+
+			temp = kstat_irqs_cpu(j, i);
 			sum += temp;
 			per_irq_sum[j] += temp;
 		}
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7fbc9c2..621abf4 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -193,10 +193,28 @@ struct irq_desc {
 } ____cacheline_internodealigned_in_smp;
 
 extern struct irq_desc *get_irq_desc(unsigned int irq);
+extern struct irq_desc *get_irq_desc_without_new(unsigned int irq);
+
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+
 #ifndef CONFIG_HAVE_DYN_ARRAY
 /* could be removed if we get rid of all irq_desc reference */
 extern struct irq_desc irq_desc[NR_IRQS];
+#else
+extern struct irq_desc *irq_desc;
+#endif
+
+#define for_each_irq_desc(irq, desc)		\
+	for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc = &irq_desc[irq])
+
+#else
+
+extern struct irq_desc *irq_descX;
+#define for_each_irq_desc(irqX, desc)		\
+	for (desc = irq_descX, irqX = desc->irq; desc && irqX != -1U; desc = desc->next, irqX = desc ? desc->irq: -1U)
+
 #endif
+
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 67f8d9d..a2750b8 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -111,7 +111,6 @@ static void init_kstat_irqs(struct irq_desc *desc, int nr_desc, int nr)
 	}
 }
 
-
 static void __init init_work(void *data)
 {
 	struct dyn_array *da = data;
@@ -148,9 +147,27 @@ static int __init parse_nr_irq_desc(char *arg)
 
 early_param("nr_irq_desc", parse_nr_irq_desc);
 
-static struct irq_desc *irq_desc;
-DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
+struct irq_desc *irq_descX;
+DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
 
+struct irq_desc *get_irq_desc_without_new(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	BUG_ON(irq == -1U);
+
+	desc = &irq_descX[0];
+	while (desc) {
+		if (desc->irq == irq)
+			return desc;
+
+		if (desc->irq == -1U)
+			return NULL;
+
+		desc = desc->next;
+	}
+	return NULL;
+}
 struct irq_desc *get_irq_desc(unsigned int irq)
 {
 	struct irq_desc *desc, *desc_pri;
@@ -161,7 +178,7 @@ struct irq_desc *get_irq_desc(unsigned int irq)
 
 	BUG_ON(irq == -1U);
 
-	desc_pri = desc = &irq_desc[0];
+	desc_pri = desc = &irq_descX[0];
 	while (desc) {
 		if (desc->irq == irq)
 			return desc;
@@ -208,7 +225,7 @@ struct irq_desc *get_irq_desc(unsigned int irq)
 }
 #else
 
-static struct irq_desc *irq_desc;
+struct irq_desc *irq_desc;
 DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
 
 #endif
@@ -238,6 +255,10 @@ struct irq_desc *get_irq_desc(unsigned int irq)
 
 	return NULL;
 }
+struct irq_desc *get_irq_desc_without_new(unsigned int irq)
+{
+	return get_irq_desc(irq);
+}
 #endif
 
 /*
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 08a849a..605e88c 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -11,11 +11,11 @@ extern void irq_chip_set_defaults(struct irq_chip *chip);
 extern void compat_irq_chip_set_default_handler(struct irq_desc *desc);
 
 #ifdef CONFIG_PROC_FS
-extern void register_irq_proc(unsigned int irq);
+extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
 extern void register_handler_proc(unsigned int irq, struct irqaction *action);
 extern void unregister_handler_proc(unsigned int irq, struct irqaction *action);
 #else
-static inline void register_irq_proc(unsigned int irq) { }
+static inline void register_irq_proc(unsigned int irq, struct irq_desc *desc) { }
 static inline void register_handler_proc(unsigned int irq,
 					 struct irqaction *action) { }
 static inline void unregister_handler_proc(unsigned int irq,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f199122..13db003 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -466,7 +466,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 	spin_unlock_irqrestore(&desc->lock, flags);
 
 	new->irq = irq;
-	register_irq_proc(irq);
+	register_irq_proc(irq, desc);
 	new->dir = NULL;
 	register_handler_proc(irq, new);
 
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 2d8b936..43c6c05 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -163,11 +163,10 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 
 #define MAX_NAMELEN 10
 
-void register_irq_proc(unsigned int irq)
+void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
 	char name [MAX_NAMELEN];
 	struct proc_dir_entry *entry;
-	struct irq_desc *desc = get_irq_desc(irq);
 
 	if (!root_irq_dir ||
 		(desc->chip == &no_irq_chip) || desc->dir)
@@ -226,7 +225,8 @@ void register_default_affinity_proc(void)
 
 void init_irq_proc(void)
 {
-	int i;
+	unsigned irq;
+	struct irq_desc *desc;
 
 	/* create /proc/irq */
 	root_irq_dir = proc_mkdir("irq", NULL);
@@ -238,7 +238,7 @@ void init_irq_proc(void)
 	/*
 	 * Create entries for all existing IRQs.
 	 */
-	for (i = 0; i < nr_irqs; i++)
-		register_irq_proc(i);
+	for_each_irq_desc(irq, desc)
+		register_irq_proc(irq, desc);
 }
 
-- 
1.5.4.5

