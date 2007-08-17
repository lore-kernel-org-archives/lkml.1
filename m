Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbXHQE5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbXHQE5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbXHQE4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:56:51 -0400
Received: from ozlabs.org ([203.10.76.45]:39447 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbXHQE4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:56:50 -0400
From: Michael Neuling <mikey@neuling.org>
To: balbir@linux.vnet.ibm.com
cc: Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] Add scaled time to taskstats based process accounting 
In-reply-to: <46C52872.9060408@linux.vnet.ibm.com> 
References: <20070816070922.37B5370074@localhost.localdomain> <46C3FC41.4000609@linux.vnet.ibm.com> <13529.1187310208@neuling.org> <46C52872.9060408@linux.vnet.ibm.com>
Comments: In-reply-to Balbir Singh <balbir@linux.vnet.ibm.com>
   message dated "Fri, 17 Aug 2007 10:17:46 +0530."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Fri, 17 Aug 2007 14:56:44 +1000
Message-ID: <13853.1187326604@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <46C52872.9060408@linux.vnet.ibm.com> you wrote:
> Michael Neuling wrote:
> >> I'd also request for you to add a cpu_scaled_run_real_total for use
> >> by delay accounting. cpu_scaled_run_real_total should be similar in
> >> functionality to cpu_run_real_total.
> > 
> > Will do.  Should I add cpu_scaled_run_real_total to the end of the
> > struct taskstat, or next to cpu_run_real_total?
> > 
> 
> Please add it to the end, that helps maintain binary compatibility
> across all versions of taskstats.

OK

> 
> >>>  	/* Note: this timer irq context must be accounted for as well. */
> >>> -	if (user_tick)
> >>> +	if (user_tick) {
> >>>  		account_user_time(p, jiffies_to_cputime(1));
> >>> -	else
> >>> +		account_user_time_scaled(p, jiffies_to_cputime(1));
> >>> +	} else {
> >>>  		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
> >>> +		account_system_time_scaled(p, jiffies_to_cputime(1));
> >>> +	}
> >> I am a little confused here, scaled accounting and regular accounting
> >> go hand in hand?
> > 
> > We need to account for scaled and normal time in this generic code.
> > All other calls to account_(user|system)_time are in arch code.  
> > 
> 
> So the assumption here is that we ran at full frequency during
> this time, is my understanding correct?

Yes.  

I guess we could keep a per CPU last scaling factor for this case
(similar to what we are storing in the POWERPC paca)

Mikey
