Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXBSPFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXBSPFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327AbXBSPFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:05:19 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2286 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbXBSPFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:05:18 -0500
Date: Mon, 19 Feb 2007 15:05:08 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: jose.goncalves@inov.pt, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070219150508.GD27370@flint.arm.linux.org.uk>
Mail-Followup-To: Frederik Deweerdt <deweerdt@free.fr>,
	jose.goncalves@inov.pt, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070220132909.GD566@slug> <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220144814.GJ566@slug>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 02:48:14PM +0000, Frederik Deweerdt wrote:
> (trimmed tie-fei.zang from the CC, added by mistake)
> On Mon, Feb 19, 2007 at 02:35:20PM +0000, Russell King wrote:
> > > Neither did I, but introducing printk's through the function, we narrowed
> > > the problem to this part of the code. And removing it makes the problem
> > > go away. We inserted 37 printk's in the function body, and Jose bisected
> > > those until the problem went away.
> > 
> > Well, there's still little clue about why this is causing a NULL pointer
> > dereference.  The only thing I can think is that somehow performing
> > this test is causing a power glitch to your CPU, causing its registers
> > to get corrupted, and which results in it doing a NULL pointer deref.
> That may be the case, indeed.
> > 
> > Are you saying that the NULL pointer occurred while executing this code?
> > If not, where does the NULL pointer occur?
> The thing is, the NULL pointer deref dissapeared as soon as we
> instrumented (printk'ed) the code. So it's seems to be triggered by
> check+timing+hardware.

So to summarise, we have some code somewhere which is causing a NULL
pointer deref in uart_startup().  If we remove some code, the NULL
pointer deref stops happening.

And that's about the sum total of the information we know.  We don't
know precisely where the NULL pointer deref occurs, and we don't know
what's causing it.

It doesn't sound like there's much understanding of the problem at hand. ;(

> > Andrew's said no (in that the thread you refer to) and suggested an
> > alternative, I've said no, how many more 'no's do you need to turn
> > you away from the wrong approach?
> One is usually sufficient once I've understood :). I missed the module
> option approach. Is it ok with you? If yes, I'll put up a patch to do
> this.

I guess so, but how does the user know whether they need this enabled or
disabled?

> The problem appears to be reproducible on Jose's hardware within 2-3 days.
> If you see other tests to be performed...

Maybe adding some delays in that bit of code?  I'm sure you've already
thought of that though.  Since no one has a proper understanding of the
problem, the only suggestions possible are mere shots in the dark.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
