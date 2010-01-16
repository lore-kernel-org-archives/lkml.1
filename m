Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab0APDLO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809Ab0APDKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:10:07 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33975 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857Ab0APDIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:08:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 19:07:02 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 31/37] x86: remove arch_probe_nr_irqs
In-reply-to: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263611228-6751-32-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so keep nr_irqs == NR_IRQS

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d5bfa29..3beaf80 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
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
-- 
1.6.4.2

