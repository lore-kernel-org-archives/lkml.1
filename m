Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbXIREad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbXIREad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 00:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbXIREaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 00:30:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:50877 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbXIREaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 00:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bTNEsxlc1KQUQbx2D1B19TvJqKm9kwRRr/0A3nJHldOnRsJ+UZS1oIEJKlKOU2+icsIbfZ4lghrkCTSj8uT5mePtmq+sXFCRrAz6xxeZlQDfNRWTASgLkA1DtRm6nZOnLS7EYyqKnTgexhPVdWzejFd1akPAX6hNB1FhQXIIF20=
Message-ID: <6b8cef970709172130v317a6c48h814ef5a1488f798e@mail.gmail.com>
Date: Tue, 18 Sep 2007 00:30:05 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Scheduler benchmarks - a follow-up
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
In-Reply-To: <20070917203607.GA20564@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com>
	 <20070917130524.GA10707@elte.hu> <20070917203607.GA20564@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
> > i've meanwhile tested hackbench 90 and the performance difference
> > between -ck and -cfs-devel seems to be mostly down to the more precise
> > (but slower) sched_clock() introduced in v2.6.23 and to the startup
> > penalty of freshly created tasks.
>
> Rob, another thing i just noticed in your .configs: you have
> CONFIG_PREEMPT=y enabled. Would it be possible to get a testrun with
> that disabled? That gives the best throughput and context-switch latency
> numbers. (CONFIG_PREEMPT might also have preemption artifacts - there's
> one report of it having _worse_ desktop latencies on certain hardware
> than !CONFIG_PREEMPT.)

I reverted the patch from before since it didn't seem to help. Do you
think it may have to do with my system having Hyper-Threading enabled?
I should have pointed out before that I don't really have a dual-core
system, just a P4 with Hyper-Threading (I loosely used core to refer
to processor).

Some new numbers for 2.6.23-rc6-cfs-devel (!CONFIG_PREEMPT and bound
to single processor)

lat_ctx:

15  2.73
16  2.74
17  2.81
18  2.74
19  2.74
20  2.73
21  2.60
22  2.74
23  2.72
24  2.74
25  2.74

hackbench:

80 11.578
81 11.991
82 11.914
83 12.026
84 12.226
85 12.347
86 12.552
87 12.655
88 13.011
89 12.941
90 13.237

pipe-test:

1  9.58
2  9.58
3  9.58
4  9.58
5  9.58
6  9.58
7  9.58
8  9.58
9  9.58
10 9.58

The obligatory graphs:
http://www.healthcarelinen.com/misc/benchmarks/BOUND_NOPREEMPT_lat_ctx_benchmark.png
http://www.healthcarelinen.com/misc/benchmarks/BOUND_NOPREEMPT_hackbench_benchmark.png
http://www.healthcarelinen.com/misc/benchmarks/BOUND_NOPREEMPT_pipe-test_benchmark.png

A cursory glance suggests that performance wrt lat_ctx and hackbench
has increased (lower numbers), but degraded quite a lot for pipe-test.
The numbers for  pipe-test are extremely stable though, while the
numbers for hackbench are more erratic (which isn't saying much since
the original numbers gave nearly a straight line). I'm still willing
to try out any more ideas.

Regards,
Rob
