Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899Ab0A2KEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0A2KEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854Ab0A2KEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:04:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51078 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab0A2KEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:04:43 -0500
Date: Fri, 29 Jan 2010 11:04:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] bitops: Provide compile time HWEIGHT{8,16,32,64}
Message-ID: <20100129100431.GA6513@elte.hu>
References: <20100122155535.797688466@chello.nl>
 <tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>
 <20100129020128.716af8fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129020128.716af8fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 29 Jan 2010 09:28:04 GMT tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > +#define HWEIGHT8(w)			\
> > +      (	(!!((w) & (1ULL << 0))) +	\
> > +	(!!((w) & (1ULL << 1))) +	\
> > +	(!!((w) & (1ULL << 2))) +	\
> > +	(!!((w) & (1ULL << 3))) +	\
> > +	(!!((w) & (1ULL << 4))) +	\
> > +	(!!((w) & (1ULL << 5))) +	\
> > +	(!!((w) & (1ULL << 6))) +	\
> > +	(!!((w) & (1ULL << 7)))	)
> > +
> > +#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8(w >> 8))
> > +#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16(w >> 16))
> > +#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32(w >> 32))
> 
> Would be nice if it had a comment explaining why it exists.  If people
> accidentally use this with non-constant arguments, the generated code
> will be pretty ghastly.
> 
> Or add some barf-if-not-__constant_p() thing, perhaps.

Yeah, agreed.

	Ingo
