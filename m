Return-Path: <linux-kernel-owner+w=401wt.eu-S933461AbZDHQ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbZDHQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759824AbZDHQ3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:29:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46855 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbZDHQ3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:29:13 -0400
Date: Wed, 8 Apr 2009 18:26:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
	default percpu allocator
Message-ID: <20090408162651.GA14449@elte.hu>
References: <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu> <alpine.DEB.1.10.0904012216370.32656@qirst.com> <20090402034223.GA25791@elte.hu> <alpine.DEB.1.10.0904020948570.31756@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904020948570.31756@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 2 Apr 2009, Ingo Molnar wrote:
> 
> > to quote an earlier part of my mail:
> >
> > > > We encourage kfree(NULL) and it triggers commonly in the 
> > > > kernel today [on distro kernels we checked it can trigger 
> > > > once per syscall!] - so i think we should consider 
> > > > free_percpu(NULL) a possibly common pattern too. (even 
> > > > though today it's likely _not_ common at all.)
> >
> > I specifically mentioned that it is not at all common now.
> 
> What is this? Nonsense day? Consider it a common pattern although 
> its likely not common at all? April fools day?

Dude, this is a new facility freshly modernized and freshly made 
usable. What did you expect, for a thousand usecases pop up in the 
kernel overnight? _None_ of this code is "common" today per se. (the 
networking folks are working on making it more and more common 
though)

> > But there's no reason why an object shutdown fastpath with an 
> > optional percpu buffer (say for debug statistics, not enabled by 
> > default) couldnt look like this:
> >
> > 	percpu_free(NULL);
> >
> > We actually have such patterns of kfree(ptr) use, where the _common_
> > case in a fastpath is kfree(NULL).
> 
> Speculation. A shutdown fastpath? The percpu allocation and free 
> operations are expensive and deal with teardown and setup of 
> virtual mappings. Those paths are *not* optimized for fastpath 
> use. kfree is different.

Of course a lot of this is speculation, dynamic percpu so far has 
been a rarely used facility compared to kmalloc()/kfree(). If you 
dont accept my analogy that's fine - but that is opinion against 
opinion - while you state you opinion as truism.

So my point remains: your patch had effects you clearly did not 
anticipate, and the cacheline alignment management situation is not 
nearly as clear-cut as you imagine it to be.

Unfortunately you failed to answer my detailed mail that made very 
specific points though, you only got into generalities and flames 
about my summary mail - so it's hard to judge what your opinion 
about those specific facts is - you have not stated one.

	Ingo
