Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbYCKBAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbYCKBAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbYCKA7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:59:39 -0400
Received: from mail.suse.de ([195.135.220.2]:60541 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539AbYCKA7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:59:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/6] USB: enable USB-PERSIST by default
Date: Mon, 10 Mar 2008 17:59:12 -0700
Message-Id: <1205197152-18146-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080311004239.GD17890@suse.de>
References: <20080311004239.GD17890@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1052) enables USB-PERSIST for all devices by default.
The user won't have to remember to enable it explicitly for devices
containing mounted filesystems.

Eventually userspace tools like hal may be able to set the persist
attribute automatically when a filesystem is mounted on a USB device.
When that time comes this patch can be reverted, if people think it
matters.

This approach has the advantage of giving the user the ability to turn
off USB-PERSIST for devices with mounted filesystems, rather than
making the kernel always assume it should be on.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/quirks.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 10d66d0..93e12f1 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -95,12 +95,14 @@ void usb_detect_quirks(struct usb_device *udev)
 		udev->autosuspend_disabled = 1;
 #endif
 
-#ifdef	CONFIG_PM
+	/* For the present, all devices default to USB-PERSIST enabled */
+#if 0		/* was: #ifdef CONFIG_PM */
 	/* Hubs are automatically enabled for USB-PERSIST */
 	if (udev->descriptor.bDeviceClass == USB_CLASS_HUB)
 		udev->persist_enabled = 1;
+
 #else
-	/* In the absense of PM, we can safely enable USB-PERSIST
+	/* In the absence of PM, we can safely enable USB-PERSIST
 	 * for all devices.  It will affect things like hub resets
 	 * and EMF-related port disables.
 	 */
-- 
1.5.4.3

