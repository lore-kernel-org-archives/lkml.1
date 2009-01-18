Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbZAROFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbZAROFO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 09:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbZAROE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 09:04:57 -0500
Received: from h4320.serverkompetenz.net ([81.169.172.102]:52401 "EHLO
	www.deb-support.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758522AbZAROE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 09:04:56 -0500
X-Greylist: delayed 653 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2009 09:04:55 EST
Date: Sun, 18 Jan 2009 13:53:59 +0000
From: Michael Bramer <michael@debsupport.de>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org
Subject: [PATCH] drivers/serial/8250_pci.c (add support for '8-port RS-232 MIC-3620 from advantech'
Message-ID: <20090118135359.GA3087@deb-support.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: grisu@deb-support.de
X-SA-Exim-Scanned: No (on www.deb-support.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

This is my first mail to this list... sorry for all my mistakes

We use a 8-port RS-232 MIC-3620 from advantech (see
http://www.advantech.com/products/8-port-RS-232-Communication-CPCI-Card/mod_1-2MLG80.aspx)
and need linux support for this card.

This patch add is:
-------------------------------------
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -768,6 +769,8 @@
 #define PCI_SUBDEVICE_ID_OCTPRO422      0x0208
 #define PCI_SUBDEVICE_ID_POCTAL232      0x0308
 #define PCI_SUBDEVICE_ID_POCTAL422      0x0408
+#define PCI_VENDOR_ID_ADVANTECH         0x13fe
+#define PCI_DEVICE_ID_ADVANTECH_PCI3620 0x3620

 /*
  * Master list of serial port init/setup/exit quirks.
@@ -789,6 +792,16 @@
                .setup          = addidata_apci7800_setup,
        },
        /*
+        * ADVANTECH
+        */
+       {
+               .vendor         = PCI_VENDOR_ID_ADVANTECH,
+               .device         = PCI_DEVICE_ID_ADVANTECH_PCI3620,
+               .subvendor      = PCI_DEVICE_ID_ADVANTECH_PCI3620,
+               .subdevice      = PCI_ANY_ID,
+               .setup          = pci_default_setup,
+       },
+       /*
         * AFAVLAB cards - these may be called via parport_serial
         *  It is not clear whether this applies to all products.
         */
@@ -2041,6 +2054,9 @@
 #endif

 static struct pci_device_id serial_pci_tbl[] = {
+       {       PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
+               PCI_DEVICE_ID_ADVANTECH_PCI3620, PCI_ANY_ID, 0, 0,
+               pbn_b2_8_921600 },
        {       PCI_VENDOR_ID_V3, PCI_DEVICE_ID_V3_V960,
                PCI_SUBVENDOR_ID_CONNECT_TECH,
                PCI_SUBDEVICE_ID_CONNECT_TECH_BH8_232, 0, 0,
-------------------------------------

can you add this in the next linux kernel?

Thanks for linux!

Gruss
Grisu
-- 
Michael Bramer  -- http://www.feuerwehr.kreuzau.de/wiki/
PGP: finger grisu@db.debian.org  -- Linux Sysadmin   -- Use Debian Linux
"Wenn ich die Folgen geahnt hätte, wäre ich Uhrmacher geworden!"
                                                 --- Albert Einstein
