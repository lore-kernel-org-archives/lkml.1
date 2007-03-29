Return-Path: <linux-kernel-owner+w=401wt.eu-S932873AbXC2BYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbXC2BYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 21:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933059AbXC2BYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 21:24:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:57796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873AbXC2BYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 21:24:37 -0400
Date: Thu, 29 Mar 2007 03:24:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nikita Danilov <nikita@clusterfs.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-ID: <20070329012412.GA2390@wotan.suse.de>
References: <20070323085910.GA11577@wotan.suse.de> <20070323100418.GA30740@elte.hu> <20070323103243.GE11577@wotan.suse.de> <17925.18904.820106.145029@gargle.gargle.HOWL> <20070324172959.GB542@elte.hu> <20070328064318.GA12508@wotan.suse.de> <Pine.LNX.4.64.0703281224030.21150@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703281224030.21150@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 12:26:57PM -0700, Davide Libenzi wrote:
> On Wed, 28 Mar 2007, Nick Piggin wrote:
> 
> > On Sat, Mar 24, 2007 at 06:29:59PM +0100, Ingo Molnar wrote:
> > > 
> > > * Nikita Danilov <nikita@clusterfs.com> wrote:
> > > 
> > > > Indeed, this technique is very well known. E.g., 
> > > > http://citeseer.ist.psu.edu/anderson01sharedmemory.html has a whole 
> > > > section (3. Local-spin Algorithms) on them, citing papers from the 
> > > > 1990 onward.
> > > 
> > > that is a cool reference! So i'd suggest to do (redo?) the patch based 
> > > on those concepts and that terminology and not use 'queued spinlocks' 
> > > that are commonly associated with MS's stuff. And as a result the 
> > > contended case would be optimized some more via local-spin algorithms. 
> > > (which is not a key thing for us, but which would be nice to have 
> > > nevertheless)
> > 
> > Firstly, the terminology in that paper _is_ "queue lock", which isn't
> > really surprising. I don't really know or care about what MS calls their
> > locks, but I'd suggest that their queued spinlock is probably named in
> > reference to its queueing property rather than its local spin property.
> 
> The method you propose is otherwise called "Ticket Lock":
> 
> http://en.wikipedia.org/wiki/Ticket_lock
> http://www.cs.rochester.edu/research/synchronization/pseudocode/ss.html#ticket

Yes, a ticket based FIFO queue isn't new... I think we have a lot of
xamples already in the kernel. Using them to implement queue locks
obviously isn't new either.

I don't think we'd have to worry about patents.
