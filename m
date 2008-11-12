Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYKLCur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYKLCur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 21:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYKLCuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 21:50:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64759 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbYKLCug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 21:50:36 -0500
Message-ID: <491A43E0.2080109@cn.fujitsu.com>
Date: Wed, 12 Nov 2008 10:48:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Fabio Checconi <fchecconi@gmail.com>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       paolo.valente@unimore.it, fabio@gandalf.sssup.it,
       Linux Containers <containers@lists.linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/3] BFQ I/O Scheduler (second take)
References: <20081111125148.GD9508@gandalf.sssup.it>
In-Reply-To: <20081111125148.GD9508@gandalf.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Linux Containers <containers@lists.linux-foundation.org>
    Vivek Goyal <vgoyal@redhat.com>

Fabio Checconi wrote:
> Hi Jens, hi all,
> 

Hi Fabio,

>   this is an updated version of the patchset introducing the BFQ (Budget
> Fair Queueing) I/O scheduler.  It is based on CFQ and it has been
> developed trying to improve the predictability and the fairness of the
> service prvided, without penalizing the aggregate throughput.
> 
> This new version hopefully addresses the issues pointed out after the
> first submission[1]:
> 
>   1) it introduces a bitmap to notify priority changes to the bfq/cfq;
>   2) it introduces a timeout to put an higher limit to the time a
>       task can take to consume its budget;
>   3) it supports hierarchical scheduling.
> 

So this is another cgroup-aware block i/o controller. ;)

People are sending different proposals for bio controller. A summary
on this can be found here:
	http://marc.info/?l=linux-kernel&m=121798534716673&w=2

And a new proposal sent by Vivek several days ago:
	http://lkml.org/lkml/2008/11/6/227

And there are some discussions about can we modify the elevator layer
and create a common layer so we can provide group control for all
the 4 io schedulers. (in the above mail thread)

You may share some ideas with us.

> With the introduction of a budget timeout, each task is still assigned
> a budget measured in number of sectors instead of amount of time,
> but a budget is not served to its exhaustion if it's taking too much
> to complete.  Budgets are still scheduled using a modified version
> of WF2Q+.
> 
> Using huge values for max_budget turns the scheduler into a pure
> time-domain proportional share one, and the timeout controls the duration
> of the time quanta.
> 
> WRT the support for hierarchical scheduling, that is being discussed
> so much in these days, this scheduler does not add anything new, it
> supports proportional share distribution of disk bandwidth among
> full cgroup hierarchies; the mapping from requests to cgroups is
> correct only in case of synchronous reads.
> 
> The overall diffstat is the following:
> 
>  block/Kconfig.iosched         |   25 +
>  block/Makefile                |    1 +
>  block/bfq-cgroup.c            |  743 +++++++++++++++
>  block/bfq-ioc.c               |  375 ++++++++
>  block/bfq-iosched.c           | 2010 +++++++++++++++++++++++++++++++++++++++++
>  block/bfq-sched.c             |  950 +++++++++++++++++++
>  block/bfq.h                   |  514 +++++++++++
>  block/blk-ioc.c               |   27 +-
>  block/cfq-iosched.c           |   10 +-
>  fs/ioprio.c                   |    9 +-
>  include/linux/cgroup_subsys.h |    6 +
>  include/linux/iocontext.h     |   18 +-
>  12 files changed, 4669 insertions(+), 19 deletions(-)
> 
> For a complete description of the algorithm and of its properties
> please refer to [2], (where extensive experiments on older hw can
> also be found), and for some performance measurements and implementation
> details, to [3].
> 
> [1] http://lkml.org/lkml/2008/4/1/234
> [2] http://algo.ing.unimo.it/people/paolo/disk_sched/
> [3] http://feanor.sssup.it/~fabio/linux/bfq/
> 
> As usual, any kind of feedback will be greatly appreciated, thanks
> in advance.
> 
> Fabio Checconi, Paolo Valente

