Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab0CLDOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 22:14:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:50010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab0CLDOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 22:14:14 -0500
Message-ID: <4B99B15B.8060002@kernel.org>
Date: Fri, 12 Mar 2010 12:13:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       dipankar@in.ibm.com, josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       oleg@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCHSET] cpuhog: implement and use cpuhog
References: <1268063603-7425-1-git-send-email-tj@kernel.org> <1268249155.5279.128.camel@twins>
In-Reply-To: <1268249155.5279.128.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Mar 2010 03:13:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On 03/11/2010 04:25 AM, Peter Zijlstra wrote:
> cpuhog as a name doesn't work for me, stop-machine had a name that
> described its severity and impact, cpuhog makes me think of while(1);.
>
> Can't we keep the stop_machine name and make that a workqueue interface
> like you propose?
>
> That way we'd end up with something like:
> 
> kernel/stop_machine.c
>   int stop_cpu(int cpu, stop_fn_t fn, void *arg)
>   int stop_machine(struct cpumask *mask, stop_fn_t fn, void *arg)

The distinction would be diabling of IRQ on each CPU.
hog_[one_]cpu[s]() schedule highest priority task to, well, hog the
cpu but doesn't affect contextless part of the cpu (irq, bh, whatnot).
In that sense, it is the lowest bottom of upper half but not quite
stopping the cpu and I think the distinction is rather important to
make.  With the proposed preemption disabling around the callback, it
pretty much behaves like a complete hog too.

> alternatively, something like schedule_primary_work*() might work I
> guess.

I wanted to avoid verbs associatffed with the traditional workqueue -
schedule and queue, while emphasizing that this is something that you
don't want to abuse - so the verb hog.  monopolize_cpu() was the
second choice but hog is shorter, sweeter and can also be used as a
noun as-is, so I chose hog.

So, those were my rationales.  What do you think?

Thanks.

-- 
tejun
