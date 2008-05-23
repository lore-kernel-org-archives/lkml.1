Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbYEWUvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbYEWUvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbYEWUu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:50:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17968 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbYEWUu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:50:56 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5302"; a="3207987"
Message-ID: <48372E2E.4020902@qualcomm.com>
Date: Fri, 23 May 2008 13:50:54 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, pj@sgi.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [PATCH] [genirq] Expose default irq affinity mask
References: <1211571995-17488-1-git-send-email-maxk@qualcomm.com> <20080523134702.e5fb9145.rdunlap@xenotime.net>
In-Reply-To: <20080523134702.e5fb9145.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Fri, 23 May 2008 12:46:35 -0700 Max Krasnyansky wrote:
> 
>> Current IRQ affinity interface does not provide a way to set affinity
>> for the IRQs that will be allocated/activated in the future.
>> This patch creates /proc/irq/default_smp_affinity that lets users set
>> default affinity mask for the newly allocated IRQs. Changing default
>> does not affect affinity masks for the currently active IRQs, they
>> have to be changed explicitly.
> 
> Documentation, perhaps an update to Documentation/filesystems/proc.txt ?
Absolutely. I wanted to see if it gets accepted first.

> 
>> Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
>> ---
>>  arch/alpha/kernel/irq.c |    5 +--
>>  include/linux/irq.h     |   14 ++++-------
>>  kernel/irq/manage.c     |   28 +++++++++++++++++++++-
>>  kernel/irq/proc.c       |   57 ++++++++++++++++++++++++++++++++++++++++++++++-
>>  4 files changed, 89 insertions(+), 15 deletions(-)
>>
>> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
>> index 438a014..90f9ccc 100644
>> --- a/kernel/irq/manage.c
>> +++ b/kernel/irq/manage.c
>> @@ -16,6 +16,8 @@
>>  
>>  #ifdef CONFIG_SMP
>>  
>> +cpumask_t irq_default_affinity = CPU_MASK_ALL;
>> +
>>  /**
>>   *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
>>   *	@irq: interrupt number to wait for
>> @@ -94,6 +96,27 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
>>  	return 0;
>>  }
>>  
>> +#ifndef CONFIG_AUTO_IRQ_AFFINITY
>> +/**
>> + * Generic version of the affinity autoselector.
>> + */
> 
> Please don't use /** as the beginning of a comment block unless that
> comment block is in kernel-doc format (this one is not).

Oops, my bad. Did it again. Will fix.

Max

