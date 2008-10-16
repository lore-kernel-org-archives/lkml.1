Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbYJPXRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbYJPXRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbYJPXRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:17:21 -0400
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:39649
	"EHLO tadamune.kami.home" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759090AbYJPXRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:17:17 -0400
X-Greylist: delayed 1690 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2008 19:17:17 EDT
Date: Fri, 17 Oct 2008 07:49:03 +0900
From: Mattia Dongili <malattia@linux.it>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] sony-laptop: Ignore missing _DIS method on pic device
Message-ID: <20081016224903.GD21963@inferi.kami.home>
References: <1224192550-366-1-git-send-email-ajax@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224192550-366-1-git-send-email-ajax@redhat.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.26-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 05:29:10PM -0400, Adam Jackson wrote:
> From: Matthew Garrett <mjg59@srcf.ucam.org>
> 
> At least the Vaio VGN-Z540N doesn't have this method, so let's not fail
> to suspend just because it doesn't exist.

Do you happen to have a DSDT dump for this model? I'd be glad to see it.

> Signed-off-by: Adam Jackson <ajax@redhat.com>

Acked-by: Mattia Dongili <malattia@linux.it>

> ---
>  drivers/misc/sony-laptop.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
> index 60775be..b35eb92 100644
> --- a/drivers/misc/sony-laptop.c
> +++ b/drivers/misc/sony-laptop.c
> @@ -2315,8 +2315,10 @@ end:
>   */
>  static int sony_pic_disable(struct acpi_device *device)
>  {
> -	if (ACPI_FAILURE(acpi_evaluate_object(device->handle,
> -			"_DIS", NULL, NULL)))
> +	acpi_status ret = acpi_evaluate_object(device->handle, "_DIS", NULL,
> +					       NULL);
> +
> +	if (ACPI_FAILURE(ret) && ret != AE_NOT_FOUND)
>  		return -ENXIO;
>  
>  	dprintk("Device disabled\n");
> -- 
> 1.6.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
-- 
mattia
:wq!
