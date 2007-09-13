Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbXIMUTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbXIMUTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbXIMUTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:19:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36687 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755323AbXIMUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:19:03 -0400
Date: Thu, 13 Sep 2007 22:19:10 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-ID: <20070913201910.GH3563@stusta.de>
References: <20070913154019.GG3563@stusta.de> <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 12:07:15PM -0400, Alan Stern wrote:
> On Thu, 13 Sep 2007, Adrian Bunk wrote:
> 
> > > > It is a good thing if userspace can add currently missing devices to
> > > > whitelists, but the whitelist itself should be in the kernel.
> > > 
> > > It's not clear that this sort of approach will turn out to be workable.  
> > > Whitelists/blacklists do okay in the kernel when they refer to a 
> > > relatively small subset of devices.  However in this case I have the 
> > > impression that we're talking about roughly a 50/50 split.  Keeping an 
> > > in-kernel list with even 10% of all existing USB devices simply isn't 
> > > feasible.
> > 
> > What about this is not feasible?
> > 
> > The amount of work for maintaining the list is the same:
> > 
> > No matter whether it's in-kernel or in the userspace, you need a list of 
> > working devices in some machine readable format.
> > 
> > Whether this gets used by the kernel, by userspace, or both, shouldn't 
> > make any difference.
> > 
> > Kernel image size can be a problem in some cases, but an in-kernel list 
> > doesn't have to be mandatory but could be made selectable in kconfig.
> 
> Well, size is one problem I had in mind.  There are a _lot_ of USB 
> devices in existence.

Kernel image size matters much for some uses, but not for all.

> But mainly it's a question of maintenance and modification.  Kernel
> developers don't really enjoy maintaining black- or whitelists of
> devices, together with all the work involved in sorting through the
> issues when somebody posts an email saying "My device doesn't work!".
> 
> Also, modifying device lists in the kernel tends to be a slow process, 
> involving at least one kernel release cycle.  It's much easier for 
> people to maintain userspace databases.  Now I realize you proposed 
> there be a userspace interface for modifying the kernel's whitelist -- 
> but if you're going to do that, why not put the entire whitelist in 
> userspace to begin with?

No matter whether the list is in userspace or in the kernel, maintaining 
it is exactly the same job of adding entries into some machine readable 
list (no matter whether it's a C struct or a CSV list that later gets 
converted).

This could be the kernel developers or some external sf project that 
gets synced with the kernel during each merge window.

> Maybe you're concerned about propagating updates as painlessly as 
> possible -- if the whitelist is in the kernel then every kernel release 
> would include an update.  But in userspace it's possible to do updates 
> even more quickly and painlessly.  For example, there could be a 
> network server available for both interactive lookups and automatic 
> queries from HAL.
>...

No, what I'm concerned about is that this would require userspace for 
something that is completely in-kernel.

> Alan Stern

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

