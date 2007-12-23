Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbXLWLuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbXLWLuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 06:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXLWLua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 06:50:30 -0500
Received: from [212.12.190.216] ([212.12.190.216]:53983 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbXLWLu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 06:50:29 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-usb@vger.kernel.org
Subject: [PATCH] USB Kconfig: Reorganize USB Kconfig Menu
Date: Sun, 23 Dec 2007 14:49:00 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712231449.00862.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reogranize USB Kconfig Menu, and move USB_GADGET out into the Device Driver
Menu.  This helps the USB Kconfig Menu to be more logical/usable.

Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Boldi <a1426z@gawab.com>

---

--- 23.a/drivers/Kconfig
+++ 23.b/drivers/Kconfig
@@ -70,6 +70,8 @@ source "drivers/hid/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+source "drivers/usb/gadget/Kconfig"
+
 source "drivers/mmc/Kconfig"
 
 source "drivers/leds/Kconfig"
--- 23.a/drivers/usb/Kconfig
+++ 23.b/drivers/usb/Kconfig
@@ -2,8 +2,8 @@
 # USB device configuration
 #
 
-menuconfig USB_SUPPORT
-	bool "USB support"
+config USB_SUPPORT
+	bool
 	depends on HAS_IOMEM
 	default y
 	---help---
@@ -52,8 +52,8 @@ config USB_ARCH_HAS_EHCI
 	default PCI
 
 # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
-config USB
-	tristate "Support for Host-side USB"
+menuconfig USB
+	tristate "Host-side USB"
 	depends on USB_ARCH_HAS_HCD
 	---help---
 	  Universal Serial Bus (USB) is a specification for a serial bus
@@ -87,21 +87,16 @@ config USB
 	  To compile this driver as a module, choose M here: the
 	  module will be called usbcore.
 
+if USB
+
 source "drivers/usb/core/Kconfig"
 
 source "drivers/usb/host/Kconfig"
 
-source "drivers/usb/class/Kconfig"
-
 source "drivers/usb/storage/Kconfig"
 
-source "drivers/usb/image/Kconfig"
-
 source "drivers/usb/mon/Kconfig"
 
-comment "USB port drivers"
-	depends on USB
-
 config USB_USS720
 	tristate "USS720 parport driver"
 	depends on USB && PARPORT
@@ -133,10 +128,13 @@ config USB_USS720
 
 source "drivers/usb/serial/Kconfig"
 
-source "drivers/usb/misc/Kconfig"
-
 source "drivers/usb/atm/Kconfig"
 
-source "drivers/usb/gadget/Kconfig"
+source "drivers/usb/class/Kconfig"
+
+source "drivers/usb/image/Kconfig"
+
+source "drivers/usb/misc/Kconfig"
 
+endif # USB
 endif # USB_SUPPORT
--- 23.a/drivers/usb/serial/Kconfig
+++ 23.b/drivers/usb/serial/Kconfig
@@ -2,10 +2,7 @@
 # USB Serial device configuration
 #
 
-menu "USB Serial Converter support"
-	depends on USB!=n
-
-config USB_SERIAL
+menuconfig USB_SERIAL
 	tristate "USB Serial Converter support"
 	depends on USB
 	---help---
@@ -20,6 +17,8 @@ config USB_SERIAL
 	  To compile this driver as a module, choose M here: the
 	  module will be called usbserial.
 
+if USB_SERIAL
+
 config USB_SERIAL_CONSOLE
 	bool "USB Serial Console device support (EXPERIMENTAL)"
 	depends on USB_SERIAL=y && EXPERIMENTAL
@@ -581,5 +580,4 @@ config USB_EZUSB
 	default y
 
 
-endmenu
-
+endif # USB_SERIAL
--- 23.a/drivers/usb/core/Kconfig
+++ 23.b/drivers/usb/core/Kconfig
@@ -1,6 +1,12 @@
 #
 # USB Core configuration
 #
+menuconfig USB_CORE_MENU
+	bool "USB Core Config"
+	depends on USB
+
+if USB_CORE_MENU
+
 config USB_DEBUG
 	bool "USB verbose debug messages"
 	depends on USB
@@ -142,3 +148,4 @@ config USB_OTG_BLACKLIST_HUB
 	  external hubs.  OTG hosts are allowed to reduce hardware
 	  and software costs by not supporting external hubs.
 
+endif # USB_CORE_MENU
--- 23.a/drivers/usb/host/Kconfig
+++ 23.b/drivers/usb/host/Kconfig
@@ -1,7 +1,7 @@
 #
 # USB Host Controller Drivers
 #
-comment "USB Host Controller Drivers"
+menu "USB Host Controller Drivers"
 	depends on USB
 
 config USB_EHCI_HCD
@@ -248,3 +248,4 @@ config USB_R8A66597_HCD
 	  To compile this driver as a module, choose M here: the
 	  module will be called r8a66597-hcd.
 
+endmenu
--- 23.a/drivers/usb/class/Kconfig
+++ 23.b/drivers/usb/class/Kconfig
@@ -1,9 +1,12 @@
 #
 # USB Class driver configuration
 #
-comment "USB Device Class drivers"
+menuconfig USB_DEVICE_CLASS_MENU
+	bool "USB Device Class drivers"
 	depends on USB
 
+if USB_DEVICE_CLASS_MENU
+
 config USB_ACM
 	tristate "USB Modem (CDC ACM) support"
 	depends on USB
@@ -29,3 +32,4 @@ config USB_PRINTER
 	  To compile this driver as a module, choose M here: the
 	  module will be called usblp.
 
+endif # USB_DEVICE_CLASS_MENU
--- 23.a/drivers/usb/gadget/Kconfig
+++ 23.b/drivers/usb/gadget/Kconfig
@@ -12,10 +12,8 @@
 # With help from a special transceiver and a "Mini-AB" jack, systems with
 # both kinds of controller can also support "USB On-the-Go" (CONFIG_USB_OTG).
 #
-menu "USB Gadget Support"
-
-config USB_GADGET
-	tristate "Support for USB Gadgets"
+menuconfig USB_GADGET
+	tristate "Peripheral-side USB"
 	help
 	   USB is a master/slave protocol, organized with one master
 	   host (such as a PC) controlling up to 127 peripheral devices.
@@ -42,6 +40,8 @@ config USB_GADGET
 	   For more information, see <http://www.linux-usb.org/gadget> and
 	   the kernel DocBook documentation for this API.
 
+if USB_GADGET
+
 config USB_GADGET_DEBUG
 	boolean "Debugging messages"
 	depends on USB_GADGET && DEBUG_KERNEL && EXPERIMENTAL
@@ -522,4 +522,4 @@ config USB_MIDI_GADGET
 
 endchoice
 
-endmenu
+endif # USB_GADGET
--- 23.a/drivers/usb/storage/Kconfig
+++ 23.b/drivers/usb/storage/Kconfig
@@ -2,11 +2,12 @@
 # USB Storage driver configuration
 #
 
-comment "NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'"
-comment "may also be needed; see USB_STORAGE Help for more information"
+comment "NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may"
+	depends on USB
+comment "also be needed; see USB_STORAGE Help for more information"
 	depends on USB
 
-config USB_STORAGE
+menuconfig USB_STORAGE
 	tristate "USB Mass Storage support"
 	depends on USB && SCSI
 	---help---
--- 23.a/drivers/usb/atm/Kconfig
+++ 23.b/drivers/usb/atm/Kconfig
@@ -2,10 +2,7 @@
 # USB/ATM DSL configuration
 #
 
-menu "USB DSL modem support"
-	depends on USB
-
-config USB_ATM
+menuconfig USB_ATM
 	tristate "USB DSL modem support"
 	depends on USB && ATM
 	select CRC32
@@ -18,6 +15,8 @@ config USB_ATM
 	  To compile this driver as a module, choose M here: the
 	  module will be called usbatm.
 
+if USB_ATM
+
 config USB_SPEEDTOUCH
 	tristate "Speedtouch USB support"
 	depends on USB_ATM
@@ -70,4 +69,4 @@ config USB_XUSBATM
 	  To compile this driver as a module, choose M here: the
 	  module will be called xusbatm.
 
-endmenu
+endif # USB_ATM
--- 23.a/drivers/usb/image/Kconfig
+++ 23.b/drivers/usb/image/Kconfig
@@ -1,9 +1,12 @@
 #
 # USB Imageing devices configuration
 #
-comment "USB Imaging devices"
+menuconfig USB_IMG_MENU
+	bool "USB Imaging devices"
 	depends on USB
 
+if USB_IMG_MENU
+
 config USB_MDC800
 	tristate "USB Mustek MDC800 Digital Camera support (EXPERIMENTAL)"
 	depends on USB && EXPERIMENTAL
@@ -28,3 +31,5 @@ config USB_MICROTEK
 	  The scanner will appear as a scsi generic device to the rest
 	  of the system. Scsi support is required.
 	  This driver can be compiled as a module, called microtek.
+
+endif # USB_IMG_MENU
--- 23.a/drivers/usb/misc/Kconfig
+++ 23.b/drivers/usb/misc/Kconfig
@@ -1,9 +1,12 @@
 #
 # USB Miscellaneous driver configuration
 #
-comment "USB Miscellaneous drivers"
+menuconfig USB_MISC_MENU
+	bool "USB Miscellaneous drivers"
 	depends on USB
 
+if USB_MISC_MENU
+
 config USB_EMI62
 	tristate "EMI 6|2m USB Audio interface support"
 	depends on USB
@@ -269,3 +272,4 @@ config USB_TEST
 	  See <http://www.linux-usb.org/usbtest/> for more information,
 	  including sample test device firmware and "how to use it".
 
+endif # USB_MISC_MENU

