Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbYGKNC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbYGKNC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYGKNCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:02:52 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:30289 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYGKNCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:02:51 -0400
Message-Id: <48772221.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 11 Jul 2008 07:04:33 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: <mingo@elte.hu>, <akpm@linux-foundation.org>,
       "David Howells" <dhowells@redhat.com>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix inc_rt_tasks() to not declare variable 'rq' if
	it's notneeded
References: <20080711123454.10475.33099.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080711123454.10475.33099.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Fri, Jul 11, 2008 at  8:34 AM, in message
<20080711123454.10475.33099.stgit@warthog.procyon.org.uk>, David Howells
<dhowells@redhat.com> wrote: 
> Fix inc_rt_tasks() to not declare variable 'rq' if it's not needed.  It is
> declared if CONFIG_SMP or CONFIG_RT_GROUP_SCHED, but only used if 
> CONFIG_SMP.
> 
> This is a consequence of patch 1f11eb6a8bc92536d9e93ead48fa3ffbd1478571 plus
> patch 1100ac91b6af02d8639d518fad5b434b1bf44ed6.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked by: Gregory Haskins <ghaskins@novell.com>

> ---
> 
>  kernel/sched_rt.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index acba8eb..ec19ce5 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -505,7 +505,9 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct 
> rt_rq *rt_rq)
>  	rt_rq->rt_nr_running++;
>  #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
>  	if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
> +#ifdef CONFIG_SMP
>  		struct rq *rq = rq_of_rt_rq(rt_rq);
> +#endif
>  
>  		rt_rq->highest_prio = rt_se_prio(rt_se);
>  #ifdef CONFIG_SMP



