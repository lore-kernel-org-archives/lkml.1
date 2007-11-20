Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbXKTL1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbXKTL1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 06:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbXKTL1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 06:27:12 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:49639 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbXKTL1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 06:27:10 -0500
Date: Tue, 20 Nov 2007 16:25:57 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 1/3] cpu-hotplug: Refcount Based Cpu Hotplug
	implementation
Message-ID: <20071120105557.GA2726@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071115134924.GA15282@in.ibm.com> <20071115135108.GA15462@in.ibm.com> <20071115141501.GB28857@elte.hu> <20071115152558.GA22599@elte.hu> <20071115160520.GA3969@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115160520.GA3969@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 05:05:20PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > FYI, i've put these 3 patches into the scheduler git tree and it's 
> > looking very good so far. So unless Andrew or Linus objects to put 
> > this into v2.6.24, or there's serious questions during review, could 
> > we merge it this way?
> 
> i've got this trivial build fix for !SMP - otherwise it's still looking 
> good.
> 

Thanks for this. I had compile tested only for !CONFIG_HOTPLUG_CPU and
missed !CONFIG_SMP.

Regards
gautham.

> 	Ingo
> 
> ------------------>
> Subject: cpu hotplug: fix build on !CONFIG_SMP
> From: Ingo Molnar <mingo@elte.hu>
> 
> fix build on !CONFIG_SMP.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/cpu.h |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> Index: linux/include/linux/cpu.h
> ===================================================================
> --- linux.orig/include/linux/cpu.h
> +++ linux/include/linux/cpu.h
> @@ -71,19 +71,25 @@ static inline void unregister_cpu_notifi
> 
>  int cpu_up(unsigned int cpu);
> 
> +extern void cpu_hotplug_init(void);
> +
>  #else
> 
>  static inline int register_cpu_notifier(struct notifier_block *nb)
>  {
>  	return 0;
>  }
> +
>  static inline void unregister_cpu_notifier(struct notifier_block *nb)
>  {
>  }
> 
> +static inline void cpu_hotplug_init(void)
> +{
> +}
> +
>  #endif /* CONFIG_SMP */
>  extern struct sysdev_class cpu_sysdev_class;
> -extern void cpu_hotplug_init(void);
>  extern void cpu_maps_update_begin(void);
>  extern void cpu_maps_update_done(void);
> 

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
