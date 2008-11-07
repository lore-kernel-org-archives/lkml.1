Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYKGI62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYKGI62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYKGI6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:58:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44561 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYKGI6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:58:19 -0500
Date: Fri, 7 Nov 2008 09:57:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Message-ID: <20081107085746.GB27245@elte.hu>
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <200811021229.16061.rusty@rustcorp.com.au> <alpine.LFD.2.00.0811011834360.3483@nehalem.linux-foundation.org> <200811070949.02914.rusty@rustcorp.com.au> <20081107084016.GF4435@elte.hu> <20081107005229.53d6f2e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107005229.53d6f2e3.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > +#if NR_CPUS == 1
> > +/* Uniprocesor. */

btw: s/Uniprocesor/Uniprocessor

> > +#define cpumask_first(src)		({ (void)(src); 0; })
> >
> > ...
> >
> > +#else
> > +static inline unsigned int cpumask_first(const struct cpumask *srcp)
> > +{
> > +	return find_first_bit(cpumask_bits(srcp), nr_cpumask_bits);
> > +}
> >
> > ...
> >
> > +#endif /* SMP */
> 
> So I can happily compile and run
> 
> 	cpumask_first("hello, world");
> 
> with CONFIG_SMP=n?

yeah, you are right that the use of a macro sucks there, it should be 
an inline function.

We should stop using CPP, which is the outdated tech of the sixties. 
We should go with the new wave of the seventies and use this shiny new 
"C" language that's all the rage with features like type checking and 
stuff.

	Ingo
