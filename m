Return-Path: <linux-kernel-owner+w=401wt.eu-S1764526AbXINO0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764526AbXINO0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXINO01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:26:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54275 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750890AbXINO00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:26:26 -0400
Date: Fri, 14 Sep 2007 10:26:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Adrian Bunk <bunk@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
In-Reply-To: <20070913212842.GI3563@stusta.de>
Message-ID: <Pine.LNX.4.44L0.0709141015550.3782-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Adrian Bunk wrote:

> What is not policy is the blacklist or whitelist information.

That's debatable, but never mind.

> And I'm also a bit concerned why "is policy" is that much a reason 
> against setting *reasonable default policies* without requiring the user 
> to do various things in userspace.

"Don't autosuspend" _is_ a reasonable default policy.  It's what Linux 
has been doing all along.

> Especially since this creates some nasty interdependencies between the 
> kernel and userspace.

No it doesn't.  If the kernel fails to provide the mechanism there's 
nothing that userspace can do about it anyway.  If the kernel does 
provide the mechanism and userspace ignores it, then things continue to 
work the same as they always have.

> And as an example, couldn't you equally say it's wrong that the kernel
> enables DMA on disks instead of leaving it to userspace?

It's not analogous.  Autosuspend involves setting an idle-delay time, 
which depends on the type of device and how it is being used.  DMA 
doesn't involve anything like that.

But forget about the delay for the moment.  If there were a high 
percentage of disk drives which would fail when DMA was enabled, then 
yes, the decision should be left to userspace.  If the percentage is 
low enough (and shrinking as vendors become more clueful) then moving
the decision into the kernel is acceptable.  At the moment USB 
autosuspend is not in this position, as we have learned painfully.

> We've already seen the udev disaster where upgrading from Debian 3.1 to 
> Debian 4.0 means upgrading from kernel 2.6.8 to 2.6.18 with the udev 
> version in Debian 3.1 not supporting kernel 2.6.18 and the udev version 
> in Debian 4.0 not supporting kernel 2.6.8, and I don't have a good 
> feeling about outsourcing more and more things to userspace tools not 
> distributed with the kernel.

This isn't a question of not being able to boot, like the udev fiasco;
this is a question of saving a few watts of power.  While it may be 
important for laptop users, it is not critical.

Alan Stern

