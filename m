Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZHBTvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZHBTvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZHBTvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:51:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47466 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZHBTu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:50:59 -0400
Date: Sun, 2 Aug 2009 21:50:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Anton Blanchard <anton@samba.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, benh@kernel.crashing.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, paulus@samba.org,
       williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090802195043.GD24486@elte.hu>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> <20090802194454.GC28572@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802194454.GC28572@bombadil.infradead.org>
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


* Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Sun, Aug 02, 2009 at 08:41:48PM +0200, Ingo Molnar wrote:
> > Could we somehow define a weak symbol for those library functions 
> > ourselves and thus just fall back to that (which does nothing) 
> > instead of failing the link?
> > 
> 
> Well, you could just dlopen the object, but that's kind of 
> gross...

hm, why is it gross? I think it's a nicely plug-and-play tooling 
solution - instead of some obscure make flag.

Since we define the prototype anyway:

> +static inline char *bfd_demangle(void __used *v, const char __used *c,
> +				int __used i) {
> +	return NULL;
> +}

We are sticking to a given version of the API. We could turn that 
into a function pointer and fill it in during startup via dlopen(). 
If it's NULL then we dont call it and assume a value of NULL.

Mind submitting such a version of your fix? It would nicely decrease 
the build requirements cross section surface of perf.

	Ingo
