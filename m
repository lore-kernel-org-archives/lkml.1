Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbYKMF4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbYKMF4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 00:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYKMF4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 00:56:15 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:49237 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYKMF4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 00:56:14 -0500
Date: Thu, 13 Nov 2008 00:56:09 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [sony-laptop] Fix regression caused by
 "sony-laptop: fingers off backlight if video.ko is serving this functionality"
In-reply-to: <200811122303.29372.ag@alessandroguido.name>
X-X-Sender: lenb@localhost.localdomain
To: Alessandro Guido <ag@alessandroguido.name>
Cc: trenn@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811130055550.21141@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200811122303.29372.ag@alessandroguido.name>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied.

thanks for testing!

-Len

On Wed, 12 Nov 2008, Alessandro Guido wrote:

> After commit 540b8bb9c33935183ceb5bed466a42ad72b2af56:
> 
>   sony-laptop: fingers off backlight if video.ko is serving this functionality
> 
> I can't set brightness on my sony laptop (nothing in /sys/class/backlight).
> dmesg says "sony-laptop: Sony: Brightness ignored, must be controlled by ACPI
> video driver".
> The function acpi_video_backlight_support returns 0 if we should use the
> vendor-specific backlight support, while non-0 if the ACPI generic should
> be used. Because of this, the check introduced by the said commit appears
> reversed.
> 
> Signed-off-by: Alessandro Guido <ag@alessandroguido.name>
> ---
> diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
> index 7bcb810..2a613d4 100644
> --- a/drivers/misc/sony-laptop.c
> +++ b/drivers/misc/sony-laptop.c
> @@ -1038,7 +1038,7 @@ static int sony_nc_add(struct acpi_device *device)
>  		goto outinput;
>  	}
>  
> -	if (!acpi_video_backlight_support()) {
> +	if (acpi_video_backlight_support()) {
>  		printk(KERN_INFO DRV_PFX "Sony: Brightness ignored, must be "
>  		       "controlled by ACPI video driver\n");
>  	} else if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle, "GBRT",
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
