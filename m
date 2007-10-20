Return-Path: <linux-kernel-owner+w=401wt.eu-S1765985AbXJTSlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765985AbXJTSlK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757772AbXJTSk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:40:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60343 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbXJTSk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:40:56 -0400
Date: Sat, 20 Oct 2007 20:41:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net, mwallis@serialmonkey.com
Subject: rt73usb: support for wireless in Kohjinsha subnotebook
Message-ID: <20071020184100.GA11640@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Kohjinsha subnotebook seems to contain wifi with USB IDs 0x18e8,
0x6206... I hope that to be compatible with
net/wireless/rt2x00/rt73usb.c .

[Sidenote: could we add some real author info into rt73usb.c?]

I did this on 2.6.23-rc8-mm1 kernel (The RT hack may not be
neccessary), but then it oopses somewhere in softmac layer. I'll try
to play with it some more.

If you have any ideas, let me know.
								Pavel

--- clean-mm/drivers/net/wireless/rt2x00/rt73usb.c	2007-10-09 09:32:08.000000000 +0200
+++ linux-mm/drivers/net/wireless/rt2x00/rt73usb.c	2007-10-19 22:19:45.000000000 +0200
@@ -1580,7 +1580,6 @@
 
 	if (!rt2x00_rev(&rt2x00dev->chip, 0x25730)) {
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
-		return -ENODEV;
 	}
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF5226) &&
@@ -1588,7 +1587,6 @@
 	    !rt2x00_rf(&rt2x00dev->chip, RF5225) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2527)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
-		return -ENODEV;
 	}
 
 	/*
@@ -2080,6 +2078,7 @@
 	{ USB_DEVICE(0x148f, 0x2671), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6196), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x18e8, 0x6206), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x18e8, 0x6229), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x18e8, 0x6238), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Senao */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
