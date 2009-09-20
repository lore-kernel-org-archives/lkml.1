Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZITSGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZITSGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZITSGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:06:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39048 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbZITSGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:06:49 -0400
Date: Sun, 20 Sep 2009 20:06:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sheng Yang <sheng@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dimitri Sivanich <sivanich@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Don't ack_APIC_irq() if lapic is disabled in
	GENERIC_INTERRUPT_VECTOR handler
Message-ID: <20090920180632.GB8498@elte.hu>
References: <1252403546-12544-1-git-send-email-sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252403546-12544-1-git-send-email-sheng@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1571]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sheng Yang <sheng@linux.intel.com> wrote:

> Otherwise would cause trouble...
> 
> Cc: Dimitri Sivanich <sivanich@sgi.com>
> Signed-off-by: Sheng Yang <sheng@linux.intel.com>
> ---
>  arch/x86/kernel/irq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index b0cdde6..78b23d0 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -257,7 +257,8 @@ void smp_generic_interrupt(struct pt_regs *regs)
>  {
>  	struct pt_regs *old_regs = set_irq_regs(regs);
>  
> -	ack_APIC_irq();
> +	if (!disable_apic)
> +		ack_APIC_irq();

Wont in that case the apic->ack method be a NOP?

	Ingo
