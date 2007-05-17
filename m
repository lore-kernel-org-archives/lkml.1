Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbXEQSTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbXEQSTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbXEQSTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:19:00 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:9391 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931AbXEQSTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:19:00 -0400
In-Reply-To: <464C99FF.8080404@ru.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com> <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org> <464C99FF.8080404@ru.mvista.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
Cc: tglx@linutronix.de, mingo@elte.hu, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Date: Thu, 17 May 2007 13:17:07 -0500
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17, 2007, at 1:07 PM, Sergei Shtylyov wrote:

> Hello.
>
> Kumar Gala wrote:
>
>>> Index: linux-2.6/arch/powerpc/kernel/time.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/powerpc/kernel/time.c
>>> +++ linux-2.6/arch/powerpc/kernel/time.c
> [...]
>>> @@ -128,6 +129,83 @@ unsigned long ppc_tb_freq;
>>>  static u64 tb_last_jiffy __cacheline_aligned_in_smp;
>>>  static DEFINE_PER_CPU(u64, last_jiffy);
>>>
>>> +#ifdef CONFIG_GENERIC_CLOCKEVENTS
>>> +
>>> +#if defined(CONFIG_40x) || defined(CONFIG_BOOKE)
>>> +#define DECREMENTER_MAX 0xffffffff
>>> +#else
>>> +#define DECREMENTER_MAX 0x7fffffff /* setting MSB triggers an   
>>> interrupt */
>>> +#endif
>>> +
>>> +static int decrementer_set_next_event(unsigned long evt,
>>> +                      struct clock_event_device *dev)
>>> +{
>>> +#if defined(CONFIG_40x)
>>> +    mtspr(SPRN_PIT, evt);    /* 40x has a hidden PIT auto- 
>>> reload  register */
>>> +#elif defined(CONFIG_BOOKE)
>>> +    mtspr(SPRN_DECAR, evt); /* Book E has  separate auto-reload   
>>> register */
>>> +    set_dec(evt);
>
>> what's the point of setting decar if you're just going to set_dec  
>> as  well?
>
>    Bothered to read the Book E specs? ;-)

I have :)

>    Loading DECAR doesn't auto-reload DEC. What I want is both set  
> the auto-reload value and start counting down from it at the same  
> time (if the decrementer is in auto-reload mode).

I see you're using DECAR to make it periodic.

> [big cut-off]
>
> WBR, Sergei

I haven't looked at all the new clock/timer code, is there any  
utility in having support for more than one clock source?

- k
