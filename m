Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbXBTBFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbXBTBFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbXBTBFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:05:01 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:25979 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbXBTBE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:04:56 -0500
Date: Mon, 19 Feb 2007 19:01:59 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH 1/5] sata_nv: Add CPB register info to error_handler output
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45DA4887.1060705@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When error handling occurs with pending commands, output the contents
of the next CPB count and next CPB index registers as well as the others,
since these may be useful for debugging.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.20-git6edit/drivers/ata/sata_nv.c	2007-02-15 22:36:02.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/sata_nv.c.delayandfixes	2007-02-19 17:00:14.000000000 -0600
@@ -1462,10 +1461,14 @@ static void nv_adma_error_handler(struct
 			u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
 			u32 gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
 			u32 status = readw(mmio + NV_ADMA_STAT);
+			u8 cpb_count = readb(mmio + NV_ADMA_CPB_COUNT);
+			u8 next_cpb_idx = readb(mmio + NV_ADMA_NEXT_CPB_IDX);
 
 			ata_port_printk(ap, KERN_ERR, "EH in ADMA mode, notifier 0x%X "
-				"notifier_error 0x%X gen_ctl 0x%X status 0x%X\n",
-				notifier, notifier_error, gen_ctl, status);
+				"notifier_error 0x%X gen_ctl 0x%X status 0x%X "
+				"next cpb count 0x%X next cpb idx 0x%x\n",
+				notifier, notifier_error, gen_ctl, status,
+				cpb_count, next_cpb_idx);
 
 			for( i=0;i<NV_ADMA_MAX_CPBS;i++) {
 				struct nv_adma_cpb *cpb = &pp->cpb[i];

