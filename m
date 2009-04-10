Return-Path: <linux-kernel-owner+w=401wt.eu-S937771AbZDJOAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937771AbZDJOAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 10:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZDJOAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 10:00:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35491 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZDJOAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 10:00:30 -0400
Date: Fri, 10 Apr 2009 16:00:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [RFC -tip] x86: do_IRQ - send APIC EOI for x86-32 on irq
	without handler v3
Message-ID: <20090410140023.GA29090@elte.hu>
References: <20090409181802.GC7558@lenovo> <20090410122750.GR21506@elte.hu> <20090410135606.GA8204@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410135606.GA8204@lenovo>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Ingo Molnar - Fri, Apr 10, 2009 at 02:27:50PM +0200]
> | 
> | * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> | 
> | > Ingo, I've checked the sources and as far as I see
> | > we could NOP'ify apic->write indeed but I have
> | > an internal feeling that this will bring us more problem
> | > in future (for example it could be the following scenario:
> | > some screwed APIC would require cleaning of LVT's or
> | > IRR after resume regardless if it was initialized
> | > or not at all). Mostly I mean that the idea of making
> | > apic->write NOP'ified is quite elegant indeed but
> | > cut off the subset of apic operations (we need
> | > apic->read anyway) somehow bothering me from inside :)
> | 
> | it's as if assigned a special type of 'dummy apic' struct apic. It 
> | wont cause problems down the line: we use the new APIC driver 
> | infrastructure to abstract out quirks.
> 
> Well, it's not that new actually :-)

Yeah, i mean the new unified/modernized code in 2.6.30-to-be.

> | 
> | one small detail:
> | 
> | > +/* Ack APIC irq if it's enabled only */
> | > +static inline void ack_APIC_irq_safe(void)
> | > +{
> | > +#ifdef CONFIG_X86_LOCAL_APIC
> | > +	if (cpu_has_apic)
> | > +		ack_APIC_irq();
> | > +#endif
> | 
> | we dont need the cpu_has_apic check there, do we? In the 
> | !cpu_has_apic the ->write method should be a dummy.
> 
> Yes. In case you're talking about it'll not be needed
> (we will find earlier whether cpu_has_apic or not).

yeah.

	Ingo
