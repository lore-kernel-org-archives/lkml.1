Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbZLJICn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbZLJICn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbZLJICm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:02:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56338 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760661AbZLJICl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:02:41 -0500
Date: Thu, 10 Dec 2009 09:02:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Memory leak in two error corner cases
Message-ID: <20091210080240.GE25549@elte.hu>
References: <1260380746-4856-1-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260380746-4856-1-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:

> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9841,8 +9841,10 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
>  
>  		se = kzalloc_node(sizeof(struct sched_entity),
>  				  GFP_KERNEL, cpu_to_node(i));
> -		if (!se)
> +		if (!se) {
> +			kfree(cfs_rq);
>  			goto err;
> +		}

would be nice to turn this into a regular pattern of:

		if (!se)
			goto err_kfree;

where err_kfree does the kfree.

Thanks,

	Ingo
