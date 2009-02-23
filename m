Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbZBWRVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbZBWRVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZBWRVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:21:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZBWRVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:21:04 -0500
Date: Mon, 23 Feb 2009 18:20:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223172044.GA29344@elte.hu>
References: <20090220140157.GA12799@elte.hu> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com> <200902240029.37815.nickpiggin@yahoo.com.au> <20090223161726.GD6751@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223161726.GD6751@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Feb 24, 2009 at 12:29:36AM +1100, Nick Piggin wrote:
> > On Monday 23 February 2009 16:17:09 Paul E. McKenney wrote:
> > 
> > > The boot CPU runs in the context of its idle thread during boot-up.
> > > During this time, idle_cpu(0) will always return nonzero, which will
> > > fool Classic and Hierarchical RCU into deciding that a large chunk of
> > > the boot-up sequence is a big long quiescent state.  This in turn causes
> > > RCU to prematurely end grace periods during this time.
> > >
> > > This patch creates a new global variable that is set to 1 just before
> > > the boot CPU first enters the scheduler, after which the idle task
> > > really is idle.
> > 
> > Nice work all (btw. if this patch goes in rather than using system_state,
> > then please make the variable __read_mostly).
> 
> Hmmm...  I misread this and made system_state be 
> __read_mostly.  Let me know if this is bad, easy to fix if 
> needed.

no, it's the right thing to do. I'd not be surprised if we were 
already running into it as a performance problem - a number of 
common things check this flag.

	Ingo
