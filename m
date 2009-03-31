Return-Path: <linux-kernel-owner+w=401wt.eu-S1761961AbZCaP2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961AbZCaP2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762364AbZCaPYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:24:10 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15194 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762260AbZCaPYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:24:08 -0400
Subject: [PATCH 12/15] PCI Hotplug: cpqphp: eliminate dead code -
	PCI_ScanBusNonBridge
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:24:07 -0600
Message-ID: <20090331152407.26622.73807.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no clue what the original intent here was, but the code as
written is useless.

The old dbg() statement above the old callsite might lead one to think
that at one point, there was supposed to be some recursion, but any
sense of sanity here has been lost to the ravages of time.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp_pci.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 6201281..3e3acc7 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -193,16 +193,6 @@ int cpqhp_set_irq (u8 bus_num, u8 dev_num, u8 int_pin, u8 irq_num)
 }
 
 
-/*
- * WTF??? This function isn't in the code, yet a function calls it, but the
- * compiler optimizes it away?  strange.  Here as a placeholder to keep the
- * compiler happy.
- */
-static int PCI_ScanBusNonBridge (u8 bus, u8 device)
-{
-	return 0;
-}
-
 static int PCI_ScanBusForNonBridge(struct controller *ctrl, u8 bus_num, u8 * dev_num)
 {
 	u16 tdevice;
@@ -231,9 +221,9 @@ static int PCI_ScanBusForNonBridge(struct controller *ctrl, u8 bus_num, u8 * dev
 		/* Yep we got one. bridge ? */
 		if ((work >> 8) == PCI_TO_PCI_BRIDGE_CLASS) {
 			pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(tdevice, 0), PCI_SECONDARY_BUS, &tbus);
+			/* XXX: no recursion, wtf? */
 			dbg("Recurse on bus_num %d tdevice %d\n", tbus, tdevice);
-			if (PCI_ScanBusNonBridge(tbus, tdevice) == 0)
-				return 0;
+			return 0;
 		}
 	}
 

