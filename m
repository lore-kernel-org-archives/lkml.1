Return-Path: <linux-kernel-owner+w=401wt.eu-S1031162AbXHMNJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031162AbXHMNJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969652AbXHMIbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:31:52 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:33008 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969646AbXHMIbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:31:49 -0400
Subject: [KJ] replacing kmalloc with kzalloc in io_apic.c
From: Surya Prabhakar N <surya.prabhakar@wipro.com>
Reply-To: surya.prabhakar@wipro.com
To: mingo@redhat.com
Cc: yaku@css1.kbnes.nec.co.jp, kisimoto@css1.kbnes.nec.co.jp, zab@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Coe, Wipro Technologies
Date: Mon, 13 Aug 2007 14:01:21 +0530
Message-Id: <1186993881.3175.15.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 13 Aug 2007 08:32:07.0351 (UTC) FILETIME=[6F25AC70:01C7DD84]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   Replacing kmalloc with kzalloc and cleaning up memset in 
arch/i386/kernel/io_apic.c


Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
--- 

diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 4b8a8da..1329615 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -690,14 +690,12 @@ static int __init balanced_irq_init(void)
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



thanks
surya.
