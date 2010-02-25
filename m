Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172Ab0BYVpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:45:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999Ab0BYVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:43:44 -0500
Subject: Re: [PATCH 2/3] sched: enforce per-cpu utilization limits on
 runtime balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
	 <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 21:28:23 +0100
Message-ID: <1267129703.22519.559.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> +#ifdef CONFIG_SMP
> +static inline unsigned long rt_init_free_bw(void)
> +{
> +       unsigned long used = to_ratio(global_rt_period(), global_rt_runtime());
> +
> +       return to_ratio(RUNTIME_INF, RUNTIME_INF) - used;
> +}
> +#endif

> +static void __rt_restart_balancing(void)
> +{
> +       unsigned long used, global, free;
> +       struct rq *rq;
> +       int i;
> +
> +       used = rt_used_bandwidth();
> +       global = to_ratio(RUNTIME_INF, RUNTIME_INF);
> +
> +       free = global - used;


We take the max as RUNTIME_INF instead of global_rt_* so that we can
move runtime around and fully saturate a single cpu (given there is
enough free to compensate on other cpus) ?

