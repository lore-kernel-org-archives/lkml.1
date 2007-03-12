Return-Path: <linux-kernel-owner+w=401wt.eu-S965480AbXCLJ7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480AbXCLJ7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXCLJ7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:59:16 -0400
Received: from mga06.intel.com ([134.134.136.21]:47709 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965452AbXCLJ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:59:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,274,1170662400"; 
   d="scan'208"; a="207908982:sNHT21711858"
Message-Id: <20070312095911.842948000@linux.intel.com>
References: <20070312093128.577087000@linux.intel.com>
User-Agent: quilt/0.45-1
Date: Mon, 12 Mar 2007 02:59:30 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Val Henson <val_henson@linux.intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 2/4] [TULIP]  Quiet down tulip_stop_rxtx
Content-Disposition: inline; filename=tulip-quiet-stop-rxtx
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Only print out debugging info for tulip_stop_rxtx if debug is on.
Many cards (including at least two of my own) fail to stop properly
during initialization according to this test with no apparent ill
effects.  Worse, it tends to spam logs when the driver doesn't work.

Signed-off-by: Val Henson <val_henson@linux.intel.com>
Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
Cc: Jeff Garzik <jeff@garzik.org>

---
 drivers/net/tulip/tulip.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- tulip-2.6-mm-linux.orig/drivers/net/tulip/tulip.h
+++ tulip-2.6-mm-linux/drivers/net/tulip/tulip.h
@@ -481,7 +481,7 @@ static inline void tulip_stop_rxtx(struc
 		while (--i && (ioread32(ioaddr + CSR5) & (CSR5_TS|CSR5_RS)))
 			udelay(10);
 
-		if (!i)
+		if (!i && (tulip_debug > 1))
 			printk(KERN_DEBUG "%s: tulip_stop_rxtx() failed"
 					" (CSR5 0x%x CSR6 0x%x)\n",
 					pci_name(tp->pdev),

--
