Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZCYMpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZCYMpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761896AbZCYMpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:45:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37839 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761889AbZCYMpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:45:14 -0400
Date: Wed, 25 Mar 2009 13:45:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: beckyb@kernel.crashing.org, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jeremy@goop.org
Subject: Re: [PATCH 2/5] swiotlb: fix compile warning
Message-ID: <20090325124503.GD30755@elte.hu>
References: <1237930126-6741-3-git-send-email-beckyb@kernel.crashing.org> <20090325114023S.fujita.tomonori@lab.ntt.co.jp> <D375125B-E20E-47D9-87F5-EB9CBE927293@kernel.crashing.org> <20090325125227C.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325125227C.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 24 Mar 2009 22:42:33 -0500
> Becky Bruce <beckyb@kernel.crashing.org> wrote:
> 
> > 
> > On Mar 24, 2009, at 9:58 PM, FUJITA Tomonori wrote:
> > 
> > > On Tue, 24 Mar 2009 16:28:43 -0500
> > > Becky Bruce <beckyb@kernel.crashing.org> wrote:
> > >
> > >> Squash a build warning seen on 32-bit powerpc caused by calling min()
> > >> with 2 different types.  Cast the first arg to size_t, which is the
> > >> type of the second, and should be portable across architectures.
> > >>
> > >> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
> > >> ---
> > >> lib/swiotlb.c |    2 +-
> > >> 1 files changed, 1 insertions(+), 1 deletions(-)
> > >>
> > >> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > >> index f59cf30..62f5f75 100644
> > >> --- a/lib/swiotlb.c
> > >> +++ b/lib/swiotlb.c
> > >> @@ -341,7 +341,7 @@ static void swiotlb_bounce(phys_addr_t phys,  
> > >> char *dma_addr, size_t size,
> > >> 		unsigned long flags;
> > >>
> > >> 		while (size) {
> > >> -			sz = min(PAGE_SIZE - offset, size);
> > >> +			sz = min((size_t)(PAGE_SIZE - offset), size);
> > >>
> > >> 			local_irq_save(flags);
> > >> 			buffer = kmap_atomic(pfn_to_page(pfn),
> > >
> > > ?
> > >
> > > diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > > index f59cf30..fa62498 100644
> > > --- a/lib/swiotlb.c
> > > +++ b/lib/swiotlb.c
> > > @@ -341,7 +341,7 @@ static void swiotlb_bounce(phys_addr_t phys,  
> > > char *dma_addr, size_t size,
> > > 		unsigned long flags;
> > >
> > > 		while (size) {
> > > -			sz = min(PAGE_SIZE - offset, size);
> > > +			sz = min_t(size_t, PAGE_SIZE - offset, size);
> > >
> > > 			local_irq_save(flags);
> > > 			buffer = kmap_atomic(pfn_to_page(pfn),
> > 
> > OK, we're clearly pointed at different trees here, and it looks like  
> > I'm behind - this patch is based on Ingo's master.  Which tree has  
> > this change?
> 
> I also use tip/master. I think that we are on the same page. No 
> tree has this change. I just send it because I'm not sure why you 
> don't use min_t().

yes, min_t() is safer and cleaner than min()+cast.

	Ingo
