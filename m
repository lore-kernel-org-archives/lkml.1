Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601Ab0AKIfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0AKIfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197Ab0AKIf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:35:29 -0500
Received: from h3281.serverkompetenz.net ([81.169.158.52]:39045 "EHLO
	h3281.serverkompetenz.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab0AKIf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:35:29 -0500
Message-ID: <4B4AE2C5.8070203@hillier.de>
Date: Mon, 11 Jan 2010 09:35:17 +0100
From: Gernot Hillier <gernot@hillier.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthias Urlichs <smurf@smurf.noris.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] option.c: Add 4G W14 stick to blacklist for option_send_setup
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gernot Hillier <gernot@hillier.de>

The 4G XS Stick W14 seems to not understand RTS/DTR setting in 
option_send_setup causing long timeouts on any open() which 
disturbs a lot of well-known userspace applications like 
minicom or ModemManager.

Therefore, we enable OPTION_BLACKLIST_SENDSETUP blacklisting for it.

Signed-off-by: Gernot Hillier <gernot@hillier.de>

Index: linux-next/drivers/usb/serial/option.c
===================================================================
--- linux-next.orig/drivers/usb/serial/option.c	2010-01-09 10:25:00.000000000 +0100
+++ linux-next/drivers/usb/serial/option.c	2010-01-09 10:25:05.000000000 +0100
@@ -357,6 +357,13 @@ struct option_blacklist_info {
 	option_blacklist_reason_t reason;
 };
 
+static const u8 four_g_w14_no_sendsetup[] = { 0, 1 };
+static const struct option_blacklist_info four_g_w14_blacklist = {
+	.infolen = ARRAY_SIZE(four_g_w14_no_sendsetup),
+	.ifaceinfo = four_g_w14_no_sendsetup,
+	.reason = OPTION_BLACKLIST_SENDSETUP
+};
+
 static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -657,7 +664,9 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
-	{ USB_DEVICE(FOUR_G_SYSTEMS_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14) },
+  	{ USB_DEVICE(FOUR_G_SYSTEMS_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
+  	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
+  	},
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
 	{ } /* Terminating entry */
 };
