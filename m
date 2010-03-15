Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699Ab0COFve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:51:34 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55753 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759672Ab0COFvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:51:31 -0400
Date: Mon, 15 Mar 2010 11:21:18 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 120/123] sched: Fix sched_mv_power_savings for !SMT
Message-ID: <20100315055118.GP5212@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20100313001618.GA9811@kroah.com>
 <20100313001515.642272234@kvm.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100313001515.642272234@kvm.kroah.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de> [2010-03-12 16:13:38]:

> 2.6.33-stable review patch.  If anyone has any objections, please let me know.

Hi Greg,

Thanks to pulling this into .32 and .33-stable.  Please correct the
subject and commit message to sched_mc_power_savings when you apply.
The term sched_mv_power_savings is a typo.

"sched: Fix sched_mc_power_savings for !SMT"

Thanks,
Vaidy

Ref: http://lkml.org/lkml/2010/2/16/230

> -----------------
> 
> From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> 
> commit 28f5318167adf23b16c844b9c2253f355cb21796 upstream.
> 
> Fix for sched_mc_powersavigs for pre-Nehalem platforms.
> Child sched domain should clear SD_PREFER_SIBLING if parent will have
> SD_POWERSAVINGS_BALANCE because they are contradicting.
> 
> Sets the flags correctly based on sched_mc_power_savings.
> 
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <20100208100555.GD2931@dirshya.in.ibm.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  include/linux/sched.h |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -878,7 +878,10 @@ static inline int sd_balance_for_mc_powe
>  	if (sched_smt_power_savings)
>  		return SD_POWERSAVINGS_BALANCE;
> 
> -	return SD_PREFER_SIBLING;
> +	if (!sched_mc_power_savings)
> +		return SD_PREFER_SIBLING;
> +
> +	return 0;
>  }
> 
>  static inline int sd_balance_for_package_power(void)
> 
> 
