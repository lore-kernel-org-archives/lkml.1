Return-Path: <linux-kernel-owner+w=401wt.eu-S1751730AbZHBCRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbZHBCRu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 22:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZHBCRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 22:17:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65497 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbZHBCRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 22:17:49 -0400
Message-ID: <4A74F767.7060401@cn.fujitsu.com>
Date: Sun, 02 Aug 2009 10:18:15 +0800
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
Subject: Re: [PATCH] cpusets: rework guarantee_online_cpus() to fix deadlock
 with cpu_down()
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729212216.GB16970@redhat.com> <20090729230043.GA28175@redhat.com> <4A70FD26.1010800@cn.fujitsu.com> <20090730175108.GC3617@redhat.com> <4A725594.8020205@cn.fujitsu.com> <20090801044236.GA23975@redhat.com>
In-Reply-To: <20090801044236.GA23975@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:

> 
> 	- do NOT scan cs->parent cpusets. If there are no online CPUs in
> 	  cs->cpus_allowed, we use cpu_online_mask. This is only possible
> 	  when we are called by cpu_down() hooks, in that case
> 	  cpuset_track_online_cpus(CPU_DEAD) will fix things later.
> 


We must scan cs->parent cpusets.
A task is constrained by a cpuset, it must be constrained
this cpuset's parent too.

cpuset_lock() is not awful at all.

Lai.


