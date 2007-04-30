Return-Path: <linux-kernel-owner+w=401wt.eu-S1031514AbXD3L5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031514AbXD3L5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031525AbXD3L5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:57:11 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:32809 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031514AbXD3L5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:57:09 -0400
Date: Mon, 30 Apr 2007 13:55:37 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH 32/36] Use menuconfig objects II - USB
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301354540.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/usb/Kconfig |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/usb/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/usb/Kconfig
@@ -2,7 +2,11 @@
 # USB device configuration
 #
 
-menu "USB support"
+menuconfig USB_SUPPORT
+	bool "USB support"
+	default y
+
+if USB_SUPPORT
 
 # Host-side USB depends on having a host controller
 # NOTE:  dummy_hcd is always an option, but it's ignored here ...
@@ -133,5 +137,4 @@ source "drivers/usb/atm/Kconfig"
 
 source "drivers/usb/gadget/Kconfig"
 
-endmenu
-
+endif # USB_SUPPORT
