Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZHYUDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZHYUDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZHYUDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:03:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbZHYUDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:03:32 -0400
Date: Tue, 25 Aug 2009 22:03:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Execute WP test after interrupts are enabled
Message-ID: <20090825200328.GA21677@elte.hu>
References: <1251227779-24347-1-git-send-email-penberg@cs.helsinki.fi> <4A943CBD.60808@goop.org> <1251229085.25686.2.camel@penberg-laptop> <4A94411E.708@goop.org> <84144f020908251258p71d5ad2fx7d31361c243a698e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020908251258p71d5ad2fx7d31361c243a698e@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, Aug 25, 2009 at 10:53 PM, Jeremy Fitzhardinge<jeremy@goop.org> wrote:
> > On 08/25/09 12:38, Pekka Enberg wrote:
> >> On Tue, 2009-08-25 at 12:34 -0700, Jeremy Fitzhardinge wrote:
> >>
> >>> I don't think this is the real fix, and it seems a bit ugly. ?I'm OK
> >>> with it as a workaround, but I think it will end up getting reverted if
> >>> applied.
> >>>
> >> Yeah, I'm fine with that. It's just that we're really late in the
> >> release cycle now so I'd like to keep the fix as simple as possible.
> >
> > Yeah, that's fine, but I think something like this would be simpler.
> > Arnd, could you test it please?
> >
> > From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Date: Tue, 25 Aug 2009 12:47:17 -0700
> > Subject: [PATCH] xen: suppress WP test
> >
> > Xen always runs on CPUs which properly support WP enforcement in
> > privileged mode, so there's no need to test for it.
> >
> > This also works around a crash reported by Arnd Hannemann, though
> > I think its just a band-aid for that case.
> >
> > Reported-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> >
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 16d0d70..e5b903b 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -1069,6 +1069,7 @@ asmlinkage void __init xen_start_kernel(void)
> > ? ? ? ?/* set up basic CPUID stuff */
> > ? ? ? ?cpu_detect(&new_cpu_data);
> > ? ? ? ?new_cpu_data.hard_math = 1;
> > + ? ? ? new_cpu_data.wp_works_ok = 1;
> > ? ? ? ?new_cpu_data.x86_capability[0] = cpuid_edx(1);
> > ?#endif
> 
> Yeah, this is even better assuming it works. :-)
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

yeah, we should do this one for .31.

	Ingo
