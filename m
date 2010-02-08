Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab0BHMq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 07:46:59 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:54649 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0BHMq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 07:46:58 -0500
Date: Mon, 8 Feb 2010 18:16:49 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sched_mc_powersavings broken on pre-Nehalem x86 platforms
Message-ID: <20100208124649.GE2931@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20100208100555.GD2931@dirshya.in.ibm.com>
 <1265628948.1853.43.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1265628948.1853.43.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-02-08 12:35:48]:

> On Mon, 2010-02-08 at 15:35 +0530, Vaidyanathan Srinivasan wrote:
> 
> >     Fix for sched_mc_powersavigs for pre-Nehalem platforms.
> >     Child sched domain should clear SD_PREFER_SIBLING if parent will have 
> >     SD_POWERSAVINGS_BALANCE because they are contradicting.
> > 
> >     Sets the flags correctly based on sched_mc_power_savings.
> >     
> >     Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 6550415..ef6b7cd 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -866,7 +866,10 @@ static inline int sd_balance_for_mc_power(void)
> >  	if (sched_smt_power_savings)
> >  		return SD_POWERSAVINGS_BALANCE;
> >  
> > -	return SD_PREFER_SIBLING;
> > +	if (!sched_mc_power_savings)
> > +		return SD_PREFER_SIBLING;
> > +
> > +	return 0;
> >  }
> >  
> >  static inline int sd_balance_for_package_power(void)
> > 
> 
> Looks good, thanks!
> 
> What's the status of getting rid of sched_{mc,smt}_power_savings?

Hi Peter,

With the current rearrangement of the code, the unified
sched_power_savings seems more doable.

However, I have few more fixes for sched_smt_powersavings on Nehalem
before I would revisit the unified tunable.

--Vaidy

