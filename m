Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbXEKHoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbXEKHoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXEKHn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:43:57 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4623 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXEKHn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:43:56 -0400
Date: Fri, 11 May 2007 08:43:38 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Simon Horman <horms@verge.net.au>, Timur Tabi <timur@freescale.com>,
       Kim Phillips <kim.phillips@freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Kconfig warnings on latest GIT
Message-ID: <20070511074337.GA3048@flint.arm.linux.org.uk>
Mail-Followup-To: Kumar Gala <galak@kernel.crashing.org>,
	Simon Horman <horms@verge.net.au>, Timur Tabi <timur@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	Michael Schmitz <schmitz@debian.org>,
	Roman Zippel <zippel@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
References: <200705080004.14570.ismail@pardus.org.tr> <20070508143127.38fafa3c.kim.phillips@freescale.com> <4640D988.1040504@freescale.com> <20070510051042.GA16812@verge.net.au> <46434ED0.6030808@freescale.com> <20070511012529.GC10715@verge.net.au> <Pine.LNX.4.64.0705102046400.10555@gate.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705102046400.10555@gate.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 08:47:05PM -0500, Kumar Gala wrote:
> On Fri, 11 May 2007, Simon Horman wrote:
> 
> > On Thu, May 10, 2007 at 11:56:48AM -0500, Timur Tabi wrote:
> > > Simon Horman wrote:
> > >
> > > >>So my question is: in which Kconfig do I define "UCC_FAST_TEMP" and
> > > >>"UCC_SLOW_TEMP"?  At first I thought, just put it in drivers/Kconfig, but
> > > >>that Kconfig does nothing but including other Kconfigs.  I believe that if I
> > > >>submit a patch that adds "UCC_FAST_TEMP" and "UCC_SLOW_TEMP" to
> > > >>drivers/Kconfig, it will be rejected.  Either that, or I'll spend six weeks
> > > >>trying to persuade everyone that it's a good idea.
> > > >>
> > > >>Does anyone have any suggestions on how I can fix this?
> > > >That does seem like a reasonable suggestion, and one that
> > > >would probably work well with the other similar problems
> > > >that have been introduced sice 2.6.21.
> > >
> > > Looks like the fix is simpler than I thought.  Instead of having
> > >
> > > UCC_GETH
> > > 	select UCC_FAST
> > >
> > > I need to do
> > >
> > > UCC_FAST
> > > 	default y if UCC_GETH
> >
> > I pondered something like that, but I couldn't get it quite right :(
> >
> > > I'll have a patch that fixes this out later today.
> > >
> > > I chose the first method because I wanted each individual UCC device
> > > driver to select UCC_FAST or UCC_SLOW as appropriate, so that I
> > > wouldn't have to update arch/powerpc/sysdev/qe_lib/Kconfig every time
> > > we add a new UCC driver.  Oh well.
> >
> > --
> > Horms
> >   H: http://www.vergenet.net/~horms/
> >   W: http://www.valinux.co.jp/en/
> >
> 
> Try this patch:

You might also want to fix the other stupidity with this.  See my message
on this very subject ("select is evil: another reason" from May 9th on lkml.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
