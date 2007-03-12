Return-Path: <linux-kernel-owner+w=401wt.eu-S965461AbXCLJ7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461AbXCLJ7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXCLJ7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:59:18 -0400
Received: from mga06.intel.com ([134.134.136.21]:15727 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965461AbXCLJ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:59:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,274,1170662400"; 
   d="scan'208"; a="207908985:sNHT21499576"
Message-Id: <20070312095912.309990000@linux.intel.com>
References: <20070312093128.577087000@linux.intel.com>
User-Agent: quilt/0.45-1
Date: Mon, 12 Mar 2007 02:59:31 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Valerie Henson <val_henson@linux.intel.com>, Jeff Garzik <jeff@garzik.org>
Subject: [patch 3/4] [TULIP]  Fix SytemError typo
Content-Disposition: inline; filename=tulip-system-error-typo
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an annoying typo - SytemError -> SystemError

Signed-off-by: Valerie Henson <val_henson@linux.intel.com>
Cc: Jeff Garzik <jeff@garzik.org>

---
 drivers/net/tulip/interrupt.c   |    4 ++--
 drivers/net/tulip/tulip.h       |    2 +-
 drivers/net/tulip/winbond-840.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- tulip-2.6-mm-linux.orig/drivers/net/tulip/interrupt.c
+++ tulip-2.6-mm-linux/drivers/net/tulip/interrupt.c
@@ -675,7 +675,7 @@ irqreturn_t tulip_interrupt(int irq, voi
 				if (tp->link_change)
 					(tp->link_change)(dev, csr5);
 			}
-			if (csr5 & SytemError) {
+			if (csr5 & SystemError) {
 				int error = (csr5 >> 23) & 7;
 				/* oops, we hit a PCI error.  The code produced corresponds
 				 * to the reason:
@@ -745,7 +745,7 @@ irqreturn_t tulip_interrupt(int irq, voi
 			  TxFIFOUnderflow |
 			  TxJabber |
 			  TPLnkFail |
-			  SytemError )) != 0);
+			  SystemError )) != 0);
 #else
 	} while ((csr5 & (NormalIntr|AbnormalIntr)) != 0);
 
--- tulip-2.6-mm-linux.orig/drivers/net/tulip/tulip.h
+++ tulip-2.6-mm-linux/drivers/net/tulip/tulip.h
@@ -132,7 +132,7 @@ enum pci_cfg_driver_reg {
 /* The bits in the CSR5 status registers, mostly interrupt sources. */
 enum status_bits {
 	TimerInt = 0x800,
-	SytemError = 0x2000,
+	SystemError = 0x2000,
 	TPLnkFail = 0x1000,
 	TPLnkPass = 0x10,
 	NormalIntr = 0x10000,
--- tulip-2.6-mm-linux.orig/drivers/net/tulip/winbond-840.c
+++ tulip-2.6-mm-linux/drivers/net/tulip/winbond-840.c
@@ -1148,7 +1148,7 @@ static irqreturn_t intr_handler(int irq,
 		}
 
 		/* Abnormal error summary/uncommon events handlers. */
-		if (intr_status & (AbnormalIntr | TxFIFOUnderflow | SytemError |
+		if (intr_status & (AbnormalIntr | TxFIFOUnderflow | SystemError |
 						   TimerInt | TxDied))
 			netdev_error(dev, intr_status);
 

--
