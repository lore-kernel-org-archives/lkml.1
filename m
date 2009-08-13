Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbZHMTuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbZHMTuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbZHMTuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:50:06 -0400
Received: from kroah.org ([198.145.64.141]:36793 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169AbZHMTsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:48:01 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:39 2009
Message-Id: <20090813194339.196018261@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [patch 23/28] USB: usbfs: fix -ENOENT error code to be -ENODEV
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=usb-usbfs-fix-enoent-error-code-to-be-enodev.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 01105a246345f011fde64d24a601090b646e9e4c upstream.

This patch (as1272) changes the error code returned when an open call
for a USB device node fails to locate the corresponding device.  The
appropriate error code is -ENODEV, not -ENOENT.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -579,7 +579,7 @@ static int usbdev_open(struct inode *ino
 	if (!ps)
 		goto out;
 
-	ret = -ENOENT;
+	ret = -ENODEV;
 
 	/* usbdev device-node */
 	if (imajor(inode) == USB_DEVICE_MAJOR)


