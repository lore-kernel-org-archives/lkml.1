Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYLZJSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYLZJSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYLZJSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:18:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbYLZJSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:18:42 -0500
Date: Fri, 26 Dec 2008 10:18:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2 -tip] irq: kstat_incr_irqs_this_cpu only needs one
	parameter
Message-ID: <20081226091822.GE27747@elte.hu>
References: <4954A02E.3030207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4954A02E.3030207@cn.fujitsu.com>
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


* Wang Chen <wangchen@cn.fujitsu.com> wrote:

> desc is useless for kstat_incr_irqs_this_cpu.
> 
> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
> ---
>  arch/x86/kernel/visws_quirks.c |    2 +-
>  arch/x86/xen/spinlock.c        |    2 +-
>  include/linux/kernel_stat.h    |    3 +--
>  kernel/irq/chip.c              |   10 +++++-----
>  kernel/irq/handle.c            |    4 ++--
>  5 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
> index 0c9667f..bd37460 100644
> --- a/arch/x86/kernel/visws_quirks.c
> +++ b/arch/x86/kernel/visws_quirks.c
> @@ -633,7 +633,7 @@ static irqreturn_t piix4_master_intr(int irq, void *dev_id)
>  	/*
>  	 * handle this 'virtual interrupt' as a Cobalt one now.
>  	 */
> -	kstat_incr_irqs_this_cpu(realirq, desc);
> +	kstat_incr_irqs_this_cpu(realirq);
>  
>  	if (likely(desc->action != NULL))
>  		handle_IRQ_event(realirq, desc->action);

'desc' is needed in the sparseirq model:

#define kstat_incr_irqs_this_cpu(irqno, DESC) \
        ((DESC)->kstat_irqs[smp_processor_id()]++)

See:

 http://people.redhat.com/mingo/tip.git/README

	Ingo
