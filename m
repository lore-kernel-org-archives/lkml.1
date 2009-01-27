Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbZA0NWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbZA0NWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZA0NVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:21:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbZA0NVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:21:47 -0500
Date: Tue, 27 Jan 2009 14:21:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 #tj-percpu] x86: fix build breakage on voyage
Message-ID: <20090127132141.GA17286@elte.hu>
References: <20090126103243.GA31307@elte.hu> <1232977445-11815-1-git-send-email-brgerst@gmail.com> <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org> <497E8778.9060503@gmail.com> <1233032609.3248.78.camel@localhost.localdomain> <497E9B9D.4010102@gmail.com> <20090127113734.GA28249@elte.hu> <497EF43D.9010303@gmail.com> <20090127131108.GE23121@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127131108.GE23121@elte.hu>
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

> 
> * Tejun Heo <htejun@gmail.com> wrote:
> 
> > Hello, Ingo.
> > 
> > Ingo Molnar wrote:
> > >> +#ifdef CONFIG_X86_LOCAL_APIC
> > >>  	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
> > >>  	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
> > >> +#endif
> > > 
> > > That patch is not acceptable - it is ugly and it adds another set of
> > > #ifdefs to an already complex piece of code.
> > 
> > Well, although the patch itself does add #ifdef, if you look over the 
> > whole series, voyager is now a much more conforming citizen in the x86 
> > world.  There are several solutions to this particular one.
> > 
> > 1. Just let apic stuff defined and not use it in voyager if the ifdef
> >    is disturbing.  IIUC, apic isn't used in voyager at all, right?
> > 
> > 2. Clean up early percpu stuff so that it each early percpu variable
> >    doesn't need to be explicitly copied and cleared, which is the
> >    actual problem here.
> > 
> > 3. But, then again, the current interim and ugly way of doing it isn't
> >    too bad considering the small number of early per cpu users.
> > 
> > To me the current form doesn't look too bad but if it's too ugly, maybe 
> > doing #2 is not such a bad idea such that early percpu can be 
> > transferred to percpu in more systematic way.  It still feels a bit like 
> > overdoing it tho.
> > 
> > What do you think?
> 
> This issue might be minor, but it's the death of a thousand cuts. It 
> should switch to the generic x86 code, use smp_ops to wrap/express its 
> own SMP weirdnesses [and extend it where needed - because _that_ is a 
> step forward for the whole code - fixing build bugs isnt] and then such 
> problems simply wont occur.

btw., i have pulled it to not hold up the flow, but this is the absolutely 
last warning for Voyager to get fixed. There's perhaps two Voyager systems 
left in existence running mainline kernels (both owned by James) while the 
code you are hacking on code that affects tens of millions of Linux boxes.

Every minute you waste on thinking about Voyager build issues has a 
multiplier effect of 1:1000,000. Voyager needs to be isolated into 
arch/x86/kernel/voyager_quirks.c and that's it.

	Ingo
