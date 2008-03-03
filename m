Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbYCCRog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbYCCRog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760910AbYCCRnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:43:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46103 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760529AbYCCRnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:43:52 -0500
Date: Mon, 3 Mar 2008 18:44:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
	is required
Message-ID: <20080303174422.GB13869@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0803031207120.3611-100000@iolanthe.rowland.org> <alpine.LFD.1.00.0803030921420.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803030921420.17889@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Consider a routine like the following:
> > 
> > 	static task_struct *the_task;
> > 
> > 	void store_task(void)
> > 	{
> > 		the_task = current;
> > 	}
> > 
> > Is it possible to say whether readers examining "the_task" are 
> > guaranteed to see a coherent value?
> 
> Yes, we do depend on this.  All the RCU stuff (and in general *anything* 
> that depends on memory ordering as opposed to full locking, and we have 
> quite a lot of it) is very fundamentally dependent on the fact that things 
> like pointers get read and written atomically.
> 
> HOWEVER, it is worth pointing out that it's generally true in a 
> "different" sense than the actual atomic accesses. For example, if you 
> test a single bit of a word, it's still quite possible that gcc will have 
> turned that "atomic" read into a single byte read, so it's not necessarily 
> the case that we'll actually even read the whole word. 
> 
> (Writes are different: if you do things like bitwise updates they simply 
> *will*not* be atomic, but that's simply not what we depend on anyway).

Ok... can we get Alan Stern's patch into Documentation/atomic_ops.txt
, then? I was not aware of this, and there seems to be lot of
confusion around...

Plus... I really don't think we can "just access" this as normal
pointers... due to the compiler issues Alan Cox mentioned, and due to
the ACCESS_ONCE() issue.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
