Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYFBUX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYFBUX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYFBUV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:21:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:17242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYFBUV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:21:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=xltwUKeA3mDFQEhOXBHSW4IFElWweqxBKB7vaNcMO0CID+ilQ1ajhW3QgR+dMvDUooB2kQF9IFzEMujxo3j/7KdxQ/Gxpg1lQ+k4FJckbCtm/+rkiVGsrPxFvB5Eu59JniBp3+F7fcA2R7yvtpx7qnypDusoPDdkQmBEulrvlrU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Jun 2008 22:23:26 +0200
Message-Id: <20080602202326.7265.15042.sendpatchset@localhost.localdomain>
In-Reply-To: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
References: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/9] delkin_cb: add warm-plug support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't fail the probe if there are no devices attached to the controller.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/delkin_cb.c |    4 ----
 1 file changed, 4 deletions(-)

Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -99,15 +99,11 @@ delkin_cb_probe (struct pci_dev *dev, co
 
 	ide_device_add(idx, &delkin_cb_port_info);
 
-	if (!hwif->present)
-		goto out_disable;
-
 	pci_set_drvdata(dev, hwif);
 
 	return 0;
 
 out_disable:
-	printk(KERN_ERR "delkin_cb: no IDE devices found\n");
 	pci_release_regions(dev);
 	pci_disable_device(dev);
 	return -ENODEV;
