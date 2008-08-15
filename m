Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYHOLwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYHOLwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYHOLwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:52:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43794 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbYHOLwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:52:07 -0400
Date: Fri, 15 Aug 2008 13:51:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, tglx@linutronix.de,
       hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] x86: apic - unify init_bsp_APIC
Message-ID: <20080815115147.GA32726@elte.hu>
References: <20080814183428.550709025@gmail.com> <20080814184652.475361864@gmail.com> <Pine.LNX.4.55.0808142043150.7213@cliff.in.clinika.pl> <aa79d98a0808142341k6a074c8fh41e44a9f23c14f0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa79d98a0808142341k6a074c8fh41e44a9f23c14f0a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.3 required=5.9 tests=BAYES_00,FRT_LEVITRA autolearn=no SpamAssassin version=3.2.3
	1.8 FRT_LEVITRA            BODY: ReplaceTags: Levitra
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Thu, Aug 14, 2008 at 11:44 PM, Maciej W. Rozycki
> <macro@linux-mips.org> wrote:
> > On Thu, 1 Jan 1970, Cyrill Gorcunov wrote:
> >
> >> @@ -962,7 +962,8 @@ void __init init_bsp_APIC(void)
> >>        */
> >>       apic_write(APIC_LVT0, APIC_DM_EXTINT);
> >>       value = APIC_DM_NMI;
> >> -     if (!lapic_is_integrated())             /* 82489DX */
> >> +     /* discrete on 82489DX */
> >> +     if (!lapic_is_integrated())
> >>               value |= APIC_LVT_LEVEL_TRIGGER;
> >>       apic_write(APIC_LVT1, value);
> >>  }
> >
> >  Please elaborate.
> >
> >  Maciej
> >
> 
> Hi Maciej,
> 
> don't really understand what do you mean. [...]

i suspect the question might have been: 'why this change'.

If that was the question, the answer would be: to unify apic_32.c and 
apic_64.c we first use tiny little changes to bring the two files in 
sync. Presumably, each such change is a NOP or at least very safe - and 
clearly bisectable in the worst-case.

In this case, something that only makes sense on 32-bit has been added 
over to the 64-bit side. The resulting apic.c file will have to have 
legacy code as well - but hopefully not too much.

Cyrill, i've applied your series to tip/x86/apic. (i have fixed the 
timestamps) Please address Maciej's feedback as well, in subsequent 
patches.

	Ingo
