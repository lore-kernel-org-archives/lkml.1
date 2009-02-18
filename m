Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZBRQUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZBRQUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbZBRQT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:19:59 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:31627 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZBRQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:19:58 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH] x86: use dev_printk in quirk message
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Date: Wed, 18 Feb 2009 09:19:57 -0700
Message-ID: <20090218161957.12773.31822.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes a VIA PCI quirk to use dev_info() rather than printk().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/x86/kernel/pci-dma.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b254285..022833b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -290,8 +290,7 @@ fs_initcall(pci_iommu_init);
 static __devinit void via_no_dac(struct pci_dev *dev)
 {
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
-		printk(KERN_INFO
-			"PCI: VIA PCI bridge detected. Disabling DAC.\n");
+		dev_info(&dev->dev, "disabling DAC on VIA PCI bridge\n");
 		forbid_dac = 1;
 	}
 }

