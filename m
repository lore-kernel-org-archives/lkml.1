Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZHAFmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZHAFmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 01:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZHAFmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 01:42:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38461 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbZHAFmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 01:42:38 -0400
Date: Sat, 1 Aug 2009 07:34:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] cpusets: rework guarantee_online_cpus() to fix
	deadlock with cpu_down()
Message-ID: <20090801053454.GA26596@redhat.com>
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729212216.GB16970@redhat.com> <20090729230043.GA28175@redhat.com> <4A70FD26.1010800@cn.fujitsu.com> <20090730175108.GC3617@redhat.com> <4A725594.8020205@cn.fujitsu.com> <20090801044236.GA23975@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090801044236.GA23975@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for noise, forgot to mention...

On 08/01, Oleg Nesterov wrote:
>
> 	- adds cpuset->cpumask_lock, this lock is taken by
> 	  update_cpumask() around cpumask_copy(cs->cpus_allowed, newcpus).

Most probably there are other places where ->cpus_allowed is changed,
in that case they need ->cpumask_lock too. But this is trivial, the
patch I sent just explains what I meant.

Oleg.

