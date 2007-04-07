Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbXDGDwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbXDGDwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 23:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXDGDwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 23:52:00 -0400
Received: from mail.tmr.com ([64.65.253.246]:59575 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbXDGDv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 23:51:59 -0400
Message-ID: <461715B4.9060701@tmr.com>
Date: Fri, 06 Apr 2007 23:53:24 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Tasos Parisinos <t.parisinos@sciensis.com>,
       Andi Kleen <andi@firstfloor.org>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
References: <4610D25F.7080005@ceid.upatras.gr>    <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com>    <4616BC09.2080509@tmr.com> <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>
In-Reply-To: <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> On Fri, April 6, 2007 23:30, Bill Davidsen wrote:
>   
>> Tasos Parisinos wrote:
>>     
>>> The main purpose behind the creation of this module was to create the
>>> cryptographic infrastructure to develop an in-kernel system of signed
>>> modules.
>>>
>>>       
>
>   
>>> Although this functionality can be achieved using userland helper
>>> programs this may create the need to physically secure entire
>>> filesystems which adds to the cost of developing such devices.
>>>       
>> So to save cost on your end you want to make this feature part of the
>> mainline kernel. Am I misreading your intent here?
>>     
>
> (Tasos was talking about the cost of securing whole file systems versus only
> the kernel binary.)
>
> But if that "entire filesystem" is initramfs, I don't
> see any problem. If it fits into the kernel, it also has enough room for an
> initramfs with a user space program with the RSA signing. I said this before,
> so please look up how initramfs works and tell us why that isn't sufficient
> for this case.
>
> I suspect your answer will be because it isn't the only part and a lot other
> infrastructure is need in the kernel to do all the binary signing. But that
> code you didn't post, only a MPI module, however nice, which is only a partial
> solution to what you want to achieve. Combine that with the kernel policy to
> not merge unused code, and you're in the current situation.
>
>   
>> Having said all this, we have a boatload of other crypto in the kernel,
>> if it's just the crypto module, like aes, anubis or micheal_mic, and is
>> GPL compatible, some people may agree. But if this is an embedded
>> system, and you have the patch, why not just apply it to your kernel and
>> forget mainline?
>>     
>
> Currently it's less than a cryptoapi module, as it only provide some functions
> to do multi-precision integer calculations, which happen to be the tricky part
> of implementing RSA.
>
> That said, this implementation seems quite good, from a code size and complexity
> point of view. So for that alone I think it wouldn't be bad to merge this or a
> modified version of this, even if it's unused by the rest of the kernel, it might
> be useful for other users. The burden to carry it along for the kernel is quite
> small, while the code is worth something and might get improved by their users,
> in the end having a central place to collect them. So I think from an open source
> ecological point of view, it wouldn't be bad to merge it.
>
> I see three possible way forwards (alternative is the status quo):
>
> 1) Move it to user space (into the initramfs embedded into the kernel).
> But you'd still need to add binary (modules, libs and programs) load hooks.
>
> 2) Flesh it out into a ready to use, full blown RSA cryptoAPI module. Whatever
> you said earlier, whether you want or not, it's just a block cipher, with the
> modulo as block size (I suspect there's some room for code simplification when
> assuming fixed block sizes too, by allocating blocksize * 2 space instead of
> resizing when needed).
>
>   
This would probably be the best solution, to provide most of the hooks 
while presenting the cryptoAPI for others to use if they wish. Good 
suggestion.
> 3) Go all the way, and post all the other kernel modifications too, to get the
> whole binary signing you want to achieve.
> Advantage will be that in the end you'll end up with something scrutinized to
> death. Disadvantage is that it will be scrutinized to death, as that can take
> a lot of time. Maybe you'll end up with a new LSM module, who knows?
>
> The list is in increasing order of difficulty and quality of your end code.
>
> It would help if you could find others who also wants something similar and
> work together to get it into the kernel. But even if the last step fails,
> you still have had people reviewing your code. And failing even that, you at
> least shared your code with the rest of the world, which is already something
> good (and required by the GPL. But doing it in the open is much more laudable
> than hiding it on a website).
>
> Greetings,
>
> Indan
>
>
>   
I think you have covered the possibilities, my read is that your item 
number two is most likely to be accepted.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

