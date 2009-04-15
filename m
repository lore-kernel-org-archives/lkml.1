Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbZDOKRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbZDOKRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbZDOKRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:17:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55784 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZDOKR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:17:29 -0400
Date: Wed, 15 Apr 2009 12:17:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are
	inappropriate or CPU is not supported
Message-ID: <20090415101700.GE6669@elte.hu>
References: <1239725240.2966.4.camel@ht.satnam> <20090414165052.GA2089@elte.hu> <1239728481.2966.21.camel@ht.satnam> <20090414184222.GC11214@elte.hu> <20090414200247.1d0a8667@lxorguk.ukuu.org.uk> <20090414191622.GA797@elte.hu> <1239773665.15436.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239773665.15436.9.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Tue, 2009-04-14 at 21:16 +0200, Ingo Molnar wrote:
> > * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> > > > > Do you still think that boot_cpu_data.x86_vendor is better option in
> > > > > case for multiple CPUs.
> > > > 
> > > > yes. Assymetric SMP never really happened on x86.
> > > 
> > > It did but not between vendors. You can get away with a vendor 
> > > assumption but cpu type (mixed 486SX/DX, PII/PIII/Celeron) mixed 
> > > steppings and mixed speeds do occur. We've never supported the 
> > > mixed 486SX cases but the PII/PIII cases work (or at least 
> > > worked).
> > 
> > yeah - but look at the specific purpose here: we are deciding 
> > whether to print out state information related to major CPU 
> > features. Mixed steppings/speeds might happen, mixed apic / 
> > non-lapic not really.
> > 
> 
> We are trying to debug each CPU, so we should also collect information
> from each CPU.
> 
> Just reading information from boot CPU and display information for 
> all CPU is not correct. If we are getting information from boot 
> CPU then we only need to show information for boot CPU and ignore 
> others.
> 
> I am trying to adding more features which will be unique for each 
> CPU/core.
> 
> So it seems current model is correct where I am collecting 
> information for each CPU and printing information for each CPU.

that's OK - and we have all the per cpu data too.

The main beef i had with your code is that it copies CPU enumeration 
over into some local variables (cpu_modelflag, cpu_model) with 
redundant encodings and decodings which dont fully work.

Is there anything that your encoding/decoding does that cannot be 
done via the standard methods?

Do:

   git grep X86_VENDOR_INTEL arch/x86/

To see existing coding practices that make use of these facilities.

	Ingo
