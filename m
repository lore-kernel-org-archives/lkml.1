Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab0BYVnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:43:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:50432 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933698Ab0BYVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:43:43 -0500
Subject: Re: [PATCH 1/3] sched: use EDF to schedule groups
From: Peter Zijlstra <peterz@infradead.org>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <4aed689fbdd9a7e4c625d4dd4f85533ec61722ef.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
	 <4aed689fbdd9a7e4c625d4dd4f85533ec61722ef.1266931410.git.fabio@helm.retis>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 21:28:20 +0100
Message-ID: <1267129700.22519.557.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> @@ -36,7 +29,8 @@ static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
>  
>  static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
>  {
> -       return container_of(rt_rq, struct rq, rt);
> +       struct rt_root_rq *rt = container_of(rt_rq, struct rt_root_rq, rt_rq);
> +       return container_of(rt, struct rq, rt);
>  } 

I think you can write that double container_of() as a single:

 return container_of(rt_rq, struct rq, rt.rt_rq);



