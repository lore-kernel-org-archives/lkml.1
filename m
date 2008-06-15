Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYFOXjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYFOXjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 19:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYFOXjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 19:39:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49586 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbYFOXjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 19:39:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 16 Jun 2008 01:39:28 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2 update] ieee1394: Kconfig menu touch-up
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.57b015762839f264@s5r6.in-berlin.de>
Message-ID: <tkrat.3efd78ed9bdbe878@s5r6.in-berlin.de>
References: <tkrat.e8d86d7d304b0005@s5r6.in-berlin.de>
 <tkrat.57b015762839f264@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename and reorder some prompts and modify some help texts.
The result:

  -------------------- IEEE 1394 (FireWire) support --------------------
  *** Enable only one of the two stacks, unless you know what you are doing ***
  New FireWire stack, EXPERIMENTAL
    OHCI-1394 controllers
    Storage devices (SBP-2 protocol)
  Stable FireWire stack
    OHCI-1394 controllers
    PCILynx controller
    Storage devices (SBP-2 protocol)
      Enable replacement for physical DMA in SBP2
    IP over 1394
    raw1394 userspace interface
    video1394 userspace interface
    dv1394 userspace interface (deprecated)
    Excessive debugging output

The old prompts for reference:

  -------------------- IEEE 1394 (FireWire) support --------------------
  IEEE 1394 (FireWire) support - alternative stack, EXPERIMENTAL
    Support for OHCI FireWire host controllers
    Support for storage devices (SBP-2 protocol driver)
  IEEE 1394 (FireWire) support
    *** Subsystem Options ***
    Excessive debugging output
    *** Controllers ***
    Texas Instruments PCILynx support
    OHCI-1394 support
    *** Protocols ***
    OHCI-1394 Video support
    SBP-2 support (Harddisks etc.)
      Enable replacement for physical DMA in SBP2
    IP over 1394
    OHCI-DV I/O support (deprecated)
    Raw IEEE1394 I/O support

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Patch update:  "Old FireWire stack" reworded as "Stable FireWire stack".
We can start to call it "old" once the new stack is stable enough to
render the old one obsolete.

Even though changing the names of long established prompts has its own
support problems, I am very tempted to send these two patches to Linus
still in this week --- to avoid issues like this one:
http://bbs.archlinux.org/viewtopic.php?id=47611


 drivers/ieee1394/Kconfig |  118 +++++++++++++++++++++------------------
 1 file changed, 66 insertions(+), 52 deletions(-)

Index: linux/drivers/ieee1394/Kconfig
===================================================================
--- linux.orig/drivers/ieee1394/Kconfig
+++ linux/drivers/ieee1394/Kconfig
@@ -4,7 +4,7 @@ menu "IEEE 1394 (FireWire) support"
 source "drivers/firewire/Kconfig"
 
 config IEEE1394
-	tristate "IEEE 1394 (FireWire) support"
+	tristate "Stable FireWire stack"
 	depends on PCI || BROKEN
 	help
 	  IEEE 1394 describes a high performance serial bus, which is also
@@ -19,30 +19,45 @@ config IEEE1394
 	  To compile this driver as a module, say M here: the
 	  module will be called ieee1394.
 
-comment "Subsystem Options"
-	depends on IEEE1394
-
-config IEEE1394_VERBOSEDEBUG
-	bool "Excessive debugging output"
-	depends on IEEE1394
+config IEEE1394_OHCI1394
+	tristate "OHCI-1394 controllers"
+	depends on PCI && IEEE1394
 	help
-	  If you say Y here, you will get very verbose debugging logs from
-	  the subsystem which includes a dump of the header of every sent
-	  and received packet.  This can amount to a high amount of data
-	  collected in a very short time which is usually also saved to
-	  disk by the system logging daemons.
+	  Enable this driver if you have an IEEE 1394 controller based on the
+	  OHCI-1394 specification. The current driver is only tested with OHCI
+	  chipsets made by Texas Instruments and NEC. Most third-party vendors
+	  use one of these chipsets.  It should work with any OHCI-1394
+	  compliant card, however.
 
-	  Say Y if you really want or need the debugging output, everyone
-	  else says N.
+	  To compile this driver as a module, say M here: the
+	  module will be called ohci1394.
 
-comment "Controllers"
-	depends on IEEE1394
+	  NOTE:
+
+	  You should only build either ohci1394 or the new firewire-ohci driver,
+	  but not both.  If you nevertheless want to install both, you should
+	  configure them only as modules and blacklist the driver(s) which you
+	  don't want to have auto-loaded.  Add either
+
+	      blacklist firewire-ohci
+	  or
+	      blacklist ohci1394
+	      blacklist video1394
+	      blacklist dv1394
+
+	  to /etc/modprobe.conf or /etc/modprobe.d/* and update modprobe.conf
+	  depending on your distribution.  The latter two modules should be
+	  blacklisted together with ohci1394 because they depend on ohci1394.
+
+	  If you have an old modprobe which doesn't implement the blacklist
+	  directive, use "install modulename /bin/true" for the modules to be
+	  blacklisted.
 
-comment "Texas Instruments PCILynx requires I2C"
+comment "PCILynx controller requires I2C"
 	depends on IEEE1394 && I2C=n
 
 config IEEE1394_PCILYNX
-	tristate "Texas Instruments PCILynx support"
+	tristate "PCILynx controller"
 	depends on PCI && IEEE1394 && I2C
 	select I2C_ALGOBIT
 	help
@@ -57,35 +72,11 @@ config IEEE1394_PCILYNX
 	  PowerMacs G3 B&W contain the PCILynx controller.  Therefore
 	  almost everybody can say N here.
 
-config IEEE1394_OHCI1394
-	tristate "OHCI-1394 support"
-	depends on PCI && IEEE1394
-	help
-	  Enable this driver if you have an IEEE 1394 controller based on the
-	  OHCI-1394 specification. The current driver is only tested with OHCI
-	  chipsets made by Texas Instruments and NEC. Most third-party vendors
-	  use one of these chipsets.  It should work with any OHCI-1394
-	  compliant card, however.
-
-	  To compile this driver as a module, say M here: the
-	  module will be called ohci1394.
-
-comment "Protocols"
-	depends on IEEE1394
-
-config IEEE1394_VIDEO1394
-	tristate "OHCI-1394 Video support"
-	depends on IEEE1394 && IEEE1394_OHCI1394
-	help
-	  This option enables video device usage for OHCI-1394 cards.  Enable
-	  this option only if you have an IEEE 1394 video device connected to
-	  an OHCI-1394 card.
-
 comment "SBP-2 support (for storage devices) requires SCSI"
 	depends on IEEE1394 && SCSI=n
 
 config IEEE1394_SBP2
-	tristate "SBP-2 support (Harddisks etc.)"
+	tristate "Storage devices (SBP-2 protocol)"
 	depends on IEEE1394 && SCSI
 	help
 	  This option enables you to use SBP-2 devices connected to an IEEE
@@ -127,24 +118,47 @@ config IEEE1394_ETH1394
 
 	  The module is called eth1394 although it does not emulate Ethernet.
 
+config IEEE1394_RAWIO
+	tristate "raw1394 userspace interface"
+	depends on IEEE1394
+	help
+	  This option adds support for the raw1394 device file which enables
+	  direct communication of user programs with IEEE 1394 devices
+	  (isochronous and asynchronous).  Almost all application programs
+	  which access FireWire require this option.
+
+	  To compile this driver as a module, say M here: the module will be
+	  called raw1394.
+
+config IEEE1394_VIDEO1394
+	tristate "video1394 userspace interface"
+	depends on IEEE1394 && IEEE1394_OHCI1394
+	help
+	  This option adds support for the video1394 device files which enable
+	  isochronous communication of user programs with IEEE 1394 devices,
+	  especially video capture or export.  This interface is used by all
+	  libdc1394 based programs and by several other programs, in addition to
+	  the raw1394 interface.  It is generally not required for DV capture.
+
+	  To compile this driver as a module, say M here: the module will be
+	  called video1394.
+
 config IEEE1394_DV1394
-	tristate "OHCI-DV I/O support (deprecated)"
+	tristate "dv1394 userspace interface (deprecated)"
 	depends on IEEE1394 && IEEE1394_OHCI1394
 	help
 	  The dv1394 driver is unsupported and may be removed from Linux in a
 	  future release.  Its functionality is now provided by raw1394 together
 	  with libraries such as libiec61883.
 
-config IEEE1394_RAWIO
-	tristate "Raw IEEE1394 I/O support"
+config IEEE1394_VERBOSEDEBUG
+	bool "Excessive debugging output"
 	depends on IEEE1394
 	help
-	  This option adds support for the raw1394 device file which enables
-	  direct communication of user programs with the IEEE 1394 bus and thus
-	  with the attached peripherals.  Almost all application programs which
-	  access FireWire require this option.
+	  If you say Y here, you will get very verbose debugging logs from the
+	  ieee1394 drivers, including sent and received packet headers.  This
+	  will quickly result in large amounts of data sent to the system log.
 
-	  To compile this driver as a module, say M here: the module will be
-	  called raw1394.
+	  Say Y if you really need the debugging output.  Everyone else says N.
 
 endmenu

-- 
Stefan Richter
-=====-==--- -==- =----
http://arcgraph.de/sr/

