Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbXCJIZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbXCJIZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933572AbXCJIZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:25:12 -0500
Received: from vana.vc.cvut.cz ([147.32.240.58]:34381 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933564AbXCJIZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:25:09 -0500
X-Greylist: delayed 1503 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2007 03:25:09 EST
Date: Sat, 10 Mar 2007 09:00:03 +0100
From: Petr Vandrovec <petr@vandrovec.name>
To: khali@linux-fr.org
Cc: i2c@lm-sensors.org, hfvogt@gmx.net, linux-kernel@vger.kernel.org
Subject: [PATCH] Add nForce MCP61 support to i2c-nforce2
Message-ID: <20070310080003.GA24177@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  patch below adds support for nVidia's SMBus adapter present on Gateway's GT5414E 
motherboard (ECS's MCP61 PM-AM).  Patch is for current Linus's git tree.
						Thanks,
							Petr
--

Add support for MCP61's SMBus interface to i2c-nforce2.  Standard NVIDIA i2c design,
so just adding new device ID is everything needed.

And move MCP55 defines in pci_ids.h around a bit so NVIDIA's section is really sorted
by device ID.

00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
        Subsystem: Elitegroup Computer Systems Unknown device 2601
        Flags: 66MHz, fast devsel, IRQ 10
        I/O ports at fc00 [size=64]
        I/O ports at 1c00 [size=64]
        I/O ports at f400 [size=64]
        Capabilities: [44] Power Management version 2

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

diff -uprdN linux/drivers/i2c/busses/i2c-nforce2.c linux/drivers/i2c/busses/i2c-nforce2.c
--- linux/drivers/i2c/busses/i2c-nforce2.c	2007-03-07 22:13:25.000000000 -0800
+++ linux/drivers/i2c/busses/i2c-nforce2.c	2007-03-09 23:38:47.000000000 -0800
@@ -33,6 +33,7 @@
     nForce4 MCP-04		0034
     nForce4 MCP51		0264
     nForce4 MCP55		0368
+    nForce4 MCP61		03EB
 
     This driver supports the 2 SMBuses that are included in the MCP of the
     nForce2/3/4/5xx chipsets.
@@ -200,6 +201,7 @@ static struct pci_device_id nforce2_ids[
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SMBUS) },
 	{ 0 }
 };
 
diff -uprdN linux/include/linux/pci_ids.h linux/include/linux/pci_ids.h
--- linux/include/linux/pci_ids.h	2007-03-07 22:13:27.000000000 -0800
+++ linux/include/linux/pci_ids.h	2007-03-09 23:12:22.000000000 -0800
@@ -1157,10 +1157,6 @@
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_IDE	0x0265
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA	0x0266
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2	0x0267
-#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS	0x0368
-#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE	0x036E
-#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA	0x037E
-#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2	0x037F
 #define PCI_DEVICE_ID_NVIDIA_NVENET_12		0x0268
 #define PCI_DEVICE_ID_NVIDIA_NVENET_13		0x0269
 #define PCI_DEVICE_ID_NVIDIA_GEFORCE4_TI_4800	0x0280
@@ -1209,11 +1205,16 @@
 #define PCI_DEVICE_ID_NVIDIA_GEFORCE_FX_GO5700_2    0x0348
 #define PCI_DEVICE_ID_NVIDIA_QUADRO_FX_GO1000       0x034C
 #define PCI_DEVICE_ID_NVIDIA_QUADRO_FX_1100         0x034E
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS     0x0368
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_IDE       0x036E
 #define PCI_DEVICE_ID_NVIDIA_NVENET_14              0x0372
 #define PCI_DEVICE_ID_NVIDIA_NVENET_15              0x0373
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA      0x037E
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2     0x037F
 #define PCI_DEVICE_ID_NVIDIA_NVENET_16              0x03E5
 #define PCI_DEVICE_ID_NVIDIA_NVENET_17              0x03E6
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA      0x03E7
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SMBUS     0x03EB
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE       0x03EC
 #define PCI_DEVICE_ID_NVIDIA_NVENET_18              0x03EE
 #define PCI_DEVICE_ID_NVIDIA_NVENET_19              0x03EF
