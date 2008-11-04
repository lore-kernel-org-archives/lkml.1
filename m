Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbYKDRVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbYKDRVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYKDRVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:21:34 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:56989 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbYKDRVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:21:33 -0500
Date: Tue, 4 Nov 2008 09:20:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bharata@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
 controller
Message-Id: <20081104092040.781f9546.randy.dunlap@oracle.com>
In-Reply-To: <20081104124937.GB4898@in.ibm.com>
References: <20081024050830.GA4387@in.ibm.com>
	<6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com>
	<20081025060157.GA4614@in.ibm.com>
	<6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com>
	<20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com>
	<20081027044319.GA4386@in.ibm.com>
	<661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com>
	<49057ADD.1050705@cn.fujitsu.com>
	<20081030171622.GA19872@linux.vnet.ibm.com>
	<20081031094041.194a32d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20081104124937.GB4898@in.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 18:19:37 +0530 Bharata B Rao wrote:

> Add hierarchical accounting to cpu accounting controller and cpuacct
> documentation.
> 
> Currently, while charging the task's cputime to its accounting group,
> the accounting group hierarchy isn't updated. This patch charges the cputime
> of a task to its accounting group and all its parent accounting groups.
> 
> Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Reviewed-by: Paul Menage <menage@google.com>
> ---
>  Documentation/controllers/cpuacct.txt |   32 ++++++++++++++++++++++++++++++++
>  kernel/sched.c                        |   10 ++++++++--
>  2 files changed, 40 insertions(+), 2 deletions(-)
> 
> --- /dev/null
> +++ b/Documentation/controllers/cpuacct.txt
> @@ -0,0 +1,32 @@
> +CPU Accounting Controller
> +-------------------------
> +
> +The CPU accounting controller is used to group tasks using cgroups and
> +account the CPU usage of these group of tasks.
> +
> +The CPU accounting controller supports multi-hierarchy groups. An accounting
> +group accumulates the CPU usage of all of it's child groups and

                                             its  {it's means "it is"}

> +the tasks directly present in it's group.

                                 its

> +
> +Accounting groups can be created by first mounting the cgroup filesystem.
> +
> +# mkdir /cgroups
> +# mount -t cgroup -ocpuacct none /cgroups
> +
> +With the above step, the initial or the parent accounting group
> +becomes visible at /cgroups. At bootup, this group comprises of all the

   "comprises of all" seems awkward to me.  Maybe "includes all" or
   "comprises all" if you have to use that word.  ;)

> +tasks in the system. /cgroups/tasks lists the tasks in this cgroup.
> +/cgroups/cpuacct.usage gives the CPU time (in nanoseconds) obtained by
> +this group which is essentially the CPU time obtained by all the tasks
> +in the system.
> +
> +New accounting groups can be created under the parent group /cgroups.
> +
> +# cd /cgroups
> +# mkdir g1
> +# echo $$ > g1
> +
> +The above steps create a new group g1 and move the current shell
> +process (bash) into it. CPU time consumed by this bash and it's children

                                                              its

> +can be obtained from g1/cpuacct.usage and the same gets accumulated in

                                                      is accumulated in

> +/cgroups/cpuacct.usage also.



> Performance numbers
> ==================
> 2x2HT=4CPU i386 running 2.6.28-rc3
> 
> All benchmarks were run from bash which belonged to the grand

                                                          grandchild (?)
Otherwise it says that the "child group" is "grand."
Oh, never mind.  I thought that this was part of a doc file, but it's not.


> child group of the topmost accounting group. The tests were
> first run on 2628rc3 and then on 2628rc3+this patch and the
> normalized difference between the two runs is shown below.
> 
> I. hackbench
> ============
> # ./hackbench 100 process 100
> Running with 100*40 (== 4000) tasks.
> Normalized time difference for avg of 5 runs: 1.0059
> 
> # ./hackbench 25 thread 100
> Running with 25*40 (== 1000) tasks.
> Normalized time difference for avg of 5 runs: 1.0139
> 
> II. lmbench
> ===========
> ---------------------
> 4 threads
> ---------------------
> size	Normalized
> (kb)	Change (Time)
> ---------------------
> 16	1.1017
> 64	1.1168
> 128	1.1072
> 256	1.0085
> --------------------
> 8 threads
> -------------------
> 16	1.1835
> 64	1.0617
> 128	0.9980
> 256	0.9682
> -------------------
> 16 threads
> -------------------
> 16	1.1186
> 64	0.9921
> 128	0.9505
> 256	1.0043
> -------------------
> 32 threads
> -------------------
> 16	1.0005
> 64	1.0089
> 128	1.0019
> 256	1.0226
> -------------------
> 64 threads
> -------------------
> 16	1.0207
> 64	1.0385
> 128	1.0109
> 256	1.0159
> -------------------
> 
> III. volanomark
> ===============
> Normalized average throughput difference for loopback test
> 
> ------------------------------------------------------------
> Nr runs		Normalized average throughput difference
> ------------------------------------------------------------
> 10		0.9579
> ------------------------------------------------------------
> 4		1.1465
> ------------------------------------------------------------
> 9		0.9451
> ------------------------------------------------------------
> 19		1.0133
> ------------------------------------------------------------
> --


---
~Randy
