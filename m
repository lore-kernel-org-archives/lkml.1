Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbYBWHUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbYBWHUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 02:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYBWHUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 02:20:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:60242 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbYBWHUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 02:20:04 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] drivers/thermal/thermal.c: fix a check-after-use
Date: Sat, 23 Feb 2008 02:19:49 -0500
User-Agent: KMail/1.9.5
Cc: Zhang Rui <rui.zhang@intel.com>, Thomas Sujith <sujith.thomas@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080220001404.GW31955@cs181133002.pp.htv.fi>
In-Reply-To: <20080220001404.GW31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802230219.50120.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 19:14, Adrian Bunk wrote:
> This patch fixes a check-after-use spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 570462ca4441d8d63dfd46efe6e5b2b1c251a611 diff --git a/drivers/thermal/thermal.c b/drivers/thermal/thermal.c
> index e782b3e..958654b 100644
> --- a/drivers/thermal/thermal.c
> +++ b/drivers/thermal/thermal.c
> @@ -308,10 +308,10 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  	struct thermal_cooling_device_instance *pos;
>  	int result;
>  
> -	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
> +	if (!tz || !cdev)
>  		return -EINVAL;
>  
> -	if (!tz || !cdev)
> +	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
>  		return -EINVAL;
>  
>  	dev =
> 
> --

this patch no longer applies because the bogus check for a programming error
was already replaced by a better check of run-time params.

thanks,
-len
