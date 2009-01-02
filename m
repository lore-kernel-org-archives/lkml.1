Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbZABWWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbZABWWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 17:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbZABWWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 17:22:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbZABWWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 17:22:32 -0500
Date: Fri, 2 Jan 2009 23:21:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [sparseirq] remove debug printks (io_apic.c)
Message-ID: <20090102222148.GG17240@elte.hu>
References: <20081225160741.GA14486@elte.hu> <20081231120043.GA2419@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231120043.GA2419@gentoox2.trippelsdorf.de>
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


* Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On Thu, Dec 25, 2008 at 05:07:41PM +0100, Ingo Molnar wrote:
> > 
> > Please pull the latest irq-core-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus
> > 
> > Most of the changes here are related to enable and implement sparseirq 
> > support on x86.
> 
> > Yinghai Lu (10):
> >       sparse irq_desc[] array: core kernel and x86 changes
> >       x86: use NR_IRQS_LEGACY
> >       x86: MSI start irq numbering from nr_irqs_gsi
> >       x86, MSI: pass irq_cfg and irq_desc
> >       sparseirq: fix Alpha build failure
> >       sparseirq: fix !SMP && !PCI_MSI && !HT_IRQ build
> >       x86, sparseirq: move irq_desc according to smp_affinity, v7
> >       sparseirq: fix !SMP building, #2
> >       sparseirq: add kernel-doc notation for new member in irq_desc, -v2
> >       sparseirq: fix numa_migrate_irq_desc dependency and comments
> 
> The message "alloc irq_2_pin on cpu 0 node 0" is printed way too often.
> 
> % dmesg|grep irq_2_pin|wc -l
> 20
> 
> Get rid of the debug printks.
> 
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> ---
>  arch/x86/kernel/io_apic.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
> index f6ea94b..66f97b2 100644
> --- a/arch/x86/kernel/io_apic.c
> +++ b/arch/x86/kernel/io_apic.c
> @@ -129,7 +129,6 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int cpu)
>  	node = cpu_to_node(cpu);
>  
>  	pin = kzalloc_node(sizeof(*pin), GFP_ATOMIC, node);
> -	printk(KERN_DEBUG "  alloc irq_2_pin on cpu %d node %d\n", cpu, node);
>  
>  	return pin;
>  }
> @@ -207,7 +206,6 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
>  	node = cpu_to_node(cpu);
>  
>  	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
> -	printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
>  
>  	return cfg;

Agreed, those are not needed - i've applied your patch to tip/x86/urgent, 
thanks!

	Ingo
