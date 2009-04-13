Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZDMGpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZDMGpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 02:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbZDMGpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 02:45:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58403 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbZDMGpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 02:45:32 -0400
Message-ID: <49E2DF6B.6040204@redhat.com>
Date: Mon, 13 Apr 2009 09:44:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --	infrastructure
References: <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu> <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com> <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain> <20090412163356.GA2392@elte.hu> <49E2398A.3050405@redhat.com> <20090413041625.GF11652@elte.hu>
In-Reply-To: <20090413041625.GF11652@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>>> Sure, go ahead and wrap them in some kind of "save and restore all  
>>>> registers" wrapping, but nothing fancier than that. It would just be 
>>>> overkill, and likely to break more than it fixes.
>>>>     
>>>>         
>>> Yeah. I only brought up the virtualization thing as a 
>>> hypothetical: "if" corrupting the main OS ever became a 
>>> widespread problem. Then i made the argument that this is 
>>> unlikely to happen, because Windows will be affected by it just 
>>> as much. (while register state corruptions might go unnoticed 
>>> much more easily, just via the random call-environment clobbering 
>>> of registers by Windows itself.)
>>>
>>> The only case where i could see virtualization to be useful is 
>>> the low memory RAM corruption pattern that some people have 
>>> observed.
>>>       
>> You could easily check that by checksumming pages (or actually 
>> copying them to high memory) before the call, and verifying after 
>> the call.
>>     
>
> Yes, we could do memory checks, and ... hey, we already do that:
>
>    bb577f9: x86: add periodic corruption check
>    5394f80: x86: check for and defend against BIOS memory corruption
>
> ... and i seem to be the one who implemented it! ;-)
>
> That check resulted in logs showing the BIOS corrupting Linux memory 
> across s2ram cycles or HDMI plug/unplug events on certain boxes (are 
> Hollywood rootkits in the BIOS now?), and resulted in some 
> head-scratching but not much more.
>   

Then there's definitely no point in putting it into a container, is 
there?  I mean, we could track down the exact instruction which caused 
the corruption, but how would it help us?

>> I don't think the effort is worth the benefit in this case, but 
>> there actually is an interesting use case for this.  SMM is known 
>> to be harmful to deterministic replay games and to real time 
>> response.  If we can virtualize SMM, we can increase the range of 
>> hardware on which the real time kernel is able to deliver real 
>> time guarantees.
>>     
>
> Hey, i do have a real sweet spot for deterministic execution - but 
> SMM, while not problem-free (like most of firmware), also has a very 
> real role in not letting various hardware melt. So SMM should be 
> thought of as a flexible extended arm of hardware - not some sw bit.
>
> So i think that the memory of that SMM virtualization chapter you've 
> almost read should be quickly erased from your mind. (Via forceful 
> means if prompt corrective self-action is not forthcoming.)
>   

I'll keep my remaining neurons, thanks.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

