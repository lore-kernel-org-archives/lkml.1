Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbYHJHws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbYHJHws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbYHJHjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:39:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbYHJHje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fM52eKPmv6dEPP4MVS0xZBbqDB1U6ItMk1aVpeelkRJj/ebkXxharGGFQNHOnErio/
         o8cBScN6O8pdpz4XBMp4gKvPd0hKxIoYqrCm1gaSZxKxFqfs1tpnqwWTCfekSJECfry1
         ryps/YbAXEm3qlcRVS5RhhaZTh1hT6VfvKqnc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 42/43] x86_64: make /proc/interrupts works with dyn irq_desc
Date: Sun, 10 Aug 2008 00:36:31 -0700
Message-Id: <1218353792-3355-43-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-42-git-send-email-yhlu.kernel@gmail.com>
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
 <1218353792-3355-41-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-42-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop with irq_desc list

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/irq_64.c |   31 ++++++++++++++++++++++++-------
 fs/proc/proc_misc.c      |   28 ++++++++++++++++++++++++----
 2 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 4ebf884..f7dabe8 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -70,9 +70,27 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 
 int show_interrupts(struct seq_file *p, void *v)
 {
-	int i = *(loff_t *) v, j;
+	int i, j;
 	struct irqaction * action;
 	unsigned long flags;
+	unsigned int entries;
+	struct irq_desc *desc;
+	int tail = 0;
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	desc = (struct irq_desc *)v;
+	entries = -1U;
+	i = desc->irq;
+	if (!desc->next)
+		tail = 1;
+#else
+	entries = nr_irqs - 1;
+	i = *(loff_t *) v;
+	if (i == nr_irqs)
+		tail = 1;
+	else
+		desc = irq_desc(i);
+#endif
 
 	if (i == 0) {
 		seq_printf(p, "           ");
@@ -81,12 +99,8 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_putc(p, '\n');
 	}
 
-	if (i < nr_irqs) {
+	if (i <= entries) {
 		unsigned any_count = 0;
-		struct irq_desc *desc = irq_desc(i);
-
-		if (!desc)
-			return 0;
 
 		spin_lock_irqsave(&desc->lock, flags);
 #ifndef CONFIG_SMP
@@ -116,7 +130,9 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_putc(p, '\n');
 skip:
 		spin_unlock_irqrestore(&desc->lock, flags);
-	} else if (i == nr_irqs) {
+	}
+
+	if (tail) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->__nmi_count);
@@ -155,6 +171,7 @@ skip:
 		seq_printf(p, "  Spurious interrupts\n");
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	}
+
 	return 0;
 }
 
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 1131f07..4cf6fdf 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -638,15 +638,36 @@ static const struct file_operations proc_stat_operations = {
  */
 static void *int_seq_start(struct seq_file *f, loff_t *pos)
 {
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	struct irq_desc *desc;
+	int irq;
+	int count = *pos;
+
+	for_each_irq_desc(irq, desc) {
+		if (count-- == 0)
+			return desc;
+	}
+
+	return NULL;
+#else
 	return (*pos <= nr_irqs) ? pos : NULL;
+#endif
 }
 
+
 static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+	struct irq_desc *desc;
+
+	desc = ((struct irq_desc *)v)->next;
 	(*pos)++;
-	if (*pos > nr_irqs)
-		return NULL;
-	return pos;
+
+	return desc;
+#else
+	(*pos)++;
+	return (*pos <= nr_irqs) ? pos : NULL;
+#endif
 }
 
 static void int_seq_stop(struct seq_file *f, void *v)
@@ -654,7 +675,6 @@ static void int_seq_stop(struct seq_file *f, void *v)
 	/* Nothing to do */
 }
 
-
 static const struct seq_operations int_seq_ops = {
 	.start = int_seq_start,
 	.next  = int_seq_next,
-- 
1.5.4.5

