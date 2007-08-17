Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbXHQEs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbXHQEs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbXHQEsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:48:21 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:56460 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbXHQEsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:48:20 -0400
Message-ID: <46C52872.9060408@linux.vnet.ibm.com>
Date: Fri, 17 Aug 2007 10:17:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] Add scaled time to taskstats based process accounting
References: <20070816070922.37B5370074@localhost.localdomain> <46C3FC41.4000609@linux.vnet.ibm.com> <13529.1187310208@neuling.org>
In-Reply-To: <13529.1187310208@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling wrote:
>> I'd also request for you to add a cpu_scaled_run_real_total for use
>> by delay accounting. cpu_scaled_run_real_total should be similar in
>> functionality to cpu_run_real_total.
> 
> Will do.  Should I add cpu_scaled_run_real_total to the end of the
> struct taskstat, or next to cpu_run_real_total?
> 

Please add it to the end, that helps maintain binary compatibility
across all versions of taskstats.

>>>  	/* Note: this timer irq context must be accounted for as well. */
>>> -	if (user_tick)
>>> +	if (user_tick) {
>>>  		account_user_time(p, jiffies_to_cputime(1));
>>> -	else
>>> +		account_user_time_scaled(p, jiffies_to_cputime(1));
>>> +	} else {
>>>  		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
>>> +		account_system_time_scaled(p, jiffies_to_cputime(1));
>>> +	}
>> I am a little confused here, scaled accounting and regular accounting
>> go hand in hand?
> 
> We need to account for scaled and normal time in this generic code.
> All other calls to account_(user|system)_time are in arch code.  
> 

So the assumption here is that we ran at full frequency during
this time, is my understanding correct?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
