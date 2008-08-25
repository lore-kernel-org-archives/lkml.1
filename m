Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYHYWCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYHYWCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbYHYWBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:01:46 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9582 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbYHYWBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:01:45 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 1/5] x86/PCI: follow lspci device/vendor style
To: linux-kernel@vger.kernel.org
Date: Mon, 25 Aug 2008 16:01:43 -0600
Message-ID: <20080825220143.19210.41035.stgit@tigger.helgaas>
In-Reply-To: <20080825220137.19210.41857.stgit@tigger.helgaas>
References: <20080825220137.19210.41857.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format
used by lspci(8).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/pci/irq.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 8e07718..9e7c862 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -493,7 +493,7 @@ static int pirq_amd756_get(struct pci_dev *router, struct pci_dev *dev, int pirq
 	if (pirq <= 4)
 		irq = read_config_nybble(router, 0x56, pirq - 1);
 	dev_info(&dev->dev,
-		 "AMD756: dev [%04x/%04x], router PIRQ %d get IRQ %d\n",
+		 "AMD756: dev [%04x:%04x], router PIRQ %d get IRQ %d\n",
 		 dev->vendor, dev->device, pirq, irq);
 	return irq;
 }
@@ -501,7 +501,7 @@ static int pirq_amd756_get(struct pci_dev *router, struct pci_dev *dev, int pirq
 static int pirq_amd756_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
 {
 	dev_info(&dev->dev,
-		 "AMD756: dev [%04x/%04x], router PIRQ %d set IRQ %d\n",
+		 "AMD756: dev [%04x:%04x], router PIRQ %d set IRQ %d\n",
 		 dev->vendor, dev->device, pirq, irq);
 	if (pirq <= 4)
 		write_config_nybble(router, 0x56, pirq - 1, irq);
@@ -823,7 +823,7 @@ static void __init pirq_find_router(struct irq_router *r)
 	r->get = NULL;
 	r->set = NULL;
 
-	DBG(KERN_DEBUG "PCI: Attempting to find IRQ router for %04x:%04x\n",
+	DBG(KERN_DEBUG "PCI: Attempting to find IRQ router for [%04x:%04x]\n",
 	    rt->rtr_vendor, rt->rtr_device);
 
 	pirq_router_dev = pci_get_bus_and_slot(rt->rtr_bus, rt->rtr_devfn);
@@ -843,7 +843,7 @@ static void __init pirq_find_router(struct irq_router *r)
 			h->probe(r, pirq_router_dev, pirq_router_dev->device))
 			break;
 	}
-	dev_info(&pirq_router_dev->dev, "%s IRQ router [%04x/%04x]\n",
+	dev_info(&pirq_router_dev->dev, "%s IRQ router [%04x:%04x]\n",
 		 pirq_router.name,
 		 pirq_router_dev->vendor, pirq_router_dev->device);
 

