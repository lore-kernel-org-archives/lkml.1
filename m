Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbXC0Okh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbXC0Okh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXC0Okh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:40:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbXC0Okg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:40:36 -0400
Message-ID: <46092C9B.4030700@redhat.com>
Date: Tue, 27 Mar 2007 10:39:23 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Subject: Re: [patch 1/2] Ignore stolen time in the softlockup watchdog
References: <20070327053816.881735237@goop.org> <20070327054106.664262413@goop.org>
In-Reply-To: <20070327054106.664262413@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeremy Fitzhardinge wrote:
>
> ---
>  kernel/softlockup.c |   28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
>
> ===================================================================
> --- a/kernel/softlockup.c
> +++ b/kernel/softlockup.c
> @@ -17,8 +17,8 @@
>  
>  static DEFINE_SPINLOCK(print_lock);
>  
> -static DEFINE_PER_CPU(unsigned long, touch_timestamp);
> -static DEFINE_PER_CPU(unsigned long, print_timestamp);
> +static DEFINE_PER_CPU(unsigned long long, touch_timestamp);
> +static DEFINE_PER_CPU(unsigned long long, print_timestamp);
>  static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
>  
>  static int did_panic = 0;
> @@ -37,7 +37,7 @@ static struct notifier_block panic_block
>  
>  void touch_softlockup_watchdog(void)
>  {
> -	__raw_get_cpu_var(touch_timestamp) = jiffies;
> +	__raw_get_cpu_var(touch_timestamp) = sched_clock();
>  }
>   

I'd like to see this patch implement/fix touch_cpu_softlockup_watchdog 
and touch_softlockup_watchdog to mimic touch_nmi_watchdog's behaviour.

See this now obsolete patch: http://lkml.org/lkml/2007/3/15/131

P.
