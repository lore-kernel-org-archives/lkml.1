Return-Path: <linux-kernel-owner+w=401wt.eu-S1762889AbYHHWFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762889AbYHHWFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760755AbYHHVy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762189AbYHHVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JLB0UMEp99OG6FSPJDip8RRn7hVYDeuVmcOy0GmsLgwWEEtEKfr0GsFHVfgNgRsYie
         Dd5XUD7eRb8dw9j0ReCO5z8++tKtZ5FaHZiJ/ALsx/UGapY3ageqv8CgpbzNsn12Mu2I
         yp5Zy8Aw6CFuiaO8iTfGBkNyxzWXfyd3kiFDg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 30/42] x86: move kstat_irqs from kstat to irq_desc
Date: Fri,  8 Aug 2008 14:52:36 -0700
Message-Id: <1218232368-31228-31-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-30-git-send-email-yhlu.kernel@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

based Eric's patch ...

together mold it with dyn_array for irq_desc, will allcate kstat_irqs for
nr_irq_desc alltogether if needed. -- at that point nr_cpus is known already.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/alpha/kernel/irq.c                 |    2 +-
 arch/alpha/kernel/irq_alpha.c           |    2 +-
 arch/arm/kernel/irq.c                   |    2 +-
 arch/arm/mach-ns9xxx/irq.c              |    3 +-
 arch/avr32/kernel/irq.c                 |    2 +-
 arch/cris/kernel/irq.c                  |    2 +-
 arch/frv/kernel/irq.c                   |    2 +-
 arch/h8300/kernel/irq.c                 |    2 +-
 arch/ia64/kernel/irq.c                  |    2 +-
 arch/ia64/kernel/irq_ia64.c             |    8 +-
 arch/m32r/kernel/irq.c                  |    2 +-
 arch/m68k/kernel/ints.c                 |    6 +-
 arch/m68k/sun3/sun3ints.c               |    8 +-
 arch/mips/kernel/irq.c                  |    2 +-
 arch/mips/sgi-ip22/ip22-int.c           |    2 +-
 arch/mips/sgi-ip22/ip22-time.c          |    2 +-
 arch/mips/sibyte/bcm1480/smp.c          |    2 +-
 arch/mips/sibyte/sb1250/irq.c           |    2 +-
 arch/mips/sibyte/sb1250/smp.c           |    2 +-
 arch/mn10300/kernel/irq.c               |    2 +-
 arch/parisc/kernel/irq.c                |    2 +-
 arch/powerpc/kernel/irq.c               |    2 +-
 arch/powerpc/platforms/cell/interrupt.c |    2 +-
 arch/s390/kernel/irq.c                  |    2 +-
 arch/s390/kernel/s390_ext.c             |    2 +-
 arch/sh/kernel/irq.c                    |    2 +-
 arch/sparc/kernel/irq.c                 |    7 +-
 arch/sparc/kernel/sun4d_irq.c           |    5 +-
 arch/sparc64/kernel/irq.c               |    2 +-
 arch/sparc64/kernel/time.c              |    2 +-
 arch/um/kernel/irq.c                    |    2 +-
 arch/x86/kernel/io_apic_32.c            |    2 +-
 arch/x86/kernel/irq_32.c                |    4 +-
 arch/x86/kernel/irq_64.c                |    4 +-
 arch/x86/kernel/visws_quirks.c          |    2 +-
 arch/xtensa/kernel/irq.c                |    2 +-
 drivers/s390/cio/cio.c                  |    2 +-
 fs/proc/proc_misc.c                     |    2 +-
 include/linux/irq.h                     |    7 ++
 include/linux/kernel_stat.h             |   14 ++---
 kernel/irq/chip.c                       |   15 ++---
 kernel/irq/handle.c                     |   97 ++++++++++++++++++++++---------
 kernel/sched.c                          |    5 +-
 43 files changed, 140 insertions(+), 103 deletions(-)

diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index 85d7173..10b9ebc 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -94,7 +94,7 @@ show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(irq));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[irq]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(irq, j));
 #endif
 		seq_printf(p, " %14s", desc->chip->typename);
 		seq_printf(p, "  %c%s",
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index feddec7..060ad37 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -64,7 +64,7 @@ do_entInt(unsigned long type, unsigned long vector,
 		smp_percpu_timer_interrupt(regs);
 		cpu = smp_processor_id();
 		if (cpu != boot_cpuid) {
-		        kstat_cpu(cpu).irqs[RTC_IRQ]++;
+		        irq_desc(RTC_IRQ)->kstat_irqs[cpu]++;
 		} else {
 			handle_irq(RTC_IRQ);
 		}
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index a542c8d..d4a74e7 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -77,7 +77,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_printf(p, "%3d: ", i);
 		for_each_present_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 		seq_printf(p, " %10s", desc->chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
diff --git a/arch/arm/mach-ns9xxx/irq.c b/arch/arm/mach-ns9xxx/irq.c
index ca85d24..1b9c272 100644
--- a/arch/arm/mach-ns9xxx/irq.c
+++ b/arch/arm/mach-ns9xxx/irq.c
@@ -64,7 +64,6 @@ static struct irq_chip ns9xxx_chip = {
 #else
 static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
 {
-	unsigned int cpu = smp_processor_id();
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
@@ -73,7 +72,7 @@ static void handle_prio_irq(unsigned int irq, struct irq_desc *desc)
 	BUG_ON(desc->status & IRQ_INPROGRESS);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
diff --git a/arch/avr32/kernel/irq.c b/arch/avr32/kernel/irq.c
index 28d5d03..b75a957 100644
--- a/arch/avr32/kernel/irq.c
+++ b/arch/avr32/kernel/irq.c
@@ -60,7 +60,7 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		seq_printf(p, "%3d: ", i);
 		for_each_online_cpu(cpu)
-			seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 		seq_printf(p, " %8s", desc->chip->name ? : "-");
 		seq_printf(p, "  %s", action->name);
 		for (action = action->next; action; action = action->next)
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index b280e0a..55598b1 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -68,7 +68,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i,j));
 #endif
 		seq_printf(p, " %14s", desc->chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/frv/kernel/irq.c b/arch/frv/kernel/irq.c
index 4770219..1bdb600 100644
--- a/arch/frv/kernel/irq.c
+++ b/arch/frv/kernel/irq.c
@@ -76,7 +76,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
-				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 			seq_printf(p, " %10s", desc->chip->name ? : "-");
 			seq_printf(p, "  %s", action->name);
 			for (action = action->next;
diff --git a/arch/h8300/kernel/irq.c b/arch/h8300/kernel/irq.c
index 6c2e213..65bb8b8 100644
--- a/arch/h8300/kernel/irq.c
+++ b/arch/h8300/kernel/irq.c
@@ -200,7 +200,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		if (!action)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
-		seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+		seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		seq_printf(p, " %14s", desc->chip->name);
 		seq_printf(p, "-%-8s", desc->name);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index b9290c6..f0dda1c 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -82,7 +82,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j) {
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		}
 #endif
 		seq_printf(p, " %14s", desc->chip->name);
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 28d3d48..fa28483 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -495,9 +495,9 @@ ia64_handle_irq (ia64_vector vector, struct pt_regs *regs)
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_this_cpu.irqs[vector]++;
+			kstat_irqs_this_cpu(irq_desc(vector))++;
 		} else if (unlikely(IS_RESCHEDULE(vector)))
-			kstat_this_cpu.irqs[vector]++;
+			kstat_irqs_this_cpu(irq_desc(vector))++;
 		else {
 			int irq = local_vector_to_irq(vector);
 
@@ -553,9 +553,9 @@ void ia64_process_pending_intr(void)
 	while (vector != IA64_SPURIOUS_INT_VECTOR) {
 		if (unlikely(IS_LOCAL_TLB_FLUSH(vector))) {
 			smp_local_flush_tlb();
-			kstat_this_cpu.irqs[vector]++;
+			kstat_irqs_this_cpu(irq_desc(vector))++;
 		} else if (unlikely(IS_RESCHEDULE(vector)))
-			kstat_this_cpu.irqs[vector]++;
+			kstat_irqs_this_cpu(irq_desc(vector))++;
 		else {
 			struct pt_regs *old_regs = set_irq_regs(NULL);
 			int irq = local_vector_to_irq(vector);
diff --git a/arch/m32r/kernel/irq.c b/arch/m32r/kernel/irq.c
index d9c2a00..753709d 100644
--- a/arch/m32r/kernel/irq.c
+++ b/arch/m32r/kernel/irq.c
@@ -54,7 +54,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i,j));
 #endif
 		seq_printf(p, " %14s", desc->chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index ded7dd2..669ab97 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -389,7 +389,7 @@ EXPORT_SYMBOL(irq_canonicalize);
 asmlinkage void m68k_handle_int(unsigned int irq)
 {
 	struct irq_node *node;
-	kstat_cpu(0).irqs[irq]++;
+	kstat_irqs_this_cpu(irq_desc(irq))++;
 	node = irq_list[irq];
 	do {
 		node->handler(irq, node->dev_id);
@@ -407,7 +407,7 @@ asmlinkage void __m68k_handle_int(unsigned int irq, struct pt_regs *regs)
 
 asmlinkage void handle_badint(struct pt_regs *regs)
 {
-	kstat_cpu(0).irqs[0]++;
+	kstat_irqs_this_cpu(irq_desc(0))++;
 	printk("unexpected interrupt from %u\n", regs->vector);
 }
 
@@ -421,7 +421,7 @@ int show_interrupts(struct seq_file *p, void *v)
 	if (irq_list[i]) {
 		contr = irq_controller[i];
 		node = irq_list[i];
-		seq_printf(p, "%-8s %3u: %10u %s", contr->name, i, kstat_cpu(0).irqs[i], node->devname);
+		seq_printf(p, "%-8s %3u: %10u %s", contr->name, i, kstat_irqs_cpu(i, 0), node->devname);
 		while ((node = node->next))
 			seq_printf(p, ", %s", node->devname);
 		seq_puts(p, "\n");
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 7364cd6..cf4f3e8 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -52,8 +52,8 @@ void sun3_disable_irq(unsigned int irq)
 static irqreturn_t sun3_int7(int irq, void *dev_id)
 {
 	*sun3_intreg |=  (1 << irq);
-	if (!(kstat_cpu(0).irqs[irq] % 2000))
-		sun3_leds(led_pattern[(kstat_cpu(0).irqs[irq] % 16000) / 2000]);
+	if (!(kstat_irqs_cpu(irq, 0) % 2000))
+		sun3_leds(led_pattern[(kstat_irqs_cpu(irq, 0) % 16000) / 2000]);
 	return IRQ_HANDLED;
 }
 
@@ -70,8 +70,8 @@ static irqreturn_t sun3_int5(int irq, void *dev_id)
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
-        if (!(kstat_cpu(0).irqs[irq] % 20))
-                sun3_leds(led_pattern[(kstat_cpu(0).irqs[irq] % 160) / 20]);
+        if (!(kstat_irqs_cpu(irq, 0) % 20))
+                sun3_leds(led_pattern[(kstat_irqs_cpu(irq, 0) % 160) / 20]);
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 3c2e8f0..6c27486 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -105,7 +105,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", desc->chip->name);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
index f6d9bf4..e3bf905 100644
--- a/arch/mips/sgi-ip22/ip22-int.c
+++ b/arch/mips/sgi-ip22/ip22-int.c
@@ -164,7 +164,7 @@ static void indy_buserror_irq(void)
 	int irq = SGI_BUSERR_IRQ;
 
 	irq_enter();
-	kstat_this_cpu.irqs[irq]++;
+	kstat_irqs_this_cpu(irq_desc(irq))++;
 	ip22_be_interrupt(irq);
 	irq_exit();
 }
diff --git a/arch/mips/sgi-ip22/ip22-time.c b/arch/mips/sgi-ip22/ip22-time.c
index 10e5054..0669426 100644
--- a/arch/mips/sgi-ip22/ip22-time.c
+++ b/arch/mips/sgi-ip22/ip22-time.c
@@ -186,7 +186,7 @@ void indy_8254timer_irq(void)
 	char c;
 
 	irq_enter();
-	kstat_this_cpu.irqs[irq]++;
+	kstat_irqs_this_cpu(irq_desc(irq))++;
 	printk(KERN_ALERT "Oops, got 8254 interrupt.\n");
 	ArcRead(0, &c, 1, &cnt);
 	ArcEnterInteractiveMode();
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index bd9eeb4..028759c 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -180,7 +180,7 @@ void bcm1480_mailbox_interrupt(void)
 	int cpu = smp_processor_id();
 	unsigned int action;
 
-	kstat_this_cpu.irqs[K_BCM1480_INT_MBOX_0_0]++;
+	irq_desc(K_BCM1480_INT_MBOX_0_0).kstat_irqs[cpu]++;
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (__raw_readq(mailbox_0_regs[cpu]) >> 48) & 0xffff;
 
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index fd4d58c..30a59fb 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -353,7 +353,7 @@ static void sb1250_kgdb_interrupt(void)
 	 * host to stop the break, since we would see another
 	 * interrupt on the end-of-break too)
 	 */
-	kstat_this_cpu.irqs[kgdb_irq]++;
+	kstat_irqs_this_cpu(irq_desc(kgdb_irq))++;
 	mdelay(500);
 	duart_out(R_DUART_CMD, V_DUART_MISC_CMD_RESET_BREAK_INT |
 				M_DUART_RX_EN | M_DUART_TX_EN);
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index 0734b93..40449f7 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -168,7 +168,7 @@ void sb1250_mailbox_interrupt(void)
 	int cpu = smp_processor_id();
 	unsigned int action;
 
-	kstat_this_cpu.irqs[K_INT_MBOX_0]++;
+	irq_desc(K_INT_MBOX_0)->kstat_irqs[cpu]++;
 	/* Load the mailbox register to figure out what we're supposed to do */
 	action = (____raw_readq(mailbox_regs[cpu]) >> 48) & 0xffff;
 
diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index 38c218c..888d2b3 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -204,7 +204,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		if (action) {
 			seq_printf(p, "%3d: ", i);
 			for_each_present_cpu(cpu)
-				seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+				seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
 			seq_printf(p, " %14s.%u", desc->chip->name,
 				   (GxICR(i) & GxICR_LEVEL) >>
 				   GxICR_LEVEL_SHIFT);
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index e8a3883..a9e5581 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -184,7 +184,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%3d: ", i);
 #ifdef CONFIG_SMP
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #else
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 0e14f8c..4ffd5d9 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -200,7 +200,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%3d: ", i);
 #ifdef CONFIG_SMP
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #else
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #endif /* CONFIG_SMP */
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 2d5bb22..490b619 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -254,7 +254,7 @@ static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 		goto out_eoi;
 	}
 
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index e7c5bfb..3d40087 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -39,7 +39,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
                 seq_putc(p, '\n');
 
diff --git a/arch/s390/kernel/s390_ext.c b/arch/s390/kernel/s390_ext.c
index e019b41..e868194 100644
--- a/arch/s390/kernel/s390_ext.c
+++ b/arch/s390/kernel/s390_ext.c
@@ -124,7 +124,7 @@ void do_extint(struct pt_regs *regs, unsigned short code)
 	if (S390_lowcore.int_clock >= S390_lowcore.clock_comparator)
 		/* Serve timer interrupts first. */
 		clock_comparator_work();
-	kstat_cpu(smp_processor_id()).irqs[EXTERNAL_INTERRUPT]++;
+	kstat_irqs_this_cpu(irq_desc(EXTERNAL_INTERRUPT))++;
         index = ext_hash(code);
 	for (p = ext_int_hash[index]; p; p = p->next) {
 		if (likely(p->code == code))
diff --git a/arch/sh/kernel/irq.c b/arch/sh/kernel/irq.c
index 290befa..5f81932 100644
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -53,7 +53,7 @@ int show_interrupts(struct seq_file *p, void *v)
 			goto unlock;
 		seq_printf(p, "%3d: ",i);
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		seq_printf(p, " %14s", desc->chip->name);
 		seq_printf(p, "-%-8s", desc->name);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
index 93e1d1c..3d803ea 100644
--- a/arch/sparc/kernel/irq.c
+++ b/arch/sparc/kernel/irq.c
@@ -187,8 +187,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j) {
-			seq_printf(p, "%10u ",
-				    kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 		}
 #endif
 		seq_printf(p, " %c %s",
@@ -337,7 +336,7 @@ void handler_irq(int irq, struct pt_regs * regs)
 #endif
 	action = sparc_irq[irq].action;
 	sparc_irq[irq].flags |= SPARC_IRQ_INPROGRESS;
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(irq_desc(irq))++;
 	do {
 		if (!action || !action->handler)
 			unexpected_irq(irq, NULL, regs);
@@ -488,7 +487,7 @@ void sparc_floppy_irq(int irq, void *dev_id, struct pt_regs *regs)
 	old_regs = set_irq_regs(regs);
 	disable_pil_irq(irq);
 	irq_enter();
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(irq_desc(irq))++;
 	floppy_irq_handler(irq, dev_id);
 	irq_exit();
 	enable_pil_irq(irq);
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index 1290b59..9c09e2d 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -106,7 +106,7 @@ found_it:	seq_printf(p, "%3d: ", i);
 #else
 		for_each_online_cpu(x)
 			seq_printf(p, "%10u ",
-			       kstat_cpu(cpu_logical_map(x)).irqs[i]);
+			       kstat_irqs_cpu(i, cpu_logical_map(x)));
 #endif
 		seq_printf(p, "%c %s",
 			(action->flags & IRQF_DISABLED) ? '+' : ' ',
@@ -202,7 +202,6 @@ void sun4d_handler_irq(int irq, struct pt_regs * regs)
 {
 	struct pt_regs *old_regs;
 	struct irqaction * action;
-	int cpu = smp_processor_id();
 	/* SBUS IRQ level (1 - 7) */
 	int sbusl = pil_to_sbus[irq];
 	
@@ -213,7 +212,7 @@ void sun4d_handler_irq(int irq, struct pt_regs * regs)
 	
 	old_regs = set_irq_regs(regs);
 	irq_enter();
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(irq_desc(irq))++;
 	if (!sbusl) {
 		action = *(irq + irq_action);
 		if (!action)
diff --git a/arch/sparc64/kernel/irq.c b/arch/sparc64/kernel/irq.c
index bbed41c..8956e18 100644
--- a/arch/sparc64/kernel/irq.c
+++ b/arch/sparc64/kernel/irq.c
@@ -187,7 +187,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %9s", desc->chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/sparc64/kernel/time.c b/arch/sparc64/kernel/time.c
index a0c6a97..1cd35ba 100644
--- a/arch/sparc64/kernel/time.c
+++ b/arch/sparc64/kernel/time.c
@@ -942,7 +942,7 @@ void timer_interrupt(int irq, struct pt_regs *regs)
 
 	irq_enter();
 
-	kstat_this_cpu.irqs[0]++;
+	irq_desc(0)->kstat_irqs[0]++;
 
 	if (unlikely(!evt->event_handler)) {
 		printk(KERN_WARNING
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 2a37d33..aed625c 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -44,7 +44,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", desc->chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 942983c..cb18dbb 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -526,7 +526,7 @@ static void do_irq_balance(void)
 			if (package_index == i)
 				IRQ_DELTA(package_index, j) = 0;
 			/* Determine the total count per processor per IRQ */
-			value_now = (unsigned long) kstat_cpu(i).irqs[j];
+			value_now = (unsigned long) kstat_irqs_cpu(j,i);
 
 			/* Determine the activity per processor per IRQ */
 			delta = value_now - LAST_CPU_IRQ(i, j);
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index c6750fe..8ff73e7 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -280,7 +280,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		any_count = kstat_irqs(i);
 #else
 		for_each_online_cpu(j)
-			any_count |= kstat_cpu(j).irqs[i];
+			any_count |= kstat_irqs_cpu(i, j);
 #endif
 		action = desc->action;
 		if (!action && !any_count)
@@ -290,7 +290,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i,j));
 #endif
 		seq_printf(p, " %8s", desc->chip->name);
 		seq_printf(p, "-%-8s", desc->name);
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 5e0a938..61fe896 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -90,7 +90,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		any_count = kstat_irqs(i);
 #else
 		for_each_online_cpu(j)
-			any_count |= kstat_cpu(j).irqs[i];
+			any_count |= kstat_irqs_cpu(i, j);
 #endif
 		action = desc->action;
 		if (!action && !any_count)
@@ -100,7 +100,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i,j));
 #endif
 		seq_printf(p, " %8s", desc->chip->name);
 		seq_printf(p, "-%-8s", desc->name);
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 6fa3128..c9f2010 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -635,7 +635,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 	/*
 	 * handle this 'virtual interrupt' as a Cobalt one now.
 	 */
-	kstat_cpu(smp_processor_id()).irqs[realirq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	if (likely(desc->action != NULL))
 		handle_IRQ_event(realirq, desc->action);
diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index 6f26802..a662aa2 100644
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -101,7 +101,7 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_printf(p, "%10u ", kstat_irqs(i));
 #else
 		for_each_online_cpu(j)
-			seq_printf(p, "%10u ", kstat_cpu(j).irqs[i]);
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
 #endif
 		seq_printf(p, " %14s", desc->chip->typename);
 		seq_printf(p, "  %s", action->name);
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 33bff8f..6e09719 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -634,7 +634,7 @@ do_IRQ (struct pt_regs *regs)
 	tpi_info = (struct tpi_info *) __LC_SUBCHANNEL_ID;
 	irb = (struct irb *) __LC_IRB;
 	do {
-		kstat_cpu(smp_processor_id()).irqs[IO_INTERRUPT]++;
+		kstat_irqs_this_cpu(irq_desc(IO_INTERRUPT))++;
 		/*
 		 * Non I/O-subchannel thin interrupts are processed differently
 		 */
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 1968251..aeb0a40 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -526,7 +526,7 @@ static int show_stat(struct seq_file *p, void *v)
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		for (j = 0; j < nr_irqs; j++) {
-			unsigned int temp = kstat_cpu(i).irqs[j];
+			unsigned int temp = kstat_irqs_cpu(j, i);
 			sum += temp;
 			per_irq_sum[j] += temp;
 		}
diff --git a/include/linux/irq.h b/include/linux/irq.h
index ed2a79e..f802abd 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -159,6 +159,11 @@ struct irq_desc {
 #ifdef CONFIG_HAVE_SPARSE_IRQ
 	struct irq_desc		*next;
 #endif
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned int		*kstat_irqs;
+#else
+	unsigned int		kstat_irqs[NR_CPUS];
+#endif
 	struct timer_rand_state *timer_rand_state;
 	irq_flow_handler_t	handle_irq;
 	struct irq_chip		*chip;
@@ -192,6 +197,8 @@ extern struct irq_desc *irq_desc(unsigned int irq);
 /* could be removed if we get rid of all irq_desc reference */
 extern struct irq_desc irq_descX[NR_IRQS];
 #endif
+#define kstat_irqs_this_cpu(DESC) \
+	((DESC)->kstat_irqs[smp_processor_id()])
 
 /*
  * Migration helpers for obsolete names, they will go away:
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index fe1f7fe..8d8e84b 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -28,11 +28,6 @@ struct cpu_usage_stat {
 
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
-#ifdef CONFIG_HAVE_DYN_ARRAY
-	unsigned int *irqs;
-#else
-	unsigned int irqs[NR_IRQS];
-#endif
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
@@ -43,15 +38,18 @@ DECLARE_PER_CPU(struct kernel_stat, kstat);
 
 extern unsigned long long nr_context_switches(void);
 
+extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
+
 /*
  * Number of interrupts per specific IRQ source, since bootup
  */
-static inline int kstat_irqs(int irq)
+static inline unsigned int kstat_irqs(unsigned int irq)
 {
-	int cpu, sum = 0;
+	unsigned int sum = 0;
+	int cpu;
 
 	for_each_possible_cpu(cpu)
-		sum += kstat_cpu(cpu).irqs[irq];
+		sum += kstat_irqs_cpu(irq, cpu);
 
 	return sum;
 }
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index b79337a..9b8ea26 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -311,14 +311,13 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct irqaction *action;
 	irqreturn_t action_ret;
-	const unsigned int cpu = smp_processor_id();
 
 	spin_lock(&desc->lock);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
@@ -350,7 +349,6 @@ out_unlock:
 void
 handle_level_irq(unsigned int irq, struct irq_desc *desc)
 {
-	unsigned int cpu = smp_processor_id();
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
@@ -360,7 +358,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	/*
 	 * If its disabled or no action available
@@ -398,7 +396,6 @@ out_unlock:
 void
 handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
-	unsigned int cpu = smp_processor_id();
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
@@ -408,7 +405,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 		goto out;
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	/*
 	 * If its disabled or no action available
@@ -457,8 +454,6 @@ out:
 void
 handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 {
-	const unsigned int cpu = smp_processor_id();
-
 	spin_lock(&desc->lock);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
@@ -475,7 +470,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		goto out_unlock;
 	}
 
-	kstat_cpu(cpu).irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	/* Start handling the irq */
 	desc->chip->ack(irq);
@@ -530,7 +525,7 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irqreturn_t action_ret;
 
-	kstat_this_cpu.irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 
 	if (desc->chip->ack)
 		desc->chip->ack(irq);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index d75c272..1f23f78 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -37,7 +37,7 @@ void
 handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 {
 	print_irq_desc(irq, desc);
-	kstat_this_cpu.irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 	ack_bad_irq(irq);
 }
 
@@ -79,17 +79,38 @@ static void init_one_irq_desc(struct irq_desc *desc)
 #endif
 }
 
-#ifdef CONFIG_HAVE_SPARSE_IRQ
-static int nr_irq_desc = 32;
+extern int after_bootmem;
+extern void *__alloc_bootmem_nopanic(unsigned long size,
+			     unsigned long align,
+			     unsigned long goal);
 
-static int __init parse_nr_irq_desc(char *arg)
+static void init_kstat_irqs(struct irq_desc *desc, int nr_desc, int nr)
 {
-	if (arg)
-		nr_irq_desc = simple_strtoul(arg, NULL, 0);
-	return 0;
+	unsigned long bytes, total_bytes;
+	char *ptr;
+	int i;
+	unsigned long phys;
+
+	/* Compute how many bytes we need per irq and allocate them */
+	bytes = nr * sizeof(unsigned int);
+	total_bytes = bytes * nr_desc;
+	if (after_bootmem)
+		ptr = kzalloc(total_bytes, GFP_ATOMIC);
+	else
+		ptr = __alloc_bootmem_nopanic(total_bytes, PAGE_SIZE, 0);
+
+	if (!ptr)
+		panic(" can not allocate kstat_irqs\n");
+
+	phys = __pa(ptr);
+	printk(KERN_DEBUG "kstat_irqs ==> [%#lx - %#lx]\n", phys, phys + total_bytes);
+
+	for (i = 0; i < nr_desc; i++) {
+		desc[i].kstat_irqs = (unsigned int *)ptr;
+		ptr += bytes;
+	}
 }
 
-early_param("nr_irq_desc", parse_nr_irq_desc);
 
 static void __init init_work(void *data)
 {
@@ -99,25 +120,44 @@ static void __init init_work(void *data)
 
 	desc = *da->name;
 
-	for (i = 0; i < *da->nr; i++)
+	for (i = 0; i < *da->nr; i++) {
 		init_one_irq_desc(&desc[i]);
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+		desc[i].irq = i;
+#endif
+	}
 
+#ifdef CONFIG_HAVE_SPARSE_IRQ
 	for (i = 1; i < *da->nr; i++)
 		desc[i-1].next = &desc[i];
+#endif
+
+	/* init kstat_irqs, nr_cpu_ids is ready already */
+	init_kstat_irqs(desc, *da->nr, nr_cpu_ids);
 }
 
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+static int nr_irq_desc = 32;
+
+static int __init parse_nr_irq_desc(char *arg)
+{
+	if (arg)
+		nr_irq_desc = simple_strtoul(arg, NULL, 0);
+	return 0;
+}
+
+early_param("nr_irq_desc", parse_nr_irq_desc);
+
 static struct irq_desc *irq_descX;
 DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
 
-extern int after_bootmem;
-extern void *__alloc_bootmem_nopanic(unsigned long size,
-			     unsigned long align,
-			     unsigned long goal);
 struct irq_desc *irq_desc(unsigned int irq)
 {
 	struct irq_desc *desc, *desc_pri;
 	int i;
 	int count = 0;
+	unsigned long phys;
+	unsigned long total_bytes;
 
 	BUG_ON(irq == -1U);
 
@@ -140,38 +180,34 @@ struct irq_desc *irq_desc(unsigned int irq)
 	 */
 	printk(KERN_DEBUG "try to get more irq_desc %d\n", nr_irq_desc);
 
+	total_bytes = sizeof(struct irq_desc) * nr_irq_desc;
 	if (after_bootmem)
-		desc = kzalloc(sizeof(struct irq_desc)*nr_irq_desc, GFP_ATOMIC);
+		desc = kzalloc(total_bytes, GFP_ATOMIC);
 	else
-		desc = __alloc_bootmem_nopanic(sizeof(struct irq_desc)*nr_irq_desc, PAGE_SIZE, 0);
+		desc = __alloc_bootmem_nopanic(total_bytes, PAGE_SIZE, 0);
 
         if (!desc)
 		panic("please boot with nr_irq_desc= %d\n", count * 2);
 
+	phys = __pa(desc);
+	printk(KERN_DEBUG "irq_desc ==> [%#lx - %#lx]\n", phys, phys + total_bytes);
+
 	for (i = 0; i < nr_irq_desc; i++)
 		init_one_irq_desc(&desc[i]);
 
 	for (i = 1; i < nr_irq_desc; i++)
 		desc[i-1].next = &desc[i];
 
+	/* init kstat_irqs, nr_cpu_ids is ready already */
+	init_kstat_irqs(desc, nr_irq_desc, nr_cpu_ids);
+
 	desc->irq = irq;
 	desc_pri->next = desc;
 
 	return desc;
 }
 #else
-static void __init init_work(void *data)
-{
-	struct dyn_array *da = data;
-	int i;
-	struct  irq_desc *desc;
-
-	desc = *da->name;
 
-	for (i = 0; i < *da->nr; i++)
-		init_one_irq_desc(&desc[i]);
-
-}
 static struct irq_desc *irq_descX;
 DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
 
@@ -314,7 +350,7 @@ unsigned int __do_IRQ(unsigned int irq)
 	struct irqaction *action;
 	unsigned int status;
 
-	kstat_this_cpu.irqs[irq]++;
+	kstat_irqs_this_cpu(desc)++;
 	if (CHECK_IRQ_PER_CPU(desc->status)) {
 		irqreturn_t action_ret;
 
@@ -414,3 +450,10 @@ void early_init_irq_lock_class(void)
 }
 #endif
 
+unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
+{
+	struct irq_desc *desc = irq_desc(irq);
+	return desc->kstat_irqs[cpu];
+}
+EXPORT_SYMBOL(kstat_irqs_cpu);
+
diff --git a/kernel/sched.c b/kernel/sched.c
index 21c0839..55cb4ce 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4021,11 +4021,8 @@ static inline void idle_balance(int cpu, struct rq *rq)
 #endif
 
 DEFINE_PER_CPU(struct kernel_stat, kstat);
-EXPORT_PER_CPU_SYMBOL(kstat);
 
-#ifdef CONFIG_HAVE_DYN_ARRAY
-DEFINE_PER_CPU_DYN_ARRAY_ADDR(per_cpu__kstat_irqs, per_cpu__kstat.irqs, sizeof(unsigned int), nr_irqs, sizeof(unsigned long), NULL);
-#endif
+EXPORT_PER_CPU_SYMBOL(kstat);
 
 /*
  * Return p->sum_exec_runtime plus any more ns on the sched_clock
-- 
1.5.4.5

