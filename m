Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbZGCTR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbZGCTR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZGCTRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:17:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48448 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904AbZGCTRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:17:18 -0400
Date: Fri, 3 Jul 2009 21:17:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: atomic64: inline atomic64_read()
Message-ID: <20090703191709.GA17057@elte.hu>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org> <4A4E1AA2.30002@gmail.com> <20090703180450.GB3405@elte.hu> <alpine.LFD.2.01.0907031207030.3210@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907031207030.3210@localhost.localdomain>
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

> On Fri, 3 Jul 2009, Ingo Molnar wrote:
> > > +
> > > +	asm volatile(
> > > +		"mov %%ebx, %%eax\n\t"
> > > +		"mov %%ecx, %%edx\n\t"
> > > +		LOCK_PREFIX "cmpxchg8b %1\n"
> > > +			: "=&A" (res)
> > > +			: "m" (*ptr) 
> > > +		);
> > 
> > That clobbers or affects eax, ebx, ecx, edx. The only registers 
> > it does not clobber is esi, edi and rbp.
> 
> No, it only clobbers eax/edx. Yes, it touches ebx/ecx, but that's 
> kind of incidental, and read-only, and doesn't matter.
> 
> > Linus, what's your preference in this case?
> 
> I think it's kind of subtle to do that thing, but it _is_ very 
> much a special case. It's odd to use a cmpxchg8b to just do a read 
> in the first place, so the fact that we then play other games with 
> it is kind of immaterial.
> 
> Adding a comment about the magic "we don't care about the initial 
> values in eax/edx and ebx/ecx, but they have to match in case we 
> end up doing a writeback" might be a good idea.

Ok - i've applied it and added a comment as well about the reasons 
an subtleties.

	Ingo
