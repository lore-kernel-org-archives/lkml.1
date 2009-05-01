Return-Path: <linux-kernel-owner+w=401wt.eu-S1763835AbZEARUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763835AbZEARUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbZEARUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:20:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46303 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754987AbZEARUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:20:00 -0400
Date: Fri, 1 May 2009 13:20:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David VomLehn <dvomlehn@cisco.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/5] KERNEL: Support asynchronously-discovered boot
 devices, v4 (resend)
In-Reply-To: <20090501165803.GA13342@cuplxvomd02.corp.sa.net>
Message-ID: <Pine.LNX.4.44L0.0905011308460.2989-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, David VomLehn wrote:

> > OK, so "initdev" could be viewed as meaning "a device which /sbin/init
> > needs"?  Even I can understand that.
> > 
> > But /sbin/init isn't the first userspace we run, is it?  There's
> > initramfs stuff, firmware loaders, etc.
> > 
> > What's the story here?  Do we intend that all initdevs be up and
> > running before _any_ userspace runs?  Or is /sbin/init the red line?
> 
> I've avoided making any guarantees about this, but /sbin/init is implicitly
> the red line. If we make this explicit, we're probably back in the vicinity
> of the bike shed, but this should help frame any subsequent discussion
> in a concrete manner.

This matter is a little unclear, to me at least.  Consoles, yes, I
think we do want the console to be connected when the first user
process -- whether it is an initramfs or /bin/init or whatever --
starts up (if a console device does exist).

But the root filesystem is another story.  The initramfs or initrd may
itself load the necessary drivers.  Waiting for the root device to show
up then is no longer the kernel's responsibility.  However if there is
no initramfs then the kernel should indeed wait for the root device to
exist before trying to mount the root filesystem and start /bin/init.

Alan Stern

