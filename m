Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZLWMDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZLWMDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZLWMDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:03:35 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58053 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZLWMDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=F0dbmHO/hIPXYSlD2CmeGlML0xC9BAG+fuu7sFIajImTX9b+B3wdG+Pio97+5kMy32
         e3MU1ZdCqwOupgJ8rkDdirv3Kg5TpXKVn+xRJSGDMr2Q6vsOYzOwaoBmM2bfmwp3M381
         YoQTX7uanDGKpLmAxBzNwI8j5n0nEbWSZr9pY=
Message-ID: <4B320700.8060905@gmail.com>
Date: Wed, 23 Dec 2009 19:03:12 +0700
From: Donny Kurnia <donnykurnia@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthias Urlichs <smurf@smurf.noris.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Kernel patch for usbserial driver, support hi speed for modem Haier
 CE100, kernel 2.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I made this patch for usbserial driver to add the support for EVDO modem Haier CE100. The bugs report for this is here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/490068

This patch based on these post:
http://blankblondtank.wordpress.com/2009/09/04/mengoptimalkan-koneksi-modem-haier-ce-100-cdma-di-linux/
http://tantos.web.id/blogs/how-to-internet-connection-using-cdma-evdo-modem-and-karmic-koala-ubuntu-9-10

I made this patch based on git that I clone from:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
at the same date of my patch below.

Here is the patch:

--- drivers/usb/serial/option.c.orig    2009-12-23 03:12:29.000000000 -0800
+++ drivers/usb/serial/option.c 2009-12-23 03:12:35.000000000 -0800
@@ -340,6 +340,10 @@ static int  option_resume(struct usb_ser
 #define FOUR_G_SYSTEMS_VENDOR_ID               0x1c9e
 #define FOUR_G_SYSTEMS_PRODUCT_W14             0x9603
 
+/* HAIER PRODUCTS */
+#define HAIER_VENDOR_ID                        0x201e
+#define HAIER_PRODUCT_CE100                    0x2009
+
 static struct usb_device_id option_ids[] = {
        { USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
        { USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -641,6 +645,7 @@ static struct usb_device_id option_ids[]
        { USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
        { USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
        { USB_DEVICE(FOUR_G_SYSTEMS_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14) },
+       { USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
        { } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);

End of patch.

I hope this patch can help other that have the Haier C100 modem, mostly in my country, Indonesia.

Signed-off-by: Donny Kurnia <donnykurnia@gmail.com>

Thanks.
--
Donny Kurnia
http://blog.abifathir.com
http://hantulab.blogspot.com
http://twitter.com/user/donnykurnia
http://plurk.com/user/donnykurnia


