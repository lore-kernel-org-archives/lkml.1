Return-Path: <linux-kernel-owner+w=401wt.eu-S1761916AbYBZJJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761916AbYBZJJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760677AbYBZJIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:08:36 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:51531 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756430AbYBZJId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:08:33 -0500
Date: Tue, 26 Feb 2008 10:08:13 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2.6.25-rc2-git 1/2] atmel_tc library
Message-ID: <20080226100813.0f55127b@hskinnemoen.norway.atmel.com>
In-Reply-To: <20080225180644.78CA31E564F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <200802221723.24003.david-b@pacbell.net>
	<20080224184554.2c863f63@siona>
	<20080224225527.62D5D28E1A2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20080225012637.1535c95b@siona>
	<20080225010310.B59E98E4B8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20080225124319.4ec8a00b@dhcp-252-066.norway.atmel.com>
	<20080225180644.78CA31E564F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 10:06:44 -0800
David Brownell <david-b@pacbell.net> wrote:

> > > > Which reminds me...you were talking about a patch that adds oneshot
> > > > support for the count/compare clocksource and more cleanups, but I
> > > > don't think I've seen it...?
> > > 
> > > I avoid sending non-working patches, and hadn't made time to
> > > work on that issue recently.
> >
> > I was thinking that I could perhaps help you get it working...
> 
> OK, if you want I'll send it.

That would be great. Otherwise I fear your work might be lost...

> > > > I've never really seen the point of indenting those defines at all.
> > > 
> > > Without them, it's harder to discern the logical structure of
> > > all the various bitfields and their contents.
> >
> > I prefer to separate the registers from the bitfields and the other
> > stuff. That way, no indentation is necessary.
> 
> But that way it's no longer clear which symbols apply to which
> registers.  It's not "needed" because that information became
> harder to find ... as in <include/asm-avr32/arch-at32ap/time.h>,
> which ISTR isn't even complete in its bitfield definitions.

Ok, I get your point.

> There's one clear need for tclib:  to hand out timers from the (small)
> pool of hardware entities.  Each one can be used for different purposes
> by different drivers.
> 
> The *current* tclib addresses only that minimal need.
> 
> You're the one who wants to add more to it; I was just pointing out that
> you were being inconsistent.

And I was trying to point out that _you_ were being inconsistent ;-)

> > Of course the driver should be responsible for calling clk_enable() and
> > clk_disable(). Otherwise, power management will be tricky. And since
> > the driver may need to make a decision about which interrupts to
> > request, it might as well call platform_get_irq() directly.
> 
> You're being inconsistent here.  It has to make the same kinds of
> decision about which clocks to enable/disable.  So why should it
> have to platform_get_irq() but not clk_get()?
> 
> > On the other hand, the driver will _always_ need a reference to each
> > clock,
> 
> No; it doesn't need references to clocks for unused TC channels.

Ok. Let's drop the clock references...

> >	and it will always need a pointer through which to access the
> > registers, so the mid-layer might as well do those things.
> 
> True about doing the ioremap.

...and keep the regs pointer, and possibly add the iomem resource.

Ok?

Btw, I'm not saying that you're the one who has to make these changes.
Once we agree, I can send a patch to do the things we agreed on.

Haavard
