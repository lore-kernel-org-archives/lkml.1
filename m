Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0CCVtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:49:09 -0500
Received: from mail.openrapids.net ([64.15.138.104]:54982 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756696Ab0CCVs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:48:59 -0500
Date: Wed, 3 Mar 2010 16:48:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip] x86: Issue at least one memory barrier in
	stop_machine_text_poke().
Message-ID: <20100303214856.GA26640@Krystal>
References: <20100303213614.GA29880@Krystal> <20100303214847.26177.98280.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303214847.26177.98280.stgit@localhost6.localdomain6>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:48:18 up 40 days, 25 min,  6 users,  load average: 0.39, 0.51,
	0.66
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Fix stop_machine_text_poke() to issue smp_mb() before exiting waiting
> loop, and use cpu_relax() for waiting.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jason Baron <jbaron@redhat.com>
> ---
> 
>  arch/x86/kernel/alternative.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 635e4f4..3a4bf35 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -597,8 +597,8 @@ static int __kprobes stop_machine_text_poke(void *data)
>  		wrote_text = 1;
>  	} else {
>  		while (!wrote_text)
> -			smp_rmb();
> -		sync_core();
> +			cpu_relax();
> +		smp_mb();	/* Load wrote_text before following execution */
>  	}
>  
>  	flush_icache_range((unsigned long)tpp->addr,
> 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
