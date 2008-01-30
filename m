Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbYA3LN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbYA3LN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbYA3LNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:13:18 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:44488 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbYA3LNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:13:17 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/2] Char: applicom, use pci_resource_start
Date: Wed, 30 Jan 2008 12:13:14 +0100
Message-Id: <1201691595-11448-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080128054917.GA10504@hacking>
References: <20080128054917.GA10504@hacking>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pci_resource_start instead of accessing pci_dev struct internals.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/applicom.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 1f0b752..b0bb71b 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -206,22 +206,23 @@ static int __init applicom_init(void)
 		if (pci_enable_device(dev))
 			return -EIO;
 
-		RamIO = ioremap(dev->resource[0].start, LEN_RAM_IO);
+		RamIO = ioremap(pci_resource_start(dev, 0), LEN_RAM_IO);
 
 		if (!RamIO) {
 			printk(KERN_INFO "ac.o: Failed to ioremap PCI memory "
 				"space at 0x%llx\n",
-				(unsigned long long)dev->resource[0].start);
+				(unsigned long long)pci_resource_start(dev, 0));
 			pci_disable_device(dev);
 			return -EIO;
 		}
 
 		printk(KERN_INFO "Applicom %s found at mem 0x%llx, irq %d\n",
 		       applicom_pci_devnames[dev->device-1],
-			   (unsigned long long)dev->resource[0].start,
+			   (unsigned long long)pci_resource_start(dev, 0),
 		       dev->irq);
 
-		boardno = ac_register_board(dev->resource[0].start, RamIO,0);
+		boardno = ac_register_board(pci_resource_start(dev, 0),
+				RamIO, 0);
 		if (!boardno) {
 			printk(KERN_INFO "ac.o: PCI Applicom device doesn't have correct signature.\n");
 			iounmap(RamIO);
-- 
1.5.3.8

