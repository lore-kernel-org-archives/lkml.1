Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYKQIcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYKQIcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYKQIcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:32:09 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46054 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbYKQIcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:32:08 -0500
Date: Mon, 17 Nov 2008 09:30:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081117083022.GE26778@kernel.dk>
References: <20081115112751.1d38c072@infradead.org> <Pine.LNX.4.64.0811152003360.1618@blonde.site> <20081115123916.0d83a89e@infradead.org> <491FACC3.1050202@gmail.com> <20081117081117.GD26778@kernel.dk> <20081117082201.GB24603@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117082201.GB24603@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > +#define kunmap(p)			\
> > +	do {				\
> > +		struct page *__p;	\
> > +		(void) (&__p == &(p));	\
> > +		__kunmap(p);		\
> > +	} while (0)
> > +
> > +#define kunmap_atomic(a, t)		\
> > +	do {				\
> > +		void *__p;		\
> > +		(void) (&__p == &(a));	\
> > +		__kunmap_atomic(a, t);	\
> > +	} while (0)
> 
> Agreed - but please use the typecheck() primitive. (linux/typecheck.h)

Neat, didn't know about that, thanks.

-- 
Jens Axboe

