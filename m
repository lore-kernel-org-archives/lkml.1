Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbZA1JNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbZA1JNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZA1JNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:13:11 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44287 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZA1JNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:13:10 -0500
Date: Wed, 28 Jan 2009 09:13:06 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Lubomir Rintel <lkundrak@v3.sk>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       eric@anholt.net
Subject: Re: [PATCH] Fix a panic with 1M of shared memory, no GTT entries
In-Reply-To: <1233131443.5389.12.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0901280912350.29809@skynet.skynet.ie>
References: <1233131443.5389.12.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> When GTT size is equal to amount of video memory, the amount of GTT
> entries is computed lower than zero, which is invalid and leads to
> off-by-one error in intel_i915_configure()
> 
> Originally posted here:
> http://bugzilla.kernel.org/show_bug.cgi?id=12539
> http://bugzilla.redhat.com/show_bug.cgi?id=445592

cc'ed Intel agp knowledge.

Dave.

> 
> Signed-Off-By: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  drivers/char/agp/intel-agp.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> index c771418..4373adb 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -633,13 +633,15 @@ static void intel_i830_init_gtt_entries(void)
>  			break;
>  		}
>  	}
> -	if (gtt_entries > 0)
> +	if (gtt_entries > 0) {
>  		dev_info(&agp_bridge->dev->dev, "detected %dK %s memory\n",
>  		       gtt_entries / KB(1), local ? "local" : "stolen");
> -	else
> +		gtt_entries /= KB(4);
> +	} else {
>  		dev_info(&agp_bridge->dev->dev,
>  		       "no pre-allocated video memory detected\n");
> -	gtt_entries /= KB(4);
> +		gtt_entries = 0;
> +	}
>  
>  	intel_private.gtt_entries = gtt_entries;
>  }
> 
