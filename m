Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbXELVKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbXELVKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 17:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXELVK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 17:10:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36361 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbXELVK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 17:10:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFD] Freezing of kernel threads
Date: Sat, 12 May 2007 23:14:56 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200705122017.32792.rjw@sisk.pl> <alpine.LFD.0.98.0705121120280.3986@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705121120280.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705122314.57458.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 May 2007 20:25, Linus Torvalds wrote:
> 
> On Sat, 12 May 2007, Rafael J. Wysocki wrote:
> > 
> > Of course, that would also require us to rewrite the freezer itself quite a
> > bit, but IMO it's worthy of doing.
> > 
> > Thoughts?
> 
> I'd much prefer it. One of the reasons I hate the freezer so much is that 
> it ends up affecting things it really has no business affecting. Why 
> should a random kernel thread have to havecode NOT to care? So it makes 
> much more sense to default to "I don't care about the freezer", and then 
> people who do care can say so and add their own code.
> 
> That said, I also suspect that suspend should depend less on the freezer 
> in the first place, and depend more on just shutting up specific actions.

Well, I think that could be the next step.

> The freezer is kind of a blunt instrument that just stops everything, 
> without actually understanding *what* it stops. As a result (since it 
> really doesn't know what it's doing), it ends up having all the issues 
> with "ok, I don't know what I'm doing, but that guy says I shouldn't do 
> it, so I won't".
> 
> Blunt instruments are often _easier_ (compare with the global kernel lock 
> in SMP), but they end up being very inflexible and hard to get rid of 
> later when you want to do something more intelligent. 

I generally agree, but as far as the hibernation/suspend is concerned, I'm not
at the point of doing things more intelligently yet.  Someone who's been
developing the kernel for the last 15 years surely can do this, but not me.

OTOH, I think I can change the freezer so that it works as I outlined in the
previous message and I'd like to be able to make some progress in a direction
that's more-or-less acceptable to everyone.

Frankly, I don't see much point in developing things that you object to very
strongly, because that ultimately would lead to a loss of time, mine as well as
yours.

Greetings,
Rafael
