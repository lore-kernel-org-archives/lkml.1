Return-Path: <linux-kernel-owner+w=401wt.eu-S1762100AbYDUOWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762100AbYDUOWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbYDUOWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:22:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60591 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453AbYDUOW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:22:29 -0400
Date: Mon, 21 Apr 2008 16:22:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: spinlock ops are always-inlined
Message-ID: <20080421142217.GT9554@elte.hu>
References: <200804181847.m3IIlLPr032254@hera.kernel.org> <20080418143110.c8e596c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418143110.c8e596c8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 18 Apr 2008 18:47:21 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7fda20f146d5d217684ffbc37c6b6c5f82c2dffd
> > Commit:     7fda20f146d5d217684ffbc37c6b6c5f82c2dffd
> > Parent:     d93c870bad38e8daaaf9f7e900a13431f24becbb
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Fri Feb 29 10:29:38 2008 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu Apr 17 17:41:29 2008 +0200
> > 
> >     x86: spinlock ops are always-inlined
> >     
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  include/asm-x86/spinlock.h |   12 ++++++------
> >  1 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/asm-x86/spinlock.h b/include/asm-x86/spinlock.h
> > index 47dfe26..bc6376f 100644
> > --- a/include/asm-x86/spinlock.h
> > +++ b/include/asm-x86/spinlock.h
> > @@ -78,7 +78,7 @@ static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
> >  	return (((tmp >> 8) & 0xff) - (tmp & 0xff)) > 1;
> >  }
> >  
> > -static inline void __raw_spin_lock(raw_spinlock_t *lock)
> > +static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)
> 
> What was the reason for making this change?

has no effect on current kernels (which always inline), but it breaks 
with an upcoming feature, CONFIG_OPTIMIZE_INLINING=y that lets gcc 
decide whether to inline or not. (should have mentioned this in the 
changelog, sorry)

	Ingo
