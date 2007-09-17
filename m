Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbXIQUpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbXIQUpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbXIQUpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:45:05 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:35311 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbXIQUpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:45:02 -0400
Message-ID: <46EEE72B.1010008@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2007 02:14:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc4-mm1 compile error for ppc 32
References: <20070906184011.GA1776@Krystal> <20070906160009.fa52e8d2.akpm@linux-foundation.org> <200709081136.46605.nickpiggin@yahoo.com.au> <1189269730.5972.163.camel@localhost.localdomain> <20070913151738.4462fdf2.akpm@linux-foundation.org> <1189863147.6403.8.camel@localhost.localdomain> <20070915150055.GA15620@Krystal> <1190061073.6403.66.camel@localhost.localdomain>
In-Reply-To: <1190061073.6403.66.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Sat, 2007-09-15 at 11:00 -0400, Mathieu Desnoyers wrote:
>> * Benjamin Herrenschmidt (benh@kernel.crashing.org) wrote:
>>> On Thu, 2007-09-13 at 15:17 -0700, Andrew Morton wrote:
>>>
>>>> Like this?
>>>>
>>>> --- a/include/asm-powerpc/bitops.h~powerpc-lock-bitops-fix
>>>> +++ a/include/asm-powerpc/bitops.h
>>>> @@ -226,7 +226,7 @@ static __inline__ void set_bits(unsigned
>>>>  
>>>>  static __inline__ void __clear_bit_unlock(int nr, volatile unsigned long *addr)
>>>>  {
>>>> -	__asm__ __volatile__(LWSYNC_ON_SMP ::: "memory");
>>>> +	__asm__ __volatile__(LWSYNC_ON_SMP "" ::: "memory");
>>>>  	__clear_bit(nr, addr);
>>>>  }
>>>>  
>>> Looks ok. Can somebody test ? I'm still travelling...
>>>
>>>
>> Hi Benjamin,
>>
>> With this patch and hrtimer.c fixes, 2.6.23-rc4-mm1 PPC arch (for
>> powerpc 405) compiles fine.
>>
>> I still see errors/warnings from modpost though:
> 
> Looks like the legacy ISA DMA crap no ? I don't know much about it.
> 
> Ben.
> 

Kamalesh has reported a similar bug and is looking to fix this problem.
He's been looking at Kconfig's to see that all of them either
depend on GENERIC_ISA_DMA or select it.

>> make -f /home/compudj/git/linux-2.6-lttng/scripts/Makefile.modpost
>>   scripts/mod/modpost -m  -o /home/compudj/obj/powerpc-405/Module.symvers    -s
>> ERROR: "request_dma" [sound/oss/sscape.ko] undefined!
>> ERROR: "free_dma" [sound/oss/sscape.ko] undefined!
>> ERROR: "dma_spin_lock" [sound/oss/sscape.ko] undefined!
>> ERROR: "free_dma" [sound/oss/sound.ko] undefined!
>> ERROR: "request_dma" [sound/oss/sound.ko] undefined!
>> ERROR: "dma_spin_lock" [sound/oss/sound.ko] undefined!
>> ERROR: "dma_spin_lock" [sound/core/snd.ko] undefined!
>> ERROR: "dma_spin_lock" [net/irda/irda.ko] undefined!
>> WARNING: "div64_64" [net/ipv4/tcp_cubic.ko] has no CRC!
>> ERROR: "free_dma" [drivers/parport/parport_pc.ko] undefined!
>> ERROR: "request_dma" [drivers/parport/parport_pc.ko] undefined!
>> ERROR: "dma_spin_lock" [drivers/parport/parport_pc.ko] undefined!
>> ERROR: "request_dma" [drivers/net/irda/w83977af_ir.ko] undefined!
>> ERROR: "free_dma" [drivers/net/irda/w83977af_ir.ko] undefined!
>> ERROR: "request_dma" [drivers/net/irda/via-ircc.ko] undefined!
>> ERROR: "free_dma" [drivers/net/irda/via-ircc.ko] undefined!
>> ERROR: "request_dma" [drivers/net/irda/smsc-ircc2.ko] undefined!
>> ERROR: "free_dma" [drivers/net/irda/smsc-ircc2.ko] undefined!
>> ERROR: "free_dma" [drivers/net/irda/nsc-ircc.ko] undefined!
>> ERROR: "request_dma" [drivers/net/irda/nsc-ircc.ko] undefined!
>> ERROR: "free_dma" [drivers/net/irda/ali-ircc.ko] undefined!
>> ERROR: "request_dma" [drivers/net/irda/ali-ircc.ko] undefined!
>> ERROR: "request_dma" [drivers/mmc/host/wbsd.ko] undefined!
>> ERROR: "dma_spin_lock" [drivers/mmc/host/wbsd.ko] undefined!
>> ERROR: "free_dma" [drivers/mmc/host/wbsd.ko] undefined!
>>
>> Mathieu
>>
-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
