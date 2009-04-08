Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbZDHJwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbZDHJwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757494AbZDHJwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:52:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:41138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbZDHJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:52:05 -0400
Subject: Re: [PATCH]kernel/sched_fair.c: the comment of the
 calc_delta_fair() maybe not correctly
From: Peter Zijlstra <peterz@infradead.org>
To: "figo.zhang" <figo.zhang@kolorific.com>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net
In-Reply-To: <20090408022723.22EC7F50054@mail.kolorific.com>
References: <20090407063306.64659F50054@mail.kolorific.com>
	 <20090407165736.GI12226@hack>
	 <20090408022723.22EC7F50054@mail.kolorific.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Apr 2009 11:53:45 +0200
Message-Id: <1239184425.24828.1373.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 10:27 +0800, figo.zhang wrote:
> the comment of the calc_delta_fair() maybe not correctly, should be
> delta *= NICE_0_LOAD/se->load
> 
> Signed-off-by: figo.zhang <figo.zhang@kolorific.com>
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 3816f21..5134b45 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -386,7 +386,7 @@ int sched_nr_latency_handler(struct ctl_table
> *table, int write, #endif
>  
>  /*
> - * delta /= w
> + * delta *= NICE_0_LOAD/se->load
>   */
>  static inline unsigned long
>  calc_delta_fair(unsigned long delta, struct sched_entity *se)

The comment is conceptually correct.

NICE_0_LOAD := 1 and se->load := w, ergo, delta /= w.


