Return-Path: <linux-kernel-owner+w=401wt.eu-S1762722AbXGFHNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722AbXGFHNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXGFHNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:13:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413AbXGFHNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:13:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 09:20:42 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Paul Mackerras <paulus@samba.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0707051014180.3728-100000@iolanthe.rowland.org> <1183676393.3388.89.camel@localhost.localdomain>
In-Reply-To: <1183676393.3388.89.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707060920.43707.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6 July 2007 00:59, Benjamin Herrenschmidt wrote:
> On Thu, 2007-07-05 at 10:23 -0400, Alan Stern wrote:
> > 
> > How will that help?  Block the kernel thread in the freezer or block it 
> > in the driver -- either way it is blocked.  So how do your deadlocks 
> > get resolved?
> 
> Because nobody is waiting on that kernel thread anyway without a freezer
> so there is no deadlock anymore.

I'm not sure what you mean.  The freezer doesn't wait for threads that are
already frozen ...

> > I disagree with your analysis -- not that it's completely wrong, but it 
> > points out an existing basic problem in the kernel.  The kernel should 
> > never depend on userspace!  More correctly, a task executing in the 
> > kernel should never block with any sort of mutex or other lock held (in 
> > a way that would preclude it from being frozen, let's say) while 
> > waiting for a response from userspace.
> > 
> > Then the dependency graph would be easy to construct: User tasks can
> > depend on whatever they want, and kernel threads never depend on a user
> > task.
> 
> In an idea world, there would be no hunger...
> 
> > If this contradicts the existing implementations and APIs for userspace 
> > filesystems, then so be it.  My conclusion would be that the 
> > implementations and APIs should be changed.
> 
> Why are you guys working so hard and spending so much energy to try to
> avoid doing the right thing is beyond my understanding...
> 
> > It _does_ apply to kernel threads.  That's exactly why I wrote above 
> > that kernel threads which try to do I/O during a suspend will need 
> > extra attention.
> 
> Ok none at all if you don't have a freezer.

Provided that drivers can handle that.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
