Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYAHJzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYAHJzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYAHJzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:55:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYAHJzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:55:22 -0500
Date: Tue, 8 Jan 2008 10:54:28 +0100
From: Michal Schmidt <mschmidt@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jon Masters <jcm@redhat.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] kthread: always create the kernel threads with normal
 priority
Message-ID: <20080108105428.2fb04bdd@brian.englab.brq.redhat.com>
In-Reply-To: <20080107092956.419b5f91.akpm@linux-foundation.org>
References: <20071217234314.540b59bd@hammerfall>
	<20071222013021.db2528cb.akpm@linux-foundation.org>
	<20080107110603.09b72450@brian.englab.brq.redhat.com>
	<20080107022513.3ac05734.akpm@linux-foundation.org>
	<20080107110904.GB28481@elte.hu>
	<20080107092956.419b5f91.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 09:29:56 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 7 Jan 2008 12:09:04 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > > > This causes a practical problem. When a runaway real-time task
> > > > is eating 100% CPU and we attempt to put the CPU offline,
> > > > sometimes we block while waiting for the creation of the
> > > > highest-priority "kstopmachine" thread.
> > 
> > sched-devel.git has new mechanisms against runaway RT tasks.
> > There's a new RLIMIT_RTTIME rlimit - if an RT task exceeds that
> > rlimit then it is sent SIGXCPU.
> 
> Is that "total RT CPU time" or "elapsed time since last schedule()"?
> 
> If the former, it is not useful for this problem.

It's "runtime since last sleep" so it is useful.

I still think the kthread patch is good to have anyway. The user can
have other reasons to change kthreadd's priority/cpumask.

Michal
