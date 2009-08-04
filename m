Return-Path: <linux-kernel-owner+w=401wt.eu-S932656AbZHDHfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbZHDHfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 03:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932509AbZHDHfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 03:35:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63163 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932519AbZHDHfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:35:31 -0400
Message-ID: <4A77E4D0.20900@cn.fujitsu.com>
Date: Tue, 04 Aug 2009 15:35:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] cpusets: rework guarantee_online_cpus() to fix	deadlock
 with cpu_down()
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729212216.GB16970@redhat.com> <20090729230043.GA28175@redhat.com> <4A70FD26.1010800@cn.fujitsu.com> <20090730175108.GC3617@redhat.com> <4A725594.8020205@cn.fujitsu.com> <20090801044236.GA23975@redhat.com> <4A74F767.7060401@cn.fujitsu.com> <20090802065504.GA27164@redhat.com>
In-Reply-To: <20090802065504.GA27164@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 08/02, Lai Jiangshan wrote:
>> Oleg Nesterov wrote:
>>
>>> 	- do NOT scan cs->parent cpusets. If there are no online CPUs in
>>> 	  cs->cpus_allowed, we use cpu_online_mask. This is only possible
>>> 	  when we are called by cpu_down() hooks, in that case
>>> 	  cpuset_track_online_cpus(CPU_DEAD) will fix things later.
>>>
>>
>> We must scan cs->parent cpusets.
>> A task is constrained by a cpuset,
> 
> Yes, the task esacpes its cpuset. With or without this patch.
> Because cs->cpus_allowed has no online CPUs.
> 
>> it must be constrained
>> this cpuset's parent too.
> 
> It will be constained again, after scan_for_empty_cpusets(), no?

cpuset_cpus_allowed() is not only  used for CPU offline.

sched_setaffinity() also uses it. The task will not be constained again.
Or I missed something.

Lai

