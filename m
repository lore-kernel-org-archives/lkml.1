Return-Path: <linux-kernel-owner+w=401wt.eu-S932099Ab0AETV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab0AETV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863Ab0AETVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:21:25 -0500
Received: from mga07.intel.com ([143.182.124.22]:26642 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932076Ab0AETVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:21:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229497585"
Date: Tue, 5 Jan 2010 20:23:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, amit.kucheria@verdurent.com
Subject: Re: [PATCH] mfd: Fix test of unsigned in
 twl4030_configure_resource()
Message-ID: <20100105192227.GJ4274@sortiz.org>
References: <4B28E3A4.1010601@gmail.com>
 <4B28E42F.9000209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B28E42F.9000209@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roel,

On Wed, Dec 16, 2009 at 02:44:15PM +0100, Roel Kluin wrote:
> devgroup is unsigned so the test did not work.
This one was fixed with commit 56baa667973e53d6d38af2ad3731d558566d818b.

Cheers,
Samuel.


> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Found using coccinelle: http://coccinelle.lip6.fr/
> 
> see
> vi arch/arm/mach-omap2/board-rx51-peripherals.c +512
> 
> Oops, missed some in previous patch.
> 
> Roel
> 
> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> index d423e0c..cc984a5 100644
> --- a/drivers/mfd/twl4030-power.c
> +++ b/drivers/mfd/twl4030-power.c
> @@ -335,7 +335,7 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
>  		return err;
>  	}
>  
> -	if (rconfig->devgroup >= 0) {
> +	if (rconfig->devgroup != -1) {
>  		grp &= ~DEVGROUP_MASK;
>  		grp |= rconfig->devgroup << DEVGROUP_SHIFT;
>  		err = twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> @@ -355,12 +355,12 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
>  		return err;
>  	}
>  
> -	if (rconfig->type >= 0) {
> +	if (rconfig->type != -1) {
>  		type &= ~TYPE_MASK;
>  		type |= rconfig->type << TYPE_SHIFT;
>  	}
>  
> -	if (rconfig->type2 >= 0) {
> +	if (rconfig->type2 != -1) {
>  		type &= ~TYPE2_MASK;
>  		type |= rconfig->type2 << TYPE2_SHIFT;
>  	}

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
