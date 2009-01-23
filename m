Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbZAWIBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbZAWIBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 03:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZAWIBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 03:01:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:54871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZAWIBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 03:01:02 -0500
Subject: Re: [RFC PATCH 01/19] lockdep: annotate reclaim context
 (__GFP_NOFS)
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090123073326.GA19986@wotan.suse.de>
References: <20090122173701.674448070@chello.nl>
	 <20090122174052.061744802@chello.nl> <1232653234.4890.135.camel@laptop>
	 <1232656187.4890.136.camel@laptop>  <20090123073326.GA19986@wotan.suse.de>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 09:00:57 +0100
Message-Id: <1232697657.4791.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 08:33 +0100, Nick Piggin wrote:
> On Thu, Jan 22, 2009 at 09:29:47PM +0100, Peter Zijlstra wrote:
> > On Thu, 2009-01-22 at 20:40 +0100, Peter Zijlstra wrote:
> > > > +               return;
> > > > +       if (DEBUG_LOCKS_WARN_ON(irqs_disabled()))
> > > > +               return;
> > > > +
> > > > +       mark_held_locks(curr, RECLAIM_FS);
> > > > +}
> > > 
> > > Not quite seeing how this happens though...
> > > 
> > > [    6.998258] WARNING: at /usr/src/linux-2.6/kernel/lockdep.c:2266
> > > lockdep_trace_alloc+0x58/0x69() 
> > 
> > Doh, its getting there without __GFP_WAIT...
> 
> Ah, sorry. Thanks for debugging. Should just be a matter of sticking
> a check for GFP_WAIT in there somewhere?

Yeah, I'll stick a check in there, that ought to suffice.

> Thanks for pulling this in BTW (hopefully you don't see any more issues).
> Your subsequent improvements all seem pretty nice to me too (although I
> don't know the lockdep code well, but I didn't see any obviuos problems).

Thanks, I'll test it some today, and hopefully stuff will just work ;-)

