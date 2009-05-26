Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZEZGwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZEZGwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 02:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZEZGwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 02:52:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38124 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZEZGwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 02:52:14 -0400
Date: Tue, 26 May 2009 08:44:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH resend4 2/3] itimers: fix periodic tics precision
Message-ID: <20090526084455.672c652f@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20090525145132.03915e19@dhcp-lab-109.englab.brq.redhat.com>
References: <20090522154339.06d30f0a@dhcp-lab-109.englab.brq.redhat.com>
	<alpine.LFD.2.00.0905221611380.3570@localhost.localdomain>
	<20090525132814.442877e5@dhcp-lab-109.englab.brq.redhat.com>
	<alpine.LFD.2.00.0905251423490.3582@localhost.localdomain>
	<20090525145132.03915e19@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009 14:51:32 +0200
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Mon, 25 May 2009 14:32:14 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Mon, 25 May 2009, Stanislaw Gruszka wrote:
> > > @@ -904,6 +905,7 @@ void __init time_init(void)
> > >  	tb_ticks_per_usec = ppc_tb_freq / 1000000;
> > >  	tb_to_us = mulhwu_scale_factor(ppc_tb_freq, 1000000);
> > >  	calc_cputime_factors();
> > > +	cputime_one = jiffies_to_cputime(1);
> > 
> >   1) The variable name is misleading.
> 
> What about cputime_one_jiffy ?
> 
> >   2) The patch breaks all powerpc platforms which have
> >   CONFIG_VIRT_CPU_ACCOUNTING=n and ia64 with
> >   CONFIG_VIRT_CPU_ACCOUNTING=y
> 
> Stupid me, in asm-generic/cputime.h should be 
> #define cputime_one jiffies_to_cputime(1)

Hmmm, I'm confused. Perhaps I missed something, but I think patch was ok.
For powerpc and ia64 and CONFIG_VIRT_CPU_ACCOUNTING=n definitions from
asm-generic/cputime.h where used. In this file was:

#define cputime_one (1UL) 

and that correct as jiffies_to_cputime(x) is just (x)

For CONFIG_VIRT_CPU_ACCOUTING=y:
- For powerpc additional variable was  declared and computed in
  initialization  time. Declaration of was in __KERENEL__ scope.
- For ia64: cputime_one was defined as jiffies_to_cputime(1)

Anyway I didn't try to even compile the patch on other architectures than x86.
Of cource I will test my patch, but first I would like to know what You think?
Does we really need such optimization (because before usage of
jiffies_to_cputime(1) was just fine) ?

Cheers
Stanislaw
