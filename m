Return-Path: <linux-kernel-owner+w=401wt.eu-S965535AbZLQTt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965535AbZLQTt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965516AbZLQTtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:49:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59118 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965512AbZLQTtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:49:11 -0500
Date: Thu, 17 Dec 2009 19:48:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Joe Buck <Joe.Buck@synopsys.COM>,
       Richard Guenther <richard.guenther@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
Message-ID: <20091217194837.GD4440@n2100.arm.linux.org.uk>
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com> <20091217181718.GA4440@n2100.arm.linux.org.uk> <20091217183517.GC10707@synopsys.com> <20091217190613.GB4440@n2100.arm.linux.org.uk> <20091217191401.GD10707@synopsys.com> <20091217193826.GE362@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217193826.GE362@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 07:38:26PM +0000, Jamie Lokier wrote:
> Joe Buck wrote:
> > On Thu, Dec 17, 2009 at 11:06:13AM -0800, Russell King - ARM Linux wrote:
> > > On Thu, Dec 17, 2009 at 10:35:17AM -0800, Joe Buck wrote:
> > > > Besides, didn't I see a whole bunch of kernel security patches related
> > > > to null pointer dereferences lately?  If page 0 can be mapped, you
> > > > suddenly won't get your trap.
> > > 
> > > Page 0 can not be mapped on ARM kernels since the late 1990s, and this
> > > protection is independent of the generic kernel.
> > > 
> > > Milage may vary on other architectures, but that's not a concern here.
> 
> It does not trap on at least one ARM-nommu kernel...

I was going to say the following in a different reply but discarded it
because it wasn't relevant to the GCC list.

I regard ARM nommu as highly experimental, especially as the maintainer
vanished half way through merging it into mainline.  I know that there
are some parts of ARM nommu that are highly buggy - such as ARM940
support invalidating the entire data cache on any DMA transaction...
say goodbye stacked return addresses.

As such, I would not be surprised if the ARM nommu kernel has _lots_ of
weird and wonderful bugs.  I am not surprised that NULL pointer dereferences
don't work - its actually something I'd expect given that they have a
protection unit which the kernel doesn't apparently touch.

Maybe the protection unit code never got merged?  I've no idea.  As I
say, uclinux support got as far as being half merged and that's roughly
the state it's remained in ever since.

We don't even have any no-MMU configurations which the kernel builder
automatically tests for us.

Given the lack of progress/bug reporting on ARM uclinux, the lack of
platform support and the lack of configurations, my view is that there
is no one actually using it.  I know that I don't particularly take any
care with respect to uclinux when making changes to the MMU based kernels.
Why bother if apparantly no one's using it?
