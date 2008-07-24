Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYGXUjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYGXUjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYGXUj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:39:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56332 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYGXUj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:39:28 -0400
Message-ID: <4888E83E.8080702@zytor.com>
Date: Thu, 24 Jul 2008 16:38:22 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 fixes
References: <20080724151200.GA19266@elte.hu> <alpine.LFD.1.10.0807241233450.3237@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807241233450.3237@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 24 Jul 2008, Ingo Molnar wrote:
>> Hugh Dickins (1):
>>       x86: BUILD_IRQ say .text to avoid .data.percpu
>>
>> diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
>> index 0373e88..9414125 100644
>> --- a/arch/x86/kernel/irqinit_64.c
>> +++ b/arch/x86/kernel/irqinit_64.c
>> @@ -43,7 +43,7 @@
>>  
>>  #define BUILD_IRQ(nr)				\
>>  	asmlinkage void IRQ_NAME(nr);		\
>> -	asm("\n.p2align\n"			\
>> +	asm("\n.text\n.p2align\n"		\
>>  	    "IRQ" #nr "_interrupt:\n\t"		\
>>  	    "push $~(" #nr ") ; "		\
>>  	    "jmp common_interrupt");
> 
> I do not think this is a good idea AT ALL.
> 
> You need a ".previous" there too, otherwise any random C code that doesn't 
> _happen_ to change segments will now possibly put some random variable in 
> the .text segment.
> 
> And yes, dependign on just where the BUILD_IRQ() is, and what is around 
> it, and what compiler version we have, this bug may or may not show. But 
> it's still _wrong_.
> 
> I pulled it, will fix up by hand.

You're obviously right here; thanks for taking care of it.

	-hpa
