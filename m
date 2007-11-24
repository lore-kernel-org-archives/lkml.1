Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbXKXH4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbXKXH4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 02:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXKXH4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 02:56:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44959 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbXKXH4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 02:56:05 -0500
Date: Sat, 24 Nov 2007 08:55:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>
Subject: Re: [bug] xfrm_state_lock: possible circular locking dependency
	detected
Message-ID: <20071124075519.GA9118@elte.hu>
References: <20071123153851.GA26308@elte.hu> <20071124021814.GA24056@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071124021814.GA24056@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Fri, Nov 23, 2007 at 04:38:51PM +0100, Ingo Molnar wrote:
> > 
> > DaveJ's Fedora 8 rpm for 2.6.24 works petty well, except for the 
> > neworking related lockdep assert attached below, which happened while 
> > starting up ipsec. Let me know if you need any more info - it's a pretty 
> > stock setup.
> 
> Thanks for the report Ingo!
> 
> This is indeed a regression caused by:
> 
> commit 050f009e16f908932070313c1745d09dc69fd62b
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Tue Oct 9 13:31:47 2007 -0700
> 
>     [IPSEC]: Lock state when copying non-atomic fields to user-space
> 
> For 2.6.24 I'm simply going to revert this change since that just puts 
> us back to the same state we've been for the last few years.
> 
> For 2.6.25 I'll do a proper fix by making sure that every xfrm state 
> user obeys the rule that if x->lock is to be taken with 
> xfrm_state_lock then it must be done from within.

ok, great. I cannot test the revert because i only run distro kernels on 
this box so i can only confirm that the bug is gone once your revert is 
upstream and DaveJ has built a new Fedora kernel for it (which is 1-2 
days after the commit goes upstream). So consider it fixed once you do 
the revert and i'll re-report it if i see any similar assert on a kernel 
that has this commit reverted.

	Ingo
