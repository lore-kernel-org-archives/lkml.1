Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZJSPGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZJSPGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZJSPGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:06:14 -0400
Received: from mga10.intel.com ([192.55.52.92]:42045 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756516AbZJSPGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,585,1249282800"; 
   d="scan'208";a="738009146"
Date: Mon, 19 Oct 2009 17:08:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 5/7] mfd: pcf50633: Cleanup pcf50633_probe error
 handling
Message-ID: <20091019150812.GC3885@sortiz.org>
References: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-2-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-3-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-4-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-5-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255471956-29201-5-git-send-email-fercerpav@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Oct 14, 2009 at 02:12:34AM +0400, Paul Fertser wrote:
> From: Lars-Peter Clausen <lars@metafoo.de>
> 
> Currently the child devices were not freed if the irq could not be requested.
> This patch restructures the function, that in case of an error all previously
> allocated resources are freed.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> ---
>  drivers/mfd/pcf50633-core.c |   47 +++++++++++++++++++++++++-----------------
>  1 files changed, 28 insertions(+), 19 deletions(-)
[...]
>  	if (enable_irq_wake(client->irq) < 0)
> -		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
> +		dev_info(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
>  			"in this hardware revision", client->irq);
2 things here: This doesnt really belong to this patch, and also I'd prefer to
keep that as an error message.


>  	ret = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
>  	if (ret)
> -		dev_err(pcf->dev, "error creating sysfs entries\n");
> +		dev_info(pcf->dev, "Failed to create sysfs entries\n");
Same here.

Otherwise, this patch looks good to me.



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
