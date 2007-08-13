Return-Path: <linux-kernel-owner+w=401wt.eu-S948150AbXHMPL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948150AbXHMPL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945700AbXHMMxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:53:51 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:58331 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S945691AbXHMMxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:53:49 -0400
Subject: [kj] is_power_of_2 in drivers/pci/pci.c
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vigneshbabu@gmail.com
To: gregkh@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Mon, 13 Aug 2007 18:23:14 +0530
Message-Id: <1187009594.7273.4.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
X-OriginalArrivalTime: 13 Aug 2007 12:54:08.0852 (UTC) FILETIME=[09E45940:01C7DDA9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing n & (n - 1) for power of 2 check by is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
---
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 37c00f6..19a64a3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
+#include <linux/log2.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
 
@@ -1454,7 +1455,7 @@ int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc)
 	int cap, err = -EINVAL;
 	u32 stat, cmd, v, o;
 
-	if (mmrbc < 512 || mmrbc > 4096 || (mmrbc & (mmrbc-1)))
+	if (mmrbc < 512 || mmrbc > 4096 || !is_power_of_2(mmrbc))
 		goto out;
 
 	v = ffs(mmrbc) - 10;
@@ -1526,7 +1527,7 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 	int cap, err = -EINVAL;
 	u16 ctl, v;
 
-	if (rq < 128 || rq > 4096 || (rq & (rq-1)))
+	if (rq < 128 || rq > 4096 || !is_power_of_2(rq))
 		goto out;
 
 	v = (ffs(rq) - 8) << 12;

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

