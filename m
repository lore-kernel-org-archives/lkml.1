Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZCNQLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZCNQLE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZCNQKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:10:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35511 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752182AbZCNQKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:10:54 -0400
Date: Sat, 14 Mar 2009 12:10:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
In-Reply-To: <20090314122434.GA14521@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903141157320.8138-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009, Ingo Molnar wrote:

> 
> * Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On Sat, 14 Mar 2009, K.Prasad wrote:
> > 
> > > Here's a summary of the intended changes to the patchset, which I hope
> > > to post early the following week. It tears down many features in the
> > > present submission (The write-up below is done without the benefit of
> > > actually having run into limitations while trying to chisel out code).
> > > 
> > > - Adopt a static allocation method for registers, say FCFS (and perhaps
> > >   botton-up for user-space allocations and the reverse for
> > >   kernel-space), although individual counters to do book-keeping should also
> > >   suffice.
> > 
> > You can't enforce bottom-up allocation for userspace breakpoint
> > requests. [...]
> 
> That's not the point.
> 
> The point is to offer a reasonable and simple static allocator 
> that will work fine with usual gdb usage. If something takes 
> away db4 that's as if user-space took away all registers - tough 
> luck.
> 
> You are trying to put complexity into a situation that is not 
> schedulable hence not resolvable _anyway_. There's just 4 debug 
> registers, not more. If the combined usage goes above four 
> someone will lose anyway - even with your allocator.

You are reading far more into my message than what I wrote.

I'm _not_ trying to put complexity anywhere.  All I did was point out
that Prasad was wrong to state that the kernel could adopt (or enforce)  
a bottom-up method for allocating debug registers for userspace 
breakpoints.  I trust you aren't trying to imply that he really was 
right?

> With my proposal the 'loss' can indeed come sooner if user-space 
> took db4 and there's nothing left for the kernel anymore - but 
> that's just an uninteresting special case that wont occur with 
> typical debug-register usage.
> 
> If it ever causes problems seriously _then_ will be the time to 
> consider "is it worth adding a more complex, dynamic allocator 
> for debug registers". Not now. This stuff is currently 
> over-designed and not acceptable to me in its current form.

My message didn't mention a word about more complex, dynamic
allocation.  Just the opposite, in fact -- because if we did virtualize
the debug registers then we _would_ be able to enforce bottom-up
allocation.

So in the end, you're _agreeing_ with what I wrote.  And yet the tone
of your reply suggests that you seemed to think that my message had
some deep, hostile intent.  It didn't.

Alan Stern

