Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYAXIgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYAXIgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 03:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYAXIgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 03:36:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:49357 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbYAXIgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 03:36:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sk2v/XA8K2KCKtGB6dt9mbjhbcvJW8oQtFLBi/Yudxotf584wjFEbJ0xLGrfzfcqu6k5OsFIO1UVTdh2MqJdyBagrWNK/GOBQWc7wrTOD0ITFdxRx7RZEmf81HisR4kW/T4HMGGmc+nfefAuzg3lgrCDwSZmn9+09XBSoxDnOes=
From: Denis Cheng <crquan@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: Use menuconfig objects
Date: Thu, 24 Jan 2008 16:36:31 +0800
Message-Id: <1201163791-5167-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 04d06ad0f1fdb499af84ae3d7969e2136a462f38 have added menuconfig support
for the whole USB Kconfig, but there are still menuconfig need for usb/serial,
usb/atm, and usb/gadget, so that the user can disable all the options in that
menu at once instead of having to disable each option separately.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/usb/atm/Kconfig    |    9 ++++-----
 drivers/usb/gadget/Kconfig |    9 +++++----
 drivers/usb/serial/Kconfig |   11 ++++-------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/atm/Kconfig b/drivers/usb/atm/Kconfig
index b450cba..86e6403 100644
--- a/drivers/usb/atm/Kconfig
+++ b/drivers/usb/atm/Kconfig
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
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index f81d08d..8393176 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -12,10 +12,9 @@
 # With help from a special transceiver and a "Mini-AB" jack, systems with
 # both kinds of controller can also support "USB On-the-Go" (CONFIG_USB_OTG).
 #
-menu "USB Gadget Support"
 
-config USB_GADGET
-	tristate "Support for USB Gadgets"
+menuconfig USB_GADGET
+	tristate "USB Gadget Support"
 	help
 	   USB is a master/slave protocol, organized with one master
 	   host (such as a PC) controlling up to 127 peripheral devices.
@@ -42,6 +41,8 @@ config USB_GADGET
 	   For more information, see <http://www.linux-usb.org/gadget> and
 	   the kernel DocBook documentation for this API.
 
+if USB_GADGET
+
 config USB_GADGET_DEBUG
 	boolean "Debugging messages"
 	depends on USB_GADGET && DEBUG_KERNEL && EXPERIMENTAL
@@ -546,4 +547,4 @@ config USB_MIDI_GADGET
 
 endchoice
 
-endmenu
+endif # USB_GADGET
diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index 4a86696..0474412 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
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
@@ -590,6 +589,4 @@ config USB_EZUSB
 	depends on USB_SERIAL_KEYSPAN_PDA || USB_SERIAL_XIRCOM || USB_SERIAL_KEYSPAN || USB_SERIAL_WHITEHEAT
 	default y
 
-
-endmenu
-
+endif # USB_SERIAL
-- 
1.5.3.5

