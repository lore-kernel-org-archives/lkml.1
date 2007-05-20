Return-Path: <linux-kernel-owner+w=401wt.eu-S1764767AbXETAN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764767AbXETAN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 20:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXETANt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 20:13:49 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38970 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752354AbXETANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 20:13:49 -0400
Date: Sun, 20 May 2007 02:13:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>
Subject: Re: RFC: kconfig select warnings bogus?
Message-ID: <20070520001335.GQ6291@stusta.de>
References: <20070519151523.GA26724@uranus.ravnborg.org> <20070519110944.2a52061e.akpm@linux-foundation.org> <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com> <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com> <20070519230940.GJ6291@stusta.de> <a781481a0705191617v901ac64nfa7040ff302d2da1@mail.gmail.com> <20070519232542.GL6291@stusta.de> <a781481a0705191636i371da96fxc0e9805778afad78@mail.gmail.com> <20070519234844.GN6291@stusta.de> <a781481a0705191655t8e305aage47fb063c55ab86a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a781481a0705191655t8e305aage47fb063c55ab86a@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 05:25:24AM +0530, Satyam Sharma wrote:
> On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
>> On Sun, May 20, 2007 at 05:06:33AM +0530, Satyam Sharma wrote:
>> > On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
>> >>...
>> >> Consider ATARI_KBD_CORE was used by 20 drivers.
>> >>
>> >> Using select for such not user visible helper variables is a really 
>> nice
>> >> thing, and much more readable (and therefore much less likely to 
>> contain
>> >> bugs) than dependencies with tons of "||"'s.
>> >
>> > Well, the "default .. if .." kind of idiom is fairly common (I could say
>> > almost standard), in arch/.../config's. It's been used for some time,
>> > and for several symbols over there. But you're right that if 20 drivers
>> > used ATARI_KBD_CORE, we'd get tons of ugly "||"'s there, so
>> > perhaps we do need some kind of fix for this.
>>
>> And the fix is to use select.
>>
>> Compare the handling of options like IRQ_CPU in arch/mips/Kconfig in
>> current kernels with the handling in kernel 2.6.0 .
>>
>> Or as an exercise, change drivers/net/Kconfig to no longer use
>> "select MII". When you are finished, ensure that you are handling it
>> properly although the option is user visible...
>
> "config MII" and "select MII" are _not_ equivalent to the case at hand.
> MII is defined in drivers/net/Kconfig itself so does not print any "symbol
> unknown kind of warnings" ... so clearly no probs in "select" for it ...

Then move the "config MII" to arch/i386/Kconfig and assume all drivers  
select'ing it would depend on X86_32.

This is not a problem in the kernel sources, it is an example for you to 
see why select is the correct idiom in such cases.

Please try it if you want to understand the problem you are talking 
about.

>> There are cases where "default .. if .." is the right idiom, but there
>> are also cases where "select" is the right idiom. And for helper code
>> like ATARI_KBD_CORE, "select" is the right idiom.
>
> ATARI_KBD_CORE, unlike MII, is defined only by some archs. And the
> correct (most widely used or standard, in any case) idiom for that is
> "default .. if ..". Or perhaps you can convert those helper code options in
> arch/.../config's over to select too, as an exercise? :-)

Perhaps not as an exercise, but actually for real.

We had "fixed" such warnings in the past similar to your patch, but that 
was actually a mistake.

And "correct" can easily be the opposite of "most widely used or standard"
if you discover that you did it wrong in the past.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

