Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYI0DMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYI0DMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 23:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYI0DMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 23:12:06 -0400
Received: from mga10.intel.com ([192.55.52.92]:23417 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751475AbYI0DMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 23:12:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,317,1220252400"; 
   d="scan'208";a="384951247"
Subject: [PATCH] merge the define of PCI_CFG_SPACE_SIZE
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Greg KH <greg@kroah.com>, jbarnes@virtuousgeek.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 27 Sep 2008 11:08:53 +0800
Message-Id: <1222484933.25574.35.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: pci: merge define of PCI_CFG_SPACE_SIZE
﻿From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>

3 files define PCI_CFG_SPACE_SIZE. Move the define to file
pci_regs.h.

﻿Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6.27-rc7/drivers/pci/pcie/aer/aerdrv_core.c linux-2.6.27-rc7_cleanup/drivers/pci/pcie/aer/aerdrv_core.c
--- linux-2.6.27-rc7/drivers/pci/pcie/aer/aerdrv_core.c	2008-09-27 09:35:32.000000000 +0800
+++ linux-2.6.27-rc7_cleanup/drivers/pci/pcie/aer/aerdrv_core.c	2008-09-27 10:29:57.000000000 +0800
@@ -28,7 +28,6 @@
 static int forceload;
 module_param(forceload, bool, 0);
 
-#define PCI_CFG_SPACE_SIZE	(0x100)
 int pci_find_aer_capability(struct pci_dev *dev)
 {
 	int pos;
diff -Nraup linux-2.6.27-rc7/drivers/pci/pcie/portdrv.h linux-2.6.27-rc7_cleanup/drivers/pci/pcie/portdrv.h
--- linux-2.6.27-rc7/drivers/pci/pcie/portdrv.h	2008-07-14 05:51:29.000000000 +0800
+++ linux-2.6.27-rc7_cleanup/drivers/pci/pcie/portdrv.h	2008-09-27 10:29:38.000000000 +0800
@@ -25,7 +25,6 @@
 #define PCIE_CAPABILITIES_REG		0x2
 #define PCIE_SLOT_CAPABILITIES_REG	0x14
 #define PCIE_PORT_DEVICE_MAXSERVICES	4
-#define PCI_CFG_SPACE_SIZE		256
 
 #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
 
diff -Nraup linux-2.6.27-rc7/drivers/pci/probe.c linux-2.6.27-rc7_cleanup/drivers/pci/probe.c
--- linux-2.6.27-rc7/drivers/pci/probe.c	2008-09-27 09:35:32.000000000 +0800
+++ linux-2.6.27-rc7_cleanup/drivers/pci/probe.c	2008-09-27 10:42:30.000000000 +0800
@@ -14,8 +14,6 @@
 
 #define CARDBUS_LATENCY_TIMER	176	/* secondary latency timer */
 #define CARDBUS_RESERVE_BUSNR	3
-#define PCI_CFG_SPACE_SIZE	256
-#define PCI_CFG_SPACE_EXP_SIZE	4096
 
 /* Ugh.  Need to stop exporting this to modules. */
 LIST_HEAD(pci_root_buses);
diff -Nraup linux-2.6.27-rc7/include/linux/pci_regs.h linux-2.6.27-rc7_cleanup/include/linux/pci_regs.h
--- linux-2.6.27-rc7/include/linux/pci_regs.h	2008-09-27 09:35:35.000000000 +0800
+++ linux-2.6.27-rc7_cleanup/include/linux/pci_regs.h	2008-09-27 10:37:34.000000000 +0800
@@ -421,6 +421,10 @@
 #define PCI_EXP_RTSTA		32	/* Root Status */
 
 /* Extended Capabilities (PCI-X 2.0 and Express) */
+/* pci space size & Ext cap start offset */
+#define PCI_CFG_SPACE_SIZE		(256)
+#define PCI_CFG_SPACE_EXP_SIZE		(4096) /* pci ext space size */
+
 #define PCI_EXT_CAP_ID(header)		(header & 0x0000ffff)
 #define PCI_EXT_CAP_VER(header)		((header >> 16) & 0xf)
 #define PCI_EXT_CAP_NEXT(header)	((header >> 20) & 0xffc)


