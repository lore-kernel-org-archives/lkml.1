Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935151Ab0CMBPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:15:24 -0500
Received: from kroah.org ([198.145.64.141]:32806 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934994Ab0CMAUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:55 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:13 2010
Message-Id: <20100313001513.530168611@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 096/123] USB: remove debugging message for uevent constructions
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Alan Stern <stern@rowland.harvard.edu>

commit cceffe9348f93188d7811bda95924d4bd3040d0f upstream.

This patch (as1332) removes an unneeded and annoying debugging message
announcing all USB uevent constructions.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -691,9 +691,6 @@ static int usb_uevent(struct device *dev
 {
 	struct usb_device *usb_dev;
 
-	/* driver is often null here; dev_dbg() would oops */
-	pr_debug("usb %s: uevent\n", dev_name(dev));
-
 	if (is_usb_device(dev)) {
 		usb_dev = to_usb_device(dev);
 	} else if (is_usb_interface(dev)) {
@@ -705,6 +702,7 @@ static int usb_uevent(struct device *dev
 	}
 
 	if (usb_dev->devnum < 0) {
+		/* driver is often null here; dev_dbg() would oops */
 		pr_debug("usb %s: already deleted?\n", dev_name(dev));
 		return -ENODEV;
 	}


