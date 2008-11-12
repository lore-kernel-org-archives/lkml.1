Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYKLW13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYKLW13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYKLW1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:27:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbYKLW1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:27:19 -0500
From: Thomas Renninger <trenn@suse.de>
To: Alessandro Guido <ag@alessandroguido.name>
Subject: Re: [sony-laptop] Fix regression caused by "sony-laptop: fingers off backlight if video.ko is serving this functionality"
Date: Wed, 12 Nov 2008 16:27:12 -0600
User-Agent: KMail/1.9.10
Cc: len.brown@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <200811122303.29372.ag@alessandroguido.name>
In-Reply-To: <200811122303.29372.ag@alessandroguido.name>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121627.13525.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008 04:03:28 pm Alessandro Guido wrote:
> After commit 540b8bb9c33935183ceb5bed466a42ad72b2af56:
>
>   sony-laptop: fingers off backlight if video.ko is serving this
> functionality
>
> I can't set brightness on my sony laptop (nothing in /sys/class/backlight).
> dmesg says "sony-laptop: Sony: Brightness ignored, must be controlled by
> ACPI video driver".
> The function acpi_video_backlight_support returns 0 if we should use the
> vendor-specific backlight support, while non-0 if the ACPI generic should
> be used. Because of this, the check introduced by the said commit appears
> reversed.
>
> Signed-off-by: Alessandro Guido <ag@alessandroguido.name>

Thanks for finding this stupid typo,

       Thomas

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


