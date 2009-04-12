Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZDLOk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZDLOk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 10:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZDLOkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 10:40:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54445 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbZDLOkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 10:40:45 -0400
Message-ID: <49E1FD15.50805@redhat.com>
Date: Sun, 12 Apr 2009 17:39:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, rjw@sisk.pl, linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --	infrastructure
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu> <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com> <20090412140149.GB5246@elte.hu>
In-Reply-To: <20090412140149.GB5246@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
>
>   
>> Avi Kivity wrote:
>>     
>>> kvm might help detecting these issues, but not in fixing them.  
>>> If you isolate the BIOS, then you've prevented corruption, but 
>>> you've also prevented it from doing whatever it is it was 
>>> supposed to do.  If you give it access to memory and the rest of 
>>> the system, then whatever evil it has wrought affects the system.
>>>
>>> You could try to allow the BIOS access to selected pieces of 
>>> memory and hardware, virtualizing the rest, but it seems to me it 
>>> would be more like a recipe for a giant headache that a solution.
>>>
>>>       
>> The main thing you could do is drop or virtualize memory accesses 
>> to RAM it should never access in the first place, like some BIOSes 
>> which scribble over random locations in low memory.
>>     
>
> it would be enough to get the information out. That way we could see 
> (from the access patterns) what the heck it is trying to do (did 
> someone rootkit the bios?), and what we can do about it. Trying to 
> contain it will likely break the BIOS and causes silent hangs with 
> no usable bug report left.
>   

Hmm, it's doable with the 1:1 mode; Andrea did some work on this.

However if the bios tries to do anything clever (like using SMM) things 
will fail pretty badly.

-- 
error compiling committee.c: too many arguments to function

