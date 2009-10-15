Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbZJOHc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbZJOHc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbZJOHc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:32:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:53066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbZJOHc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:32:56 -0400
Message-ID: <4AD6CF91.8090203@kernel.org>
Date: Thu, 15 Oct 2009 16:30:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Frans Pop <elendil@planet.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: bisect results of MSI-X related panic (help!)
References: <1252699744.3877.15.camel@jbrandeb-hc.jf.intel.com>  <200909120623.49764.elendil@planet.nl> <4AAE0F7B.5050203@kernel.org>  <4AAE105E.1080005@kernel.org> <4807377b0910091724k2a332e90i9941971f6032663c@mail.gmail.com> <4AD2E05A.6060700@kernel.org> <alpine.WNT.2.00.0910120907170.11804@jbrandeb-mobl2.amr.corp.intel.com> <4AD3E875.5040800@kernel.org> <alpine.WNT.2.00.0910141527550.3036@jbrandeb-desk1.amr.corp.intel.com>
In-Reply-To: <alpine.WNT.2.00.0910141527550.3036@jbrandeb-desk1.amr.corp.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 07:30:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Brandeburg, Jesse wrote:
> On Mon, 12 Oct 2009, Tejun Heo wrote:
>> Can you please apply the following patch and try to retrigger the
>> panic?
>>
>> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
>> index c166019..f5a1482 100644
>> --- a/kernel/irq/chip.c
>> +++ b/kernel/irq/chip.c
>> @@ -63,6 +63,9 @@ void dynamic_irq_cleanup(unsigned int irq)
>>  	struct irq_desc *desc = irq_to_desc(irq);
>>  	unsigned long flags;
>>
>> +	printk("XXX dynamic_irq_cleanup() called on %u\n", irq);
>> +	dump_stack();
>> +
>>  	if (!desc) {
>>  		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
>>  		return;
> 
> I'm working on it, but now that I've added a bunch of debug including the 
> above printk, my system panics (with a stack protector canary overwrite) 
> when loading the first network adapter with 30+ MSI-X vectors.  I can boot 
> single user mode and bring up netconsole, but then as soon as I brought up 
> the first port with lots of MSI-X vectors, the system hard locks, no panic 
> message.
>  
> I have a bit of a theory that the node = -1 (numa_node) stuff might be 
> playing some havoc with the code in numa_migrate.c.  I'm not sure if that 
> is contributing, but the code in there doesn't seem written to handle node 
> = - 1 very well.  As in I never see it do an smp_processor_id at the 
> bottom before accessing the node value.
> 
> Not sure if that is relevant, but I wanted to mention it before I went 
> home.
> 
> What next?  I made it worse so I guess that is something.

I don't know.  At this point, I can't think of anything other than
sprinkling printks and dump_stacks around.  :-(

Thanks.

-- 
tejun
