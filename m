Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZAWHdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZAWHdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 02:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZAWHd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 02:33:29 -0500
Received: from ns1.suse.de ([195.135.220.2]:56013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbZAWHd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 02:33:28 -0500
Date: Fri, 23 Jan 2009 08:33:26 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/19] lockdep: annotate reclaim context (__GFP_NOFS)
Message-ID: <20090123073326.GA19986@wotan.suse.de>
References: <20090122173701.674448070@chello.nl> <20090122174052.061744802@chello.nl> <1232653234.4890.135.camel@laptop> <1232656187.4890.136.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232656187.4890.136.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 09:29:47PM +0100, Peter Zijlstra wrote:
> On Thu, 2009-01-22 at 20:40 +0100, Peter Zijlstra wrote:
> > > +               return;
> > > +       if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
> > > +               return;
> > > +
> > > +       mark_held_locks(curr, RECLAIM_FS);
> > > +}
> > 
> > Not quite seeing how this happens though...
> > 
> > [    6.998258] WARNING: at /usr/src/linux-2.6/kernel/lockdep.c:2266
> > lockdep_trace_alloc+0x58/0x69() 
> 
> Doh, its getting there without __GFP_WAIT...

Ah, sorry. Thanks for debugging. Should just be a matter of sticking
a check for GFP_WAIT in there somewhere?

Thanks for pulling this in BTW (hopefully you don't see any more issues).
Your subsequent improvements all seem pretty nice to me too (although I
don't know the lockdep code well, but I didn't see any obviuos problems).

Thanks,
Nick
