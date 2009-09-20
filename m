Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZITSVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZITSVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZITSVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:21:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33240 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbZITSVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:21:39 -0400
Date: Sun, 20 Sep 2009 20:21:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Sheng Yang <sheng@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Dimitri Sivanich <sivanich@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Don't ack_APIC_irq() if lapic is disabled in
	GENERIC_INTERRUPT_VECTOR handler
Message-ID: <20090920182124.GD8498@elte.hu>
References: <1252403546-12544-1-git-send-email-sheng@linux.intel.com> <20090920180632.GB8498@elte.hu> <20090920181326.GB32176@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920181326.GB32176@lenovo>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Ingo Molnar - Sun, Sep 20, 2009 at 08:06:32PM +0200]
> | 
> | * Sheng Yang <sheng@linux.intel.com> wrote:
> | 
> | > Otherwise would cause trouble...
> | > 
> | > Cc: Dimitri Sivanich <sivanich@sgi.com>
> | > Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> | > ---
> | >  arch/x86/kernel/irq.c |    3 ++-
> | >  1 files changed, 2 insertions(+), 1 deletions(-)
> | > 
> | > diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> | > index b0cdde6..78b23d0 100644
> | > --- a/arch/x86/kernel/irq.c
> | > +++ b/arch/x86/kernel/irq.c
> | > @@ -257,7 +257,8 @@ void smp_generic_interrupt(struct pt_regs *regs)
> | >  {
> | >  	struct pt_regs *old_regs = set_irq_regs(regs);
> | >  
> | > -	ack_APIC_irq();
> | > +	if (!disable_apic)
> | > +		ack_APIC_irq();
> | 
> | Wont in that case the apic->ack method be a NOP?
> | 
> | 	Ingo
> | 
> 
> iirc it was Xen related patch. So it's not that simple.
> 
> I've pointed out Sheng about disable_apic. I'm not Xen
> specialist but Xen team seem to use specific apic setup
> so our "dummy" operations are not involved (case they
> set disable_apic=1 without "turn off" apic ops in real).
> Something like that.

They should then set a NOP function in that case. We really dont want to 
slow down hotpath functions like smp_generic_interrupt() with flaggery.

	Ingo
