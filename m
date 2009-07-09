Return-Path: <linux-kernel-owner+w=401wt.eu-S1760313AbZGIKnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313AbZGIKnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZGIKnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:43:12 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:64754 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbZGIKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:43:12 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/8] Fix rt_rq->pushable_tasks initialization in
 init_rt_rq()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20090615185638.GK21741@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
	 <20090615185638.GK21741@gandalf.sssup.it>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 12:43:04 +0200
Message-Id: <1247136184.9777.364.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 20:56 +0200, Fabio Checconi wrote:
> init_rt_rq() initializes only rq->rt.pushable_tasks, and not the
> pushable_tasks field of the passed rt_rq.  The plist is not used
> uninitialized since the only pushable_tasks plists used are the
> ones of root rt_rqs; anyway reinitializing the list on every group
> creation corrupts the root plist, losing its previous contents.
> 
> Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>

Good catch, I'll queue this up.

> ---
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6032f51..873b252 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9075,7 +9075,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
>  #ifdef CONFIG_SMP
>  	rt_rq->rt_nr_migratory = 0;
>  	rt_rq->overloaded = 0;
> -	plist_head_init(&rq->rt.pushable_tasks, &rq->lock);
> +	plist_head_init(&rt_rq->pushable_tasks, &rq->lock);
>  #endif
>  
>  	rt_rq->rt_time = 0;

