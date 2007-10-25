Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXJYT6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXJYT6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbXJYT6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:58:12 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:44769 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbXJYT6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:58:11 -0400
Date: Thu, 25 Oct 2007 15:58:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [PATCH 2/3] RT: Cache cpus_allowed weight for optimizing migration
In-Reply-To: <20071025144628.19876.35583.stgit@novell1.haskins.net>
Message-ID: <Pine.LNX.4.58.0710251556130.5152@gandalf.stny.rr.com>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net>
 <20071025144628.19876.35583.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
> @@ -5371,7 +5372,13 @@ int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
>  		goto out;
>  	}
>
> -	p->cpus_allowed = new_mask;
> +	if (p->sched_class->set_cpus_allowed)
> +		p->sched_class->set_cpus_allowed(p, new_mask);
> +	else {
> +		p->cpus_allowed    = new_mask;
> +		p->nr_cpus_allowed = cpus_weight(new_mask);
> +	}
> +

OK, forget everything I said on this topic. I must have replied while low
on caffeine.

I see here that you do the set_cpus_allowed code if defined _ELSE_ you
just update the weight.

So you do do what I asked.

/me slaps himself to wakeup.

-- Steve

