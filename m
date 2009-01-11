Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbZAKOym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbZAKOym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZAKOya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:54:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46530 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbZAKOy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:54:29 -0500
Date: Sun, 11 Jan 2009 15:54:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparseirq: make some func to be used with genirq
Message-ID: <20090111145406.GB13453@elte.hu>
References: <496534B1.6080902@kernel.org> <20090108120619.GF1539@elte.hu> <1231435078.3178.278.camel@calx> <20090111034646.GA28520@elte.hu> <20090111042857.GA7195@elte.hu> <4969AF5E.7020809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4969AF5E.7020809@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > Yinghai, the crossbuild to Alpha fails with:
> > 
> > /home/mingo/tip/kernel/fork.c: In function 'copy_signal':
> > /home/mingo/tip/kernel/fork.c:825: warning: unused variable 'ret'
> > /home/mingo/tip/drivers/char/random.c: In function 'get_timer_rand_state':
> > /home/mingo/tip/drivers/char/random.c:584: error: dereferencing pointer to incomplete type
> > /home/mingo/tip/drivers/char/random.c: In function 'set_timer_rand_state':
> > /home/mingo/tip/drivers/char/random.c:594: error: dereferencing pointer to incomplete type
> > make[3]: *** [drivers/char/random.o] Error 1
> > 
> 
> please check
> 
> [PATCH] sparseirq: fix compiling with unknown irq_desc struct
> 
> Impact: fix compiling
> 
> irq_desc is defined in linux/irq.h
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> diff --git a/include/linux/random.h b/include/linux/random.h
> index 407ea36..a27bf17 100644
> --- a/include/linux/random.h
> +++ b/include/linux/random.h
> @@ -10,6 +10,10 @@
>  #include <linux/ioctl.h>
>  #include <linux/irqnr.h>
>  
> +#ifdef CONFIG_GENERIC_HARDIRQS
> +#include <linux/irq.h>
> +#endif

applied to tip/irq/sparseirq, thanks Yinghai!

	Ingo
