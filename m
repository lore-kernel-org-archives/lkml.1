Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZIIJCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZIIJCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZIIJCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:02:44 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:30561 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZIIJCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:02:43 -0400
X-SourceIP: 213.93.53.227
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1252486344.28645.18.camel@marge.simson.net>
References: <20090906205952.GA6516@elte.hu>
	 <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk>
	 <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk>
	 <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk>
	 <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk>
	 <20090909061308.GA28109@elte.hu>
	 <1252486344.28645.18.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 11:02:34 +0200
Message-Id: <1252486954.7746.173.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 10:52 +0200, Mike Galbraith wrote:
> @@ -1502,7 +1502,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
>          */
>         if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
>                 set_last_buddy(se);
> -       set_next_buddy(pse);
> +       if (sched_feat(NEXT_BUDDY))
> +               set_next_buddy(pse);
>  
>         /*
>          * We can come here with TIF_NEED_RESCHED already set from new task

You might want to test stuff like sysbench again, iirc we went on a
cache-trashing rampage without buddies.

Our goal is not to excel at any one load but to not suck at any one
load.

