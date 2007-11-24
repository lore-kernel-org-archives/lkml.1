Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbXKXMXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbXKXMXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 07:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXKXMXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 07:23:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49268 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbXKXMXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 07:23:31 -0500
Date: Sat, 24 Nov 2007 13:22:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debug_check_no_locks_freed: fix in_range() checks
Message-ID: <20071124122237.GB2513@elte.hu>
References: <20071120234605.GG23667@elte.hu> <20071121155842.GA864@tv-sign.ru> <20071124105343.GA2044@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071124105343.GA2044@tv-sign.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > But debug_check_no_locks_freed() seems does:
> > const void *mem_to = mem_from + mem_len
> > -> mem_to is the last byte of the freed range, that fits in_range
> > lock_from = (void *)hlock->instance;
> > -> first byte of the lock
> > lock_to = (void *)(hlock->instance + 1);
> > -> first byte of the next lock, not last byte of the lock that is being checked!
> >
> > The test is:
> > if (!in_range(mem_from, lock_from, mem_to) &&
> >                                         !in_range(mem_from, lock_to, mem_to))
> >                         continue;
> > So it tests, if the first byte of the lock is in the range that is freed ->OK
> > And if the first byte of the *next* lock is in the range that is freed
> > -> Not OK.

thanks, applied.

	Ingo
