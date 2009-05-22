Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZEVOKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZEVOKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZEVOK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:10:28 -0400
Received: from www.tglx.de ([62.245.132.106]:52951 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbZEVOK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:10:28 -0400
Date: Fri, 22 May 2009 16:08:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend4 1/3] itimers: merge ITIMER_VIRT and ITIMER_PROF
 common code
In-Reply-To: <20090522154331.3e6f5ca3@dhcp-lab-109.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.0905221600210.3570@localhost.localdomain>
References: <20090522154331.3e6f5ca3@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw,

On Fri, 22 May 2009, Stanislaw Gruszka wrote:
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -790,10 +790,10 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
>  	thread_group_cputime_init(sig);
>  
>  	/* Expiration times and increments. */
> -	sig->it_virt_expires = cputime_zero;
> -	sig->it_virt_incr = cputime_zero;
> -	sig->it_prof_expires = cputime_zero;
> -	sig->it_prof_incr = cputime_zero;
> +	sig->it[0].expires = cputime_zero;
> +	sig->it[0].incr = cputime_zero;
> +	sig->it[1].expires = cputime_zero;
> +	sig->it[1].incr = cputime_zero;

  Nit, can we please use CPUCLOCK_PROF/VIRT instead of 0/1 ?
  
Thanks,

	tglx
