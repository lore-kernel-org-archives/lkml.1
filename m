Return-Path: <linux-kernel-owner+w=401wt.eu-S1764853AbYHHWJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764853AbYHHWJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761903AbYHHVz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761858AbYHHVzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HhYBP7uYMULEMRs4l8yM/HPMwSdFu+pJqQD6J3AQDtbPb/8s4U94yjnfxbKIRvELIS
         Hc42KjR7+4ew0LulF/kdLrBdOi4pARodjyNJill2/bbfiq+TZDvb1zr29UjXi4SXSL8u
         lLqI5zABBKlTInL6p2CBQHvpnKP5MA42rs458=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 40/42] x86_64: make /proc/interrupts works with dyn irq_desc
Date: Fri,  8 Aug 2008 14:52:46 -0700
Message-Id: <1218232368-31228-41-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-40-git-send-email-yhlu.kernel@gmail.com>
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
 <1218232368-31228-40-git-send-email-yhlu.kernel@gmail.com>
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
index 7db6843..ef96ce7 100644
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
index c9ee1f7..15901c7 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -633,15 +633,36 @@ static const struct file_operations proc_stat_operations = {
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
@@ -649,7 +670,6 @@ static void int_seq_stop(struct seq_file *f, void *v)
 	/* Nothing to do */
 }
 
-
 static const struct seq_operations int_seq_ops = {
 	.start = int_seq_start,
 	.next  = int_seq_next,
-- 
1.5.4.5

