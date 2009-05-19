Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZESJBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZESJBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZESJBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:01:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50903 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017AbZESJA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:00:58 -0400
Date: Tue, 19 May 2009 11:00:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       peterz@infradead.org
Subject: Re: [PATCH] include KERN_* constant in printk calls
Message-ID: <20090519090049.GB9388@elte.hu>
References: <20090518233121.GC3109@chrisubuntu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518233121.GC3109@chrisubuntu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Sanford <crsanford@gmail.com> wrote:

> Add the KERN_CONT constant to two printk calls.
> 
> Signed-off-by: Chris Sanford <crsanford@gmail.com>
> 
> ---
> 
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 26efa47..6a2ed16 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7319,7 +7319,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
>  	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
>  
>  	if (!(sd->flags & SD_LOAD_BALANCE)) {
> -		printk("does not load-balance\n");
> +		printk(KERN_CONT "does not load-balance\n");
>  		if (sd->parent)
>  			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
>  					" has parent");
> @@ -7340,7 +7340,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
>  	printk(KERN_DEBUG "%*s groups:", level + 1, "");
>  	do {
>  		if (!group) {
> -			printk("\n");
> +			printk(KERN_CONT "\n");
>  			printk(KERN_ERR "ERROR: group is NULL\n");
>  			break;

Please use pr_cont() - and while at it, perhaps convert all other 
printk()s in sched.c from KERN_* to the pr_*() notation as well?

Thanks,

	Ingo
