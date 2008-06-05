Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbYFESvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbYFESvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYFESvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:51:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36324 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYFESvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:51:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 5 Jun 2008 20:50:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: write selfIDBufferPtr before
 LinkControl.rcvSelfID
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.8c942d590ea22fd3@s5r6.in-berlin.de>
Message-ID: <tkrat.999def4a37c1ecd9@s5r6.in-berlin.de>
References: <tkrat.1dfeb5ce5dd30360@s5r6.in-berlin.de>
 <tkrat.8c942d590ea22fd3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OHCI 1.1 clause 5.10 requires that selfIDBufferPtr is valid when a 1 is
written into LinkControl.rcvSelfID.

This driver bug has so far not been known to cause harm because most
chips obviously accept a later selfIDBufferPtr write.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -1473,6 +1473,7 @@ static int ohci_enable(struct fw_card *c
 	reg_write(ohci, OHCI1394_HCControlClear,
 		  OHCI1394_HCControl_noByteSwapData);
 
+	reg_write(ohci, OHCI1394_SelfIDBuffer, ohci->self_id_bus);
 	reg_write(ohci, OHCI1394_LinkControlClear,
 		  OHCI1394_LinkControl_rcvPhyPkt);
 	reg_write(ohci, OHCI1394_LinkControlSet,
@@ -1488,7 +1489,6 @@ static int ohci_enable(struct fw_card *c
 	ar_context_run(&ohci->ar_request_ctx);
 	ar_context_run(&ohci->ar_response_ctx);
 
-	reg_write(ohci, OHCI1394_SelfIDBuffer, ohci->self_id_bus);
 	reg_write(ohci, OHCI1394_PhyUpperBound, 0x00010000);
 	reg_write(ohci, OHCI1394_IntEventClear, ~0);
 	reg_write(ohci, OHCI1394_IntMaskClear, ~0);

-- 
Stefan Richter
-=====-==--- -==- --=-=
http://arcgraph.de/sr/

