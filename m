Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbZJUWZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbZJUWZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 18:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZJUWZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 18:25:10 -0400
Received: from mga12.intel.com ([143.182.124.36]:23800 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755038AbZJUWZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 18:25:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,600,1249282800"; 
   d="scan'208";a="201941110"
Date: Thu, 22 Oct 2009 00:26:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: fix more undefined twl4030-power resconfig value
 checks
Message-ID: <20091021222627.GD17796@sortiz.org>
References: <1256125762-10069-1-git-send-email-amit.kucheria@verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256125762-10069-1-git-send-email-amit.kucheria@verdurent.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 02:49:22PM +0300, Amit Kucheria wrote:
> Based on Aaro's previous fix, this needs to be fixed for the newly added
> remap_off and remap_sleep resources as well.
> 
> The code tries to skip values initialized with -1, but since the values
> are unsigned the comparison is always true.
> 
> The patch eliminates the following compiler warnings:
> 
> drivers/mfd/twl4030-power.c: In function 'twl4030_configure_resource':
> drivers/mfd/twl4030-power.c:338: warning: comparison is always true due to
> limited range of data type
Thanks Amit, patch applied.

Cheers,
Samuel.

 
> Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/twl4030-power.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index 9f98c36..3048f18 100644
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -398,12 +398,12 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
>  		return err;
>  	}
>  
> -	if (rconfig->remap_off >= 0) {
> +	if (rconfig->remap_off != TWL4030_RESCONFIG_UNDEF) {
>  		remap &= ~OFF_STATE_MASK;
>  		remap |= rconfig->remap_off << OFF_STATE_SHIFT;
>  	}
>  
> -	if (rconfig->remap_sleep >= 0) {
> +	if (rconfig->remap_sleep != TWL4030_RESCONFIG_UNDEF) {
>  		remap &= ~SLEEP_STATE_MASK;
>  		remap |= rconfig->remap_off << SLEEP_STATE_SHIFT;
>  	}
> -- 
> 1.6.3.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
