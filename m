Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab0BHLgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 06:36:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:49391 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0BHLgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 06:36:03 -0500
Subject: Re: BUG: sched_mc_powersavings broken on pre-Nehalem x86 platforms
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100208100555.GD2931@dirshya.in.ibm.com>
References: <20100208100555.GD2931@dirshya.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 12:35:48 +0100
Message-ID: <1265628948.1853.43.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 15:35 +0530, Vaidyanathan Srinivasan wrote:

>     Fix for sched_mc_powersavigs for pre-Nehalem platforms.
>     Child sched domain should clear SD_PREFER_SIBLING if parent will have 
>     SD_POWERSAVINGS_BALANCE because they are contradicting.
> 
>     Sets the flags correctly based on sched_mc_power_savings.
>     
>     Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 6550415..ef6b7cd 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -866,7 +866,10 @@ static inline int sd_balance_for_mc_power(void)
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

Looks good, thanks!

What's the status of getting rid of sched_{mc,smt}_power_savings?

