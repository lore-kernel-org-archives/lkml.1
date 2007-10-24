Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbXJXCoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbXJXCoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXJXCoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:44:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:34736 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbXJXCoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:44:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,322,1188802800"; 
   d="scan'208";a="356462602"
Subject: [patch] pcie port driver: correctly detect native PME feature
From: Shaohua Li <shaohua.li@intel.com>
To: linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 10:43:23 +0800
Message-Id: <1193193803.27150.13.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Native PME is capability of root port or root complex event collector.
It's not determined by PCI PME capability.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/pci/pcie/portdrv_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux.orig/drivers/pci/pcie/portdrv_core.c	2007-10-22 09:36:05.000000000 +0800
+++ linux/drivers/pci/pcie/portdrv_core.c	2007-10-22 09:41:25.000000000 +0800
@@ -192,9 +192,8 @@ static int get_port_device_capability(st
 		if (reg32 & SLOT_HP_CAPABLE_MASK)
 			services |= PCIE_PORT_SERVICE_HP;
 	} 
-	/* PME Capable */
-	pos = pci_find_capability(dev, PCI_CAP_ID_PME);
-	if (pos) 
+	/* PME Capable - root port capability */
+	if (((reg16 >> 4) & PORT_TYPE_MASK) == PCIE_RC_PORT)
 		services |= PCIE_PORT_SERVICE_PME;
 	
 	pos = PCI_CFG_SPACE_SIZE;
