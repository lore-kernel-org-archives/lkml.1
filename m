Return-Path: <linux-kernel-owner+w=401wt.eu-S965780AbXDBUEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965780AbXDBUEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965781AbXDBUEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:04:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4084 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965780AbXDBUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:04:46 -0400
Date: Mon, 2 Apr 2007 16:04:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [linux-pm] [PATCH v2] Add suspend/resume for HPET
In-Reply-To: <200704021216.22280.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0704021557270.29713-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, David Brownell wrote:

> What the driver model does now is problematic.  Even if the clockevent
> stuff gets different fixes, those driver model issues still exist:  the
> existence of dependencies that are not part of the device tree.

> No, it's a "just happened to work" because the only ordering promise
> that was explicitly made is that the parent/child relationships will
> be obeyed.  Any additional ordering dependency is out-of-scope of the
> current driver model -- and that's a proble that eventually needs to
> be fixed.
> 
> This is the kind of thing that the pm_parent relationship was (AFAICT)
> originally supposed to handle.  Of course, it doesn't/can't, given the
> current implementation ... that relationship is never used.

Just so.  In fact, there almost certainly are other dependencies that 
nobody is aware of, simply because they have never had a chance to bite.

Such things can be rather difficult to pin down when they occur.  I would
be happy enough to leave matters as they are, with a strict LIFO approach.  
If someone ever tries to parallelize suspend/resume in multiple threads,
they will have their work cut out for them -- even probing ran into
trouble when attempts were made to parallelize it, and it's a lot simpler.


> It's not that simple though, especially with HPET.  The BIOS may expect
> the PIT to work, but Linux currently (and problematically!) uses HPET in
> "legacy replacement mode".  And ISTR the problems are coming up when the
> system is already in a low-functionality state:  IRQs off everywhere,
> even timer ticks have stopped.

I know nothing about the workings of the HPET and other clock code.  My 
point was this: Suspend passes through various intermediate stages in 
which some devices are available and others aren't.  So long as those 
stages are exact duplicates (in reverse order) of the stages that occurred 
during startup, it should be possible to make them all work.

Alan Stern

