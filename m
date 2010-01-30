Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235Ab0A3QhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0A3QhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 11:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786Ab0A3QhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 11:37:23 -0500
Received: from kolab.mylinuxtime.de ([80.190.48.10]:47056 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab0A3QhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 11:37:22 -0500
X-Greylist: delayed 1822 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jan 2010 11:37:22 EST
X-Spam-ASN: 
From: Christian Hesse <mail@earthworm.de>
To: linux-kernel@vger.kernel.org
Subject: Samsung N220 backlight support
Date: Sat, 30 Jan 2010 17:06:18 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-ARCH; KDE/4.3.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6jFZLVYbxeTddPF"
Message-Id: <201001301706.18245.mail@earthworm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_6jFZLVYbxeTddPF
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Greg,

this adds support for Samsung N220 to your samsung-backlight. Tested on my 
device, works for me.

Regards,
Chris

Signed-off-by: Christian Hesse <mail@earthworm.de>


--Boundary-00=_6jFZLVYbxeTddPF
Content-Type: text/x-patch;
  charset="UTF-8";
  name="samsung-backlight-n220.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="samsung-backlight-n220.diff"

--- samsung-backlight.c~	2010-01-28 19:10:40.000000000 +0100
+++ samsung-backlight.c	2010-01-28 19:18:50.000000000 +0100
@@ -105,6 +105,15 @@ static struct dmi_system_id __initdata s
 		.callback = dmi_check_cb,
 	},
 	{
+		.ident = "N220",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N220"),
+			DMI_MATCH(DMI_BOARD_NAME, "N220"),
+		},
+		.callback = dmi_check_cb,
+	},
+	{
 		.ident = "NC10",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
@@ -138,8 +147,11 @@ static int __init samsung_init(void)
 	pci_device = pci_get_device(PCI_VENDOR_ID_INTEL, 0x27ae, NULL);
 	if (!pci_device) {
 		pci_device = pci_get_device(PCI_VENDOR_ID_INTEL, 0x2a02, NULL);
-		if (!pci_device)
+		if (!pci_device) {
+			pci_device = pci_get_device(PCI_VENDOR_ID_INTEL, 0xa011, NULL);
+			if (!pci_device)
 			return -ENODEV;
+		}
 	}
 
 	/* create a backlight device to talk to this one */
@@ -175,5 +187,6 @@ MODULE_DESCRIPTION("Samsung Backlight dr
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnN120:*:rnN120:*");
 MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnN130:*:rnN130:*");
+MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnN220:*:rnN220:*");
 MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnNC10:*:rnNC10:*");
 MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnSQ45S70S:*:rnSQ45S70S:*");

--Boundary-00=_6jFZLVYbxeTddPF--
