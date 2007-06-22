Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbXFVN4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbXFVN4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbXFVN4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:56:38 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:56496 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbXFVN4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:56:37 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Fri, 22 Jun 2007 15:57:34 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [patch] usbnet: fix kconfig for usbnet drivers
Message-ID: <20070622135734.GO5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Jun 2007 13:56:25.0666 (UTC)
 FILETIME=[1FB9EA20:01C7B4D5]
X-WSS-ID: 6A650A861S41140777-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kernel build error:

 drivers/built-in.o: In function `usbnet_set_settings':
 : undefined reference to `mii_ethtool_sset'
 drivers/built-in.o: In function `usbnet_get_settings':
 : undefined reference to `mii_ethtool_gset'
 drivers/built-in.o: In function `usbnet_get_link':
 : undefined reference to `mii_link_ok'
 drivers/built-in.o: In function `usbnet_nway_reset':
 : undefined reference to `mii_nway_restart'

This occurs when an USBNET device is built-in but MII is
selected as module.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 8dc09a3..5a38fa2 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -68,6 +68,7 @@ config USB_KAWETH
 
 config USB_PEGASUS
 	tristate "USB Pegasus/Pegasus-II based ethernet device support"
+	select NET_ETHERNET
 	select MII
 	---help---
 	  Say Y here if you know you have Pegasus or Pegasus-II based adapter.
@@ -84,6 +85,7 @@ config USB_PEGASUS
 config USB_RTL8150
 	tristate "USB RTL8150 based ethernet device support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	select NET_ETHERNET
 	select MII
 	help
 	  Say Y here if you have RTL8150 based usb-ethernet adapter.
@@ -93,13 +95,8 @@ config USB_RTL8150
 	  To compile this driver as a module, choose M here: the
 	  module will be called rtl8150.
 
-config USB_USBNET_MII
-	tristate
-	default n
-
 config USB_USBNET
 	tristate "Multi-purpose USB Networking Framework"
-	select MII if USB_USBNET_MII != n
 	---help---
 	  This driver supports several kinds of network links over USB,
 	  with "minidrivers" built around a common network driver core
@@ -135,7 +132,7 @@ config USB_NET_AX8817X
 	tristate "ASIX AX88xxx Based USB 2.0 Ethernet Adapters"
 	depends on USB_USBNET && NET_ETHERNET
 	select CRC32
-	select USB_USBNET_MII
+	select MII
 	default y
 	help
 	  This option adds support for ASIX AX88xxx based USB 2.0
@@ -190,7 +187,8 @@ config USB_NET_DM9601
 	tristate "Davicom DM9601 based USB 1.1 10/100 ethernet devices"
 	depends on USB_USBNET
 	select CRC32
-	select USB_USBNET_MII
+	select NET_ETHERNET
+	select MII
 	help
 	  This option adds support for Davicom DM9601 based USB 1.1
 	  10/100 Ethernet adapters.
@@ -225,7 +223,8 @@ config USB_NET_PLUSB
 config USB_NET_MCS7830
 	tristate "MosChip MCS7830 based Ethernet adapters"
 	depends on USB_USBNET
-	select USB_USBNET_MII
+	select NET_ETHERNET
+	select MII
 	help
 	  Choose this option if you're using a 10/100 Ethernet USB2
 	  adapter based on the MosChip 7830 controller. This includes



