Return-Path: <linux-kernel-owner+w=401wt.eu-S1762310AbXE2OQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbXE2OQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761162AbXE2OQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:16:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760916AbXE2OQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:16:33 -0400
Date: Tue, 29 May 2007 16:16:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/5] lockdep: sanitise CONFIG_PROVE_LOCKING
Message-ID: <20070529141617.GB12812@elte.hu>
References: <20070529125248.877196281@chello.nl> <20070529130106.864404378@chello.nl> <20070529132158.GA2192@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529132158.GA2192@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, May 29, 2007 at 02:52:50PM +0200, Peter Zijlstra wrote:
> > Ensure that all of the lock dependency tracking code is under
> > CONFIG_PROVE_LOCKING. This allows us to use the held lock tracking code
> > for other purposes.
> 
> There's an awfull lot of ifdefs introduced in this patch, I wonder 
> whether it might be better to split up lockdep.c at those boundaries.

it adds 6 new #ifdefs. There's 35 #ifdefs in page_alloc.c, 44 in 
sysctl.c and 64 in sched.c. I'd not call it 'an awful lot', although 
certainly it could be reduced. Splitting lockdep.c up would uglify it 
well beyond the impact of the 6 #ifdefs, given the amount of glue 
needed.

	Ingo
