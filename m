Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbYBLVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbYBLVlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYBLVlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:41:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36429 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYBLVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:41:36 -0500
Date: Tue, 12 Feb 2008 13:38:50 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: multiple drivers, single device (was Re: Announce: Linux-next
	(Or Andrew's dream  :-)))
Message-ID: <20080212213850.GA22600@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <47B1C829.8020800@garzik.org> <20080212164232.GA326@kroah.com> <47B1DDD3.2000402@garzik.org> <alpine.LFD.1.00.0802121027190.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802121027190.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:30:04AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 12 Feb 2008, Jeff Garzik wrote:
> 
> > Greg KH wrote:
> > > The work I'm doing here is for stupid PCI firmware engineers, who have
> > > created devices that are different things, all bound up under the same
> > > PCI device.  I'm thinking of watchdog timers and random number
> > > generator and i2c controller on the same PCI device, or even the more
> > > basic, frame buffer and DRM access to the same PCI video device.
> > 
> > Yes, that has a known solution:  have your driver register i2c, rng, watchdog,
> > etc. functions.
> > 
> > Works just fine inside today's infrastructure, no changes needed.
> 
> Indeed. If you have a multi-function device that shows up as a single PCI 
> function, just make it have its own "private bus", and make it show up as 
> a "devices within a device".

That's how I first tried to do this (old pci-piggy patches in -mm were a
result of this...).

But, we have the issue of the foolish-in-retrospect sysdev devices.
They are an example of "multiple drivers per device" type thing.  To
clean them up properly, they need to move to the general 'struct device'
and if that is going to already support the one-to-many model, well,
then any PCI implementation of such an internal bus can also use the
same code.

This is a lot of handwaving right now, let me go work on some code and
see how it turns out.

Don't worry, I'll expect a lot of review cycles :)

thanks,

greg k-h
