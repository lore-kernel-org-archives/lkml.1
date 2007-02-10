Return-Path: <linux-kernel-owner+w=401wt.eu-S1946803AbXBJAZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946803AbXBJAZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946802AbXBJAZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:25:07 -0500
Received: from hansmi.home.forkbomb.ch ([213.144.146.165]:7459 "EHLO
	hansmi.home.forkbomb.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423373AbXBJAZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:25:06 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 19:25:06 EST
Date: Sat, 10 Feb 2007 01:18:23 +0100
From: Michael Hanselmann <linux-kernel@hansmi.ch>
To: linux-kernel@vger.kernel.org
Cc: len.brown@intel.com, akpm@linux-foundation.org, cappaberra@gmail.com
Subject: Fix null pointer dereference in appledisplay driver
Message-ID: <20070210001823.GA3557@hansmi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 40b20c257a13c5a526ac540bc5e43d0fdf29792a by Len Brown introduced
a null pointer dereference in the appledisplay driver. This patch fixes
it.

Signed-off-by: Michael Hanselmann <linux-kernel@hansmi.ch>

---
I suggest adding this to 2.6.20.1 because this bug causes the kernel to
panic on boot when the driver is compiled in.

diff -Nrup --exclude-from linux-exclude-from linux-2.6.20.orig/drivers/usb/misc/appledisplay.c linux-2.6.20/drivers/usb/misc/appledisplay.c
--- linux-2.6.20.orig/drivers/usb/misc/appledisplay.c	2007-02-09 22:35:56.000000000 +0100
+++ linux-2.6.20/drivers/usb/misc/appledisplay.c	2007-02-10 01:00:28.000000000 +0100
@@ -281,8 +281,8 @@ static int appledisplay_probe(struct usb
 	/* Register backlight device */
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
 		atomic_inc_return(&count_displays) - 1);
-	pdata->bd = backlight_device_register(bl_name, NULL, NULL,
-						&appledisplay_bl_data);
+	pdata->bd = backlight_device_register(bl_name, NULL,
+		pdata, &appledisplay_bl_data);
 	if (IS_ERR(pdata->bd)) {
 		err("appledisplay: Backlight registration failed");
 		goto error;
