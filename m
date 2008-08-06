Return-Path: <linux-kernel-owner+w=401wt.eu-S1765640AbYHFJEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765640AbYHFJEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764109AbYHFIpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:45:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:12111 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYHFIpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JdrYyAN44JRcfBqQxG5giH37hrbZvvzNgoMS5UlH5ma+wNUhnbs2VWeEml38NbYpft
         xhzBJwQrtIHwPCU3ZdGmzQv9z5+UfCfBJM2IwFJbZKXIXUHYY8egaci78o0RZNNTA2+0
         Nv+83z8C0G9xUQkvVvreYLjnSKZEQZXAcNYq8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 32/33] remove >= nr_irqs checking with config_have_sparse_irq
Date: Wed,  6 Aug 2008 01:43:14 -0700
Message-Id: <1218012195-10429-33-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218012195-10429-32-git-send-email-yhlu.kernel@gmail.com>
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
 <1218012195-10429-32-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |   36 ++++++++++++++++++++++++------------
 arch/x86/kernel/irq_64.c     |    2 +-
 drivers/char/random.c        |    4 ++++
 fs/proc/proc_misc.c          |   29 +++++++++++++++++------------
 kernel/irq/chip.c            |   28 +++++++++++++++++++++++++++-
 kernel/irq/manage.c          |   37 +++++++++++++++++++++++++++++++------
 6 files changed, 104 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 8bb6565..1416925 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -135,6 +135,26 @@ static void __init init_work(void *data)
 static struct irq_cfg *irq_cfgx;
 DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irq_cfg, PAGE_SIZE, init_work);
 
+static struct irq_cfg *get_irq_cfg_without_new(unsigned int irq)
+{
+	struct irq_cfg *cfg;
+
+	BUG_ON(irq == -1U);
+
+	cfg = &irq_cfgx[0];
+	while (cfg) {
+		if (cfg->irq == irq)
+			return cfg;
+
+		if (cfg->irq == -1U) {
+			return NULL;
+		}
+		cfg = cfg->next;
+	}
+
+	return NULL;
+}
+
 static struct irq_cfg *get_irq_cfg(unsigned int irq)
 {
 	struct irq_cfg *cfg, *cfg_pri;
@@ -380,7 +400,6 @@ static inline void io_apic_sync(unsigned int apic)
 	struct irq_cfg *cfg;						\
 	struct irq_pin_list *entry;					\
 									\
-	BUG_ON(irq >= nr_irqs);						\
 	cfg = get_irq_cfg(irq);						\
 	entry = cfg->irq_2_pin;						\
 	for (;;) {							\
@@ -460,7 +479,6 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
 	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
 
-	BUG_ON(irq >= nr_irqs);
 	cfg = get_irq_cfg(irq);
 	entry = cfg->irq_2_pin;
 	for (;;) {
@@ -529,7 +547,6 @@ static void add_pin_to_irq(unsigned int irq, int apic, int pin)
 	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
 
-	BUG_ON(irq >= nr_irqs);
 	cfg = get_irq_cfg(irq);
 	entry = cfg->irq_2_pin;
 	if (!entry) {
@@ -820,7 +837,6 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 				best_guess = irq;
 		}
 	}
-	BUG_ON(best_guess >= nr_irqs);
 	return best_guess;
 }
 
@@ -952,7 +968,6 @@ static int pin_2_irq(int idx, int apic, int pin)
 			irq += nr_ioapic_registers[i++];
 		irq += pin;
 	}
-	BUG_ON(irq >= nr_irqs);
 	return irq;
 }
 
@@ -974,7 +989,6 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
 	int cpu;
 	struct irq_cfg *cfg;
 
-	BUG_ON((unsigned)irq >= nr_irqs);
 	cfg = get_irq_cfg(irq);
 
 	/* Only try and allocate irqs on cpus that are present */
@@ -1048,7 +1062,6 @@ static void __clear_irq_vector(int irq)
 	cpumask_t mask;
 	int cpu, vector;
 
-	BUG_ON((unsigned)irq >= nr_irqs);
 	cfg = get_irq_cfg(irq);
 	BUG_ON(!cfg->vector);
 
@@ -1898,8 +1911,6 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
-		if (irq >= nr_irqs)
-			continue;
 
 		desc = get_irq_desc(irq);
 		cfg = get_irq_cfg(irq);
@@ -2475,16 +2486,17 @@ int create_irq(void)
 	int irq;
 	int new;
 	unsigned long flags;
-	struct irq_cfg *cfg_new;
+	struct irq_cfg *cfg_new, *cfg;
 
 	irq = -ENOSPC;
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = (nr_irqs - 1); new >= 0; new--) {
 		if (platform_legacy_irq(new))
 			continue;
-		cfg_new = get_irq_cfg(new);
-		if (cfg_new->vector != 0)
+		cfg = get_irq_cfg_without_new(new);
+		if (!cfg || cfg->vector != 0)
 			continue;
+		cfg_new = get_irq_cfg(new);
 		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
 			irq = new;
 		break;
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index c2fe49f..118f24f 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -202,7 +202,7 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 	stack_overflow_check(regs);
 #endif
 
-	if (likely(irq < nr_irqs))
+	if (likely(get_irq_desc_without_new(irq)))
 		generic_handle_irq(irq);
 	else {
 		if (!disable_apic)
diff --git a/drivers/char/random.c b/drivers/char/random.c
index d9e7a08..02c4f13 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -649,8 +649,10 @@ void add_interrupt_randomness(int irq)
 	struct timer_rand_state *state;
 	struct irq_desc *desc;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return;
+#endif
 
 	desc = get_irq_desc(irq);
 	state = desc->timer_rand_state;
@@ -920,8 +922,10 @@ void rand_initialize_irq(int irq)
 	struct timer_rand_state *state;
 	struct irq_desc *desc;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return;
+#endif
 
 	desc = get_irq_desc(irq);
 	state = desc->timer_rand_state;
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 32de344..2a50625 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -495,19 +495,15 @@ static const struct file_operations proc_vmalloc_operations = {
 
 static int show_stat(struct seq_file *p, void *v)
 {
-	int i;
+	int i, j;
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
 	cputime64_t guest;
 	u64 sum = 0;
 	struct timespec boottime;
-	unsigned int *per_irq_sum;
+	unsigned int per_irq_sum;
 	struct irq_desc *desc;
 
-	per_irq_sum = kzalloc(sizeof(unsigned int)*nr_irqs, GFP_KERNEL);
-	if (!per_irq_sum)
-		return -ENOMEM;
-
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
 	guest = cputime64_zero;
@@ -515,8 +511,6 @@ static int show_stat(struct seq_file *p, void *v)
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		int j;
-
 		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
 		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
 		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
@@ -531,7 +525,6 @@ static int show_stat(struct seq_file *p, void *v)
 
 			temp = kstat_irqs_cpu(j, i);
 			sum += temp;
-			per_irq_sum[j] += temp;
 		}
 		sum += arch_irq_stat_cpu(i);
 	}
@@ -574,8 +567,21 @@ static int show_stat(struct seq_file *p, void *v)
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
-	for (i = 0; i < nr_irqs; i++)
-		seq_printf(p, " %u", per_irq_sum[i]);
+	/* sum again ? it could be updated? have another field in irq_desc?*/
+	for (j = 0; j < nr_irqs; j++) {
+		per_irq_sum = 0;
+		desc = get_irq_desc_without_new(j);
+
+		if (desc)
+			for_each_possible_cpu(i) {
+				unsigned int temp;
+
+				temp = kstat_irqs_cpu(j, i);
+				per_irq_sum += temp;
+			}
+
+		seq_printf(p, " %u", per_irq_sum);
+	}
 
 	seq_printf(p,
 		"\nctxt %llu\n"
@@ -589,7 +595,6 @@ static int show_stat(struct seq_file *p, void *v)
 		nr_running(),
 		nr_iowait());
 
-	kfree(per_irq_sum);
 	return 0;
 }
 
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d09800a..2476e96 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -27,10 +27,12 @@ void dynamic_irq_init(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs) {
 		WARN(1, KERN_ERR "Trying to initialize invalid IRQ%d\n", irq);
 		return;
 	}
+#endif
 
 	/* Ensure we don't have left over values from a previous use of this irq */
 	desc = get_irq_desc(irq);
@@ -60,10 +62,12 @@ void dynamic_irq_cleanup(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs) {
 		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
 		return;
 	}
+#endif
 
 	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
@@ -92,10 +96,12 @@ int set_irq_chip(unsigned int irq, struct irq_chip *chip)
 	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs) {
 		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
 		return -EINVAL;
 	}
+#endif
 
 	if (!chip)
 		chip = &no_irq_chip;
@@ -121,10 +127,12 @@ int set_irq_type(unsigned int irq, unsigned int type)
 	unsigned long flags;
 	int ret = -ENXIO;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs) {
 		printk(KERN_ERR "Trying to set irq type for IRQ%d\n", irq);
 		return -ENODEV;
 	}
+#endif
 
 	desc = get_irq_desc(irq);
 	if (desc->chip->set_type) {
@@ -148,11 +156,13 @@ int set_irq_data(unsigned int irq, void *data)
 	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs) {
 		printk(KERN_ERR
 		       "Trying to install controller data for IRQ%d\n", irq);
 		return -EINVAL;
 	}
+#endif
 
 	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
@@ -174,11 +184,13 @@ int set_irq_msi(unsigned int irq, struct msi_desc *entry)
 	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs) {
 		printk(KERN_ERR
 		       "Trying to install msi data for IRQ%d\n", irq);
 		return -EINVAL;
 	}
+#endif
 	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->msi_desc = entry;
@@ -200,8 +212,16 @@ int set_irq_chip_data(unsigned int irq, void *data)
 	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+	if (irq >= nr_irqs) {
+		printk(KERN_ERR
+		       "Trying to install chip data for IRQ%d\n", irq);
+		return -EINVAL;
+	}
+#endif
+
 	desc = get_irq_desc(irq);
-	if (irq >= nr_irqs || !desc->chip) {
+	if (!desc->chip) {
 		printk(KERN_ERR "BUG: bad set_irq_chip_data(IRQ#%d)\n", irq);
 		return -EINVAL;
 	}
@@ -545,11 +565,13 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs) {
 		printk(KERN_ERR
 		       "Trying to install type control for IRQ%d\n", irq);
 		return;
 	}
+#endif
 
 	desc = get_irq_desc(irq);
 
@@ -610,11 +632,13 @@ void __init set_irq_noprobe(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs) {
 		printk(KERN_ERR "Trying to mark IRQ%d non-probeable\n", irq);
 
 		return;
 	}
+#endif
 
 	desc = get_irq_desc(irq);
 
@@ -628,11 +652,13 @@ void __init set_irq_probe(unsigned int irq)
 	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs) {
 		printk(KERN_ERR "Trying to mark IRQ%d probeable\n", irq);
 
 		return;
 	}
+#endif
 
 	desc = get_irq_desc(irq);
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 13db003..f6735a2 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -34,8 +34,10 @@ void synchronize_irq(unsigned int irq)
 	struct irq_desc *desc = get_irq_desc(irq);
 	unsigned int status;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return;
+#endif
 
 	do {
 		unsigned long flags;
@@ -142,12 +144,15 @@ int irq_select_affinity(unsigned int irq)
  */
 void disable_irq_nosync(unsigned int irq)
 {
-	struct irq_desc *desc = get_irq_desc(irq);
+	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return;
+#endif
 
+	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
@@ -171,11 +176,14 @@ EXPORT_SYMBOL(disable_irq_nosync);
  */
 void disable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = get_irq_desc(irq);
+	struct irq_desc *desc;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return;
+#endif
 
+	desc = get_irq_desc(irq);
 	disable_irq_nosync(irq);
 	if (desc->action)
 		synchronize_irq(irq);
@@ -213,12 +221,15 @@ static void __enable_irq(struct irq_desc *desc, unsigned int irq)
  */
 void enable_irq(unsigned int irq)
 {
-	struct irq_desc *desc = get_irq_desc(irq);
+	struct irq_desc *desc;
 	unsigned long flags;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return;
+#endif
 
+	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
 	__enable_irq(desc, irq);
 	spin_unlock_irqrestore(&desc->lock, flags);
@@ -290,10 +301,16 @@ EXPORT_SYMBOL(set_irq_wake);
  */
 int can_request_irq(unsigned int irq, unsigned long irqflags)
 {
-	struct irq_desc *desc = get_irq_desc(irq);
+	struct irq_desc *desc;
 	struct irqaction *action;
 
-	if (irq >= nr_irqs || desc->status & IRQ_NOREQUEST)
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+	if (irq >= nr_irqs)
+		return 0;
+#endif
+
+	desc = get_irq_desc(irq);
+	if (desc->status & IRQ_NOREQUEST)
 		return 0;
 
 	action =desc->action;
@@ -345,16 +362,19 @@ static int __irq_set_trigger(struct irq_chip *chip, unsigned int irq,
  */
 int setup_irq(unsigned int irq, struct irqaction *new)
 {
-	struct irq_desc *desc = get_irq_desc(irq);
+	struct irq_desc *desc;
 	struct irqaction *old, **p;
 	const char *old_name = NULL;
 	unsigned long flags;
 	int shared = 0;
 	int ret;
 
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return -EINVAL;
+#endif
 
+	desc = get_irq_desc(irq);
 	if (desc->chip == &no_irq_chip)
 		return -ENOSYS;
 	/*
@@ -506,8 +526,11 @@ void free_irq(unsigned int irq, void *dev_id)
 	unsigned long flags;
 
 	WARN_ON(in_interrupt());
+
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return;
+#endif
 
 	desc = get_irq_desc(irq);
 	spin_lock_irqsave(&desc->lock, flags);
@@ -621,8 +644,10 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	 */
 	if ((irqflags & IRQF_SHARED) && !dev_id)
 		return -EINVAL;
+#ifndef CONFIG_HAVE_SPARSE_IRQ
 	if (irq >= nr_irqs)
 		return -EINVAL;
+#endif
 	desc = get_irq_desc(irq);
 	if (desc->status & IRQ_NOREQUEST)
 		return -EINVAL;
-- 
1.5.4.5

