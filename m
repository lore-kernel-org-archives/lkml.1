Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYAGRax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYAGRax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYAGRaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:30:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764AbYAGRap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:30:45 -0500
Date: Mon, 7 Jan 2008 09:29:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jon Masters <jcm@redhat.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] kthread: always create the kernel threads with normal
 priority
Message-Id: <20080107092956.419b5f91.akpm@linux-foundation.org>
In-Reply-To: <20080107110904.GB28481@elte.hu>
References: <20071217234314.540b59bd@hammerfall>
	<20071222013021.db2528cb.akpm@linux-foundation.org>
	<20080107110603.09b72450@brian.englab.brq.redhat.com>
	<20080107022513.3ac05734.akpm@linux-foundation.org>
	<20080107110904.GB28481@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 12:09:04 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> > > This causes a practical problem. When a runaway real-time task is 
> > > eating 100% CPU and we attempt to put the CPU offline, sometimes we 
> > > block while waiting for the creation of the highest-priority 
> > > "kstopmachine" thread.
> 
> sched-devel.git has new mechanisms against runaway RT tasks. There's a 
> new RLIMIT_RTTIME rlimit - if an RT task exceeds that rlimit then it is 
> sent SIGXCPU.

Is that "total RT CPU time" or "elapsed time since last schedule()"?

If the former, it is not useful for this problem.

> there's also a new group scheduling extension that is driven via a 
> sysctl:
> 
>   /proc/sys/kernel/sched_rt_ratio
> 
> this way if a user has a runaway RT task, other users (and root) will 
> still have some CPU time left. (in Peter's latest patchset that is 
> replaced via rt_runtime_ns - but this is a detail)

Doesn't this make the RT task non-RT?  Would need to understand more
details to tell.

> so instead of the never-ending arms race of kernel thread priorities 
> against RT task priorities, we are going towards making RT tasks safer 
> on a policy level.
> 
> 	Ingo
