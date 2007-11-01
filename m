Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbXKADez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbXKADez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 23:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbXKADer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 23:34:47 -0400
Received: from xenotime.net ([66.160.160.81]:35186 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752477AbXKADeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 23:34:46 -0400
Date: Wed, 31 Oct 2007 20:34:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] kvm: fix !SMP build error
Message-Id: <20071031203442.7e161692.rdunlap@xenotime.net>
In-Reply-To: <20071024181107.GA15250@elte.hu>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
	<20071023223640.EADF31F81AC@havoc.gtf.org>
	<20071023224455.GY30533@stusta.de>
	<471E79E2.2090204@garzik.org>
	<471F03F5.7090608@qumranet.com>
	<20071024123258.GA28653@elte.hu>
	<20071024123650.GA31562@elte.hu>
	<20071024181107.GA15250@elte.hu>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 20:11:07 +0200 Ingo Molnar wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > i have triggered this and fixed it the right way - see the patch 
> > > below. This fixes the 2.6.24-rc1 build error.
> > 
> > and this followup patch is needed too if my patch is applied.
> 
> plus the patch below is needed too in addition.
> 
> 	Ingo

Hi,
I'm still hitting this build error.  Are these 3 patches not yet
merged??

Thanks.

> ------------->
> Subject: x86: fix build error in arch/x86/kernel/nmi_32.c
> From: Ingo Molnar <mingo@elte.hu>
> 
> nmi_cpu_busy() must be available on !SMP too.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/nmi_32.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86/kernel/nmi_32.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/nmi_32.c
> +++ linux/arch/x86/kernel/nmi_32.c
> @@ -53,13 +53,13 @@ static int unknown_nmi_panic_callback(st
>  
>  static int endflag __initdata = 0;
>  
> -#ifdef CONFIG_SMP
>  /* The performance counters used by NMI_LOCAL_APIC don't trigger when
>   * the CPU is idle. To make sure the NMI watchdog really ticks on all
>   * CPUs during the test make them busy.
>   */
>  static __init void nmi_cpu_busy(void *data)
>  {
> +#ifdef CONFIG_SMP
>  	local_irq_enable_in_hardirq();
>  	/* Intentionally don't use cpu_relax here. This is
>  	   to make sure that the performance counter really ticks,
> @@ -69,8 +69,8 @@ static __init void nmi_cpu_busy(void *da
>  	   care if they get somewhat less cycles. */
>  	while (endflag == 0)
>  		mb();
> -}
>  #endif
> +}
>  
>  static int __init check_nmi_watchdog(void)
>  {
> -

---
~Randy
