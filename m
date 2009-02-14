Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbZBNXc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbZBNXc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZBNXaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:30:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47079 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759242AbZBNXaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:30:12 -0500
Date: Sun, 15 Feb 2009 00:29:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1.5/2] generic-smp: fix initial quiesent count.
Message-ID: <20090214232941.GI20477@elte.hu>
References: <20090212223200.979433820@chello.nl> <20090212223750.295581470@chello.nl> <1234622474.4698.25.camel@laptop> <1234622792.4698.31.camel@laptop> <1234646056.4695.10.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234646056.4695.10.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2009-02-14 at 15:46 +0100, Peter Zijlstra wrote:
> > first compile, then send out...
> > 
> > ---
> > Subject: generic-smp: fix initial quiesent count.
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Sat Feb 14 15:36:07 CET 2009
> > 
> > If we start with a quiesent sequence count of 0, we'll match the initial stamp
> > values of the cfd_data, and never make any progress.
> > 
> > To avoid getting stuck in this situation, start out with an increased quiesent
> > sequence count.
> 
> OK, so this is not going to fix the problem in generic. Its still
> possible to end up with the original issue.
> 
> We'd need a callback list to free used entries, much like regular RCU,
> this quiesent sequence count's wrapping just seems too brittle.

Ok, given that your series was hanging on a number of testboxes here,
lets go with my original simplification?

The broadcasting-to-a-lot-of-CPUs case is going to suck on any seriously
large system no matter what. It's single-IPI and few-IPI performance that
matters mostly.

	Ingo
