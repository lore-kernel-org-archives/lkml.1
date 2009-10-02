Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbZJBBkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbZJBBkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZJBBeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:09 -0400
Received: from kroah.org ([198.145.64.141]:33485 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888AbZJBBeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:24 2009
Message-Id: <20091002012424.630403355@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [111/136] USB: xhci: Dont touch xhci_td after its freed.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-don-t-touch-xhci_td-after-it-s-freed.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 9191eee7b8a0e18c07c06d6da502706805cab6d2 upstream.

On a successful transfer, urb->td is freed before the URB is ready to be
given back to the driver.  Don't touch urb->td after it's freed.  This bug
would have only shown up when xHCI debugging was turned on, and the freed
memory was quickly reused for something else.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1193,7 +1193,7 @@ cleanup:
 	if (urb) {
 		usb_hcd_unlink_urb_from_ep(xhci_to_hcd(xhci), urb);
 		xhci_dbg(xhci, "Giveback URB %p, len = %d, status = %d\n",
-				urb, td->urb->actual_length, status);
+				urb, urb->actual_length, status);
 		spin_unlock(&xhci->lock);
 		usb_hcd_giveback_urb(xhci_to_hcd(xhci), urb, status);
 		spin_lock(&xhci->lock);


