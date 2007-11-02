Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbXKBWhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbXKBWhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 18:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXKBWhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 18:37:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:55935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbXKBWhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 18:37:23 -0400
Date: Fri, 2 Nov 2007 23:37:21 +0100
From: Nick Piggin <npiggin@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
Message-ID: <20071102223721.GA26562@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de> <4729E567.1050402@gmail.com> <alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org> <20071101203526.293cd7f0@bree.surriel.com> <alpine.LFD.0.999.0711011819110.3342@woody.linux-foundation.org> <20071102064220.GC20967@wotan.suse.de> <20071102100537.402ac85b@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102100537.402ac85b@bree.surriel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 10:05:37AM -0400, Rik van Riel wrote:
> On Fri, 2 Nov 2007 07:42:20 +0100
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Thu, Nov 01, 2007 at 06:19:41PM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Thu, 1 Nov 2007, Rik van Riel wrote:
> > > > 
> > > > Larry Woodman managed to wedge the VM into a state where, on his
> > > > 4x dual core system, only 2 cores (on the same CPU) could get the
> > > > zone->lru_lock overnight.  The other 6 cores on the system were
> > > > just spinning, without being able to get the lock.
> > 
> > That's quite incredible, considering that the CPUs actually _taking_
> > the locks also drop the locks and do quite a bit of work before taking
> > them again (ie. they take them to pull pages off the LRU, but then
> > do a reasonable amount of work to remove each one from pagecache
> > before refilling from the LRU).
> > 
> > Possibly actually that is a *more* difficult case for the HW to
> > handle: once the CPU actually goes away and operates on other
> > cachelines, it may get a little more difficult to detect that it is
> > causing starvation issues.
> 
> In case of the zone->lru_lock, grabbing the spinlock does
> not mean that the process is letting go of the cacheline.
> 
> On the contrary, once the spinlock has been grabbed, the
> real cacheline prodding begins.

I didn't say that, though. Obviously the hardware can't do anything
about starvating until a lock is released.
