Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbZDKQPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbZDKQPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 12:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbZDKQO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 12:14:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54303 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199AbZDKQO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 12:14:58 -0400
Message-ID: <49E0C1AB.2050608@redhat.com>
Date: Sat, 11 Apr 2009 19:13:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       rjw@sisk.pl, linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --	infrastructure
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu> <20090410113824.GA18823@elf.ucw.cz>
In-Reply-To: <20090410113824.GA18823@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>   
>>> Well, difference is that you can defend against arbitrary network 
>>> packet, but you can't defend against arbitrarily broken BIOS. If 
>>> it loops forever, or overwrites random memory place, we lost...
>>>       
>> We could protect against random memory corruption too, if it ever 
>> became a widespread problem: by executing the BIOS call in a virtual 
>> machine. (We can probably use the KVM code to properly emulate big 
>> real mode, etc.)
>>     
>
> We already have problems where bios corrupts low memory area during
> suspend/resume. Not sure how KVM helps.
>
>   

kvm might help detecting these issues, but not in fixing them.  If you 
isolate the BIOS, then you've prevented corruption, but you've also 
prevented it from doing whatever it is it was supposed to do.  If you 
give it access to memory and the rest of the system, then whatever evil 
it has wrought affects the system.

You could try to allow the BIOS access to selected pieces of memory and 
hardware, virtualizing the rest, but it seems to me it would be more 
like a recipe for a giant headache that a solution.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

