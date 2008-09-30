Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYI3Kji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYI3Kji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYI3Kja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:39:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYI3Kj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:39:29 -0400
Date: Tue, 30 Sep 2008 12:39:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 0/4] futex: get_user_pages_fast() for shared futexes
Message-ID: <20080930103906.GF7557@elte.hu>
References: <20080926173219.885155151@twins.programming.kicks-ass.net> <20080927161712.GA1525@elte.hu> <200809301721.52148.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809301721.52148.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Sunday 28 September 2008 02:17, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > Since get_user_pages_fast() made it in, I thought to give this another
> > > try. Lightly tested by disabling the private futexes and running some
> > > java proglets.
> >
> > hm, very interesting. Since this is an important futex usecase i started
> > testing it in tip/core/futexes:
> >
> >  cd33272: futex: cleanup fshared
> >  a135356: futex: use fast_gup()
> >  39ce77b: futex: reduce mmap_sem usage
> >  0d7a336: futex: rely on get_user_pages() for shared futexes
> >
> > Nick, it would be nice to get an Acked-by/Reviewed-by from you, before
> > we think about whether it should go upstream.
> 
> Yeah, these all look pretty good. It's nice to get rid of mmap sem here.
> 
> Which reminds me, we need to put a might_lock mmap_sem into
> get_user_pages_fast...
> 
> But these patches look good to me (last time we discussed them I thought
> there was a race with page truncate, but it looks like you've closed that
> by holding page lock over the whole operation...)
> 
> Nice work, Peter.

great - i've added your Acked-by to the patches and have activated the 
tip/core/futexes branch for tip/auto-core-next linux-next integration.

here are the commits:

 42569c3: futex: fixup get_futex_key() for private futexes
 c2f9f20: futex: cleanup fshared
 734b05b: futex: use fast_gup()
 6127070: futex: reduce mmap_sem usage
 38d47c1: futex: rely on get_user_pages() for shared futexes

Thanks,

	Ingo
