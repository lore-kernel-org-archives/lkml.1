Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbZBQK5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbZBQK5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZBQK5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:57:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54551 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZBQK5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:57:31 -0500
Date: Tue, 17 Feb 2009 11:56:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
Message-ID: <20090217105651.GD6602@elte.hu>
References: <20090216163847.431174825@chello.nl> <20090216164114.521787803@chello.nl> <alpine.LFD.2.00.0902161636480.21686@localhost.localdomain> <1234859071.4744.10.camel@laptop> <20090217094359.GA1231@elte.hu> <1234864185.4744.36.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234864185.4744.36.camel@laptop>
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

> On Tue, 2009-02-17 at 10:43 +0100, Ingo Molnar wrote:
> > 
> > We should not bend backwards trying to preserve that kmalloc() 
> > [and prove that it's safe and race-free] - i.e. the burden of 
> > proof is on the person insisting that it's needed, not on the 
> > person wanting to remove it.
> 
> I'm not getting it, I am removing it. The only thing I want to 
> preserve is the multi-cast ipi and not be forced into the 
> multiple single-ipi path.

i know, but i mean we are trying to achieve something hard that 
came together with the kmalloc() in essence.

So instead of trying to preserve that, how about removing it the 
obvious way and then adding back a more complex multi-cast IPI 
code?

That way we'll have a safe point to fall back to, should Oleg 
poke more holes into it, down the line ;-)

	Ingo
