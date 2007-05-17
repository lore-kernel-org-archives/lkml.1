Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbXEQSGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbXEQSGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXEQSG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:06:28 -0400
Received: from h155.mvista.com ([63.81.120.155]:25003 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754758AbXEQSG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:06:27 -0400
Message-ID: <464C99FF.8080404@ru.mvista.com>
Date: Thu, 17 May 2007 22:07:59 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
Cc: tglx@linutronix.de, mingo@elte.hu, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
References: <200705172142.26739.sshtylyov@ru.mvista.com> <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
In-Reply-To: <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kumar Gala wrote:

>> Index: linux-2.6/arch/powerpc/kernel/time.c
>> ===================================================================
>> --- linux-2.6.orig/arch/powerpc/kernel/time.c
>> +++ linux-2.6/arch/powerpc/kernel/time.c
[...]
>> @@ -128,6 +129,83 @@ unsigned long ppc_tb_freq;
>>  static u64 tb_last_jiffy __cacheline_aligned_in_smp;
>>  static DEFINE_PER_CPU(u64, last_jiffy);
>>
>> +#ifdef CONFIG_GENERIC_CLOCKEVENTS
>> +
>> +#if defined(CONFIG_40x) || defined(CONFIG_BOOKE)
>> +#define DECREMENTER_MAX 0xffffffff
>> +#else
>> +#define DECREMENTER_MAX 0x7fffffff /* setting MSB triggers an  
>> interrupt */
>> +#endif
>> +
>> +static int decrementer_set_next_event(unsigned long evt,
>> +                      struct clock_event_device *dev)
>> +{
>> +#if defined(CONFIG_40x)
>> +    mtspr(SPRN_PIT, evt);    /* 40x has a hidden PIT auto-reload  
>> register */
>> +#elif defined(CONFIG_BOOKE)
>> +    mtspr(SPRN_DECAR, evt); /* Book E has  separate auto-reload  
>> register */
>> +    set_dec(evt);

> what's the point of setting decar if you're just going to set_dec as  well?

    Bothered to read the Book E specs? ;-)
    Loading DECAR doesn't auto-reload DEC. What I want is both set the 
auto-reload value and start counting down from it at the same time (if the 
decrementer is in auto-reload mode).

[big cut-off]

WBR, Sergei
