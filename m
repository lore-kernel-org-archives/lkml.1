Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbXFCJlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbXFCJlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 05:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760858AbXFCJl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 05:41:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:57712 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759471AbXFCJl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 05:41:26 -0400
Date: Sun, 3 Jun 2007 11:41:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz> 
 <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com> 
 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz> 
 <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com> 
 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz> 
 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com> 
 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com> 
 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com> 
 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
 <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Renato Golin wrote:

> 06a3:ffb5 Saitek PLC

Please try this patch on top of 2.6.20

diff --git a/drivers/usb/input/hid-core.c b/drivers/usb/input/hid-core.c
index c6c9e72..d73f949 100644
--- a/drivers/usb/input/hid-core.c
+++ b/drivers/usb/input/hid-core.c
@@ -692,6 +692,7 @@ void usbhid_init_reports(struct hid_devi
 #define USB_DEVICE_ID_IBM_GAMEPAD	0x1101
 
 #define USB_VENDOR_ID_SAITEK		0x06a3
+#define USB_DEVICE_ID_SAITEK_CYBORG	0xffb5
 #define USB_DEVICE_ID_SAITEK_RUMBLEPAD	0xff17
 
 #define USB_VENDOR_ID_NEC		0x073e
@@ -941,6 +942,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_NEC, USB_DEVICE_ID_NEC_USB_GAME_PAD, HID_QUIRK_BADPAD },
+	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_CYBORG, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RUMBLEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD, HID_QUIRK_BADPAD },
 
> I'm using 2.6.20 and compiling new kernels for Ubuntu is a nightmare.

I have never used ubuntu, but why should that be that difficult? Just 
download vanilla kernel from kernel.org, use your distro's .config, make 
oldconfig && make ... ?

> Also, would be good not to need additional parameters for the general
> public.

Sure, this was rather a debugging option just to test whether this is the 
proper quirk.

Thanks,

-- 
Jiri Kosina
SUSE Labs
