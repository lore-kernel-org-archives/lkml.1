Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbXDWOFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbXDWOFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 10:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbXDWOFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 10:05:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45459 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753994AbXDWOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 10:05:24 -0400
Date: Mon, 23 Apr 2007 15:08:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: driver-support@fabric7.com, linux-kernel@vger.kernel.org
Subject: [PATCH] vioc_irq: Switch to pci refcount safe API
Message-ID: <20070423150855.67c3c849@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/net/vioc/vioc_irq.c linux-2.6.21-rc6-mm1/drivers/net/vioc/vioc_irq.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/net/vioc/vioc_irq.c	2007-04-12 14:15:05.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/net/vioc/vioc_irq.c	2007-04-23 12:01:53.354405384 +0100
@@ -233,8 +233,10 @@
 
 	devfn = PCI_DEVFN(slot, func);
 	/* Find pci_dev structure of the requested function */
-	dev = pci_find_slot(dev_in->bus->number, devfn);
+	dev = pci_get_bus_and_slot(dev_in->bus->number, devfn);
 	if (dev) {
+		int irq = dev->irq
+		pci_dev_put(dev);
 		return irq;
 	} else {
 		return VIOC_IRQ_NONE;
