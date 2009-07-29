Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbZG2XEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbZG2XEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 19:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZG2XEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 19:04:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41518 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbZG2XEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 19:04:33 -0400
Date: Thu, 30 Jul 2009 01:00:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] cpusets: fix deadlock with cpu_down()->cpuset_lock()
Message-ID: <20090729230043.GA28175@redhat.com>
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729212216.GB16970@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729212216.GB16970@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Oleg Nesterov wrote:
>
> I strongly believe the bug does exist, but this patch needs the review
> from maintainers.

Yes...

> IOW, with this patch migration_call(CPU_DEAD) runs without callback_mutex,
> but kernel/cpuset.c always takes get_online_cpus() before callback_mutex.

Oh. I'm afraid this is not an option.

callback_mutex should nest under cgroup_mutex, but cpu hotplu pathes
take cgroup_mutex under cpu_hotplug->lock. Lockdep won't be happy.

Oleg.

