Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYLFQfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYLFQfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 11:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYLFQfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 11:35:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55172 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbYLFQfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 11:35:31 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 6 Dec 2008 17:35:20 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: ohci1394: pass error codes from request_irq through
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.2dd61cf916b60b34@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ohci1394.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux/drivers/ieee1394/ohci1394.c
===================================================================
--- linux.orig/drivers/ieee1394/ohci1394.c
+++ linux/drivers/ieee1394/ohci1394.c
@@ -3233,8 +3233,9 @@ static int __devinit ohci1394_pci_probe(
 	 * we need to get to that "no event", so enough should be initialized
 	 * by that point.
 	 */
-	if (request_irq(dev->irq, ohci_irq_handler, IRQF_SHARED,
-			 OHCI1394_DRIVER_NAME, ohci)) {
+	err = request_irq(dev->irq, ohci_irq_handler, IRQF_SHARED,
+			  OHCI1394_DRIVER_NAME, ohci);
+	if (err) {
 		PRINT_G(KERN_ERR, "Failed to allocate interrupt %d", dev->irq);
 		goto err;
 	}
@@ -3423,10 +3424,11 @@ static int ohci1394_pci_resume(struct pc
 	reg_write(ohci, OHCI1394_IntMaskClear, 0xffffffff);
 	mdelay(50);
 
-	if (request_irq(dev->irq, ohci_irq_handler, IRQF_SHARED,
-			OHCI1394_DRIVER_NAME, ohci)) {
+	err = request_irq(dev->irq, ohci_irq_handler, IRQF_SHARED,
+			  OHCI1394_DRIVER_NAME, ohci);
+	if (err) {
 		PRINT_G(KERN_ERR, "Failed to allocate interrupt %d", dev->irq);
-		return -EIO;
+		return err;
 	}
 
 	ohci_initialize(ohci);

-- 
Stefan Richter
-=====-==--- ==-- --==-
http://arcgraph.de/sr/

