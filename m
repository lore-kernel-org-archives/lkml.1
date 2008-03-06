Return-Path: <linux-kernel-owner+w=401wt.eu-S1765962AbYCFLPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765962AbYCFLPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758950AbYCFLPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:15:30 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:59361 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912AbYCFLP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:15:29 -0500
Date: Thu, 6 Mar 2008 16:45:25 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Yi Yang <yi.y.yang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
Message-ID: <20080306111525.GA23865@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <20080303153154.GA11288@in.ibm.com> <1204555505.3842.4.camel@yangyi-dev.bj.intel.com> <20080304052613.GA28632@in.ibm.com> <20080304150107.GA564@tv-sign.ru> <20080305100509.GA9265@in.ibm.com> <20080305135314.GA84@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305135314.GA84@tv-sign.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 04:53:14PM +0300, Oleg Nesterov wrote:
> On 03/05, Gautham R Shenoy wrote:
> >
> > On Tue, Mar 04, 2008 at 06:01:07PM +0300, Oleg Nesterov wrote:
> > > On 03/04, Gautham R Shenoy wrote:
> > > >
> > > > So at times, the callback thread is blocked on kthread_stop(k) in
> > > > softlockup.c, while other time, it was blocked in
> > > > cleanup_workqueue_threads() in workqueue.c. 
> > > 
> > > >From another message:
> > > >
> > > > However, it remains in R< state
> > > 
> > > What about cwq->thread? Was it TASK_RUNNING too?
> > 
> > No, it was in TASK_UNINTERRUPTIBLE state. The last thing it ever
> > executed was the wait_for_completion in flush_cpu_workqueue()
> 
> You misunderstood ;) The task doing _cpu_down() hang in flush_cpu_workqueue(),
> because cwq->thread doesn't want to die. But what was cwq->thread->state?
> 

Yup, sorry for that stupid reply.

> Could you try the patch? Yi constantly sees the tasks in R< state.
> I am starting to suspect some scheduling issue.

Me too. With your patch applied there were quite a few tasks in the
running state which didn't get the cpu for more than 120 seconds.

I could be a scheduler problem which CPU-Hotplug is able to catch more
easily. Will try a git bisect.


> 
> Oleg.

-- 
Thanks and Regards
gautham
