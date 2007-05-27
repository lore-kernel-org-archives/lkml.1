Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbXE0Ph3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbXE0Ph3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbXE0PhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:37:20 -0400
Received: from art-generator.com ([87.106.74.240]:43719 "EHLO
	s15225674.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754774AbXE0PhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:37:19 -0400
X-Greylist: delayed 1963 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 May 2007 11:37:19 EDT
Date: Sun, 27 May 2007 17:04:58 +0200
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
Subject: USB: set default y for CONFIG_USB_DEVICE_CLASS
Message-ID: <20070527150458.GA3803@vrfy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: USB: set default y for CONFIG_USB_DEVICE_CLASS

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

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

