Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab0BNAwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 19:52:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:45838 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100Ab0BNAwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 19:52:14 -0500
Message-ID: <4B77487F.8070601@kernel.org>
Date: Sat, 13 Feb 2010 16:49:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH  0/8] tip related: radix tree for spareseirq and logical
 flat clean up
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>	<m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org> <m1sk94mzg0.fsf@fess.ebiederm.org>
In-Reply-To: <m1sk94mzg0.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 04:30 PM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>>
>> Subject: [PATCH] x86: use vector_desc instead of vector_irq
>>
>> Eric pointed out that radix tree version of irq_to_desc will magnify delay on the path
>> of handle_irq.
>> use vector_desc to reduce the calling of irq_to_desc.
>>
>> next step: need to change all ack, mask, umask, eoi for all irq_chip to take irq_desc
>>
>> -v2: irq should be unsigned in 32bit handle_irq according to Eric
>>      also reset vector_desc for lguest in setup_irq
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> Index: linux-2.6/arch/x86/kernel/irq_32.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/irq_32.c
>> +++ linux-2.6/arch/x86/kernel/irq_32.c
>> @@ -76,7 +76,7 @@ static void call_on_stack(void *func, vo
>>  }
>>  
>>  static inline int
>> -execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
>> +execute_on_irq_stack(int overflow, struct irq_desc *desc)
>>  {
>>  	union irq_ctx *curctx, *irqctx;
>>  	u32 *isp, arg1, arg2;
>> @@ -189,24 +189,22 @@ asmlinkage void do_softirq(void)
> 
> This looks like it will fail to build here.
> Don't you need to update the assembly to use desc->irq instead
> of the now removed irq parameter?

ah, will fix that.

YH
