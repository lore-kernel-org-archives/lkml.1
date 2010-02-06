Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117Ab0BFAIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 19:08:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:45056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933744Ab0BFAIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 19:08:38 -0500
Message-ID: <4B6CB26C.405@kernel.org>
Date: Fri, 05 Feb 2010 16:06:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Brandon Philips <bphilips@suse.de>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: keep chip_data in create_irq_nr and destroy_irq
References: <20100203033109.GA17985@jenkins.home.ifup.org> <4B694DEF.70301@kernel.org> <20100203174216.GB17985@jenkins.home.ifup.org> <4B6BDAC0.3090900@kernel.org> <20100205210926.GE4930@jenkins.home.ifup.org> <4B6C9F69.4040605@kernel.org> <20100205225535.GF4930@jenkins.home.ifup.org>
In-Reply-To: <20100205225535.GF4930@jenkins.home.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2010 02:55 PM, Brandon Philips wrote:
> On 14:44 Fri 05 Feb 2010, Yinghai Lu wrote:
>> On 02/05/2010 01:09 PM, Brandon Philips wrote:
>>> @@ -77,7 +90,8 @@ void dynamic_irq_cleanup(unsigned int ir
>>>  	}
>>>  	desc->msi_desc = NULL;
>>>  	desc->handler_data = NULL;
>>> -	desc->chip_data = NULL;
>>> +	if (!keep_chip_data)
>>> +		desc->chip_data = NULL;
>>>  	desc->handle_irq = handle_bad_irq;
>>>  	desc->chip = &no_irq_chip;
>>>  	desc->name = NULL;
>>> @@ -85,6 +99,26 @@ void dynamic_irq_cleanup(unsigned int ir
>>>  	raw_spin_unlock_irqrestore(&desc->lock, flags);
>>>  }
>>>  
>>> +/**
>>> + *	dynamic_irq_cleanup - cleanup a dynamically allocated irq
>>> + *	@irq:	irq number to initialize
>>> + */
>>> +void dynamic_irq_cleanup(unsigned int irq)
>>> +{
>>> +	dynamic_irq_init_x(irq, false);
>>
>> should be dynamic_irq_cleanup_x here.
>>
>>> +}
>>> +
>>> +/**
>>> + *	dynamic_irq_cleanup_keep_chip_data - cleanup a dynamically allocated irq
>>> + *	@irq:	irq number to initialize
>>> + *
>>> + * 	does not set irq_to_desc(irq)->chip_data to NULL
>>> + */
>>> +void dynamic_irq_cleanup_keep_chip_data(unsigned int irq)
>>> +{
>>> +	dynamic_irq_init_x(irq, true);
>>
>> should be dynamic_irq_cleanup_x
> 
> Oops, right. I will fix this up along with the externs as hpa
> suggested and send again.

> 
> What are your thoughts on locking? Does it look OK as is?
> 

ok to me.

YH
