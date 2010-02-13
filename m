Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab0BMWiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:38:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:34027 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab0BMWiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:38:14 -0500
Message-ID: <4B772969.303@kernel.org>
Date: Sat, 13 Feb 2010 14:36:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical
 flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org> <m16361pbja.fsf@fess.ebiederm.org>
In-Reply-To: <m16361pbja.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 04:26 AM, Eric W. Biederman wrote:

>> Index: linux-2.6/arch/x86/kernel/irqinit.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/irqinit.c
>> +++ linux-2.6/arch/x86/kernel/irqinit.c
>> @@ -83,16 +83,14 @@ static struct irqaction irq2 = {
>>  	.name = "cascade",
>>  };
>>  
>> -DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
>> -	[0 ... NR_VECTORS - 1] = -1,
>> -};
>> +DEFINE_PER_CPU(vector_desc_t, vector_desc);
>>  
>>  int vector_used_by_percpu_irq(unsigned int vector)
>>  {
>>  	int cpu;
>>  
>>  	for_each_online_cpu(cpu) {
>> -		if (per_cpu(vector_irq, cpu)[vector] != -1)
>> +		if (per_cpu(vector_desc, cpu)[vector] != NULL)
>>  			return 1;
>>  	}
>>  
>> @@ -139,7 +137,7 @@ void __init init_IRQ(void)
>>  	 * irq's migrate etc.
>>  	 */
>>  	for (i = 0; i < nr_legacy_irqs; i++)
>> -		per_cpu(vector_irq, 0)[IRQ0_VECTOR + i] = i;
>> +		per_cpu(vector_desc, 0)[IRQ0_VECTOR + i] = irq_to_desc(i);
> 
> I am not familiar with this hunk (it must be in the x86 tree).
> Are you certain we have allocated the legacy irq desc here?

yes.

early_irq_init() is called before init_IRQ in start_kernel()

it will have irq_desc for legacy ready.

YH

