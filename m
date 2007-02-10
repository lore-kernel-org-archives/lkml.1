Return-Path: <linux-kernel-owner+w=401wt.eu-S933406AbXBJMDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbXBJMDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbXBJMDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:03:12 -0500
Received: from ns1.suse.de ([195.135.220.2]:50226 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933346AbXBJLu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:28 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Andrew Morton <akpm@osdl.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [5/25] i386: revert i386-fix-the-verify_quirk_intel_irqbalance
Message-Id: <20070210115017.73E6013DD5@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:17 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andrew Morton <akpm@osdl.org>

This is unneeded with Ingo's genapic rework.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/quirks.c |   33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

Index: linux/arch/i386/kernel/quirks.c
===================================================================
--- linux.orig/arch/i386/kernel/quirks.c
+++ linux/arch/i386/kernel/quirks.c
@@ -10,38 +10,13 @@
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 static void __devinit verify_quirk_intel_irqbalance(struct pci_dev *dev)
 {
-	u8 config, rev;
-	u32 word;
-
-	/* BIOS may enable hardware IRQ balancing for
-	 * E7520/E7320/E7525(revision ID 0x9 and below)
-	 * based platforms.
-	 * For those platforms, make sure that the genapic is set to 'flat'
-	 */
-	pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
-	if (rev > 0x9)
-		return;
-
-	/* enable access to config space*/
-	pci_read_config_byte(dev, 0xf4, &config);
-	pci_write_config_byte(dev, 0xf4, config|0x2);
-
-	/* read xTPR register */
-	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
-
-	if (!(word & (1 << 13))) {
 #ifdef CONFIG_X86_64
-		if (genapic !=  &apic_flat)
-			panic("APIC mode must be flat on this system\n");
+	if (genapic !=  &apic_flat)
+		panic("APIC mode must be flat on this system\n");
 #elif defined(CONFIG_X86_GENERICARCH)
-		if (genapic != &apic_default)
-			panic("APIC mode must be default(flat) on this system. Use apic=default\n");
+	if (genapic != &apic_default)
+		panic("APIC mode must be default(flat) on this system. Use apic=default\n");
 #endif
-	}
-
-	/* put back the original value for config space*/
-	if (!(config & 0x2))
-		pci_write_config_byte(dev, 0xf4, config);
 }
 
 void __init quirk_intel_irqbalance(void)
