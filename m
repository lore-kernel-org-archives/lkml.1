Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbXIRJp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbXIRJp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbXIRJpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:45:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:58501 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbXIRJpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OOU3i6TAIlrjHierQVo9YTEQbNGv//AENnT7zAARbAzYpoWbW3LMAjIShkwIySQlyJXumMWo/drAKxCy6Mxihm5YqLQz4N0fKnXPm+odmDe39BC443zZhtaDj0ISVi6r39kny1QDosHcC031sqtk2kEV4UZA54jIRpU59p5dMZ4=
Message-ID: <6b8cef970709180245r86d370q2b1a92a29128f2e@mail.gmail.com>
Date: Tue, 18 Sep 2007 05:45:15 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Scheduler benchmarks - a follow-up
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
In-Reply-To: <20070918084825.GA25803@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com>
	 <20070917130524.GA10707@elte.hu> <20070917203607.GA20564@elte.hu>
	 <6b8cef970709172130v317a6c48h814ef5a1488f798e@mail.gmail.com>
	 <20070918084825.GA25803@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rob Hussey <robjhussey@gmail.com> wrote:
>
> > The obligatory graphs:
> > http://www.healthcarelinen.com/misc/benchmarks/BOUND_NOPREEMPT_lat_ctx_benchmark.png
> > http://www.healthcarelinen.com/misc/benchmarks/BOUND_NOPREEMPT_hackbench_benchmark.png
> > http://www.healthcarelinen.com/misc/benchmarks/BOUND_NOPREEMPT_pipe-test_benchmark.png
>
> btw., it's likely that if you turn off CONFIG_PREEMPT for .21 and for
> .22-ck1 they'll improve a bit too - so it's not fair to put the .23
> !PREEMPT numbers on the graph as the PREEMPT numbers of the other
> kernels. (it shows the .23 scheduler being faster than it really is)
>

The graphs are really just to show where the new numbers fit in. Plus,
I was too lazy to run all the numbers again.

> > A cursory glance suggests that performance wrt lat_ctx and hackbench
> > has increased (lower numbers), but degraded quite a lot for pipe-test.
> > The numbers for pipe-test are extremely stable though, while the
> > numbers for hackbench are more erratic (which isn't saying much since
> > the original numbers gave nearly a straight line). I'm still willing
> > to try out any more ideas.
>
> the pipe-test behavior looks like an outlier. !PREEMPT only removes code
> (which makes the code faster), so this could be a cache layout artifact.
> (or perhaps we preempt at a different point which is disadvantageous to
> caching?) Pipe-test is equivalent to "lat_ctx -s 0 2" so if there was a
> genuine slowdown it would show up in the lat_ctx graph - but the graph
> shows a speedup.
>

Interestingly, every set of lat_ctx -s 0 2 numbers I run on the
!PREEMPT kernel are on average higher than with PREEMPT (around 2.84
for !PREEMPT and 2.4 for PREEMPT). Anything higher than around 2 or 3
(such as lat_ctx -s 0 8) gives lower average numbers for !PREEMPT.

Regards,
Rob
