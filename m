Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbXJLGrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbXJLGrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXJLGrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:47:10 -0400
Received: from mx10.go2.pl ([193.17.41.74]:58163 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759877AbXJLGrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:47:08 -0400
Date: Fri, 12 Oct 2007 08:49:27 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <npiggin@suse.de>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
Message-ID: <20071012064927.GA1962@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470EA277.7090107@bigpond.net.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-10-2007 00:23, Peter Williams wrote:
...
> The reason I was going that route was for modularity (which helps when 
> adding plugsched patches).  I'll submit a revised patch for consideration.
...

IMHO, it looks like modularity could suck here:

> +static unsigned int default_timeslice_fair(struct task_struct *p)
> +{
> +	return NS_TO_JIFFIES(sysctl_sched_min_granularity);
> +}

If it's needed for outside and sched_fair will use something else
(to avoid double conversion) this could be misleading. Shouldn't
this be kind of private and return something usable for the class
mainly? Why anything else than sched_fair should care about this?

Regards,
Jarek P.
