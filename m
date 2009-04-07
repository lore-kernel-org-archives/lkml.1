Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZDGN2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZDGN2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbZDGN2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:28:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53253 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbZDGN2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:28:37 -0400
Date: Tue, 7 Apr 2009 15:28:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] x86, perfcounters: add atomic64_xchg()
Message-ID: <20090407132825.GB30984@elte.hu>
References: <20090406094518.445450972@chello.nl> <tip-b226fa12991d6ee9b6b13a7e1de88ec5d25f5007@git.kernel.org> <18907.14029.301492.493938@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18907.14029.301492.493938@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > Complete atomic64_t support on the 32-bit side by adding atomic64_xch().
> > 
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <20090406094518.445450972@chello.nl>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  arch/x86/include/asm/atomic_32.h |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
> > index 977250e..a9fef6c 100644
> > --- a/arch/x86/include/asm/atomic_32.h
> > +++ b/arch/x86/include/asm/atomic_32.h
> > @@ -306,6 +306,12 @@ static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
> >  	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
> >  }
> >  
> > +static inline void
> > +atomic64_xchg(atomic64_t *ptr, unsigned long long new_val)
> > +{
> > +	atomic64_set(ptr, new_val);
> > +}
> 
> Umm, I don't know much about x86, but that doesn't look like an 
> exchange operation to me...  Shouldn't it return a value, for a 
> start?

Yes, indeed :) Fixed it.

/me officially loves commit notifications

	Ingo
