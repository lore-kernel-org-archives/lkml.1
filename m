Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYIYGO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYIYGO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYIYGOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:14:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:25155 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYIYGOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xiTxif8xwILRpHbPIKwflZzwjUoBVaCJKM42vjbAgs+SEWhDO7144aVGbn3Dqnjl7n
         l8xmDLqyxWfGW3OMzKiu0QSxBKaAS8q/1ZFNcqQZ+5ev+SSCgymZYNuMLxBTWVOPxvaV
         CKi+m+HYhmn8ilgqi58qNE81YQIN+oeEw56GM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Date: Wed, 24 Sep 2008 23:13:43 -0700
Message-Id: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: fix hpet compiling

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/hpet.c    |    3 +++
 arch/x86/kernel/io_apic.c |    7 +++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 422c577..686505a 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -467,6 +467,9 @@ static int hpet_setup_irq(struct hpet_dev *dev)
 	irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
 	enable_irq(dev->irq);
 
+	printk(KERN_DEBUG "hpet: %s is using irq %#x aka %d for MSI\n",
+			 dev->name, dev->irq, dev->irq);
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 4cc9cb6..dc82397 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3355,6 +3355,9 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
 #endif
 		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
 
+	printk(KERN_DEBUG "PCI: %s is using irq %#x aka %d for MSI/MSI-X\n",
+			 pci_name(dev), irq, irq);
+
 	return 0;
 }
 
@@ -3587,6 +3590,7 @@ int arch_setup_hpet_msi(unsigned int irq)
 	hpet_msi_write(irq, &msg);
 	set_irq_chip_and_handler_name(irq, &hpet_msi_type, handle_edge_irq,
 		"edge");
+
 	return 0;
 }
 #endif
@@ -3683,6 +3687,9 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
+
+		printk(KERN_DEBUG "PCI: %s is using irq %#x aka %d for HT\n",
+				 pci_name(dev), irq, irq);
 	}
 	return err;
 }
-- 
1.5.6

