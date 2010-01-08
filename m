Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379Ab0AHXrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0AHXrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219Ab0AHXrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:47:48 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42505 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0AHXrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:47:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 08 Jan 2010 15:46:33 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/5] x86: remove arch_probe_nr_irqs
In-reply-to: <1262994393-17391-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Message-id: <1262994393-17391-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262994393-17391-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so keep nr_irqs == NR_IRQS

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |   22 ----------------------
 1 file changed, 22 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3835,28 +3835,6 @@ void __init probe_nr_irqs_gsi(void)
 	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
 
-#ifdef CONFIG_SPARSE_IRQ
-int __init arch_probe_nr_irqs(void)
-{
-	int nr;
-
-	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
-		nr_irqs = NR_VECTORS * nr_cpu_ids;
-
-	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
-#if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
-	/*
-	 * for MSI and HT dyn irq
-	 */
-	nr += nr_irqs_gsi * 64;
-#endif
-	if (nr < nr_irqs)
-		nr_irqs = nr;
-
-	return 0;
-}
-#endif
-
 static int __io_apic_set_pci_routing(struct device *dev, int irq,
 				struct io_apic_irq_attr *irq_attr)
 {
