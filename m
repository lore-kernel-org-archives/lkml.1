Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZBSJLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZBSJLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZBSJLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:11:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbZBSJLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:11:23 -0500
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <200902191501.47564.rusty@rustcorp.com.au>
References: <20090216163847.431174825@chello.nl>
	 <200902181520.17504.rusty@rustcorp.com.au> <20090218160535.GD23989@elte.hu>
	 <200902191501.47564.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 10:10:29 +0100
Message-Id: <1235034629.4612.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 15:01 +1030, Rusty Russell wrote:
> On Thursday 19 February 2009 02:35:35 Ingo Molnar wrote:
> > 
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 
> > > On Tuesday 17 February 2009 20:13:59 Ingo Molnar wrote:
> > > > We should not bend backwards trying to preserve that kmalloc() 
> > > > [and prove that it's safe and race-free] - i.e. the burden of 
> > > > proof is on the person insisting that it's needed, not on the 
> > > > person wanting to remove it.
> > > 
> > > Respectfully disagree.  The kmalloc has been there for a very long time,
> > > and doing fine AFAICT.
> > 
> > The kmalloc(GFP_ATOMIC) has been in kernel/smp.c for about half 
> > a year
> 
> Oops, yes.
> 
> So if we care about the kmalloc, why didn't we see benchmarks when we
> switched from the x86 smp_call_function_mask to the generic one?  Or did
> I just miss them (there's nothing in the git commit).
> 
> Now, I think the current patch is quite neat and may not been benchmarks to
> justify it, but it'd still be nice if it were faster, but noone seems to know.

I think the problem is that even on a lively machine these routines just
aren't called that often:

CAL:         74        104         93        116   Function call interrupts
make clean; make -j8 bzImage
CAL:         74        104         93        116   Function call interrupts

We could of course construct some artificial ubench to stress it...

