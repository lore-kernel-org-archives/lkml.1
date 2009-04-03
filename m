Return-Path: <linux-kernel-owner+w=401wt.eu-S934078AbZDCQVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbZDCQVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936470AbZDCQOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:14:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48888 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936467AbZDCQOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:14:17 -0400
Subject: Re: [PATCH] tracing: fix incorrect return type of ns2usecs() V2
From: Steven Rostedt <srostedt@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49D05D10.4030009@cn.fujitsu.com>
References: <49D041ED.1060007@cn.fujitsu.com>
	 <49D05D10.4030009@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 03 Apr 2009 12:13:52 -0400
Message-Id: <1238775232.3250.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-03-30 at 13:48 +0800, Lai Jiangshan wrote:
> Impact: fix time output bug in 32bits system
> 
> ns2usecs() returns 'long', it's incorrect.
> 
> (In i386)
> # cat trace
> ...
>           <idle>-0     [000]   521.442100: _spin_lock <-tick_do_update_jiffies64
>           <idle>-0     [000]   521.442101: do_timer <-tick_do_update_jiffies64
>           <idle>-0     [000]   521.442102: update_wall_time <-do_timer
>           <idle>-0     [000]   521.442102: update_xtime_cache <-update_wall_time
> ....
> (It always print the time less than 2200 seconds besides ...)
> Because 'long' is 32bits in i386. ( (1<<31) useconds is about 2200 seconds)
> 
> # cat trace
> ...
>           <idle>-0     [001] 4154502640.134759: rcu_bh_qsctr_inc <-__do_softirq
>           <idle>-0     [001] 4154502640.134760: _local_bh_enable <-__do_softirq
>           <idle>-0     [001] 4154502640.134761: idle_cpu <-irq_exit
> ...
> (very large value)
> Because 'long' is a signed type and it is 32bits in i386.
> 
> Changed from V1:
> return 'unsigned long long' instead of 'cycle_t'
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>


Thanks, applied.

-- Steve


