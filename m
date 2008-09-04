Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYIDQBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYIDQBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYIDQA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:00:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYIDQA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:00:57 -0400
Date: Thu, 4 Sep 2008 18:00:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080904160036.GA18382@elte.hu>
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu> <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 4 Sep 2008, Ingo Molnar wrote:
> > 
> > i've added them to tip/x86/tsc and merged it into tip/master - if 
> > there's test success we can merge it into x86/urgent as well and push it 
> > into v2.6.27. Any objections to that merge route?
> 
> I don't think it's quite that urgent, and wonder what the downside is 
> of just changing the timeout to 10ms. On 32-bit x86, it was 30ms (I 
> think) before the merge, so it sounds like 50ms was a bit excessive 
> even before the whole "loop five times"/
>
> So _short_ term, I'd really prefer (a) looping just three times and 
> (b) looping with a smaller timeout.

ok - sounds very good to me! It's quite late in the cycle so the more 
commits we can delay to v2.6.28 the better IMHO.

> Long-term, I actually think even 10ms is actually a total waste. I'll 
> post my trial "quick calibration" code that is more likely to fail 
> under virtualization or SMM (or, indeed, perhaps even on things like 
> TMTA CPU's that can have longer latencies due to translation), but 
> that is really fast and knows very intimately when it succeeds. I just 
> need to do slightly more testing.

ah - perhaps a dynamic statistical approach with an estimation of 
worst-case calibration error (~= standard deviation) and a quality 
threshold to reach? That could dramatically increase the number of 
samples while also making it much faster in practice. Nifty!

	Ingo
