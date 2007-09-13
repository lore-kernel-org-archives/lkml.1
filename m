Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbXIMV2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbXIMV2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbXIMV2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:28:35 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42479 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754274AbXIMV2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:28:34 -0400
Date: Thu, 13 Sep 2007 23:28:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-ID: <20070913212842.GI3563@stusta.de>
References: <20070913154019.GG3563@stusta.de> <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org> <20070913201910.GH3563@stusta.de> <alpine.LFD.0.999.0709131341300.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709131341300.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 01:44:23PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 13 Sep 2007, Adrian Bunk wrote:
> > 
> > No, what I'm concerned about is that this would require userspace for 
> > something that is completely in-kernel.
> 
> If done right (and autosuspend now is), there is no "required" userspace.
> 
> If you want autosuspend, you just say so. The kernel doesn't do it by 
> default. This is not about "user space required" - it's about "user space 
> can ask for it if it wants to".
> 
> Notice? There doesn't even have to be any blacklists/whitelists at all. It 
> really can be just an application that allows the user to check or uncheck 
> the capability (with a warning saying something like: "Some USB devices 
> may disconnect when suspended - if this affects you, uncheck this").
> 
> That's why the kernel shouldn't set policy. It's a *good* thing to just 
> expose the capabilities, but not necessarily use them! 

What is not policy is the blacklist or whitelist information.

And I'm also a bit concerned why "is policy" is that much a reason 
against setting *reasonable default policies* without requiring the user 
to do various things in userspace.

Especially since this creates some nasty interdependencies between the 
kernel and userspace.

And as an example, couldn't you equally say it's wrong that the kernel
enables DMA on disks instead of leaving it to userspace?

We've already seen the udev disaster where upgrading from Debian 3.1 to 
Debian 4.0 means upgrading from kernel 2.6.8 to 2.6.18 with the udev 
version in Debian 3.1 not supporting kernel 2.6.18 and the udev version 
in Debian 4.0 not supporting kernel 2.6.8, and I don't have a good 
feeling about outsourcing more and more things to userspace tools not 
distributed with the kernel.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

