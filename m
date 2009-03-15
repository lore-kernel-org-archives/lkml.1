Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbZCOJrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbZCOJrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 05:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZCOJrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 05:47:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40073 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbZCOJri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 05:47:38 -0400
Date: Sun, 15 Mar 2009 10:47:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-tip-commits@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com
Subject: Re: SLOB lockup (was: Re: [tip:core/locking] lockdep: annotate
	reclaim context (__GFP_NOFS), fix SLOB)
Message-ID: <20090315094704.GA21169@elte.hu>
References: <20090128135457.350751756@chello.nl> <tip-bf722c9d324864b4256edaa330751b77f2a19861@git.kernel.org> <20090315064818.GA1193@elte.hu> <200903152006.21160.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903152006.21160.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Sunday 15 March 2009 17:48:18 Ingo Molnar wrote:
> 
> > > Cc: Nick Piggin <npiggin@suse.de>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > LKML-Reference: <20090128135457.350751756@chello.nl>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >
> > and with this fixed, and with SLOB now being tested in -tip, the
> > new lockdep assert attached below (followed by a real lockup)
> > pops up.
> >
> > Seems like a genuine SLOB bug, probably present upstream as
> > well.
> 
> Hmmf. debugobjects calls back into the slab allocator from the 
> page allocator. The following patch would improve SLOB, but I 
> think it would be a good idea to avoid a dependency in that 
> direction. Can debugobjects defer this freeing?

dunno - that's a question for Thomas.

this lockup does not trigger under any of the other allocators.

	Ingo
