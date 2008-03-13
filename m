Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYCMWas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYCMWas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbYCMW3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:29:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060AbYCMW3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:29:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IGJpSPwFaCDE6Ttfp0ZIbHRzxrUY86jzG5kNSeeoTTPJcZMQQSAzXpmd0nCmfQyhKIAF+YuRDxhLuchkG2g9M4h9bKniwZaSLZBnbAKeOa+wuHtrVXvJXjaJ+7g6DBkfNGZqBo7cmh7gFkieJb04IAzeQftCpaOHAP35YT36uEs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2008 23:44:12 +0100
Message-Id: <20080313224412.7051.9681.sendpatchset@localhost.localdomain>
In-Reply-To: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
References: <20080313224352.7051.44005.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/12] aec62xx: add "pci_clock=" parameter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "pci_clock=" parameter for specifying PCI bus clock frequency (in MHz).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/aec62xx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -13,6 +13,8 @@
 
 #include <asm/io.h>
 
+static int pci_clock;
+
 struct chipset_bus_clock_list_entry {
 	u8 xfer_speed;
 	u8 chipset_settings;
@@ -140,7 +142,7 @@ static void aec_set_pio_mode(ide_drive_t
 
 static unsigned int __devinit init_chipset_aec62xx(struct pci_dev *dev, const char *name)
 {
-	int bus_speed = system_bus_clock();
+	int bus_speed = pci_clock ? pci_clock : system_bus_clock();
 
 	if (bus_speed <= 33)
 		pci_set_drvdata(dev, (void *) aec6xxx_33_base);
@@ -308,6 +310,9 @@ static int __init aec62xx_ide_init(void)
 
 module_init(aec62xx_ide_init);
 
+module_param(pci_clock, int, 0);
+MODULE_PARM_DESC(pci_clock, "PCI bus clock frequency (in MHz)");
+
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for ARTOP AEC62xx IDE");
 MODULE_LICENSE("GPL");
