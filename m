Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZLZAhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZLZAhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbZLZAg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:36:59 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53614 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbZLZAg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:36:58 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Dec 2009 01:36:53 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/5] firewire, ieee1394: update Kconfig help
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
Message-ID: <tkrat.87d6ed22c225f448@s5r6.in-berlin.de>
References: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the Kconfig help texts of both stacks to encourage a general move
from the older to the newer drivers.  However, do not label ieee1394 as
"Obsolete" yet, as the newer drivers have not been deployed as default
stack in the majority of Linux distributions yet, and those who start
doing so now may still want to install the old drivers as fallback for
unforeseen issues.

Since Linux 2.6.32, FireWire audio devices can be driven by the newer
firewire driver stack too, hence remove an outdated comment about audio
devices.  Also remove comments about library versions since the 2nd
generation of libraw1394 and libdc1394 is now in common use; details on
library versions can be read at the wiki link from the help texts.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/Kconfig          |    2 
 drivers/firewire/Kconfig |   44 +++++++++--------------------
 drivers/ieee1394/Kconfig |   59 ++++++++++++++++++++++++++++-----------
 3 files changed, 56 insertions(+), 49 deletions(-)

Index: linux-2.6.33-rc2/drivers/Kconfig
===================================================================
--- linux-2.6.33-rc2.orig/drivers/Kconfig
+++ linux-2.6.33-rc2/drivers/Kconfig
@@ -28,7 +28,7 @@ source "drivers/md/Kconfig"
 
 source "drivers/message/fusion/Kconfig"
 
-source "drivers/ieee1394/Kconfig"
+source "drivers/firewire/Kconfig"
 
 source "drivers/message/i2o/Kconfig"
 
Index: linux-2.6.33-rc2/drivers/firewire/Kconfig
===================================================================
--- linux-2.6.33-rc2.orig/drivers/firewire/Kconfig
+++ linux-2.6.33-rc2/drivers/firewire/Kconfig
@@ -1,5 +1,10 @@
+menu "IEEE 1394 (FireWire) support"
+	depends on PCI || BROKEN
+	# firewire-core does not depend on PCI but is
+	# not useful without PCI controller driver
+
 comment "You can enable one or both FireWire driver stacks."
-comment "See the help texts for more information."
+comment "The newer stack is recommended."
 
 config FIREWIRE
 	tristate "FireWire driver stack"
@@ -15,16 +20,6 @@ config FIREWIRE
 	  To compile this driver as a module, say M here: the module will be
 	  called firewire-core.
 
-	  This module functionally replaces ieee1394, raw1394, and video1394.
-	  To access it from application programs, you generally need at least
-	  libraw1394 v2.  IIDC/DCAM applications need libdc1394 v2.
-	  No libraries are required to access storage devices through the
-	  firewire-sbp2 driver.
-
-	  NOTE:
-	  FireWire audio devices currently require the old drivers (ieee1394,
-	  ohci1394, raw1394).
-
 config FIREWIRE_OHCI
 	tristate "OHCI-1394 controllers"
 	depends on PCI && FIREWIRE
@@ -34,22 +29,7 @@ config FIREWIRE_OHCI
 	  is the only chipset in use, so say Y here.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called firewire-ohci.  It replaces ohci1394 of the classic IEEE 1394
-	  stack.
-
-	  NOTE:
-	  If you want to install firewire-ohci and ohci1394 together, you
-	  should configure them only as modules and blacklist the driver(s)
-	  which you don't want to have auto-loaded.  Add either
-
-	      blacklist firewire-ohci
-	  or
-	      blacklist ohci1394
-	      blacklist video1394
-	      blacklist dv1394
-
-	  to /etc/modprobe.conf or /etc/modprobe.d/* and update modprobe.conf
-	  depending on your distribution.
+	  called firewire-ohci.
 
 config FIREWIRE_OHCI_DEBUG
 	bool
@@ -66,8 +46,7 @@ config FIREWIRE_SBP2
 	  like scanners.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called firewire-sbp2.  It replaces sbp2 of the classic IEEE 1394
-	  stack.
+	  called firewire-sbp2.
 
 	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
 	  configuration section.
@@ -83,5 +62,8 @@ config FIREWIRE_NET
 	  NOTE, this driver is not stable yet!
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called firewire-net.  It replaces eth1394 of the classic IEEE 1394
-	  stack.
+	  called firewire-net.
+
+source "drivers/ieee1394/Kconfig"
+
+endmenu
Index: linux-2.6.33-rc2/drivers/ieee1394/Kconfig
===================================================================
--- linux-2.6.33-rc2.orig/drivers/ieee1394/Kconfig
+++ linux-2.6.33-rc2/drivers/ieee1394/Kconfig
@@ -1,8 +1,3 @@
-menu "IEEE 1394 (FireWire) support"
-	depends on PCI || BROKEN
-
-source "drivers/firewire/Kconfig"
-
 config IEEE1394
 	tristate "Legacy alternative FireWire driver stack"
 	depends on PCI || BROKEN
@@ -16,8 +11,13 @@ config IEEE1394
 	  is the core support only, you will also need to select a driver for
 	  your IEEE 1394 adapter.
 
-	  To compile this driver as a module, say M here: the
-	  module will be called ieee1394.
+	  To compile this driver as a module, say M here: the module will be
+	  called ieee1394.
+
+	  NOTE:
+	  ieee1394 is superseded by the newer firewire-core driver.  See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
 
 config IEEE1394_OHCI1394
 	tristate "OHCI-1394 controllers"
@@ -29,19 +29,23 @@ config IEEE1394_OHCI1394
 	  use one of these chipsets.  It should work with any OHCI-1394
 	  compliant card, however.
 
-	  To compile this driver as a module, say M here: the
-	  module will be called ohci1394.
+	  To compile this driver as a module, say M here: the module will be
+	  called ohci1394.
 
 	  NOTE:
+	  ohci1394 is superseded by the newer firewire-ohci driver.  See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
+
 	  If you want to install firewire-ohci and ohci1394 together, you
 	  should configure them only as modules and blacklist the driver(s)
 	  which you don't want to have auto-loaded.  Add either
 
-	      blacklist firewire-ohci
-	  or
 	      blacklist ohci1394
 	      blacklist video1394
 	      blacklist dv1394
+	  or
+	      blacklist firewire-ohci
 
 	  to /etc/modprobe.conf or /etc/modprobe.d/* and update modprobe.conf
 	  depending on your distribution.
@@ -58,8 +62,8 @@ config IEEE1394_PCILYNX
 	  Instruments PCILynx chip.  Note: this driver is written for revision
 	  2 of this chip and may not work with revision 0.
 
-	  To compile this driver as a module, say M here: the
-	  module will be called pcilynx.
+	  To compile this driver as a module, say M here: the module will be
+	  called pcilynx.
 
 	  Only some old and now very rare PCI and CardBus cards and
 	  PowerMacs G3 B&W contain the PCILynx controller.  Therefore
@@ -79,6 +83,14 @@ config IEEE1394_SBP2
 	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
 	  configuration section.
 
+	  To compile this driver as a module, say M here: the module will be
+	  called sbp2.
+
+	  NOTE:
+	  sbp2 is superseded by the newer firewire-sbp2 driver. See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
+
 config IEEE1394_SBP2_PHYS_DMA
 	bool "Enable replacement for physical DMA in SBP2"
 	depends on IEEE1394_SBP2 && VIRT_TO_BUS && EXPERIMENTAL
@@ -111,6 +123,11 @@ config IEEE1394_ETH1394
 
 	  The module is called eth1394 although it does not emulate Ethernet.
 
+	  NOTE:
+	  eth1394 is superseded by the newer firewire-net driver. See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
+
 config IEEE1394_RAWIO
 	tristate "raw1394 userspace interface"
 	depends on IEEE1394
@@ -123,6 +140,11 @@ config IEEE1394_RAWIO
 	  To compile this driver as a module, say M here: the module will be
 	  called raw1394.
 
+	  NOTE:
+	  raw1394 is superseded by the newer firewire-core driver. See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
+
 config IEEE1394_VIDEO1394
 	tristate "video1394 userspace interface"
 	depends on IEEE1394 && IEEE1394_OHCI1394
@@ -136,13 +158,18 @@ config IEEE1394_VIDEO1394
 	  To compile this driver as a module, say M here: the module will be
 	  called video1394.
 
+	  NOTE:
+	  video1394 is superseded by the newer firewire-core driver. See
+	  http://ieee1394.wiki.kernel.org/index.php/Juju_Migration for
+	  further information on how to switch to the new FireWire drivers.
+
 config IEEE1394_DV1394
 	tristate "dv1394 userspace interface (deprecated)"
 	depends on IEEE1394 && IEEE1394_OHCI1394
 	help
 	  The dv1394 driver is unsupported and may be removed from Linux in a
-	  future release.  Its functionality is now provided by raw1394 together
-	  with libraries such as libiec61883.
+	  future release.  Its functionality is now provided by either
+	  raw1394 or firewire-core together with libraries such as libiec61883.
 
 config IEEE1394_VERBOSEDEBUG
 	bool "Excessive debugging output"
@@ -153,5 +180,3 @@ config IEEE1394_VERBOSEDEBUG
 	  will quickly result in large amounts of data sent to the system log.
 
 	  Say Y if you really need the debugging output.  Everyone else says N.
-
-endmenu

-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/

