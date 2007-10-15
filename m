Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbXJOHYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbXJOHYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 03:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbXJOHYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 03:24:24 -0400
Received: from mail.hevs.ch ([153.109.23.15]:36985 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbXJOHYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 03:24:23 -0400
X-Greylist: delayed 1943 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 03:24:23 EDT
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: linux-wireless@vger.kernel.org
Subject: [PATCH] zd1211rw, fix oops when ejecting install media
Date: Mon, 15 Oct 2007 08:51:52 +0200
User-Agent: KMail/1.9.7
Cc: dsd@gentoo.org, kune@deine-taler.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710150851.52995.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The disconnect function can dereference the net_device structure before it is
allocated. This is the case when ejecting the device installer.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>

---

Hello!

Patch against 2.6.23.
This patch fixes the bug I've submitted to linux-wireless friday in the
"zd1211rw on 2.6.23 oops ejecting device" thread.

Regards

Marc

--- drivers/net/wireless/zd1211rw/zd_usb.c.orig	2007-10-15 08:29:16.000000000 +0200
+++ drivers/net/wireless/zd1211rw/zd_usb.c	2007-10-15 08:29:32.000000000 +0200
@@ -1041,14 +1041,17 @@ error:
 static void disconnect(struct usb_interface *intf)
 {
 	struct net_device *netdev = zd_intf_to_netdev(intf);
-	struct zd_mac *mac = zd_netdev_mac(netdev);
-	struct zd_usb *usb = &mac->chip.usb;
+	struct zd_mac *mac;
+	struct zd_usb *usb;
 
 	/* Either something really bad happened, or we're just dealing with
 	 * a DEVICE_INSTALLER. */
 	if (netdev == NULL)
 		return;
 
+	mac = zd_netdev_mac(netdev);
+	usb = &mac->chip.usb;
+
 	dev_dbg_f(zd_usb_dev(usb), "\n");
 
 	zd_netdev_disconnect(netdev);


