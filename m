Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYFVUN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYFVUN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYFVUNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:13:51 -0400
Received: from smtp21.orange.fr ([80.12.242.47]:49501 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbYFVUNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:13:51 -0400
X-ME-UUID: 20080622201349191.2EC141C000AC@mwinf2107.orange.fr
Message-ID: <485EB27C.2010400@wanadoo.fr>
Date: Sun, 22 Jun 2008 22:13:48 +0200
From: JAILLET Christophe <jaillet.christophe@wanadoo.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux <linux-kernel@vger.kernel.org>, cj <jaillet.christophe@wanadoo.fr>,
       petero2@telia.com
Subject: [PATCH 1/1] arch/x86/kernel/io_apic_32.c : use kzalloc instead of
 kmalloc/memset
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Jaillet <jaillet.christophe@wanadoo.fr>


Hi, here is a patch against arch/x86/kernel/io_apic_32.c which :

1) replace kmalloc/memset with equivalent kzalloc.

It is the same patch as the one I sent earlier but the formating should be OK this time.

Signed-off-by: Christophe Jaillet <jaillet.christophe@wanadoo.fr>

--- 
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 4dc8600..cb9bbeb 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -699,14 +699,12 @@ static int __init balanced_irq_init(void)
 		physical_balance = 1;
 
 	for_each_online_cpu(i) {
-		irq_cpu_data[i].irq_delta = kmalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
-		irq_cpu_data[i].last_irq = kmalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
+		irq_cpu_data[i].irq_delta = kzalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
+		irq_cpu_data[i].last_irq = kzalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
 		if (irq_cpu_data[i].irq_delta == NULL || irq_cpu_data[i].last_irq == NULL) {
 			printk(KERN_ERR "balanced_irq_init: out of memory");
 			goto failed;
 		}
-		memset(irq_cpu_data[i].irq_delta,0,sizeof(unsigned long) * NR_IRQS);
-		memset(irq_cpu_data[i].last_irq,0,sizeof(unsigned long) * NR_IRQS);
 	}
 	
 	printk(KERN_INFO "Starting balanced_irq\n");
@@ -2376,12 +2374,11 @@ static int __init ioapic_init_sysfs(void)
 	for (i = 0; i < nr_ioapics; i++ ) {
 		size = sizeof(struct sys_device) + nr_ioapic_registers[i] 
 			* sizeof(struct IO_APIC_route_entry);
-		mp_ioapic_data[i] = kmalloc(size, GFP_KERNEL);
+		mp_ioapic_data[i] = kzalloc(size, GFP_KERNEL);
 		if (!mp_ioapic_data[i]) {
 			printk(KERN_ERR "Can't suspend/resume IOAPIC %d\n", i);
 			continue;
 		}
-		memset(mp_ioapic_data[i], 0, size);
 		dev = &mp_ioapic_data[i]->dev;
 		dev->id = i; 
 		dev->cls = &ioapic_sysdev_class;

