Return-Path: <linux-kernel-owner+w=401wt.eu-S1764677AbYA3UEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764677AbYA3UEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbYA3UBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:01:45 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40675 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757226AbYA3UBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:01:43 -0500
Date: Wed, 30 Jan 2008 22:02:17 +0200
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [2.6 patch] pci_bus_size_cardbus() mustn't be __devinit
Message-ID: <20080130200217.GP29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
WARNING: drivers/pci/built-in.o(.text+0x28e1f): Section mismatch in reference from the function pci_bus_size_bridges() to the function .devinit.text:pci_bus_size_cardbus()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
5049ae8012186114d885db973a04b2f0c45f93a2 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 401e03c..2cc957d 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -390,8 +390,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long
 	return 1;
 }
 
-static void __devinit
-pci_bus_size_cardbus(struct pci_bus *bus)
+static void pci_bus_size_cardbus(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
 	struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];

