Return-Path: <linux-kernel-owner+w=401wt.eu-S1762511AbXIMQHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762511AbXIMQHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbXIMQHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:07:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54840 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752618AbXIMQHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:07:16 -0400
Date: Thu, 13 Sep 2007 12:07:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Adrian Bunk <bunk@stusta.de>
cc: Adrian Bunk <bunk@kernel.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
In-Reply-To: <20070913154019.GG3563@stusta.de>
Message-ID: <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Adrian Bunk wrote:

> > > It is a good thing if userspace can add currently missing devices to
> > > whitelists, but the whitelist itself should be in the kernel.
> > 
> > It's not clear that this sort of approach will turn out to be workable.  
> > Whitelists/blacklists do okay in the kernel when they refer to a 
> > relatively small subset of devices.  However in this case I have the 
> > impression that we're talking about roughly a 50/50 split.  Keeping an 
> > in-kernel list with even 10% of all existing USB devices simply isn't 
> > feasible.
> 
> What about this is not feasible?
> 
> The amount of work for maintaining the list is the same:
> 
> No matter whether it's in-kernel or in the userspace, you need a list of 
> working devices in some machine readable format.
> 
> Whether this gets used by the kernel, by userspace, or both, shouldn't 
> make any difference.
> 
> Kernel image size can be a problem in some cases, but an in-kernel list 
> doesn't have to be mandatory but could be made selectable in kconfig.

Well, size is one problem I had in mind.  There are a _lot_ of USB 
devices in existence.

But mainly it's a question of maintenance and modification.  Kernel
developers don't really enjoy maintaining black- or whitelists of
devices, together with all the work involved in sorting through the
issues when somebody posts an email saying "My device doesn't work!".

Also, modifying device lists in the kernel tends to be a slow process, 
involving at least one kernel release cycle.  It's much easier for 
people to maintain userspace databases.  Now I realize you proposed 
there be a userspace interface for modifying the kernel's whitelist -- 
but if you're going to do that, why not put the entire whitelist in 
userspace to begin with?

Maybe you're concerned about propagating updates as painlessly as 
possible -- if the whitelist is in the kernel then every kernel release 
would include an update.  But in userspace it's possible to do updates 
even more quickly and painlessly.  For example, there could be a 
network server available for both interactive lookups and automatic 
queries from HAL.

> > Besides, is it really that much harder for userspace to modify device
> > settings as the devices are detected than for it to modify an in-kernel
> > whitelist just once?  Don't forget about possible races: Devices may
> > already have been detected and configured before userspace was able to
> > modify the whitelist.
> 
> Above you said "there's nothing to stop you from ... even turning 
> autosuspend on or off by hand".
> 
> If this will already be supported race-free, which races will still be
> possible?

You _can't_ change the autosuspend setting for a device that hasn't yet
been detected; you can only do it after detection.  But you _can_
modify a whitelist either before or after a device is detected; any
such modifications won't affect the already-existing devices.

Does that answer your question?

Alan Stern

