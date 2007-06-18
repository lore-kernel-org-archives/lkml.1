Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbXFRJS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbXFRJS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757425AbXFRJSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:18:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41721 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286AbXFRJSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:18:50 -0400
Date: Mon, 18 Jun 2007 11:18:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, kiran@scalex86.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070618091832.GA1860@elte.hu>
References: <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu> <E1I0CY4-0006lF-00@dorka.pomaz.szeredi.hu> <20070618083109.GA23572@elte.hu> <E1I0ChN-0006nd-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I0ChN-0006nd-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > > This change causes the memory access of the "easy" spin-loop portion 
> > > > to be more agressive: after the REP; NOP we'd not do the 'easy-loop' 
> > > > with a simple CMPB, but we'd re-attempt the atomic op.
> > > 
> > > It looks as if this is going to overflow of the lock counter, no?
> > 
> > hm, what do you mean? There's no lock counter.
> 
> I mean, the repeated calls to decb will pretty soon make lock->slock 
> wrap around.

ugh, indeed, bad thinko on my part. I'll rework this.

	Ingo
