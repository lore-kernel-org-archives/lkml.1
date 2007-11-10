Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbXKJKN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbXKJKN5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 05:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbXKJKNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 05:13:49 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35885 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060AbXKJKNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 05:13:49 -0500
Date: Sat, 10 Nov 2007 11:13:24 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071110101324.GK26163@stusta.de>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org> <47356A84.9020106@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47356A84.9020106@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 03:23:32AM -0500, Jeff Garzik wrote:
> Sam Ravnborg wrote:
>> Keeping ARCH=i386 and ARCH=x86_64 around is just a way to pretend
>> this is two diffrent architectures which is no longer the case.
>
> They _are_ different in the real world...  that's why
>
> 	make ARCH=i386
>
> is so often used.

I for one use i386 simply because I do not have any computer that would 
support 64bit. But when I'll see a 32/64bit question during
"make oldconfig" I'll also know what to answer.

>> Do we need a way to say "build a kernel that is 64 bit"?
>> If we need this then we should look at the most intuitive way
>> to say so and this should work across x86, powerpc and s390.
>>
>> 	make 64BIT=y ARCH=x86
>>
>> looks so much more intuitive. And it is generic.
>> This is just a proposal.
>
> Or the short and straightforward
>
> 	make ARCH=x86_64
>
> to do the same thing (and incidentally what we've been doing up until this 
> point).
>
> Don't get so hung up on "architecture" and actually look at what people do 
> _today_.
>
> All other solutions proposed are simply _longer_ ways to do exact the same 
> thing.  "more work for same outcome" isn't optimal.

Let's check who the "people" affected are:

Aunt Tillie isn't affected since she doesn't compile her own kernel.

People compiling kernels have to learn that the choice went from 
ARCH={i386,x86_64} to a Kconfig option. I'd say it's more consistent 
that the 32/64bit question is now handled the same way as the 
K6/K7/K8/... question. And there doesn't seem to be any "longer" or 
"more work" in this case.

What's left are kernel developers who have not read the toplevel README 
and who do therefore not know about KCONFIG_ALLCONFIG. Getting people to 
write documentation is a hard task, but it's only second to getting 
people to read documentation....

And although you might argue that you have a few characters more to type 
when using KCONFIG_ALLCONFIG it has the advantage that it's generic,
and it e.g. allows you to create a CONFIG_X86_32=y, CONFIG_SMP=n 
allyesconfig configuration.

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

