Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbXIMPkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbXIMPkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbXIMPkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:40:12 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42804 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756725AbXIMPkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:40:11 -0400
Date: Thu, 13 Sep 2007 17:40:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Adrian Bunk <bunk@kernel.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-ID: <20070913154019.GG3563@stusta.de>
References: <20070913145207.GF3563@stusta.de> <Pine.LNX.4.44L0.0709131111460.3619-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0709131111460.3619-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 11:20:42AM -0400, Alan Stern wrote:
> On Thu, 13 Sep 2007, Adrian Bunk wrote:
> 
> > > These two patches address the need today to have users machines still
> > > work, even if they might draw more power than they possibly could (which
> > > is not any more than they did in 2.6.22.)
> > > 
> > > These patches do two things:
> > >   - disable USB autosuspend on all devices except for USB hubs.  This
> > >     can be easily overridden by userspace to turn on autosuspend for
> > >     devices that a user wants to.  HAL will use a whitelist in the
> > >     future for these types of devices.
> > >...
> > 
> > Not related to the patch for 2.6.23, but I have a gut feeling that 
> > something might be done the wrong way later:
> > 
> > If I understand you correctly, you are saying that I will have to 
> > install HAL for getting a whitelist for in-kernel functionality?
> 
> Your meaning isn't entirely clear.  Presumably HAL will contain such a 
> whitelist.  But there's nothing to stop you from setting up your own 
> whitelist via udev scripts, or even turning autosuspend on or off by 
> hand.
> 
> > It is a good thing if userspace can add currently missing devices to
> > whitelists, but the whitelist itself should be in the kernel.
> 
> It's not clear that this sort of approach will turn out to be workable.  
> Whitelists/blacklists do okay in the kernel when they refer to a 
> relatively small subset of devices.  However in this case I have the 
> impression that we're talking about roughly a 50/50 split.  Keeping an 
> in-kernel list with even 10% of all existing USB devices simply isn't 
> feasible.

What about this is not feasible?

The amount of work for maintaining the list is the same:

No matter whether it's in-kernel or in the userspace, you need a list of 
working devices in some machine readable format.

Whether this gets used by the kernel, by userspace, or both, shouldn't 
make any difference.

Kernel image size can be a problem in some cases, but an in-kernel list 
doesn't have to be mandatory but could be made selectable in kconfig.

> Besides, is it really that much harder for userspace to modify device
> settings as the devices are detected than for it to modify an in-kernel
> whitelist just once?  Don't forget about possible races: Devices may
> already have been detected and configured before userspace was able to
> modify the whitelist.

Above you said "there's nothing to stop you from ... even turning 
autosuspend on or off by hand".

If this will already be supported race-free, which races will still be
possible?

> Alan Stern

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

