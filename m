Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbZBFOA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbZBFOA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZBFOAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:00:49 -0500
Received: from mga06.intel.com ([134.134.136.21]:60633 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751986AbZBFOAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:00:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,391,1231142400"; 
   d="scan'208";a="384640679"
Date: Fri, 6 Feb 2009 15:03:11 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd/htc-egpio: fix iomem resource handling using
	resource_size
Message-ID: <20090206140310.GG3341@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1233434863-11806-1-git-send-email-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233434863-11806-1-git-send-email-philipp.zabel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 09:47:43PM +0100, Philipp Zabel wrote:
> Fixes an off-by-one error in the iomem resource mapping.
Applied to my for-linus branch. Will Send a pull request to Linus soon.
Thanks a lot.

Cheers,
Samuel.

 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/mfd/htc-egpio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
> index 1a4d046..e9b0745 100644
> --- a/drivers/mfd/htc-egpio.c
> +++ b/drivers/mfd/htc-egpio.c
> @@ -286,7 +286,7 @@ static int __init egpio_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res)
>  		goto fail;
> -	ei->base_addr = ioremap_nocache(res->start, res->end - res->start);
> +	ei->base_addr = ioremap_nocache(res->start, resource_size(res));
>  	if (!ei->base_addr)
>  		goto fail;
>  	pr_debug("EGPIO phys=%08x virt=%p\n", (u32)res->start, ei->base_addr);
> -- 
> 1.5.6.5
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
