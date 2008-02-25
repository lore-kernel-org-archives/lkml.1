Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYBYLan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYBYLan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYBYLaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:30:35 -0500
Received: from styx.suse.cz ([82.119.242.94]:54884 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752408AbYBYLae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:30:34 -0500
Date: Mon, 25 Feb 2008 10:03:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>, zdenek.kabelac@gmail.com,
       davem@davemloft.net
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: using long instead of atomic_t when only set/read is required (was
	Re: [Bug 10030] Suspend doesn't work when SD card is inserted)
Message-ID: <20080225090316.GA420@elf.ucw.cz>
References: <20080224214253.GE18908@elf.ucw.cz> <Pine.LNX.4.44L0.0802242109130.31164-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802242109130.31164-100000@netrider.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Alan thinks that `subj` is correct...

> > > > At the very least, you'd need rmb() before reading it and wmb() after
> > > > writing to it, but I'm not sure if that's enough on every obscure
> > > > architecture out there.
> > > 
> > > No, neither one is needed because of the way suspending_task is used.  
> > > 
> > > It's not necessary for a reader R to see the variable's actual value;  
> > > all R needs to know is whether or not suspending_task is equal to R.  
> > > Since the only process which can set suspending_task to R is R itself,
> > > and since R will set suspending_task back to NULL before releasing the
> > > write lock on pm_sleep_rwsem, there's never any ambiguity.
> > 
> > Subtle.
> > 
> > Very subtly wrong ;-).
> > 
> > imagine suspending_task == 0xabcdef01. Now task "R" with current ==
> > 0xabcd0000 reads suspending_task while the other cpu is writing to it,
> > and sees 0xabcd0000 (0xef01 was not yet written) -- and mistakenly
> > believes that  "R" == suspending_task.
> 
> I always thought that reads and writes of pointers are atomic, just 
> like reads and writes of longs.  Is that wrong?

...but I'm not that sure. Can someone clarify?

I guess it only works as long as longs are aligned? Should it be
written down to atomic_ops.txt?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
