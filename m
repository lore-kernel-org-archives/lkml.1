Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYJOKUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYJOKUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYJOKUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:20:43 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54006 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbYJOKUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:20:43 -0400
Date: Wed, 15 Oct 2008 13:20:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [GIT] HID patches for 2.6.28
Message-ID: <20081015102039.GG20183@cs181140183.pp.htv.fi>
References: <alpine.LNX.1.10.0810140055060.26779@jikos.suse.cz> <alpine.LNX.1.10.0810150011280.26779@jikos.suse.cz> <20081015093636.GB19403@elte.hu> <alpine.LNX.1.10.0810151139200.26779@jikos.suse.cz> <20081015100252.GA26296@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081015100252.GA26296@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 12:02:52PM +0200, Ingo Molnar wrote:
> 
> * Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > On Wed, 15 Oct 2008, Ingo Molnar wrote:
> > 
> > > this or the I2C updates cause widespread build failures in latest -git:
> > 
> > For the usbhid_set_leds(), Adrian has already sent me a fix [1]. 
> > Still, I would like to understand whether this failure is bug or 
> > feature in select/depends handling in Kconfig, because it seems to 
> > behave differently from what I was expecting.
> 
> yes, it's a kconfig bug: Kconfig must either not allow complex selects 
> (during its initial parsing pass of the Kconfig dependnecy tree) or 

Are we removing RCU only because people constantly get it wrong?

If you do RCU stuff without asking Paul for review it might be wrong, 
and if you are doing complex stuff in kconfig without asking Roman or
me the same applies.

> handle the dependencies correctly.

When you claim that there was one "correct" way to handle them
that's FUD, and shows that you don't understand the problem.

> The current "allow them silently and pepper the kernel with build 
> errors" approach is obviously silly.
> 
> We already have over 100 bugfixes in the tree from the past 3 years due 
> to kconfig's inability to figure out the correct dependencies. (count: 
> rising steadily)

Again, there are no "correct dependencies".

Continously repeating the same FUD doesn't make it true.

I have yet to see someone giving a semantics for select that would solve 
as many problems as the FUD claims without introducing new problems.

> Changes to the Kconfig tool to address this design bug did not get 
> picked up. See for example this quick patch from Vegard half a year ago:
> 
>   http://lkml.org/lkml/2008/5/4/13
> 
> that patch was not adopted and the config options in the warning log 

I remember that patch, Vegard himself admitted it was wrong:
  http://lkml.org/lkml/2008/5/4/48

Not sure why you whine about a broken patch not being applied...

> were later on frequent participants in build failures and subsequent 
> stream of trivial fixes.

The assumption that kconfig was trivial or all kconfig fixes were 
trivial is completely wrong.

I might just remind you of http://lkml.org/lkml/2008/4/30/446 where you 
tried to push a broken kconfig patch of yours through the Input 
maintainer (who had correctly rejected it), and the actual bug was
in the x86 code you maintain.

Something isn't trivial only because you don't understand it.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

