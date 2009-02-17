Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZBQJon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZBQJon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZBQJof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:44:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44175 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZBQJoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:44:34 -0500
Date: Tue, 17 Feb 2009 10:43:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
Message-ID: <20090217094359.GA1231@elte.hu>
References: <20090216163847.431174825@chello.nl> <20090216164114.521787803@chello.nl> <alpine.LFD.2.00.0902161636480.21686@localhost.localdomain> <1234859071.4744.10.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234859071.4744.10.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2009-02-16 at 16:40 -0800, Linus Torvalds wrote:
> > 
> > On Mon, 16 Feb 2009, Peter Zijlstra wrote:
> > >
> > > Now that there is no strict need for kmalloc anymore, and nobody seems to
> > > rely it for the queueing behaviour, remove it.
> > 
> > Peter, I really hate this series.
> > 
> > Why?
> > 
> > In 1/4 you introduce that cfd RCU thing, and then in 2/4 you remove it 
> > again.
> 
> Ah, no, I don't actually. I remove the kmalloc+call_rcu stuff in 2, not
> the newly cfd mini rcu thing.
> 
> > I realize that you seem to do that in order to do some incremental 
> > step-wise changes, but quite frankly, it just complicates the whole series 
> > and makes the patches much harder to read and follow.
> > 
> > Why don't you just combine patches 1&2? That split-up seems to just 
> > confuse things. At least it confuses me. Why does it happen?
> 
> The idea was to remove the necessity for kmalloc() in patch 1, 
> and then remove kmalloc() in patch 2.
> 
> If you prefer I can fold them, no problem.
> 
> But as you might have seen, Oleg has been punching holes in my 
> #1, so I guess I'm back to the drawing board no matter what 
> :-)

I think the kmalloc() is clearly ugly, we should remove it, and 
if someone wants to add it we want to see _hard numbers_ that 
it's worth the ugliness. I.e. lets go with the two patches i 
posted, they are obvious and tested.

We should not bend backwards trying to preserve that kmalloc() 
[and prove that it's safe and race-free] - i.e. the burden of 
proof is on the person insisting that it's needed, not on the 
person wanting to remove it.

	Ingo
