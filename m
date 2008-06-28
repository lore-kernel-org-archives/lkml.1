Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbYF1QqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbYF1QqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 12:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYF1QqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 12:46:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:37358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYF1QqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 12:46:12 -0400
Date: Sat, 28 Jun 2008 09:43:43 -0700
From: Greg KH <greg@kroah.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mmc: Export ios settings for a host through debugfs
Message-ID: <20080628164343.GA11922@kroah.com>
References: <1214478589-21291-1-git-send-email-haavard.skinnemoen@atmel.com> <1214478589-21291-2-git-send-email-haavard.skinnemoen@atmel.com> <20080628153403.0870e96c@mjolnir.drzeus.cx> <20080628154700.426a422c@hskinnemo-gx745.norway.atmel.com> <20080628155913.2bba34a9@mjolnir.drzeus.cx> <20080628160752.0fe19753@hskinnemo-gx745.norway.atmel.com> <20080628153309.GC11018@kroah.com> <20080628180858.4bb1cd5b@hskinnemo-gx745.norway.atmel.com> <20080628183736.077263a6@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080628183736.077263a6@hskinnemo-gx745.norway.atmel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 06:37:36PM +0200, Haavard Skinnemoen wrote:
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> > Ok, I'll try. I'm not an FS developer, so I'm sure the below patch is
> > horribly broken in some subtle way, but it does appear to work at least
> > the few times I tried it...
> > 
> > Lockdep indeed confirms that something is broken:
> 
> Another try. This time I'm taking only one lock at a time, so lockdep
> is happy. Is it still safe?

At first glance, this looks sane, thanks a lot.

> From ee72de0df9a471eb7fbab7827606a2b9a6afe19c Mon Sep 17 00:00:00 2001
> From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Date: Sat, 28 Jun 2008 17:54:15 +0200
> Subject: [PATCH] debugfs: Implement debugfs_remove_recursive()
> 
> debugfs_remove_recursive() will remove a dentry and all its children.
> Drivers can use this to zap their whole debugfs tree so that they don't
> need to keep track of every single debugfs dentry they created.
> 
> It may fail to remove the whole tree in certain cases:
> 
> sh-3.2# rmmod atmel-mci < /sys/kernel/debug/mmc0/ios/clock
> mmc0: card b368 removed
> atmel_mci atmel_mci.0: Lost dma0chan1, falling back to PIO
> sh-3.2# ls /sys/kernel/debug/mmc0/
> ios
> 
> But I'm not sure if that case can be handled in any sane manner.

I think we have always been failing this case as I know securityfs also
has this same issue, and the code base is pretty much identical.

So don't worry that this patch caused this issue.

I'll queue it up unless there are any other objections to it.

thanks,

greg k-h
