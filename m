Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935459Ab0CMAge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:36:34 -0500
Received: from kroah.org ([198.145.64.141]:47175 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935351Ab0CMAcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:22 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:15 2010
Message-Id: <20100313002715.704078803@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [120/145] USB: remove debugging message for uevent constructions
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
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
@@ -625,9 +625,6 @@ static int usb_uevent(struct device *dev
 {
 	struct usb_device *usb_dev;
 
-	/* driver is often null here; dev_dbg() would oops */
-	pr_debug("usb %s: uevent\n", dev_name(dev));
-
 	if (is_usb_device(dev)) {
 		usb_dev = to_usb_device(dev);
 	} else if (is_usb_interface(dev)) {
@@ -639,6 +636,7 @@ static int usb_uevent(struct device *dev
 	}
 
 	if (usb_dev->devnum < 0) {
+		/* driver is often null here; dev_dbg() would oops */
 		pr_debug("usb %s: already deleted?\n", dev_name(dev));
 		return -ENODEV;
 	}


