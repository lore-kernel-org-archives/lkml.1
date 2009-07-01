Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZGAIVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZGAIVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZGAIVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:21:37 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61356 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZGAIVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:21:35 -0400
Date: Wed, 01 Jul 2009 17:21:24 +0900 (JST)
Message-Id: <20090701.172124.1021993079596910082.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20090701073139.GA12073@elte.hu>
References: <20090701.152115.706994265076015808.mitake@dcl.info.waseda.ac.jp>
	<20090701073139.GA12073@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Date: Wed, 1 Jul 2009 09:31:39 +0200

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > Hi,
> > 
> > I wrote a test patch which add information of counts processes 
> > acquired how many spinlocks to schedstat. After applied this 
> > patch, /proc/<PID>/sched will change like this,
> > 
> > init (1, #threads: 1)
> > ---------------------------------------------------------
> > se.exec_start                      :        482130.851458
> > se.vruntime                        :         26883.107980
> > se.sum_exec_runtime                :          2316.651816
> > se.avg_overlap                     :             0.480053
> > se.avg_wakeup                      :            14.999993
> > ....
> > se.nr_wakeups_passive              :                    1
> > se.nr_wakeups_idle                 :                    0
> > se.nr_acquired_spinlock            :                74483
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Looks potentially useful - but it would be nice and go one step 
> further and add lock acquire stats as a software-counter.
> 
> Perfcounters is a feature of the latest upstream kernel, there's a 
> (still very small) Wiki page about it at:
> 
>    http://perf.wiki.kernel.org
> 

Thanks for your information.
I've never heard about this. This is a useful software for me.

> Now, it would be nice to have a lock-acquire software-counter as 
> well, which would output things like:
> 
>   $ perf stat -a -e lock-acquires sleep 1
> 
>   Performance counter stats for 'sleep 1':
> 
>           294387  lock-acquires
> 
>      1.022318527  seconds time elapsed
> 
> Furthermore, beyond plain counts, doing this would also allow the 
> profiling of lock acquire places: perf record -e lock-acquires and 
> perf report would work fine.
> 
> It is really easy to add a new sw counter, check how it is done for 
> the pagefault counter(s), see the uses of PERF_COUNT_SW_PAGE_FAULTS 
> in the following files:
> 
>   $ git grep -l PERF_COUNT_SW_PAGE_FAULTS
> 
>   arch/powerpc/mm/fault.c
>   arch/x86/mm/fault.c
>   include/linux/perf_counter.h
>   kernel/perf_counter.c
>   tools/perf/builtin-stat.c
>   tools/perf/design.txt
> 
> Would you be interested in having a look at this?

Of course, I want to do this!
If I got progress, I'll send a patch to you.
