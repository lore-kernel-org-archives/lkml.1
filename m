Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbZANLSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbZANLSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZANLSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:18:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33871 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbZANLSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:18:08 -0500
Date: Wed, 14 Jan 2009 12:17:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make 32bit MAX_HARDIRQSS_PER_CPU to be NR_VECTORS
Message-ID: <20090114111755.GN2913@elte.hu>
References: <496B9FF3.3080909@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496B9FF3.3080909@kernel.org>
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

> Impact: clean up to be same as 64bit
> 
> 32bit is use per-cpu vector too, so don't use default NR_IRQS
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/hardirq_32.h  |    3 +++
>  arch/x86/include/asm/irq_vectors.h |    4 ++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/hardirq_32.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/hardirq_32.h
> +++ linux-2.6/arch/x86/include/asm/hardirq_32.h
> @@ -20,6 +20,9 @@ typedef struct {
>  
>  DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
>  
> +/* We can have at most NR_VECTORS irqs routed to a cpu at a time */
> +#define MAX_HARDIRQS_PER_CPU NR_VECTORS
> +
>  #define __ARCH_IRQ_STAT
>  #define __IRQ_STAT(cpu, member) (per_cpu(irq_stat, cpu).member)

applied to tip/x86/cleanups. Btw., isnt the irq_vectors.h bit (mentioned 
in the diffstat) missing?

	Ingo
