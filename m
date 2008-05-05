Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYEEH6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYEEH6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYEEH6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:58:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbYEEH6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:58:38 -0400
Date: Mon, 5 May 2008 09:58:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, samuel@sortiz.org, dtor_core@ameritech.net
Subject: Re: [patch] irda: fix !PNP support in drivers/net/irda/nsc-ircc.c
Message-ID: <20080505075823.GA9299@elte.hu>
References: <20080503193222.GA23373@elte.hu> <20080505.005003.69528106.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505.005003.69528106.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 3 May 2008 21:32:23 +0200
> 
> > 
> > x86.git testing found the following build failure in latest -git:
> > 
> >  drivers/built-in.o: In function `nsc_ircc_pnp_probe':
> >  nsc-ircc.c:(.text+0xdf1b6): undefined reference to `pnp_get_resource'
> >  nsc-ircc.c:(.text+0xdf1d4): undefined reference to `pnp_get_resource'
> >  nsc-ircc.c:(.text+0xdf1ee): undefined reference to `pnp_get_resource'
> >  nsc-ircc.c:(.text+0xdf237): undefined reference to `pnp_get_resource'
> >  nsc-ircc.c:(.text+0xdf24c): undefined reference to `pnp_get_resource'
> >  drivers/built-in.o:nsc-ircc.c:(.text+0xdf266): more undefined references to `pnp_get_resource' follow
> >  make: *** [.tmp_vmlinux1] Error 1
> 
> I feel there is a better way to fix this and the other IRDA pnp build 
> failure.
> 
> linux/pnp.h provides erroring inlines when PNP is disabled, but it 
> does not provide a full set.  In order to be fully consistent it 
> should provide similar stub implementations for things like 
> pnp_get_flags() (which is what triggers the reference to 
> pnp_get_resource here), for example.
> 
> Either the whole API is provided with stubs when PNP is disabled, or 
> none should be.  If only some interfaces get the treatment, we get 
> messy ifdefs such as those seen in these patches we are discussing.

i just used the existing precedent of doing the #ifdef: it's not _that_ 
bad as it surrounds a single function most of the time so it's rather 
apparent what is happening - and that is what is done in some other 
drivers as well.

btw., when i fixed this i almost implemented it the way that you 
suggested, but there's also a code size argument to when the suspend 
callbacks are not used: the extra dummy function takes up text space, 
and people turn off PNP when they build some specialized thing and try 
to reduce the size of the kernel.

but in any case, i have no strong feelings in either direction.

	Ingo
