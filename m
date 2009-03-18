Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbZCRAKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbZCRAKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 20:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZCRAJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 20:09:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZCRAJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 20:09:47 -0400
Subject: Re: [PATCH 1/2 -tip] sched: Clean unused fields from struct rq
From: Peter Zijlstra <peterz@infradead.org>
To: Luis Henriques <henrix@sapo.pt>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20090318000343.GA2189@hades.domain.com>
References: <20090318000343.GA2189@hades.domain.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 01:09:29 +0100
Message-Id: <1237334969.5189.1242.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 00:03 +0000, Luis Henriques wrote:
> Since they are used on in statistics and are always set to zero, the following
> frields from struct rq have been removed: yld_exp_empty, yld_act_empty and
> yld_both_empty.
> 
> Signed-off-by: Luis Henriques <henrix@sapo.pt>
> ---

> +++ b/kernel/sched_stats.h
> @@ -26,9 +26,8 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  
>  		/* runqueue-specific stats */
>  		seq_printf(seq,
> -		    "cpu%d %u %u %u %u %u %u %u %u %u %llu %llu %lu",
> -		    cpu, rq->yld_both_empty,
> -		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
> +		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
> +		    cpu, rq->yld_count,
>  		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
>  		    rq->ttwu_count, rq->ttwu_local,
>  		    rq->rq_cpu_time,

I think this bit is ABI, so you either have to bump the version number
or emit 0s, iirc gregory touched some of that last -- or at least wrote
userspace for it..

