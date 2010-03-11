Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0CKEBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 23:01:25 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:38755 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab0CKEBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 23:01:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=n+RFaT7BjQCDRMQtCJxqsDuFhsevl2HYnw0/TWJghkphJb5HCnJhqMfqt/ryQxlLZ6
         AGCrTncT4Q8/s7DhzugU/YZ1jDswo/w/cUg03W6wScIkdeNX2tUkoZNOid0zkc2K1LRj
         qaBQsGaic4paGgDLcB8WuiU1Qa3znhku8ARHU=
From: Bruno Bigras <bigras.bruno@gmail.com>
To: jeremy@xensource.com
Cc: virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, Bruno Bigras <bigras.bruno@gmail.com>
Subject: [PATCH 2/2] xen: events: Fix checkpatch issues
Date: Wed, 10 Mar 2010 23:00:54 -0500
Message-Id: <1268280054-16170-2-git-send-email-bigras.bruno@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268280054-16170-1-git-send-email-bigras.bruno@gmail.com>
References: <1268280054-16170-1-git-send-email-bigras.bruno@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/xen/events.c:31: WARNING: Use #include <linux/ptrace.h> instead of <asm/ptrace.h>
drivers/xen/events.c:76: ERROR: open brace '{' following struct go on the same line
drivers/xen/events.c:509: WARNING: line over 80 characters
drivers/xen/events.c:581: ERROR: space required before the open parenthesis '('
drivers/xen/events.c:585: ERROR: space required before the open parenthesis '('
drivers/xen/events.c:590: ERROR: space required before the open parenthesis '('
drivers/xen/events.c:595: ERROR: space required before the open parenthesis '('
drivers/xen/events.c:625: ERROR: code indent should use tabs where possible
drivers/xen/events.c:625: WARNING: please, no space before tabs
drivers/xen/events.c:666: ERROR: space required before the open parenthesis '('
drivers/xen/events.c:802: ERROR: do not use assignment in if condition
drivers/xen/events.c:831: ERROR: do not use assignment in if condition

Signed-off-by: Bruno Bigras <bigras.bruno@gmail.com>
---
 drivers/xen/events.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2f84137..e86841c 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -27,8 +27,8 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/bootmem.h>
+#include <linux/ptrace.h>
 
-#include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
 #include <asm/sync_bitops.h>
@@ -72,8 +72,7 @@ enum xen_irq_type {
  *    IPI - IPI vector
  *    EVTCHN -
  */
-struct irq_info
-{
+struct irq_info {
 	enum xen_irq_type type;	/* type */
 	unsigned short evtchn;	/* event channel */
 	unsigned short cpu;	/* cpu bound */
@@ -506,7 +505,8 @@ EXPORT_SYMBOL_GPL(bind_evtchn_to_irqhandler);
 
 int bind_virq_to_irqhandler(unsigned int virq, unsigned int cpu,
 			    irq_handler_t handler,
-			    unsigned long irqflags, const char *devname, void *dev_id)
+			    unsigned long irqflags, const char *devname,
+			    void *dev_id)
 {
 	unsigned int irq;
 	int retval;
@@ -578,21 +578,21 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
 			v->evtchn_pending_sel);
 	}
 	printk("pending:\n   ");
-	for(i = ARRAY_SIZE(sh->evtchn_pending)-1; i >= 0; i--)
+	for (i = ARRAY_SIZE(sh->evtchn_pending)-1; i >= 0; i--)
 		printk("%08lx%s", sh->evtchn_pending[i],
 			i % 8 == 0 ? "\n   " : " ");
 	printk("\nmasks:\n   ");
-	for(i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--)
+	for (i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--)
 		printk("%08lx%s", sh->evtchn_mask[i],
 			i % 8 == 0 ? "\n   " : " ");
 
 	printk("\nunmasked:\n   ");
-	for(i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--)
+	for (i = ARRAY_SIZE(sh->evtchn_mask)-1; i >= 0; i--)
 		printk("%08lx%s", sh->evtchn_pending[i] & ~sh->evtchn_mask[i],
 			i % 8 == 0 ? "\n   " : " ");
 
 	printk("\npending list:\n");
-	for(i = 0; i < NR_EVENT_CHANNELS; i++) {
+	for (i = 0; i < NR_EVENT_CHANNELS; i++) {
 		if (sync_test_bit(i, sh->evtchn_pending)) {
 			printk("  %d: event %d -> irq %d\n",
 			       cpu_from_evtchn(i), i,
@@ -622,7 +622,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
- 	unsigned count;
+	unsigned count;
 
 	exit_idle();
 	irq_enter();
@@ -663,7 +663,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
 
 		count = __get_cpu_var(xed_nesting_count);
 		__get_cpu_var(xed_nesting_count) = 0;
-	} while(count != 1);
+	} while (count != 1);
 
 out:
 	irq_exit();
@@ -799,7 +799,8 @@ static void restore_cpu_virqs(unsigned int cpu)
 	int virq, irq, evtchn;
 
 	for (virq = 0; virq < NR_VIRQS; virq++) {
-		if ((irq = per_cpu(virq_to_irq, cpu)[virq]) == -1)
+		irq = per_cpu(virq_to_irq, cpu)[virq];
+		if (irq == -1)
 			continue;
 
 		BUG_ON(virq_from_irq(irq) != virq);
@@ -828,7 +829,8 @@ static void restore_cpu_ipis(unsigned int cpu)
 	int ipi, irq, evtchn;
 
 	for (ipi = 0; ipi < XEN_NR_IPIS; ipi++) {
-		if ((irq = per_cpu(ipi_to_irq, cpu)[ipi]) == -1)
+		irq = per_cpu(ipi_to_irq, cpu)[ipi];
+		if (irq == -1)
 			continue;
 
 		BUG_ON(ipi_from_irq(irq) != ipi);
-- 
1.7.0.2

