Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbYBYLnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbYBYLnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYBYLnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:43:32 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50110 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753865AbYBYLnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:43:31 -0500
Date: Mon, 25 Feb 2008 12:43:19 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2.6.25-rc2-git 1/2] atmel_tc library
Message-ID: <20080225124319.4ec8a00b@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080225010310.B59E98E4B8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <200802221723.24003.david-b@pacbell.net>
	<20080224184554.2c863f63@siona>
	<20080224225527.62D5D28E1A2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20080225012637.1535c95b@siona>
	<20080225010310.B59E98E4B8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2008 17:03:10 -0800
David Brownell <david-b@pacbell.net> wrote:

> > Which reminds me...you were talking about a patch that adds oneshot
> > support for the count/compare clocksource and more cleanups, but I
> > don't think I've seen it...?
> 
> I avoid sending non-working patches, and hadn't made time to
> work on that issue recently.

I was thinking that I could perhaps help you get it working...

> > But I was thinking about Linus' suggestions that we exploit the
> > distributed nature of git and do cross-tree merges to synchronize
> > changes to common code.
> >
> > Setting up a separate git tree would allow the changes to go into the
> > arm tree without littering it with possibly unstable avr32 changes as
> > well, and it would allow me to merge them and put more stuff on top.
> 
> Doing that with ARM patches is Russell's call; he hasn't been too
> keen on merging from non-Linus GIT trees when that came up before.

Fine with me either way.

> > I've never really seen the point of indenting those defines at all.
> 
> Without them, it's harder to discern the logical structure of
> all the various bitfields and their contents.

I prefer to separate the registers from the bitfields and the other
stuff. That way, no indentation is necessary.

> > I thought about that, but while the driver can safely call clk_enable()
> > on the same clock several times, I'm not sure if it's such a great idea
> > to call request_irq() on the same interrupt several times. So the
> > driver probably needs to know how many irqs there really are and might
> > as well use platform_get_irq() to find out.
> 
> I thought the whole point of passing the clocks was to avoid needing
> to ask for them!!  If trying one or three platform_get_irq() calls is
> OK, then surely trying one or three clk_get() calls is also OK...

If you want to go down that path, surely reserving the iomem resource
is fine too? Why don't we just kill the whole tclib layer, the driver
can certainly do everything itself?

Of course the driver should be responsible for calling clk_enable() and
clk_disable(). Otherwise, power management will be tricky. And since
the driver may need to make a decision about which interrupts to
request, it might as well call platform_get_irq() directly.

On the other hand, the driver will _always_ need a reference to each
clock, and it will always need a pointer through which to access the
registers, so the mid-layer might as well do those things.

Haavard
