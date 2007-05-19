Return-Path: <linux-kernel-owner+w=401wt.eu-S1765309AbXESX0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765309AbXESX0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 19:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761728AbXESXZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 19:25:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38884 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757048AbXESXZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 19:25:54 -0400
Date: Sun, 20 May 2007 01:25:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>
Subject: Re: RFC: kconfig select warnings bogus?
Message-ID: <20070519232542.GL6291@stusta.de>
References: <20070519151523.GA26724@uranus.ravnborg.org> <20070519110944.2a52061e.akpm@linux-foundation.org> <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com> <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com> <20070519230940.GJ6291@stusta.de> <a781481a0705191617v901ac64nfa7040ff302d2da1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a781481a0705191617v901ac64nfa7040ff302d2da1@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 04:47:52AM +0530, Satyam Sharma wrote:
> On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
>> On Sun, May 20, 2007 at 04:19:12AM +0530, Satyam Sharma wrote:
>> >...
>> > A combined patch for all of those on top of 22-rc2 (adding 
>> Signed-off-by's
>> > for original authors too):
>> >...
>> > --- a/arch/m68k/Kconfig       2007-05-20 04:11:47.000000000 +0530
>> > +++ b/arch/m68k/Kconfig       2007-05-20 04:23:57.000000000 +0530
>> > @@ -411,6 +411,7 @@ config STRAM_PROC
>> >
>> > config ATARI_KBD_CORE
>> >       bool
>> > +     default y if KEYBOARD_ATARI || MOUSE_ATARI
>> >...
>> > --- a/drivers/input/keyboard/Kconfig  2007-05-20 04:11:55.000000000 
>> +0530
>> > +++ b/drivers/input/keyboard/Kconfig  2007-05-20 04:24:54.000000000 
>> +0530
>> > @@ -167,7 +167,6 @@ config KEYBOARD_AMIGA
>> > config KEYBOARD_ATARI
>> >       tristate "Atari keyboard"
>> >       depends on ATARI
>> > -     select ATARI_KBD_CORE
>> >       help
>> >         Say Y here if you are running Linux on any Atari and have a 
>> keyboard
>> >         attached.
>> > diff -ruNp a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
>> > --- a/drivers/input/mouse/Kconfig     2007-05-20 04:11:55.000000000 
>> +0530
>> > +++ b/drivers/input/mouse/Kconfig     2007-05-20 04:25:09.000000000 
>> +0530
>> > @@ -179,7 +179,6 @@ config MOUSE_AMIGA
>> > config MOUSE_ATARI
>> >       tristate "Atari mouse"
>> >       depends on ATARI
>> > -     select ATARI_KBD_CORE
>> >       help
>> >         Say Y here if you have an Atari and want its native mouse
>> >         supported by the kernel.
>> >...
>>
>> This is a good example how "fixing" the warnings makes things worse...
>
> How?

Consider ATARI_KBD_CORE was used by 20 drivers.

Using select for such not user visible helper variables is a really nice 
thing, and much more readable (and therefore much less likely to contain 
bugs) than dependencies with tons of "||"'s.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

