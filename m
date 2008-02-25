Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYBYBDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYBYBDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 20:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYBYBDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 20:03:14 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:23627 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751101AbYBYBDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 20:03:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=tnOrpFuWq7orlAwm0UT9gUx22h8tjqGkUa4BmiWduCgU4XwmAdnfAKLPXcXuHwsQ0ptpwJK/DSdiCmR1XYjjjj07jViDYWDc+I/8o0sfa6qMqDQ0ib6osi4wl99Y5K5C3MrJYcYJh+WFzwDoUVp7o8PeCeBwU7F5bs7V1n0imw4=  ;
X-YMail-OSG: 1mfEzCkVM1n08iLaWnIfn_cPjwAtImW7Vj0CmVudDw9_4SJzl3yNaU8rL7LxmKCtVDpUUcXTOw--
X-Yahoo-Newman-Property: ymail-3
Date: Sun, 24 Feb 2008 17:03:10 -0800
From: David Brownell <david-b@pacbell.net>
To: hskinnemoen@atmel.com
Subject: Re: [patch 2.6.25-rc2-git 1/2] atmel_tc library
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200802221723.24003.david-b@pacbell.net>
 <20080224184554.2c863f63@siona>
 <20080224225527.62D5D28E1A2@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20080225012637.1535c95b@siona>
In-Reply-To: <20080225012637.1535c95b@siona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080225010310.B59E98E4B8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Note that this won't be usable until the AT91 and AT32 platforms
> > > > incorporate patches to configure the relevant platform devices.
> > > > Those changes are probably 2.6.26 material.
> > 
> > More specifically (and all those patches are available now):
> > 
> >  - AT91 needs clocksource/clockevent support for the SAM9 PIT timer;
> >  - AVR32 needs more extensive clocksource/clockevent updates;
>
> Which reminds me...you were talking about a patch that adds oneshot
> support for the count/compare clocksource and more cleanups, but I
> don't think I've seen it...?

I avoid sending non-working patches, and hadn't made time to
work on that issue recently.


> Yes, getting the fundamental stuff into mainline now would help a lot.

Or at least, towards the front of the merge queue, ahead of
the various platform-specific patches.


> But I was thinking about Linus' suggestions that we exploit the
> distributed nature of git and do cross-tree merges to synchronize
> changes to common code.
>
> Setting up a separate git tree would allow the changes to go into the
> arm tree without littering it with possibly unstable avr32 changes as
> well, and it would allow me to merge them and put more stuff on top.

Doing that with ARM patches is Russell's call; he hasn't been too
keen on merging from non-Linus GIT trees when that came up before.


> > > > +#define ATMEL_TC_BMR	0xc4		/* TC Block Mode Register */
> > > > +#define     ATMEL_TC_TC0XC0S	(3 << 0)	/* external clock 0 source */
> > > > +#define        ATMEL_TC_TC0XC0S_TCLK0	(0 << 0)
> > >
> > > Hmm. Indentation using spaces? I didn't know you were into that sort of
> > > thing ;-)
> > 
> > It's way better than indenting off the right margin of the page!
>
> I've never really seen the point of indenting those defines at all.

Without them, it's harder to discern the logical structure of
all the various bitfields and their contents.


> > > Anyway, my main issue is that I think we should add a data structure
> > > with information about each device, similar to struct ssc_device in the
> > > atmel-ssc driver. How about something like this?
> > >
> > > struct atmel_tc_block {
> > > 	void __iomem		*regs;	/* non-NULL when busy */
> > > 	struct platform_device	*pdev;
> > > 	struct clk		*clk[3];
> > > 	struct list_head	node;
> > > };
> > 
> > And per-channel IRQs too...
>
> I thought about that, but while the driver can safely call clk_enable()
> on the same clock several times, I'm not sure if it's such a great idea
> to call request_irq() on the same interrupt several times. So the
> driver probably needs to know how many irqs there really are and might
> as well use platform_get_irq() to find out.

I thought the whole point of passing the clocks was to avoid needing
to ask for them!!  If trying one or three platform_get_irq() calls is
OK, then surely trying one or three clk_get() calls is also OK...

- Dave


> > Well, if you want to take these patches off my hands and then be
> > responsible for merging them upstream, I won't object.  :)
>
> I can do that.
>
> It's getting late around here...I'll reply to your other mail tomorrow.
>
> Haavard
>
