Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbXIUF2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbXIUF2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 01:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXIUF2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 01:28:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:46880 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbXIUF2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 01:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer;
        b=UZUV6duK9LRd1ajvdOtD/F435we0FJJLmr/lgf9PSwiks19aBleiNFwxm+fSneCWzffQF/SnrluQ75Z40EWKw0aKmQAbINQvm4Y9xk/Gne/nZ989NvL4Uuojq19IBxQpuk5vT/PQOqTFrAf+W0cqNjVs5HMeQK1wsOw1R7eE5xk=
Date: Fri, 21 Sep 2007 13:28:01 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "jeff" <jeff@garzik.org>, "akpm" <akpm@linux-foundation.org>,
       "linux-ide" <linux-ide@vger.kernel.org>
Subject: [PATCH] ahci: enable GHC.AE bit before set GHC.HR
Message-ID: <200709211327569648280@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According to the description of section 5.2.2.1 and 10.1.2 of AHCI specification rev1_1/rev1_2, GHC.HR shall only be set to ¡®1¡¯
by software when GHC.AE is set to ¡®1¡¯.

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.23-rc7/drivers/ata/ahci.c.orig	2007-09-20 11:01:55.000000000 -0400
+++ linux-2.6.23-rc7/drivers/ata/ahci.c	2007-09-20 11:07:31.000000000 -0400
@@ -834,6 +834,10 @@ static int ahci_reset_controller(struct 
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 	u32 tmp;
 
+        /* turn on AHCI mode before controller reset*/
+        writel(HOST_AHCI_EN, mmio + HOST_CTL);
+        (void) readl(mmio + HOST_CTL);  /* flush */
+
 	/* global controller reset */
 	tmp = readl(mmio + HOST_CTL);
 	if ((tmp & HOST_RESET) == 0) {
-
 				
--------------
Peer Chen
2007-09-21

