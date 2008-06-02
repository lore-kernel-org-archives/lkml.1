Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbYFBOQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbYFBOQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758007AbYFBOQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:16:44 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:45422 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbYFBOQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:16:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix context assertion in ssb_pcicore_dev_irqvecs_enable
Date: Mon, 2 Jun 2008 16:15:23 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Arjan van de Ven <arjan@infradead.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021615.23710.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a context assertion in ssb that makes b44 print
out warnings on resume.

This fixes the following kernel oops:
http://www.kerneloops.org/oops.php?number=12732
http://www.kerneloops.org/oops.php?number=11410

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply to 2.6.26.

Index: wireless-testing/drivers/ssb/driver_pcicore.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_pcicore.c	2008-06-02 16:09:55.000000000 +0200
+++ wireless-testing/drivers/ssb/driver_pcicore.c	2008-06-02 16:09:59.000000000 +0200
@@ -537,12 +537,12 @@ int ssb_pcicore_dev_irqvecs_enable(struc
 	int err = 0;
 	u32 tmp;
 
-	might_sleep();
-
 	if (!pdev)
 		goto out;
 	bus = pdev->bus;
 
+	might_sleep_if(pdev->id.coreid != SSB_DEV_PCI);
+
 	/* Enable interrupts for this device. */
 	if (bus->host_pci &&
 	    ((pdev->id.revision >= 6) || (pdev->id.coreid == SSB_DEV_PCIE))) {

-- 
Greetings Michael.
