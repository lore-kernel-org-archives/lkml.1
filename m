Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYGXThS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYGXThS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYGXThD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:37:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46442 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYGXThB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:37:01 -0400
Date: Thu, 24 Jul 2008 21:35:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Patrick McHardy <kaber@trash.net>,
       David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
       w@1wt.eu, davidn@davidnewall.com, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi,
       Dave Jones <davej@redhat.com>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL
	pointer dereference
Message-ID: <20080724193532.GC1694@elte.hu>
References: <20080724093411.GA12001@elte.hu> <20080724115625.GA23994@elte.hu> <20080724115957.GA25701@elte.hu> <48886FA6.6050908@trash.net> <84144f020807240544q507e1b7cv220d1afbae0ee0f0@mail.gmail.com> <48887A71.5010209@trash.net> <1216905812.5897.6.camel@penberg-laptop> <48888434.3030207@trash.net> <1216906476.12021.4.camel@penberg-laptop> <20080724115127.6cfbb616.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724115127.6cfbb616.akpm@linux-foundation.org>
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

* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 24 Jul 2008 16:34:36 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > > >> Your patch introduced a use-after-free and double-free.
> > > >> krealloc() frees the old pointer, but it is still used
> > > >> for the ->move operations, then freed again.
> > > >>
> > > >> To fix this I think we need a __krealloc() that doesn't
> > > >> free the old memory, especially since it must not be
> > > >> freed immediately because it may still be used in a RCU
> > > >> read side (see the last part in the patch attached to
> > > >> this mail (based on a kernel without your patch)).
> > > > 
> > > > Agreed. Something like this, perhaps?
> > > > 
> > > > [PATCH] netfilter: fix double-free and use-after free
> > > > 
> > > > As suggested by Patrick McHardy, introduce a __krealloc() that doesn't
> > > > free the original buffer to fix a double-free and use-after-free bug
> > > > introduced by me in netfilter that uses RCU.
> > > > 
> > > > Reported-by: Patrick McHardy <kaber@trash.net>
> > > > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > > 
> > > Looks good to me, thanks.
> > 
> > Ingo, can you please test this? Andrew, I'm at OLS so can you pick up
> > the patch in your tree?
> 
> Sure.  Or Patrick can do so and it can be merged via the net tree.
> 
> Ingo, did this patch actually fix something over there?

not that i know of. I'll do some re-tests tomorrow to make sure.

	Ingo
