Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbXFYUTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbXFYUTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXFYUTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:19:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50023 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbXFYUTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:19:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 25 Jun 2007 22:18:40 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [RFC patch] firewire: add Kconfig help on building both stacks
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.78aa27c59575fdc3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alas that won't work so good, because nobody reads help texts.

I thought about adding some crude multiple choice selection (build the
old stack, build the new stack, build both stacks).  It's possible, but
it would introduce awkward dummy config variables.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Kconfig |   66 ++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 22 deletions(-)

Index: linux/drivers/firewire/Kconfig
===================================================================
--- linux.orig/drivers/firewire/Kconfig
+++ linux/drivers/firewire/Kconfig
@@ -4,27 +4,45 @@ comment "An alternative FireWire stack i
 	depends on EXPERIMENTAL=n
 
 config FIREWIRE
-	tristate "IEEE 1394 (FireWire) support (JUJU alternative stack, experimental)"
+	tristate "IEEE 1394 (FireWire) support (alternative stack, EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	select CRC_ITU_T
 	help
-	  IEEE 1394 describes a high performance serial bus, which is also
-	  known as FireWire(tm) or i.Link(tm) and is used for connecting all
-	  sorts of devices (most notably digital video cameras) to your
-	  computer.
-
-	  If you have FireWire hardware and want to use it, say Y here.  This
-	  is the core support only, you will also need to select a driver for
-	  your IEEE 1394 adapter.
-
-	  To compile this driver as a module, say M here: the module will be
-	  called firewire-core.
-
-	  This is the "JUJU" FireWire stack, an alternative implementation
+	  This is the "Juju" FireWire stack, a new alternative implementation
 	  designed for robustness and simplicity.  You can build either this
 	  stack, or the classic stack (the ieee1394 driver, ohci1394 etc.)
 	  or both.
 
+	  To compile this driver as a module, say M here: the module will be
+	  called firewire-core.  It functionally replaces ieee1394, raw1394,
+	  and video1394.
+
+          ---- NOTE: ----
+
+	  You should only build ONE of the stacks, unless you REALLY know what
+	  you are doing.  If you install both, you should configure them only as
+	  modules rather than link them statically, and you should at least
+	  blacklist one of the concurrent low-level drivers in
+	  /etc/modprobe.conf.  Add either
+
+	      blacklist firewire-ohci
+	  or
+	      blacklist ohci1394
+
+	  there depending on which driver you DON'T want to have auto-loaded.
+	  You can optionally do the same with the other IEEE 1394/ FireWire
+	  drivers.
+
+	  If you have an old modprobe which doesn't implement the blacklist
+	  directive, use either
+
+	       install firewire-ohci /bin/true
+	  or
+	       install ohci1394 /bin/true
+
+	  and so on, depending on which modules you DON't want to have
+	  auto-loaded.
+
 config FIREWIRE_OHCI
 	tristate "Support for OHCI FireWire host controllers"
 	depends on PCI && FIREWIRE
@@ -34,11 +52,13 @@ config FIREWIRE_OHCI
 	  is the only chipset in use, so say Y here.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called firewire-ohci.
+	  called firewire-ohci.  It replaces ohci1394 of the classic IEEE 1394
+	  stack.
 
-	  If you also build ohci1394 of the classic IEEE 1394 driver stack,
-	  blacklist either ohci1394 or firewire-ohci to let hotplug load the
-	  desired driver.
+          ---- NOTE: ----
+
+	  If you also build ohci1394 of the classic stack, blacklist either
+	  ohci1394 or firewire-ohci to let hotplug load the desired driver.
 
 config FIREWIRE_SBP2
 	tristate "Support for storage devices (SBP-2 protocol driver)"
@@ -50,12 +70,14 @@ config FIREWIRE_SBP2
 	  like scanners.
 
 	  To compile this driver as a module, say M here:  The module will be
-	  called firewire-sbp2.
+	  called firewire-sbp2.  It replaces sbp2 of the classic IEEE 1394
+	  stack.
 
 	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
 	  configuration section.
 
-	  If you also build sbp2 of the classic IEEE 1394 driver stack,
-	  blacklist either sbp2 or firewire-sbp2 to let hotplug load the
-	  desired driver.
+          ---- NOTE: ----
+
+	  If you also build sbp2 of the classic stack, blacklist either sbp2
+	  or firewire-sbp2 to let hotplug load the desired driver.
 

-- 
Stefan Richter
-=====-=-=== -==- ==--=
http://arcgraph.de/sr/

