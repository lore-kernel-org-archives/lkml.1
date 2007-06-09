Return-Path: <linux-kernel-owner+w=401wt.eu-S1032592AbXFIAZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032592AbXFIAZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968792AbXFIAZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:25:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:59925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968018AbXFIAZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:25:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       bert hubert <bert.hubert@netherlabs.nl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/9] USB: set default y for CONFIG_USB_DEVICE_CLASS
Date: Fri,  8 Jun 2007 17:03:46 -0700
Message-Id: <11813474343815-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <20070609000312.GA17574@kroah.com>
References: <20070609000312.GA17574@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: bert hubert <bert.hubert@netherlabs.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/Kconfig |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index f493fb1..346fc03 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -40,21 +40,25 @@ config USB_DEVICEFS
 config USB_DEVICE_CLASS
 	bool "USB device class-devices (DEPRECATED)"
 	depends on USB
-	default n
+	default y
 	---help---
 	  Userspace access to USB devices is granted by device-nodes exported
 	  directly from the usbdev in sysfs. Old versions of the driver
 	  core and udev needed additional class devices to export device nodes.
 
 	  These additional devices are difficult to handle in userspace, if
-	  information about USB interfaces must be available. One device contains
-	  the device node, the other device contains the interface data. Both
-	  devices are at the same level in sysfs (siblings) and one can't access
-	  the other. The device node created directly by the usbdev is the parent
-	  device of the interface and therefore easily accessible from the interface
-	  event.
-
-	  This option provides backward compatibility if needed.
+	  information about USB interfaces must be available. One device
+	  contains the device node, the other device contains the interface
+	  data. Both devices are at the same level in sysfs (siblings) and one
+	  can't access the other. The device node created directly by the
+	  usb device is the parent device of the interface and therefore
+	  easily accessible from the interface event.
+
+	  This option provides backward compatibility for libusb device
+	  nodes (lsusb) when usbfs is not used, and the following udev rule
+	  doesn't exist:
+	    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", \
+	    NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}", MODE="0644"
 
 config USB_DYNAMIC_MINORS
 	bool "Dynamic USB minor allocation (EXPERIMENTAL)"
-- 
1.5.2.1

