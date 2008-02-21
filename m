Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYBUGNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYBUGNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYBUGN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:13:29 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:49406 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYBUGN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:13:28 -0500
Date: Wed, 20 Feb 2008 22:21:57 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: remove unneeded check in mmconf reject
To: Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Message-id: <200802202221.57699.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mmconfig is only used to access ext conf space.
so don't need to reject MFG that only have one entry and only handle bus0

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
+++ linux-2.6/arch/x86/pci/mmconfig-shared.c
@@ -308,18 +308,6 @@ static void __init pci_mmcfg_reject_brok
 
 	cfg = &pci_mmcfg_config[0];
 
-	/*
-	 * Handle more broken MCFG tables on Asus etc.
-	 * They only contain a single entry for bus 0-0.
-	 */
-	if (pci_mmcfg_config_num == 1 &&
-	    cfg->pci_segment == 0 &&
-	    (cfg->start_bus_number | cfg->end_bus_number) == 0) {
-		printk(KERN_ERR "PCI: start and end of bus number is 0. "
-		       "Rejected as broken MCFG.\n");
-		goto reject;
-	}
-
 	for (i = 0; i < pci_mmcfg_config_num; i++) {
 		int valid = 0;
 		u32 size = (cfg->end_bus_number + 1) << 20;
