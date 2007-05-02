Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbXEBMTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbXEBMTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXEBMTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:19:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59030 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbXEBMTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:19:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 2 May 2007 14:19:32 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 6/6] firewire: add it all to kbuild
To: linux-kernel@vger.kernel.org
cc: Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <tkrat.c82a1d775d989371@s5r6.in-berlin.de>
Message-ID: <tkrat.abd13e310a4516c7@s5r6.in-berlin.de>
References: <4637A29F.6070302@redhat.com>
 <20070502090007.GA28174@infradead.org>
 <tkrat.087ee29add656926@s5r6.in-berlin.de>
 <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
 <tkrat.65aea95f1451c211@s5r6.in-berlin.de>
 <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de>
 <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de>
 <tkrat.c82a1d775d989371@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/Makefile          |    1 
 drivers/firewire/Kconfig  |   60 ++++++++++++++++++++++++++++++++++++++
 drivers/firewire/Makefile |   10 ++++++
 drivers/ieee1394/Kconfig  |    2 +
 4 files changed, 73 insertions(+)

Index: linux_juju/drivers/Makefile
===================================================================
--- linux_juju.orig/drivers/Makefile
+++ linux_juju/drivers/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_FC4)		+= fc4/
 obj-$(CONFIG_SCSI)		+= scsi/
 obj-$(CONFIG_ATA)		+= ata/
 obj-$(CONFIG_FUSION)		+= message/
+obj-$(CONFIG_FIREWIRE)		+= firewire/
 obj-$(CONFIG_IEEE1394)		+= ieee1394/
 obj-y				+= cdrom/
 obj-y				+= auxdisplay/
Index: linux_juju/drivers/firewire/Makefile
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for the Linux IEEE 1394 implementation
+#
+
+fw-core-objs := fw-card.o fw-topology.o fw-transaction.o fw-iso.o \
+	fw-device.o fw-cdev.o
+
+obj-$(CONFIG_FIREWIRE) += fw-core.o
+obj-$(CONFIG_FIREWIRE_OHCI) += fw-ohci.o
+obj-$(CONFIG_FIREWIRE_SBP2) += fw-sbp2.o
Index: linux_juju/drivers/ieee1394/Kconfig
===================================================================
--- linux_juju.orig/drivers/ieee1394/Kconfig
+++ linux_juju/drivers/ieee1394/Kconfig
@@ -2,6 +2,8 @@
 
 menu "IEEE 1394 (FireWire) support"
 
+source "drivers/firewire/Kconfig"
+
 config IEEE1394
 	tristate "IEEE 1394 (FireWire) support"
 	depends on PCI || BROKEN
Index: linux_juju/drivers/firewire/Kconfig
===================================================================
--- /dev/null
+++ linux_juju/drivers/firewire/Kconfig
@@ -0,0 +1,60 @@
+# -*- shell-script -*-
+
+comment "An alternative FireWire stack is available with EXPERIMENTAL=y"
+	depends on EXPERIMENTAL=n
+
+config FIREWIRE
+	tristate "IEEE 1394 (FireWire) support (JUJU alternative stack, experimental)"
+	depends on EXPERIMENTAL
+	help
+	  IEEE 1394 describes a high performance serial bus, which is also
+	  known as FireWire(tm) or i.Link(tm) and is used for connecting all
+	  sorts of devices (most notably digital video cameras) to your
+	  computer.
+
+	  If you have FireWire hardware and want to use it, say Y here.  This
+	  is the core support only, you will also need to select a driver for
+	  your IEEE 1394 adapter.
+
+	  To compile this driver as a module, say M here: the module will be
+	  called fw-core.
+
+	  This is the "JUJU" FireWire stack, an alternative implementation
+	  designed for robustness and simplicity.  You can build either this
+	  stack, or the classic stack (the ieee1394 driver, ohci1394 etc.)
+	  or both.
+
+config FIREWIRE_OHCI
+	tristate "Support for OHCI FireWire host controllers"
+	depends on PCI && FIREWIRE
+	help
+	  Enable this driver if you have a FireWire controller based
+	  on the OHCI specification.  For all practical purposes, this
+	  is the only chipset in use, so say Y here.
+
+	  To compile this driver as a module, say M here:  The module will be
+	  called fw-ohci.
+
+	  If you also build ohci1394 of the classic IEEE 1394 driver stack,
+	  blacklist either ohci1394 or fw-ohci to let hotplug load the desired
+	  driver.
+
+config FIREWIRE_SBP2
+	tristate "Support for storage devices (SBP-2 protocol driver)"
+	depends on FIREWIRE && SCSI
+	help
+	  This option enables you to use SBP-2 devices connected to a
+	  FireWire bus.  SBP-2 devices include storage devices like
+	  harddisks and DVD drives, also some other FireWire devices
+	  like scanners.
+
+	  To compile this driver as a module, say M here:  The module will be
+	  called fw-sbp2.
+
+	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
+	  configuration section.
+
+	  If you also build sbp2 of the classic IEEE 1394 driver stack,
+	  blacklist either sbp2 or fw-sbp2 to let hotplug load the desired
+	  driver.
+

-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/

