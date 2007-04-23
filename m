Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbXDWNwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbXDWNwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXDWNwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:52:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40363 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753640AbXDWNwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:52:23 -0400
Date: Mon, 23 Apr 2007 14:56:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: paulus@samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] via-pmu: Switch to ref counting PCI API
Message-ID: <20070423145601.6b37585b@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/macintosh/via-pmu.c linux-2.6.21-rc6-mm1/drivers/macintosh/via-pmu.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/macintosh/via-pmu.c	2007-04-12 14:15:04.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/macintosh/via-pmu.c	2007-04-23 11:44:53.907384888 +0100
@@ -2130,7 +2130,7 @@
 	int ret;
 	struct pci_dev *grackle;
 
-	grackle = pci_find_slot(0, 0);
+	grackle = pci_get_bus_and_slot(0, 0);
 	if (!grackle)
 		return -ENODEV;
 
@@ -2177,6 +2177,8 @@
 	pci_read_config_word(grackle, 0x70, &pmcr1);
 	pmcr1 &= ~(GRACKLE_PM|GRACKLE_DOZE|GRACKLE_SLEEP|GRACKLE_NAP); 
 	pci_write_config_word(grackle, 0x70, pmcr1);
+	
+	pci_dev_put(grackle);
 
 	/* Make sure the PMU is idle */
 	pmac_call_feature(PMAC_FTR_SLEEP_STATE,NULL,0,0);
