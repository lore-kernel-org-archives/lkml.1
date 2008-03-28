Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbYC1Upy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbYC1Upy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYC1Upr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:45:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912AbYC1Upq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:45:46 -0400
Date: Fri, 28 Mar 2008 21:45:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] x86_64: Support for new UV apic
Message-ID: <20080328204533.GC7159@elte.hu>
References: <20080328191216.GA16455@sgi.com> <20080328201532.GB26555@elte.hu> <20080328202430.GA13040@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328202430.GA13040@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> On Fri, Mar 28, 2008 at 09:15:32PM +0100, Ingo Molnar wrote:
> > 
> > * Jack Steiner <steiner@sgi.com> wrote:
> > 
> > > Index: linux/arch/x86/kernel/apic_64.c
> > > ===================================================================
> > > --- linux.orig/arch/x86/kernel/apic_64.c	2008-03-28 13:00:22.000000000 -0500
> > > +++ linux/arch/x86/kernel/apic_64.c	2008-03-28 13:06:12.000000000 -0500
> > > @@ -738,6 +738,7 @@ void __cpuinit setup_local_APIC(void)
> > >  	unsigned int value;
> > >  	int i, j;
> > >  
> > > +	preempt_disable();
> > >  	value = apic_read(APIC_LVR);
> > >  
> > >  	BUILD_BUG_ON((SPURIOUS_APIC_VECTOR & 0x0f) != 0x0f);
> > > @@ -831,6 +832,7 @@ void __cpuinit setup_local_APIC(void)
> > >  	else
> > >  		value = APIC_DM_NMI | APIC_LVT_MASKED;
> > >  	apic_write(APIC_LVT1, value);
> > > +	preempt_enable();
> > >  }
> > 
> > hm, this looks a bit weird - why are all the preempt-disable/enable 
> > calls needed?
> 
> The first patch had a preempt disable/enable in the function that 
> reads apicid (see read_apic_id() in arch/x86/kernel/genapic_64.c). 
> This seemed necessary since large system generate an apicid by reading 
> the live id & concatenating it with extra bits.
> 
> One of the review comments suggested that I change the preempt to a 
> WARN() since reading apic_id really should be done with preemtion 
> disabled. The added code eliminates the warnings.

could you post the stacktraces of the warnings as they occured? All 
those codepaths should be running with preemption disabled in some 
natural way.

	Ingo
