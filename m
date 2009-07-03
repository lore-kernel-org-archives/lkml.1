Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbZGCSoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbZGCSoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbZGCSoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:44:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbZGCSoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:44:02 -0400
Date: Fri, 3 Jul 2009 20:43:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: atomic64: inline atomic64_read()
Message-ID: <20090703184353.GB4085@elte.hu>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org> <4A4E1AA2.30002@gmail.com> <20090703180450.GB3405@elte.hu> <20090703111033.6e9627de@infradead.org> <20090703181815.GC3405@elte.hu> <20090703113002.6c2c103b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703113002.6c2c103b@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Fri, 3 Jul 2009 20:18:15 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > > On Fri, 3 Jul 2009 20:04:50 +0200
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > > +static inline u64 atomic64_read(atomic64_t *ptr)
> > > > > +{
> > > > > +	u64 res;
> > > > > +
> > > > > +	asm volatile(
> > > > > +		"mov %%ebx, %%eax\n\t"
> > > > > +		"mov %%ecx, %%edx\n\t"
> > > > > +		LOCK_PREFIX "cmpxchg8b %1\n"
> > > 
> > > also afaik cmpxchg implies the lock prefix, so no need to make an
> > > explicit one... it just adds code size and alternatives-work
> > 
> > good point!
> > 
> > Is the same true of XADD as well? If yes then we can remove the lock 
> > prefix from those as well - there's a few uses of that on 32-bit and 
> > 64-bit as well.
> > 
> 
> ok never mind I was wrong,
> it seems cmpxchg does NOT imply a lock prefix, nor does xadd.

Indeed, i just checked the SDM and the lock prefix is not implicit.

Ignore the patch i sent out ;-)

	Ingo
