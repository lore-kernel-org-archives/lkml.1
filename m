Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbXETSX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbXETSX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 14:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbXETSXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 14:23:21 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39963 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757136AbXETSXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 14:23:20 -0400
Date: Sun, 20 May 2007 20:23:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>
Subject: Re: RFC: kconfig select warnings bogus?
Message-ID: <20070520182306.GR6291@stusta.de>
References: <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com> <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com> <464F9A7B.1030708@s5r6.in-berlin.de> <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com> <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com> <4650074A.6000307@s5r6.in-berlin.de> <a781481a0705200438s634712e6v957d7085bca7407@mail.gmail.com> <46503542.50300@s5r6.in-berlin.de> <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com> <46504876.9040802@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46504876.9040802@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 03:09:10PM +0200, Stefan Richter wrote:
>...
> Since you mention "select":  My opinion about the "select" dialect of
> "depends on" is that the UIs should be improved and "select" should be
> removed from the Kconfig language.  What do we "select"?  Typically we
> "select" an option on which /n/ other options depend on but which itself
> does depend on none or few options higher up.  The UIs could be able to
> figure this out for themselves, or if necessary by a hint tacked onto
> library-type options.  That is, instead of
> 
> 	config A
> 		tristate "driver A"
> 		select L
> 
> 	config B
> 		tristate "driver B"
> 		select L
> 
> 	config L
> 		tristate "library L"
> 
> write
> 
> 	config A
> 		tristate "driver A"
> 		depends on L
> 
> 	config B
> 		tristate "driver B"
> 		depends on L
> 
> 	config L
> 		tristate "library L"
> 		hint THIS_IS_A_LIBRARY
> 
> Now let UIs "make oldconfig", "make menuconfig", "make randconfig" deal
> with the hint or ignore the hint --- according to the purpose and
> usability requirements of the respective UI.  The "hint
> THIS_IS_SOMETHING" isn't even necessary in many cases to detect roles of
> options, because their position in the dependency graph is already
> saying something about it.
>...

Example where your proposal wouldn't work well:

config MIPS_ATLAS
        bool "MIPS Atlas board"
        select SYS_SUPPORTS_LITTLE_ENDIAN
        select SYS_SUPPORTS_BIG_ENDIAN

config SYS_SUPPORTS_BIG_ENDIAN
        bool

config CPU_BIG_ENDIAN
        bool "Big endian"
        depends on SYS_SUPPORTS_BIG_ENDIAN


Where's the value of allowing an UI to ignore hints? If an UI would 
ignore all hints on SYS_SUPPORTS_BIG_ENDIAN you would no longer be able 
to configure a kernel on this architecture.

And there's no way for an UI to figure out the direction of the options - 
with "select" the only reasonable direction is fixed for all UIs.

"select" might have room for improvements especially in the area of 
dependencies of select'ed options, but replacing it with overloading
"depends on" plus hints wouldn't be a good solution.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

