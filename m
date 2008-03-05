Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYCENy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYCENy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYCENx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:53:59 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:59963 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbYCENx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:53:57 -0500
Date: Wed, 5 Mar 2008 16:53:14 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Yi Yang <yi.y.yang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are dealocked when cpu is set to offline
Message-ID: <20080305135314.GA84@tv-sign.ru>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <20080303153154.GA11288@in.ibm.com> <1204555505.3842.4.camel@yangyi-dev.bj.intel.com> <20080304052613.GA28632@in.ibm.com> <20080304150107.GA564@tv-sign.ru> <20080305100509.GA9265@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305100509.GA9265@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Gautham R Shenoy wrote:
>
> On Tue, Mar 04, 2008 at 06:01:07PM +0300, Oleg Nesterov wrote:
> > On 03/04, Gautham R Shenoy wrote:
> > >
> > > So at times, the callback thread is blocked on kthread_stop(k) in
> > > softlockup.c, while other time, it was blocked in
> > > cleanup_workqueue_threads() in workqueue.c. 
> > 
> > >From another message:
> > >
> > > However, it remains in R< state
> > 
> > What about cwq->thread? Was it TASK_RUNNING too?
> 
> No, it was in TASK_UNINTERRUPTIBLE state. The last thing it ever
> executed was the wait_for_completion in flush_cpu_workqueue()

You misunderstood ;) The task doing _cpu_down() hang in flush_cpu_workqueue(),
because cwq->thread doesn't want to die. But what was cwq->thread->state?

Could you try the patch? Yi constantly sees the tasks in R< state.
I am starting to suspect some scheduling issue.

Oleg.

