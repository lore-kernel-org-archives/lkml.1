Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbYAGLJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbYAGLJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYAGLJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:09:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50502 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbYAGLJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:09:25 -0500
Date: Mon, 7 Jan 2008 12:09:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jon Masters <jcm@redhat.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] kthread: always create the kernel threads with normal
	priority
Message-ID: <20080107110904.GB28481@elte.hu>
References: <20071217234314.540b59bd@hammerfall> <20071222013021.db2528cb.akpm@linux-foundation.org> <20080107110603.09b72450@brian.englab.brq.redhat.com> <20080107022513.3ac05734.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107022513.3ac05734.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > This causes a practical problem. When a runaway real-time task is 
> > eating 100% CPU and we attempt to put the CPU offline, sometimes we 
> > block while waiting for the creation of the highest-priority 
> > "kstopmachine" thread.

sched-devel.git has new mechanisms against runaway RT tasks. There's a 
new RLIMIT_RTTIME rlimit - if an RT task exceeds that rlimit then it is 
sent SIGXCPU.

there's also a new group scheduling extension that is driven via a 
sysctl:

  /proc/sys/kernel/sched_rt_ratio

this way if a user has a runaway RT task, other users (and root) will 
still have some CPU time left. (in Peter's latest patchset that is 
replaced via rt_runtime_ns - but this is a detail)

so instead of the never-ending arms race of kernel thread priorities 
against RT task priorities, we are going towards making RT tasks safer 
on a policy level.

	Ingo
