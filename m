Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbXEZKq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbXEZKq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 06:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXEZKqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 06:46:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:52814 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751043AbXEZKqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 06:46:15 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1+geZpNGFygWfTE5AvafuQzXs7AOMGBg4EBgmAcZy
	eWP+lAFSUwwp8e
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 12:40:54 +0200
User-Agent: KMail/1.9.5
References: <20070524195616.234280@gmx.net> <200705252140.22635.uwe.bugla@gmx.de> <200705260700.28777.mb@bu3sch.de>
In-Reply-To: <200705260700.28777.mb@bu3sch.de>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261240.55153.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 26. Mai 2007 07:00 schrieben Sie:
> On Friday 25 May 2007 21:40, Uwe Bugla wrote:
> > Am Freitag, 25. Mai 2007 20:48 schrieben Sie:
> > > On Fri, 25 May 2007 17:59:29 +0200, Uwe Bugla wrote:
> > > > Perhaps someone reading this could try to reproduce that problem on
> > > > his machine.
> > > > Now who of the readers owes a Broadcom 4401 NIC and can please try to
> > > > test kernel 2.6.22-rc2-mm1?
> > > >
> > > > Those NICs have been used very very often as onboard controllers,
> > > > especially on ASUS boards.
> > >
> > > I've been using 2.6.22-rc2 for some time and now I compiled 2.6.22-rc2-
> > > mm1 and both work fine with the BCM4401 in my laptop.
> > >
> > > Maxi
> >
> > Hello Maxi,
> >
> > That may be true for your Laptop, but it unfortunately isn't true for my
> > ASUS mainboard onboard controller.
> >
> > Unfortunately I cannot confirm this:
> >
> > My broadcom 4401 driver is not part of a notebook, but instead part of an
> > ASUS P4PE mainboard.
> >
> > At my second attempt I went the conventional path (i. e. ignoring the
> > fact that
> > "Broadcom 4400 ethernet support appears twice in section "Network device
> > support":
> >
> > Whether you leave out "EISA, VLB, PCI and on board controllers" or not it
> > simply appears twice in kernel config! This is bug number 1.
>
> No it is NOT a bug.
> It simply shows again that you don't know how b44, ssb or anything related
> works.
>
> Would you _please_ take a look at the code, before calling features bugs.
> And yes, this IS a feature. It is a feature to get b44 running on an
> OpenWRT embedded device. These devices don't have a PCI bus. So b44 MUST
> NOT depend on "EISA, VLB, PCI and on board controllers".

Thanks for the descriptive lesson! But this explanation is displaced HERE.
It should be part of the Kconfig text instead, as the b44 running on an 
OpenWRT embedded device simply does not show up in Kernel configuration of 
2.6.21.2 and earlier kernels.
In so far there is a bug that I would call superficial and incomplete 
explanation of b44 features in Kconfig!

Just two or three explaining sentences at the appropriate place would do well 
instead of singing this aria again an again:

"It simply shows again that you don't know how b44, ssb or anything related 
works."

It's NOT MY task to be omnicient. Above that, the b44 modules have never been 
documented at all. So how can you expect me and others to know about the 
latest features of version 2? Very strange behaviour of yours ) :

> "Broadcom 4400 PCI device support" does depend on "EISA, VLB, PCI and on
> board controllers".

Thanks, now I know. But the dependencies chaos plus the PCI disfunctionality 
stays unfortunately!

>
> Everything is correct.
> Bug number 1 is solved.

NO! See above please and DO NOT IGNORE!

> qed
>
> > This time I do get a "good" interrupt: IRQ 21 for the the device.
> >
> > BUT:
> >
> > Trying to ping another machine fails saying:
> >
> > "destination host unreachable"
> >
> >
> > That means, Although the interrupt is fine now, the device is still not
> > functionable.
>
> And it's completely impossible that you did a mistake when configuring
> the device? Typo in the IP? Typo in the gateway or DNS entries?

Yes! This sort of mistakes is completely impossible, as I use to work with 
aliases rather than IP adresses. The machine I tried to ping (i. e. my 
router) is called Jerry (as a reminiscence to Mr. "Captan Trips" from 
Grateful Dead), and thus "ping jerry" returned the following:

"destination host unreachable"

Above that, I state for the second time now that I reverted your patches in 
2.6.22-rc2-mm1 with the effect that everything worked perfectly!
Maxi said something at least similar. So how many proofs do you need, Mister 
Buesch, to finally pick up patchworking now?? 

So, the ball has been in your court for two days now, and you simply keep on 
hesitating to take action now. Instead you are playing a 
nonsense "I-am-not-responsible-and-you-don't-know-Ping-Pong game"
ignoring every hint, criticism that you are offered.
REAL GREAT!

> Try it again, please.

NO!

> And please try with current wireless-dev tree.

A. I do not know where to download that wireless-dev tree.
B. I do not know how to implement it into mm or mainline
C. I have given enough sophisticated proof that your stuff in mm-tree is 
highly incomplete / buggy.

>
> And I simply do not get it why you suddenly get a good IRQ number, like
> everybody else does, without fixing The Bug (tm).

That consequence I already explained:
But it's a pleasure for me to repeat it once more:

When you are saying Y to "EISA, VLB, PCI and on board controllers"

you simply do get not only completely different interrupts for the b4401 
device, but you get also completely different module dependencies.

If the module dependencies are correct the IRQ number is also correct,
If the module dependencies are broken the IRQ number is also broken.

It's as easy as that simply!

In other words, UTMOST CLEAR:

Runningh a PCI B4401 NIC:

A. If you declare the b4401 device in Kconfig as a non PCI device (well, how 
should you know if there is neither documenatary nor appropriate kconfig 
text) you get a disfunctionable b44 PLUS a BROKEN interrupt number.

B. If you declare the b4401 device in Kconfig as a PCI device you get a 
disfunctionable b44 PLUS a CORRECT interrupt number.

The ball is in your court, Michael.

Instead of playing verbal ping pong you would better send me info about debug 
parameters for ssb AND b44 and tell me what specific log you need afterwards. 
If b44 misses debug printks or dprintks then please send me an appropriate 
patch to apply against the mm-tree.

But, this stuff in the current state IS PROVEN to be highly buggy / 
experimental / incomplete / bad described in Kconfig! It should NEVER be 
pulled into vanilla in the current state!

So, Michael, you got two choices now:

A. Either you offer debug parameters now / and / or appropriate patches OR

B. I will stop answering on that issue with the consequence that your stuff 
will never reach vanilla mainline. For this case I will ask Andrew to throw 
your stuff into the trashcan.

I've wasted enough time on that buggy crap now with output zero. It's enough 
now, Michael!

Cheers

Uwe

Hint: Broadcom 4401 is NOT equal to Broadcom 4401!

I got two nearly identical machines owing that onboard controller.

There in fact has been a buggy / incomplete driver who did well on the one 
machine, but did not work on the other one..... : (
Don't ask me which 2.6 kernel that was, I do not remember. Must have been 
2.6.9 or an earlier one.
