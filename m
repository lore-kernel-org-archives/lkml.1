Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbYFNMvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbYFNMvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 08:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYFNMvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 08:51:37 -0400
Received: from japan.chezphil.org ([77.240.5.4]:3611 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYFNMvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 08:51:36 -0400
To: "Paul Collins" <paul@burly.ondioline.org>
Cc: <jkosina@suse.cz>, <linux-input@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>
Date: Sat, 14 Jun 2008 13:51:33 +0100
Subject: Re: [PATCH] [RESEND] fix HID quirks for aluminium apple wireless
	keyboards
Message-ID: <1213447893811@dmwebmail.dmwebmail.chezphil.org>
In-Reply-To: <87tzfwiguc.fsf@burly.wgtn.ondioline.org>
References: <87tzfwiguc.fsf@burly.wgtn.ondioline.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins wrote:
> Here is a new version of the patch that just adds the entries to
> hidp_blacklist using your suggested style.  I'm leaving the USB HID's
> table alone based on Phil Endecott's remarks regarding HID proxy mode,
> so now this patch only touches Bluetooth code.
>
>
> bluetooth: fix Fn on Apple Wireless Keyboard
>
> Enable the HID quirks for Apple Wireless Keyboards, based on the quirk
> table entries in the USB HID.  With this patch applied the Fn key on my
> keyboard now functions as expected.
>
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index 519cdb9..62f174a 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -676,6 +676,12 @@ static const struct {
>  	__u16 idProduct;
>  	unsigned quirks;
>  } hidp_blacklist[] = {
> +	/* Apple Wireless Keyboard, ANSI layout */
> +	{ 0x05ac, 0x022c, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
> +	/* Apple Wireless Keyboard, ISO layout */
> +	{ 0x05ac, 0x022d, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
> +	/* Apple Wireless Keyboard, JIS layout */
> +	{ 0x05ac, 0x022e, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
>  	/* Apple wireless Mighty Mouse */
>  	{ 0x05ac, 0x030c, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },

Why do you set HID_QUIRK_APPLE_NUMLOCK_EMULATION ?  I don't know what 
that quirk really does, but since these keyboards have neither a 
numeric keypad nor a numlock key I can't see any benefit.


Phil.



