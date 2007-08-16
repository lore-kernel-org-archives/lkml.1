Return-Path: <linux-kernel-owner+w=401wt.eu-S1765287AbXHPXc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765287AbXHPXc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 19:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758438AbXHPXcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 19:32:15 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56847 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759778AbXHPXcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 19:32:13 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 19:32:13 EDT
MBOX-Line: From Paul Walmsley <paul@pwsan.com> Thu Aug 16 16:22:39 2007
Message-Id: <20070816232239.533779000@pwsan.com>
References: <20070816232134.151893000@pwsan.com>
User-Agent: quilt/0.45-1
Date: Thu, 16 Aug 2007 16:21:35 -0700
From: Paul Walmsley <paul@pwsan.com>
To: linux-kernel@vger.kernel.org
Cc: Raj Kumar <rkumar@archive.org>, <gphoto-devel@lists.sourceforge.net>,
       Siznax <steve@archive.org>, Brewster Kahle <brewster@archive.org>
Subject: [patch 1/1] usb quirks: Add Canon EOS 5D (PC Connection mode) to the autosuspend blacklist
Content-Disposition: inline; filename=canon-eos5d-no-autosuspend.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recent versions of the Linux kernel auto-suspend attached USB devices.
After this happens to the Canon EOS 5D camera, the camera's interrupt endpoints
don't seem to wake back up correctly, causing further use with libgphoto2
to fail with a -114 "OS error in camera communication" error.  

A similar fix is probably necessary for this camera in PTP mode, which
identifies as USB product id 0x3102, but we haven't tested this.

As part of our testing process, we tried the USB_QUIRK_RESET_RESUME
quirk also, it's not helpful in this case.

Applies against 2.6.23-rc3.

Signed-off-by: Raj Kumar <rkumar@archive.org>
Signed-off-by: Paul Walmsley <paul@pwsan.com>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/usb/core/quirks.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/quirks.c	2007-08-16 14:42:31.000000000 -0700
+++ linux-2.6/drivers/usb/core/quirks.c	2007-08-16 16:17:51.000000000 -0700
@@ -70,6 +70,9 @@
 	/* Philips PSC805 audio device */
 	{ USB_DEVICE(0x0471, 0x0155), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Canon EOS 5D in PC Connection mode */
+	{ USB_DEVICE(0x04a9, 0x3101), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
+
 	/* RIM Blackberry */
 	{ USB_DEVICE(0x0fca, 0x0001), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
 	{ USB_DEVICE(0x0fca, 0x0004), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },

--

