Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab0CFFFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 00:05:39 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38582 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750760Ab0CFFFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 00:05:38 -0500
Date: Sat, 6 Mar 2010 08:05:36 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
Message-ID: <20100306050536.GA20539@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
 <20100205203236.GC1475@oksana.dev.rtsoft.ru>
 <fa686aa41002090913t4c72a3b8o5fda68723bc8d089@mail.gmail.com>
 <20100209191620.GA24539@oksana.dev.rtsoft.ru>
 <20100305120015.a2008f46.akpm@linux-foundation.org>
 <fa686aa41003051228w38579483yd4e95bb8eacf40f7@mail.gmail.com>
 <20100305123527.d6d68e56.akpm@linux-foundation.org>
 <fa686aa41003051547u1f499902w1d3efc614a9b20b6@mail.gmail.com>
 <20100306002823.GA22095@oksana.dev.rtsoft.ru>
 <fa686aa41003051954y3ea8ebebxa915efb74c58dcbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa686aa41003051954y3ea8ebebxa915efb74c58dcbb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 08:54:56PM -0700, Grant Likely wrote:
[...]
> The last version of the patches were posted on Feb 8.  -rc8 was
> released on Feb 12.  For changes to common code, that is a little late
> for getting queued up for the merge window.  If it was a subsystem
> that I maintain, say SPI, then I doubt I would have picked it up for
> 2.6.34.

And of course the part of the OF rework, which was first posted
for *review* on Feb 03, is a completely different story?

 48 files changed, 317 insertions(+), 575 deletions(-)

It's in Linus' tree now.

And the other part of the OF rework that was posted for review
on Feb 13 is another story too? It's in Linus' tree as well.

Your patches touch 3 architectures, and a lot of the code that
is used by all the OF drivers, still 03 and 13 Feb was OK for
them.

> But I am not the GPIO maintainer.

David is. And I heard only positive feedback on the patches
last time.

> For the record, my main concerns are:
> - Now that I see the implementation, I think that it is too complex.
> The bus notifiers really aren't needed and it can be done with much
> lower impact on the core gpiolib code.

That's a non-argument, what is "lower impact"? Do I touch any
hot paths? And if nothing has changed, David (again, the gpiolib
maintainer) is happy with the notifiers approach, why would you
care?

Anyhow, changing the notifier to a direct call is a matter of
a trivial patch that we can queue anytime in 2.6.35.

> - Using notifiers adds an unnecessary race condition, however unlikely.

Where? Is it a real one? I see a lot of race conditions, but none of
them because of the notifiers approach.

> > Is there any punishment ready for that? ;-) I see one: apply
> > these patches, and rework this stuff as you like when you have some
> > time?
> 
> Changes to common code don't work that way.  Sometimes things just
> don't get enough attention and they wait another cycle, get reworked,
> or get dropped entirely.

See above wrt OF rework patches.

> > Or tell me your idea, and I'll do the rework for you, in
> > 2.6.35.
> >
> > But in the meantime, these patches can be nicely used to support
> > I2C/SPI GPIO controllers.
> 
> ...and anyone who need it immediately is welcome to pull your changes
> into their private tree.  Skipping a cycle is not the end of the
> world.

Using notifiers is not the end of the world either.

> >> Combine that with the changes being made to drivers/of right now and
> >> the addition device tree to ARM and other architectures, my preference
> >> is to let this patch series lie fallow for one more merge cycle so
> >> that things can settle out in the OF infrastructure code.
> >
> > How exactly OF rework affects these patches?
> 
> For one, the device node pointer is moving out of archdata into
> 'struct device' proper and I've got patches adding OF hooks into the
> core of the platform bus.  If those patches look good to GregKH, then
> I'll be pursing the same pattern for the other bus types (i2c, spi,
> etc), and it will be further argument for putting the OF hooks
> directly into gpiolib instead of using a notifier.  I'll be posting
> the patches as soon as the merge window closes.

I don't get it. Why is it a problem to change your patches that
ought to be queued for 2.6.*35*?

> > And why some rework
> > should be used as an excuse for not adding a hardware support?
> 
> If this was a standalone device driver then I'd agree.  However, this
> is an infrastructure change.  Infrastructure changes get more scrutiny
> and are always harder to merge.  Especially just before the merge
> window opens with very little linux-next exposure.

See above wrt OF rework patches.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
