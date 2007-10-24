Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbXJXX11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbXJXX11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXJXX1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:27:17 -0400
Received: from rwcrmhc12.comcast.net ([216.148.227.152]:35988 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbXJXX1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:27:16 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 19:27:16 EDT
Date: Wed, 24 Oct 2007 19:22:10 -0400 (EDT)
From: Parag Warudkar <kernel-stuff@comcast.net>
X-X-Sender: parag@parag-desktop
To: linux-kernel@vger.kernel.org
cc: rt2400-devel@lists.sourceforge.net
Subject: [PATCH] rt2500usb - Don't claim 050d:705{0/a}
Message-ID: <alpine.DEB.0.99.0710241909250.18618@parag-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Belkin USB Wireless adapter with ID 050d:705a.
Both rt2500usb.c and rt73usb.c claim that they can drive the device with 
this ID.

When using the distro kernel as well as custom 2.4.24-rc1 both rt73usb and 
rt2500usb get loaded and fight for the register writes and fail. rt2500usb 
is not able to drive my device. So I have to manually rmmod/modprobe or 
delete rt2500usb.ko and depmod every time I get a new kernel.

If only rt73usb is loaded everything works well. To me it 
sounds like rt2500usb should not be driving 050d:705a.

There is another ID 050d:7050 which is also claimed to be handled by both 
rt3500usb and rt73usb. Assuming rt73usb can drive this as well (I have no 
way to be sure as I don't have device with this ID) the following patch 
makes sure only rt73usb claims the 2 devices.

Signed-off-by: Parag Warudkar <kernel-stuff@comcast.net>

--- linux-2.6-wk/drivers/net/wireless/rt2x00/rt2500usb.c.orig	2007-10-24 18:51:45.000000000 -0400
+++ linux-2.6-wk/drivers/net/wireless/rt2x00/rt2500usb.c	2007-10-24 18:52:31.000000000 -0400
@@ -1758,9 +1758,7 @@
  	{ USB_DEVICE(0x0b05, 0x1706), USB_DEVICE_DATA(&rt2500usb_ops) },
  	{ USB_DEVICE(0x0b05, 0x1707), USB_DEVICE_DATA(&rt2500usb_ops) },
  	/* Belkin */
-	{ USB_DEVICE(0x050d, 0x7050), USB_DEVICE_DATA(&rt2500usb_ops) },
  	{ USB_DEVICE(0x050d, 0x7051), USB_DEVICE_DATA(&rt2500usb_ops) },
-	{ USB_DEVICE(0x050d, 0x705a), USB_DEVICE_DATA(&rt2500usb_ops) },
  	/* Cisco Systems */
  	{ USB_DEVICE(0x13b1, 0x000d), USB_DEVICE_DATA(&rt2500usb_ops) },
  	{ USB_DEVICE(0x13b1, 0x0011), USB_DEVICE_DATA(&rt2500usb_ops) },




