Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbXGEXHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbXGEXHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762006AbXGEXHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:07:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:42354 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761269AbXGEXHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:07:19 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Paul Mackerras <paulus@samba.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <Pine.LNX.4.44L0.0707051014180.3728-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0707051014180.3728-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 08:59:52 +1000
Message-Id: <1183676393.3388.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 10:23 -0400, Alan Stern wrote:
> 
> How will that help?  Block the kernel thread in the freezer or block it 
> in the driver -- either way it is blocked.  So how do your deadlocks 
> get resolved?

Because nobody is waiting on that kernel thread anyway without a freezer
so there is no deadlock anymore.

> I disagree with your analysis -- not that it's completely wrong, but it 
> points out an existing basic problem in the kernel.  The kernel should 
> never depend on userspace!  More correctly, a task executing in the 
> kernel should never block with any sort of mutex or other lock held (in 
> a way that would preclude it from being frozen, let's say) while 
> waiting for a response from userspace.
> 
> Then the dependency graph would be easy to construct: User tasks can
> depend on whatever they want, and kernel threads never depend on a user
> task.

In an idea world, there would be no hunger...

> If this contradicts the existing implementations and APIs for userspace 
> filesystems, then so be it.  My conclusion would be that the 
> implementations and APIs should be changed.

Why are you guys working so hard and spending so much energy to try to
avoid doing the right thing is beyond my understanding...

> It _does_ apply to kernel threads.  That's exactly why I wrote above 
> that kernel threads which try to do I/O during a suspend will need 
> extra attention.

Ok none at all if you don't have a freezer.

Ben.


