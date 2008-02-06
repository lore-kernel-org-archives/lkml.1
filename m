Return-Path: <linux-kernel-owner+w=401wt.eu-S1761853AbYBFAvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853AbYBFAvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYBFAvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:51:12 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39969 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbYBFAvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:51:11 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: jeff@garzik.org
Subject: [patch] usb net: asix does not really need 10/100mbit
Date: Tue, 5 Feb 2008 19:47:42 -0500
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051947.43247.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asix usb driver currently depends on NET_ETHERNET which means you cannot
enable this driver if you only have 1000mbit enabled in your kernel.  Since
there is no real dependency between the NET_ETHERNET portion and the asix
driver, simply drop it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index a12c9c4..0604f3f 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -129,7 +129,7 @@ config USB_USBNET
 
 config USB_NET_AX8817X
 	tristate "ASIX AX88xxx Based USB 2.0 Ethernet Adapters"
-	depends on USB_USBNET && NET_ETHERNET
+	depends on USB_USBNET
 	select CRC32
 	default y
 	help
