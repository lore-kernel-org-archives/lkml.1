Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbXC1Gnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbXC1Gnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 02:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbXC1Gnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 02:43:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:55625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbXC1Gni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 02:43:38 -0400
Date: Wed, 28 Mar 2007 08:43:18 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nikita Danilov <nikita@clusterfs.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-ID: <20070328064318.GA12508@wotan.suse.de>
References: <20070323085910.GA11577@wotan.suse.de> <20070323100418.GA30740@elte.hu> <20070323103243.GE11577@wotan.suse.de> <17925.18904.820106.145029@gargle.gargle.HOWL> <20070324172959.GB542@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324172959.GB542@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2007 at 06:29:59PM +0100, Ingo Molnar wrote:
> 
> * Nikita Danilov <nikita@clusterfs.com> wrote:
> 
> > Indeed, this technique is very well known. E.g., 
> > http://citeseer.ist.psu.edu/anderson01sharedmemory.html has a whole 
> > section (3. Local-spin Algorithms) on them, citing papers from the 
> > 1990 onward.
> 
> that is a cool reference! So i'd suggest to do (redo?) the patch based 
> on those concepts and that terminology and not use 'queued spinlocks' 
> that are commonly associated with MS's stuff. And as a result the 
> contended case would be optimized some more via local-spin algorithms. 
> (which is not a key thing for us, but which would be nice to have 
> nevertheless)

Firstly, the terminology in that paper _is_ "queue lock", which isn't
really surprising. I don't really know or care about what MS calls their
locks, but I'd suggest that their queued spinlock is probably named in
reference to its queueing property rather than its local spin property.

Mine is a queueing lock, so I'll continue to call it queued spinlocks
(not that the terminology will make it into our API anyway, because I
intend for them simply to be an implementation of spinlocks).

Secondly, as you say, local spin isn't really a must have. If SGI hasn't
made a big stink about them by now, then I think queued locks (which are
addressing a real hardware starvation issue on opterons) is more important.

That isn't to say that local spin might not help performance, or that
my queued spinlocks would make it impossible to implement... it's just
that it isn't my aim.
