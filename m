Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYFNIG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYFNIG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 04:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYFNIGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 04:06:15 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:56095 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbYFNIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 04:06:11 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] [RESEND] fix HID quirks for aluminium apple wireless keyboards
References: <87iqweltzo.fsf@burly.wgtn.ondioline.org>
	<874p7ylsj0.fsf@burly.wgtn.ondioline.org>
	<1213301289.17870.72.camel@violet.holtmann.net>
Date: Sat, 14 Jun 2008 20:03:07 +1200
Message-ID: <87tzfwiguc.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann <marcel@holtmann.org> writes:

>> I also took the liberty of adding defines for the vendor and for the
>> existing Mighty Mouse quirk.
>
> I prefer not to do this. I don't see any benefit or readability coming
> out of it. Leave it as it is. Add the numeric ids and then a line on top
> of it describing the devices.

Here is a new version of the patch that just adds the entries to
hidp_blacklist using your suggested style.  I'm leaving the USB HID's
table alone based on Phil Endecott's remarks regarding HID proxy mode,
so now this patch only touches Bluetooth code.


bluetooth: fix Fn on Apple Wireless Keyboard

Enable the HID quirks for Apple Wireless Keyboards, based on the quirk
table entries in the USB HID.  With this patch applied the Fn key on my
keyboard now functions as expected.

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 519cdb9..62f174a 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -676,6 +676,12 @@ static const struct {
 	__u16 idProduct;
 	unsigned quirks;
 } hidp_blacklist[] = {
+	/* Apple Wireless Keyboard, ANSI layout */
+	{ 0x05ac, 0x022c, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
+	/* Apple Wireless Keyboard, ISO layout */
+	{ 0x05ac, 0x022d, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	/* Apple Wireless Keyboard, JIS layout */
+	{ 0x05ac, 0x022e, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
 	/* Apple wireless Mighty Mouse */
 	{ 0x05ac, 0x030c, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
 


-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
