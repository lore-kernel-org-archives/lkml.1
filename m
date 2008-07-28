Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbYG1Swd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbYG1Swd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758995AbYG1SwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:52:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43361 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbYG1SwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:52:15 -0400
Date: Mon, 28 Jul 2008 20:51:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [git pull] cpus4096 fixes
Message-ID: <20080728185134.GA11664@elte.hu>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <200807281042.12860.rusty@rustcorp.com.au> <488E06F0.4070404@sgi.com> <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org> <alpine.LFD.1.10.0807281135060.3486@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807281135060.3486@nehalem.linux-foundation.org>
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

> 
> 
> On Mon, 28 Jul 2008, Linus Torvalds wrote:
> > 
> > Here's a trivial setup, that is even tested. It's _small_ too.
> > 
> > 	/* cpu_bit_bitmap[0] is empty - so we can back into it */
> > 	#define MASK_DECLARE_1(x) [x+1][0] = 1ul << (x)
> > 	#define MASK_DECLARE_2(x) MASK_DECLARE_1(x), MASK_DECLARE_1(x+1)
> > 	#define MASK_DECLARE_4(x) MASK_DECLARE_2(x), MASK_DECLARE_2(x+2)
> > 	#define MASK_DECLARE_8(x) MASK_DECLARE_4(x), MASK_DECLARE_4(x+4)
> > 
> > 	static const unsigned long cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)] = {
> > 		MASK_DECLARE_8(0), MASK_DECLARE_8(8),
> > 		MASK_DECLARE_8(16), MASK_DECLARE_8(24),
> > 	#if BITS_PER_LONG > 32
> > 		MASK_DECLARE_8(32), MASK_DECLARE_8(40),
> > 		MASK_DECLARE_8(48), MASK_DECLARE_8(56),
> > 	#endif
> > 	};
> > 
> > 	static inline const cpumask_t *get_cpu_mask(unsigned int nr)
> > 	{
> > 		const unsigned long *p = cpu_bit_bitmap[1 + nr % BITS_PER_LONG];
> > 		p -= nr / BITS_PER_LONG;
> > 		return (const cpumask_t *)p;
> > 	}
> 
> Btw, Ingo, can we get this issue resolved asap, please?
> 
> I was planning on doing -rc1 today, but this kind of hangs over me. 
> The above three lines of code (and more lines of macro initializers) 
> obviously does need some more testing, but if you hook it into the 
> other changes you already had, maybe we can get it done.
> 
> Hmm?

yeah, i'm on it. If everything goes well hopefully i'll have something 
pullable in 1-2 hours, if that's ok as a timeframe.

	Ingo
