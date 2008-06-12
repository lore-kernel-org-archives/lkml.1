Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbYFLOEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbYFLOEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762658AbYFLOE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:04:27 -0400
Received: from japan.chezphil.org ([77.240.5.4]:5820 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762649AbYFLOEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:04:25 -0400
X-Greylist: delayed 2826 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2008 10:04:25 EDT
To: "Paul Collins" <paul@burly.ondioline.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <marcel@holtmann.org>, <jkosina@suse.cz>
Date: Thu, 12 Jun 2008 14:17:16 +0100
Subject: Re: [PATCH] [RESEND] fix HID quirks for aluminium apple wireless
	keyboards
Message-ID: <1213276636216@dmwebmail.dmwebmail.chezphil.org>
In-Reply-To: <874p7ylsj0.fsf@burly.wgtn.ondioline.org>
References: <874p7ylsj0.fsf@burly.wgtn.ondioline.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="fixed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins wrote:
> Hi Marcel and Jiri,
>
> I noticed that the quirks for Bluetooth Apple keyboards seem to have
> been incorrectly added to the USB HID, thus rendering them ineffective.
> Here is a patch that moves them to the Bluetooth HID.  With this patch
> applied the Fn key on my Apple wireless keyboard now works as expected.
>
> I also took the liberty of adding defines for the vendor and for the
> existing Mighty Mouse quirk.
>
> Signed-off-by: Paul Collins <paul@ondioline.org>
>
> ---
> Here's a new version with corrected Signed-off-by line.  Also the
> previous one was truncated by gmane; with any luck this makes it.
>
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 1df832a..ff41c07 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -72,9 +72,6 @@
>  #define USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI    0x0229
>  #define USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO     0x022a
>  #define USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS     0x022b
> -#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI  0x022c
> -#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO   0x022d
> -#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS   0x022e
>  #define USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY	0x030a
>  #define USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY	0x030b
>  #define USB_DEVICE_ID_APPLE_IRCONTROL4	0x8242
> @@ -639,9 +636,6 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
>  	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
>  	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
> -	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
> -	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
> -	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
>  	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
>  	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
>  
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index 519cdb9..f0762e5 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -671,14 +671,26 @@ static void hidp_close(struct hid_device *hid)
>  {
>  }
>  
> +#define BT_VENDOR_ID_APPLE				0x05ac
> +
> +#define BT_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI		0x022c
> +#define BT_DEVICE_ID_APPLE_ALU_WIRELESS_ISO		0x022d
> +#define BT_DEVICE_ID_APPLE_ALU_WIRELESS_JIS		0x022e
> +#define BT_DEVICE_ID_APPLE_MIGHTY_MOUSE_WIRELESS	0x030c
> +
>  static const struct {
>  	__u16 idVendor;
>  	__u16 idProduct;
>  	unsigned quirks;
>  } hidp_blacklist[] = {
> -	/* Apple wireless Mighty Mouse */
> -	{ 0x05ac, 0x030c, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
> -
> +	{ BT_VENDOR_ID_APPLE, BT_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI,
> +	  HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
> +	{ BT_VENDOR_ID_APPLE, BT_DEVICE_ID_APPLE_ALU_WIRELESS_ISO,
> +	  HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
> +	{ BT_VENDOR_ID_APPLE, BT_DEVICE_ID_APPLE_ALU_WIRELESS_JIS,
> +	  HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
> +	{ BT_VENDOR_ID_APPLE, BT_DEVICE_ID_APPLE_MIGHTY_MOUSE_WIRELESS,
> +	  HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
>  	{ }	/* Terminating entry */
>  };
>  

Hi Paul,

Did you see my messages about this a few weeks ago?  
http://thread.gmane.org/gmane.linux.kernel.input/4984

I didn't post a patch because I believe that this stuff has all moved as a 
result of Jiri Slaby's patch "HID: move apple quirks" posted to linux-input 
on 2008-05-16.  One of us should prepare a patch against the tree after 
that patch.

Does HID_QUIRK_APPLE_NUMLOCK_EMULATION do anything useful on these keyboards?  
I have not enabled it.

Do you know what happens if you have a USB bluetooth dongle with HID proxy 
mode?  My assumption was that the vendor and product IDs from the keyboard 
would then appear to the kernel as USB IDs.  If this is true, then you should 
keep the existing entries for these devices in the USB quirks tables.  Does 
anyone know if HID proxy dongles actually do this?  In any case, leaving 
the existing entries in the USB quirks table can't do any harm.

I wrote this up at http://chezphil.org/apple-alu-bluetooth-kb-linux/ and I'll 
just post that URL again to help the search engines...

Cheers,

Phil.

