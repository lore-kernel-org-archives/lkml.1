Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXD2IXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXD2IXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030297AbXD2IXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:23:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52481 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030357AbXD2IXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:23:40 -0400
Date: Sun, 29 Apr 2007 10:23:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Back to the future.
Message-ID: <20070429082313.GA1900@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <20070428085000.GA3293@elf.ucw.cz> <alpine.LFD.0.98.0704280926140.9964@woody.linux-foundation.org> <200704281950.30405.rjw@sisk.pl> <alpine.LFD.0.98.0704281421140.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704281421140.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The freezer has *caused* those deadlocks (eg by stopping threads that were 
> > > needed for the suspend writeouts to succeed!), not solved them.
> > 
> > I can't remember anything like this, but I believe you have a specific test
> > case in mind.
> 
> Ehh.. Why do you thik we _have_ that PF_NOFREEZE thing in the first place?
> 
> Rafael, you really don't know what you're talking about, do you?
> 
> Just _look_ at them. It's the IO threads etc that shouldn't be frozen, 
> exactly *because* they do IO. You claim that kernel threads shouldn't do 
> IO, but that's the point: if you cannot do IO when snapshotting to disk, 
> here's a damn big clue for you: how do you think that snapshot is going to 
> get written?
> 
> I *guarantee* you that we've had a lot more problems with threads that 
> should *not* have been frozen than with those hypothetical threads that 
> you think should have been frozen.

Well, we had nasty corruption on XFS, caused by thread that was not
frozen and should be. (While the other case leads "only" to deadlocks,
so it is easier to debug.)

The locking point.. when I added freezing to swsusp, I knew very
little about kernel locking, so I "simply" decided to avoid the
problem altogether... using the freezer.

You may be right that locks are not a big problem for the hibernation
after all; I just do not know.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
