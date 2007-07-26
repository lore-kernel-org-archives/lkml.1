Return-Path: <linux-kernel-owner+w=401wt.eu-S935664AbXGZSaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935664AbXGZSaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765544AbXGZSai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:30:38 -0400
Received: from mail.screens.ru ([213.234.233.54]:59071 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbXGZSah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:30:37 -0400
Date: Thu, 26 Jul 2007 22:30:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] make schedule_on_each_cpu() look like on_each_cpu()
Message-ID: <20070726183058.GA246@tv-sign.ru>
References: <1185448139.8197.78.camel@twins> <20070726182727.GA173@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726182727.GA173@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26, Oleg Nesterov wrote:
>
> On 07/26, Peter Zijlstra wrote:
> >
> > -int schedule_on_each_cpu(work_func_t func)
> > +int schedule_on_each_cpu(void (*func)(void *info), void *info, int retry, int wait)
> >  {
> >  	int cpu;
> > -	struct work_struct *works;
> > +	struct schedule_on_each_cpu_work **works;
> > +	int err = 0;
> >  
> > -	works = alloc_percpu(struct work_struct);
> > +	works = kzalloc(sizeof(void *)*nr_cpu_ids, GFP_KERNEL);
> 
> Not a comment, but a question: why do we need nr_cpu_ids at all?
> num_possible_cpus() looks more "correct" if cpu_possible_map has
> holes (not sure this can happen in practice).

OOPS, I am stupid, please ignore. Of course, we need the highest CPU
number, not num_possible_cpus().

Oleg.

