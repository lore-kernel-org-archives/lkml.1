Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYLZJp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYLZJp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYLZJpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:45:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56881 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbYLZJpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:45:14 -0500
Message-ID: <4954A796.4060304@cn.fujitsu.com>
Date: Fri, 26 Dec 2008 17:44:54 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2 -tip] irq: kstat_incr_irqs_this_cpu only needs one
 parameter
References: <4954A02E.3030207@cn.fujitsu.com> <20081226091822.GE27747@elte.hu>
In-Reply-To: <20081226091822.GE27747@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar said the following on 2008-12-26 17:18:
> * Wang Chen <wangchen@cn.fujitsu.com> wrote:
> 
>> desc is useless for kstat_incr_irqs_this_cpu.
>>
>> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
>> ---
>>  arch/x86/kernel/visws_quirks.c |    2 +-
>>  arch/x86/xen/spinlock.c        |    2 +-
>>  include/linux/kernel_stat.h    |    3 +--
>>  kernel/irq/chip.c              |   10 +++++-----
>>  kernel/irq/handle.c            |    4 ++--
>>  5 files changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
>> index 0c9667f..bd37460 100644
>> --- a/arch/x86/kernel/visws_quirks.c
>> +++ b/arch/x86/kernel/visws_quirks.c
>> @@ -633,7 +633,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
>>  	/*
>>  	 * handle this 'virtual interrupt' as a Cobalt one now.
>>  	 */
>> -	kstat_incr_irqs_this_cpu(realirq, desc);
>> +	kstat_incr_irqs_this_cpu(realirq);
>>  
>>  	if (likely(desc->action != NULL))
>>  		handle_IRQ_event(realirq, desc->action);
> 
> 'desc' is needed in the sparseirq model:
> 
> #define kstat_incr_irqs_this_cpu(irqno, DESC) \
>         ((DESC)->kstat_irqs[smp_processor_id()]++)
> 
> See:
> 
>  http://people.redhat.com/mingo/tip.git/README
> 
> 	Ingo

Sorry, I didn't checkout that branch.
Please ignore this one.
