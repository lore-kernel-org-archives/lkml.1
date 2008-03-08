Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYCHX16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYCHX16 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 18:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYCHX1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 18:27:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60758 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYCHX1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 18:27:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 9 Mar 2008 00:27:20 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: update Kconfig help text
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.9286022a0d31093d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some less necessary information, point out that video1394 and
dv1394 should be blacklisted along with ohci1394.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/Kconfig |   50 ++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

Index: linux/drivers/firewire/Kconfig
===================================================================
--- linux.orig/drivers/firewire/Kconfig
+++ linux/drivers/firewire/Kconfig
@@ -1,5 +1,3 @@
-# -*- shell-script -*-
-
 comment "An alternative FireWire stack is available with EXPERIMENTAL=y"
 	depends on EXPERIMENTAL=n
 
@@ -21,27 +19,7 @@ config FIREWIRE
           NOTE:
 
 	  You should only build ONE of the stacks, unless you REALLY know what
-	  you are doing.  If you install both, you should configure them only as
-	  modules rather than link them statically, and you should blacklist one
-	  of the concurrent low-level drivers in /etc/modprobe.conf.  Add either
-
-	      blacklist firewire-ohci
-	  or
-	      blacklist ohci1394
-
-	  there depending on which driver you DON'T want to have auto-loaded.
-	  You can optionally do the same with the other IEEE 1394/ FireWire
-	  drivers.
-
-	  If you have an old modprobe which doesn't implement the blacklist
-	  directive, use either
-
-	       install firewire-ohci /bin/true
-	  or
-	       install ohci1394 /bin/true
-
-	  and so on, depending on which modules you DON't want to have
-	  auto-loaded.
+	  you are doing.
 
 config FIREWIRE_OHCI
 	tristate "Support for OHCI FireWire host controllers"
@@ -57,8 +35,24 @@ config FIREWIRE_OHCI
 
           NOTE:
 
-	  If you also build ohci1394 of the classic stack, blacklist either
-	  ohci1394 or firewire-ohci to let hotplug load only the desired driver.
+	  You should only build ohci1394 or firewire-ohci, but not both.
+	  If you nevertheless want to install both, you should configure them
+	  only as modules and blacklist the driver(s) which you don't want to
+	  have auto-loaded.  Add either
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
 
 config FIREWIRE_SBP2
 	tristate "Support for storage devices (SBP-2 protocol driver)"
@@ -75,9 +69,3 @@ config FIREWIRE_SBP2
 
 	  You should also enable support for disks, CD-ROMs, etc. in the SCSI
 	  configuration section.
-
-          NOTE:
-
-	  If you also build sbp2 of the classic stack, blacklist either sbp2
-	  or firewire-sbp2 to let hotplug load only the desired driver.
-

-- 
Stefan Richter
-=====-==--- --== -=--=
http://arcgraph.de/sr/

