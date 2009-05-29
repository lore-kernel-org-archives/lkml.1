Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbZE2IVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbZE2IVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZE2IVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:21:34 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57054 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754383AbZE2IVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:21:33 -0400
Date: Fri, 29 May 2009 10:21:30 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Ingo Molnar <mingo@elte.hu>
cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       eranian@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: [perfmon2] comments on Performance Counters for Linux (PCL)
In-Reply-To: <20090529071914.GB3157@elte.hu>
Message-ID: <alpine.LRH.2.00.0905291020200.21748@vixen.sonytel.be>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com> <1243527919.6645.75.camel@laptop> <4A1EFCC2.80805@linux.vnet.ibm.com> <20090528213532.GA8589@elte.hu> <18975.7470.792842.173625@cargo.ozlabs.ibm.com> <20090529071914.GB3157@elte.hu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009, Ingo Molnar wrote:
> * Paul Mackerras <paulus@samba.org> wrote:
> > Ingo Molnar writes:
> > > * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> > > >> So you're suggesting to artificually strech periods by say 
> > > >> composing a single overflow from smaller ones, ignoring the 
> > > >> intermediate overflow events?
> > > >>
> > > >> That sounds doable, again, patch welcome.
> > > >
> > > > I definitely agree with Stephane's point on this one.  I had 
> > > > assumed that long irq_periods (longer than the width of the 
> > > > counter) would be synthesized as you suggest.  If this is not the 
> > > > case, PCL should be changed so that it does, -or- at a minimum, 
> > > > the user should get an error back stating that the period is too 
> > > > long for the hardware counter.
> > > 
> > > this looks somewhat academic - at least on x86, even the fastest 
> > > events (say cycles) with a 32 bit overflow means one event per 
> > > second on 4GB. That's not a significant event count in practice. 
> > > What's the minimum width we are talking about on Power?
> > 
> > 32 bits, but since the top bit is effectively a level-sensitive 
> > interrupt request, the maximum period in hardware is 2^31 counts.
> > 
> > However, I already support 64-bit interrupt periods (well, 63-bit 
> > actually) on powerpc by only calling perf_counter_overflow() when 
> > counter->hw.period_left becomes <= 0, and arranging to set the 
> > hardware counter to 0 if counter->hw.period_left is >= 0x80000000. 
> > It's a tiny amount of code to handle it, really.
> 
> No argument about that - just wanted to know whether there's any 
> real practical effect beyond the nitpicking factor ;-)

I never really dived into this stuff, but ISTR there are some 16-bit counters
on CELL? Is that correct?

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
