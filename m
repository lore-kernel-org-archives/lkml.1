Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbYKQIvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbYKQIvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYKQIvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:51:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56508 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbYKQIvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:51:11 -0500
Date: Mon, 17 Nov 2008 09:50:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081117085046.GE28786@elte.hu>
References: <20081115112751.1d38c072@infradead.org> <Pine.LNX.4.64.0811152003360.1618@blonde.site> <20081115123916.0d83a89e@infradead.org> <491FACC3.1050202@gmail.com> <20081117081117.GD26778@kernel.dk> <20081117082201.GB24603@elte.hu> <20081117083022.GE26778@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117083022.GE26778@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Nov 17 2008, Ingo Molnar wrote:
> > 
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > +#define kunmap(p)			\
> > > +	do {				\
> > > +		struct page *__p;	\
> > > +		(void) (&__p == &(p));	\
> > > +		__kunmap(p);		\
> > > +	} while (0)
> > > +
> > > +#define kunmap_atomic(a, t)		\
> > > +	do {				\
> > > +		void *__p;		\
> > > +		(void) (&__p == &(a));	\
> > > +		__kunmap_atomic(a, t);	\
> > > +	} while (0)
> > 
> > Agreed - but please use the typecheck() primitive. (linux/typecheck.h)
> 
> Neat, didn't know about that, thanks.

and ack on your patch obviously. Feel free to push it via the block 
tree straight away, it doesnt collide with anything pending in the x86 
tree.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
