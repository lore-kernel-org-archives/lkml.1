Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbYGFRkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbYGFRkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYGFRfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:13310 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106AbYGFRe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=c0JTw9taf5uZ0VkUi786GpzUxJ7ErKC20RrEeJN0+++pK5jhDIDaatidM65w/pcO+/
         AL0q0qqAD/Vv2IuJCrwc8du59AvoGBlxfyn6ew1jsazdyTde4qWDvLalSJnvH+1vlwbA
         0krP0/x3TlyNym5A3iyC3VVbAYJusEXxinfYk=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:26 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 16/50] cmd64x: cleanup ->init_chipset method
Content-Disposition: inline; filename=cmd64x-cleanup-init_chipset-method.patch
Message-ID: <48710240.1ade660a.3458.628d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove verbose reporting for CMD646 (PCI device revision is always
logged by IDE PCI layer).

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd64x.c |   18 ------------------
 1 file changed, 18 deletions(-)

Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -334,24 +334,6 @@ static unsigned int __devinit init_chips
 {
 	u8 mrdmode = 0;
 
-	if (dev->device == PCI_DEVICE_ID_CMD_646) {
-
-		switch (dev->revision) {
-		case 0x07:
-		case 0x05:
-			printk("%s: UltraDMA capable\n", name);
-			break;
-		case 0x03:
-		default:
-			printk("%s: MultiWord DMA force limited\n", name);
-			break;
-		case 0x01:
-			printk("%s: MultiWord DMA limited, "
-			       "IRQ workaround enabled\n", name);
-			break;
-		}
-	}
-
 	/* Set a good latency timer and cache line size value. */
 	(void) pci_write_config_byte(dev, PCI_LATENCY_TIMER, 64);
 	/* FIXME: pci_set_master() to ensure a good latency timer value */

-- 

