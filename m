Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZI3UWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZI3UWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZI3UWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:22:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55134 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZI3UWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:22:52 -0400
Date: Wed, 30 Sep 2009 22:22:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.32-rc1
Message-ID: <20090930202233.GA21890@elte.hu>
References: <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <20090930193204.GA16350@elte.hu> <4AC3BC89.2050404@gmail.com> <alpine.LFD.2.01.0909301320300.6996@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909301320300.6996@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 30 Sep 2009, Eric Dumazet wrote:
> > > +#define cmpxchg64(ptr, o, n)					\
> > > +({								\
> > > +	__typeof__(*(ptr)) __ret;				\
> > > +	__typeof__(*(ptr)) __old = (o);				\
> > > +	__typeof__(*(ptr)) __new = (n);				\
> > > +	alternative_io("call cmpxchg8b_emu",			\
> > > +			"lock; cmpxchg8b (%%esi)" ,		\
> > > +		       X86_FEATURE_CX8,				\
> > > +		       "=A" (__ret),				\
> > > +		       "S" ((ptr)), "0" (__old),		\
> > > +		       "b" ((unsigned int)__new),		\
> > > +		       "c" ((unsigned int)(__new>>32)));	\
> > 
> > probably a "memory" clobber is needed, alternative_io() doesnt provide it.
> 
> Yeah, good catch.

Yeah - i'm testing this right now, it looks like something that could 
explain the hang.

	Ingo
