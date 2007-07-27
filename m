Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbXG0BJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbXG0BJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbXG0BJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:09:37 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:56857 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbXG0BJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=uJF1wJmndubBF5/6XyXp1N55fRsPtpLAtLJots9LX9l2UME/E3zMQTWDQ6uX818A/16BCAJiFX/Ow9P3u71y4P5z1U9/KaKGzz+e3h0CYBd9dJ9XCDC/qN7dANQXyYRUlJ6AH84sOJaOishtUzFSf0bkBUYSPjn3SjVc/fSK28g=
Message-ID: <46A945CE.3060407@gmail.com>
Date: Thu, 26 Jul 2007 21:09:34 -0400
From: Parag Warudkar <parag.warudkar@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: 07/26 GIT - Build breakage
References: <46A924A0.9010501@gmail.com>	 <alpine.LFD.0.999.0707261605560.3442@woody.linux-foundation.org> <1185497965.12151.2.camel@localhost.localdomain>
In-Reply-To: <1185497965.12151.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thu, 2007-07-26 at 16:07 -0700, Linus Torvalds wrote: 
>   
>> On Thu, 26 Jul 2007, Parag Warudkar wrote:
>>     
>>> arch/i386/kernel/paravirt.o: In function `init_IRQ':
>>> (.text+0xb20): multiple definition of `init_IRQ'
>>> arch/i386/kernel/i8259.o:(.init.text+0x30): first defined here
>>> ld: Warning: size of symbol `init_IRQ' changed from 66 in
>>> arch/i386/kernel/i8259.o to 14 in arch/i386/kernel/paravirt.o
>>> make[1]: *** [arch/i386/kernel/built-in.o] Error 1
>>> make: *** [arch/i386/kernel] Error 2
>>>       
>> Ok, it seems that some versions of gcc/binutils have problems with the 
>> games that paravirt introduced with the "weak" thing. 
>>
>> I'm not entirely surprised. That stuff was trying to be too clever by 
>> half.
>>
>> Rusty?
>>     
>
> Sure, but this was in .21 and .22.  This config is from 2.6.21.5, in
> fact.
>
> Parag, does your arch/i386/kernel/i8259.c look like this around line
> 384?  If not, perhaps it's a mis-merge for you? 
>         
>         /* Overridden in paravirt.c */
>         void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
>         
>         void __init native_init_IRQ(void)
>         {
>         
>   
Never mind - I was compiling using an account which was not in use for 
long and I had totally forgotten that llvm gcc comes before the normal 
gcc version in the $PATH on that account. Correcting the path fixes the 
problem.

Sorry for the trouble.
Parag
