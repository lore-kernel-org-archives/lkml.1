Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbXBZE1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbXBZE1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 23:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933762AbXBZE1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 23:27:48 -0500
Received: from mail.kynisk.com ([89.149.220.217]:41558 "EHLO mail.kynisk.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933760AbXBZE1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 23:27:47 -0500
X-Greylist: delayed 1507 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Feb 2007 23:27:47 EST
Message-ID: <45E25BDC.2060505@kynisk.com>
Date: Mon, 26 Feb 2007 05:02:36 +0100
From: =?ISO-8859-1?Q?=D8yvind_Repvik?= <repvik@kynisk.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20-rc1-git1] siimage SIL 3512 support
Content-Type: multipart/mixed;
 boundary="------------000708030101040006020000"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000708030101040006020000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patch to enable SIL 3512 S-ATA controller, used in eg. QNAP TS-101 and 
TS-201 devices.

Signed-off-by: OEyvind Repvik <nail@nslu2-linux.org>

--------------000708030101040006020000
Content-Type: text/x-patch;
 name="001_sata-sil.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="001_sata-sil.diff"

Index: linux-2.6.21-rc1/drivers/ide/pci/siimage.c
===================================================================
--- linux-2.6.21-rc1.orig/drivers/ide/pci/siimage.c	2007-02-26 04:43:04.000000000 +0100
+++ linux-2.6.21-rc1/drivers/ide/pci/siimage.c	2007-02-26 04:45:01.000000000 +0100
@@ -50,6 +50,7 @@
 	switch(pdev->device)
 	{
 		case PCI_DEVICE_ID_SII_3112:
+		case PCI_DEVICE_ID_SII_3512:
 		case PCI_DEVICE_ID_SII_1210SA:
 			return 1;
 		case PCI_DEVICE_ID_SII_680:
@@ -1050,7 +1051,8 @@
 static ide_pci_device_t siimage_chipsets[] __devinitdata = {
 	/* 0 */ DECLARE_SII_DEV("SiI680"),
 	/* 1 */ DECLARE_SII_DEV("SiI3112 Serial ATA"),
-	/* 2 */ DECLARE_SII_DEV("Adaptec AAR-1210SA")
+	/* 2 */ DECLARE_SII_DEV("Adaptec AAR-1210SA"),
+	/* 3 */ DECLARE_SII_DEV("SiI3512 Serial ATA")
 };
 
 /**
@@ -1072,6 +1074,7 @@
 #ifdef CONFIG_BLK_DEV_IDE_SATA
 	{ PCI_VENDOR_ID_CMD, PCI_DEVICE_ID_SII_3112, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
 	{ PCI_VENDOR_ID_CMD, PCI_DEVICE_ID_SII_1210SA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
+	{ PCI_VENDOR_ID_CMD, PCI_DEVICE_ID_SII_3512, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
 #endif
 	{ 0, },
 };
Index: linux-2.6.21-rc1/include/linux/pci_ids.h
===================================================================
--- linux-2.6.21-rc1.orig/include/linux/pci_ids.h	2007-02-26 04:43:04.000000000 +0100
+++ linux-2.6.21-rc1/include/linux/pci_ids.h	2007-02-26 04:46:14.000000000 +0100
@@ -932,6 +932,7 @@
 #define PCI_DEVICE_ID_SII_680		0x0680
 #define PCI_DEVICE_ID_SII_3112		0x3112
 #define PCI_DEVICE_ID_SII_1210SA	0x0240
+#define PCI_DEVICE_ID_SII_3512		0x3512
 
 
 #define PCI_VENDOR_ID_BROOKTREE		0x109e

--------------000708030101040006020000--
