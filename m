Return-Path: <linux-kernel-owner+w=401wt.eu-S1030270AbXAaQsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270AbXAaQsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030273AbXAaQsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:48:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60398 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030270AbXAaQsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:48:12 -0500
Date: Wed, 31 Jan 2007 17:00:28 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH]: mtd - fix a pci_find_device
Message-ID: <20070131170028.3a9bef3e@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Going over the bugs and warnings I found this one left over. The other
changes have already been correctly done for this driver but the actual
switch to pci_get_device that they assume has not.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/mtd/maps/ck804xrom.c linux-2.6.20-rc6-mm3/drivers/mtd/maps/ck804xrom.c
--- linux.vanilla-2.6.20-rc6-mm3/drivers/mtd/maps/ck804xrom.c	2007-01-31 14:19:55.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/mtd/maps/ck804xrom.c	2007-01-31 15:17:52.000000000 +0000
@@ -327,7 +327,7 @@
 	pdev = NULL;
 
 	for(id = ck804xrom_pci_tbl; id->vendor; id++) {
-		pdev = pci_find_device(id->vendor, id->device, NULL);
+		pdev = pci_get_device(id->vendor, id->device, NULL);
 		if (pdev)
 			break;
 	}
