Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbZC3Jzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbZC3Jzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 05:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbZC3Jzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 05:55:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:10081 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbZC3Jzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 05:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PToiSPfQd39MMG2v0rU5iL4ZWZkaXnctA2NSELvuSQBTNsOwjh0UIcIpT7TBZ8DeId
         iZLq5Wn/p7L7YdnMy8pe/qAkJpzEs6WfyMNIKOMyiliPlfb3bmGC7qGaE6/bHlkxWPCH
         wUbluS/hr4ltz6v07t4tK9DcIXEoRMIFkYejo=
Date: Mon, 30 Mar 2009 11:55:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix incorrect return type of ns2usecs()
Message-ID: <20090330095522.GA6058@nowhere>
References: <49D041ED.1060007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D041ED.1060007@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 11:52:13AM +0800, Lai Jiangshan wrote:
> 
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
> Because 'long' is a signed type and is 32bits in i386.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> Tested-by: Lai Jiangshan <laijs@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

