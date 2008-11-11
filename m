Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYKKHrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYKKHrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 02:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYKKHrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 02:47:07 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:51423 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbYKKHrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 02:47:06 -0500
Date: Tue, 11 Nov 2008 07:47:02 +0000
From: Nick Warne <nick@ukfsn.org>
To: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] Make Dell keyboard repeat quirk apply to a wider range
 of hardware
Message-ID: <20081111074702.75e71055@sauron.linicks.net>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Dell laptops fail to send key up events for several of their special 
> keys. There's an existing quirk in the kernel to handle this, but it's 
> limited to the Latitude range. This patch extends it to cover all 
> portable Dells.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
> index b1ce10f..e32c24d 100644
> --- a/drivers/input/keyboard/atkbd.c
> +++ b/drivers/input/keyboard/atkbd.c
> @@ -834,10 +834,10 @@ static void atkbd_disconnect(struct serio *serio)
>  }
>  
>  /*
> - * Most special keys (Fn+F?) on Dell Latitudes do not generate release
> + * Most special keys (Fn+F?) on Dell laptops do not generate release
>   * events so we have to do it ourselves.
>   */
> -static void atkbd_latitude_keymap_fixup(struct atkbd *atkbd)
> +static void atkbd_dell_laptop_keymap_fixup(struct atkbd *atkbd)
>  {
>  	const unsigned int forced_release_keys[] = {
>  		0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8f, 0x93,
> @@ -1461,13 +1461,13 @@ static int __init atkbd_setup_fixup(const struct dmi_system_id *id)
>  
>  static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
>  	{
> -		.ident = "Dell Latitude series",
> +		.ident = "Dell Laptop",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
> +			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
>  		},
>  		.callback = atkbd_setup_fixup,
> -		.driver_data = atkbd_latitude_keymap_fixup,
> +		.driver_data = atkbd_dell_laptop_keymap_fixup,
>  	},
>  	{
>  		.ident = "HP 2133",

This issue has hit a lot of Ubuntu Dell uses (like myself), and the
patch indeed fixes it up - but it appears not all Dell machines are
alike.  One user has reported it doesn't work, and his investigation
reveals dmicode output shows:

Vendor: Dell Computer Corporation

So I guess this isn't totally fixed yet.  As to what the vendor output
is al all these machines, I don't know, but I guess now it could be any
permatation of Dell Inc., Dell Computer Corp. etc.

Ref. Ubuntu bug report thread:

https://bugs.launchpad.net/ubuntu/+source/acpid/+bug/285323/comments/88

Nick

-- 
Free Software Foundation Associate Member 5508
