Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYKKRRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYKKRRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYKKRR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:17:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50888 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYKKRR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:17:28 -0500
Date: Tue, 11 Nov 2008 18:16:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, adobriyan@gmail.com,
       Doug Chapman <doug.chapman@hp.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] for account_group_exec_runtime(), make sure ->signal
	can't be freed under rq->lock
Message-ID: <20081111171659.GB8201@elte.hu>
References: <20081110143930.GA28275@redhat.com> <20081111103532.GA8869@elte.hu> <1226423423.4444.8.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226423423.4444.8.camel@bobble.smo.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Mayhar <fmayhar@google.com> wrote:

> On Tue, 2008-11-11 at 11:35 +0100, Ingo Molnar wrote:
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> > > The patch is ugly, but I don't see the better fix for now. Needs the 
> > > review from Peter/Ingo.
> > this is indeed too ugly, and if we do it we'll get both this ugliness 
> > and the CPU loop upstream forever. Frank, if you dont have time to fix 
> > this code, then i guess the best thing is to do the full revert that 
> > Peter sent.
> 
> Well, at the moment I'm up to my armpits in alligators.  That said, 
> we're going to have to pull in this code regardless, ugliness and 
> all, since we're guaranteed to run into the soft lockup bug 
> otherwise.  This means that I'll have strong incentive to come back 
> and readdress the fix to remove the ugliness and address Peter's 
> concerns.  I have no idea when that will be, however.

well, we wont leave buggy code in there for .28 - it could trigger 
anytime on any SMP box, no matter how narrow the race is.

I've picked up the spin-wait fix from Oleg, because it fixes the bug. 
But we should really fix the fundamental issues here too.

	Ingo
