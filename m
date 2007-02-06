Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXBFEAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXBFEAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 23:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXBFEAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 23:00:49 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:35743 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752674AbXBFEAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 23:00:48 -0500
Message-ID: <45C7FD6F.2070402@vmware.com>
Date: Mon, 05 Feb 2007 20:00:47 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2/11] Sched clock paravirt op
References: <200702060352.l163qeAf000727@zach-dev.vmware.com>
In-Reply-To: <200702060352.l163qeAf000727@zach-dev.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
>  
>  #include "mach_timer.h"
>  
> @@ -102,9 +103,6 @@ unsigned long long sched_clock(void)
>  {
>  	unsigned long long this_offset;
>  
> -	if (unlikely(custom_sched_clock))
> -		return (*custom_sched_clock)();
> -
>  	/*
>  	 * Fall back to jiffies if there's no TSC available:
>  	 */
> @@ -113,13 +111,13 @@ unsigned long long sched_clock(void)
>  		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
>  
>  	/* read the Time Stamp Counter: */
> -	rdtscll(this_offset);
> +	get_scheduled_cycles(this_offset);
>  
>  	/* return the value in ns */
>  	return cycles_2_ns(this_offset);
>  }
>   

I missed a title / signed-off on this guy.


Internally, sched_clock runs in units of nanoseconds, not CPU cycles.  
This was wrong in my previous patch.  Fix it so everyone can use the 
same cycles_2_ns code in tsc.c.

Signed-off-by: Zachary Amsden <zach@vmware.com>
