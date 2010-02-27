Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967949Ab0B0IJc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:09:32 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49371 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967928Ab0B0IJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:09:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uubRWWfd/DipJpseQuPG6vcFahe4T6+d2edgGYthA1hQ68St37Aivdxw3PvE9bmvhx
         nJbgcYLI2uVXSIhFgHIw+iDBIT+kZ9k0rQF+nxVKLbwHgBelMLDilBIQwJsvmsHZb7Cc
         y0T/zRD2+/hzrUzeYTbpDqfzn4WdwHuFKU0LM=
Date: Sat, 27 Feb 2010 00:09:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] dell-laptop: Fix platform device unregistration
Message-ID: <20100227080926.GE793@core.coreip.homeip.net>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
 <1267197527-18062-6-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267197527-18062-6-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 10:18:38AM -0500, Matthew Garrett wrote:
> dell-laptop currently fails to clean up its platform device correctly.
> Make sure that it's unregistered.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/platform/x86/dell-laptop.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
> index 9d7e0be..b4c2190 100644
> --- a/drivers/platform/x86/dell-laptop.c
> +++ b/drivers/platform/x86/dell-laptop.c
> @@ -474,6 +474,10 @@ static void __exit dell_exit(void)
>  	i8042_remove_filter(dell_laptop_i8042_filter);
>  	backlight_device_unregister(dell_backlight_device);
>  	dell_cleanup_rfkill();
> +	if (platform_device) {
> +		platform_device_del(platform_device);

That should be platform_device_unregister(), otherwise you are missing
final platform_device_put().

> +		platform_driver_unregister(&platform_driver);
> +	}
>  }
>  

-- 
Dmitry
