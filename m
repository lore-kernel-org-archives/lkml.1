Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYIYSyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYIYSyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYIYSxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:53:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:51228 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYIYSxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=c8Ub843dC7SD2XAptTOYRzNBk67s7Ru2rEDbMmnU2b9+U0bP8ZrVXQmUqHn/KQa8SM
         5NXyifh67W+1gQkMI3muLTf/m2NrAWh4MgIFnaNyL8z39jUo2ZVRgeEH8+W2DyAcjMEE
         DHb7TW2472g6t1aq5Nms79dsr5BdS/UHENaEI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86:  print out irq nr for msi/ht v3
Date: Thu, 25 Sep 2008 11:53:11 -0700
Message-Id: <1222368791-16522-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: fix hpet compiling error
v3: Bjorn want to use dev_printk instead

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/hpet.c    |    3 +++
 arch/x86/kernel/io_apic.c |    5 +++++
 2 files changed, 8 insertions(+)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3348,6 +3348,8 @@ static int setup_msi_irq(struct pci_dev
 #endif
 		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
 
+	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
+
 	return 0;
 }
 
@@ -3580,6 +3582,7 @@ int arch_setup_hpet_msi(unsigned int irq
 	hpet_msi_write(irq, &msg);
 	set_irq_chip_and_handler_name(irq, &hpet_msi_type, handle_edge_irq,
 		"edge");
+
 	return 0;
 }
 #endif
@@ -3676,6 +3679,8 @@ int arch_setup_ht_irq(unsigned int irq,
 
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
+
+		dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
 	}
 	return err;
 }
Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -467,6 +467,9 @@ static int hpet_setup_irq(struct hpet_de
 	irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
 	enable_irq(dev->irq);
 
+	printk(KERN_DEBUG "hpet: %s irq %d for MSI\n",
+			 dev->name, dev->irq);
+
 	return 0;
 }
 
