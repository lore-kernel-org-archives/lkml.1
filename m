Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbZCKNNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbZCKNNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbZCKNNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:13:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbZCKNN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:13:29 -0400
Date: Wed, 11 Mar 2009 14:13:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
Message-ID: <20090311131321.GC1074@elte.hu>
References: <1236684201.3301.11.camel@localhost.localdomain> <20090310122806.GE5794@elte.hu> <1236697752.3387.2.camel@localhost.localdomain> <20090310152029.GN3850@elte.hu> <1236701373.3387.4.camel@localhost.localdomain> <20090310174535.GA2963@elte.hu> <1236772478.2836.12.camel@ht.satnam> <1236775518.2836.14.camel@ht.satnam> <20090311125049.GA1074@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311125049.GA1074@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > @@ -472,7 +473,7 @@ static void print_dt(void *seq)
> >  	print_desc_ptr("GDT", seq, dt);
> >  
> >  	/* LDT */
> > -	store_ldt(ldt);
> > +	asm volatile("sldt %0" : "=m" (ldt));
> 
> this is still wrong.

As i pointed it out before, we should not open-code an assembly 
primitive - especially since store_ldt() is available in 
arch/x86/include/asm/desc.h.

True, that primitive is not available on CONFIG_PARAVIRT, but 
that is a bug: the fix is to move the store_ldt() definition 
outside the CONFIG_PARAVIRT section in desc.h, not to hack 
around the problem by open-coding assembly code.

I.e. dont let an uncleanliness and incomplete primitive spread 
to other code. Fix the primitive and remove the uncleanliness 
that way.

	Ingo
