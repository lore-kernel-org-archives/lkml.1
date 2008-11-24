Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYKXD6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYKXD6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 22:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYKXD6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 22:58:05 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53686 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbYKXD6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 22:58:03 -0500
Date: Mon, 24 Nov 2008 09:28:08 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when
	the task doesn't belong to init_task_group and when
	CONFIG_RT_GROUP_SCHED isn't set
Message-ID: <20081124035807.GA3278@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081120061854.GA4349@in.ibm.com> <1227402676.7685.19942.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227402676.7685.19942.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 02:11:16AM +0100, Peter Zijlstra wrote:
> On Thu, 2008-11-20 at 11:48 +0530, Bharata B Rao wrote:
> > Applies on 2.6.28-rc5.
> > 
> > With CONFIG_RT_GROUP_SCHED not set, don't allow a task's priority switch
> > to realtime if the task isn't part of init_task_group.
> > 
> > A task belonging to a fair group could use sched_setscheduler/sched_setparam
> > to become a realtime task. If such a task belongs to one of the
> > child groups of init_task_group and if CONFIG_RT_GROUP_SCHED is not set,
> > then it ends up getting queued in init_task_group's runqueue.
> > So we have a situation where, a task belongs to one group (child)
> > but ends in the runqueue of another group (init_task_group).
> > This does not look correct.
> > 
> > Fix this by failing such priority change requests in sched_setscheduler()
> > and sched_setparam().
> 
> NAK
> 
> !RT_GROUP means the RT tasks should be fully invariant to any grouping
> configuration. This patch breaks that.
> 
> Furthermore your justification for this is plain wrong, you write as if
> an RT tasks can belong to any grouping (in the !RT_GROUP case), by the

Hmm... but that's I the impression I got when I started an RT
task in a subgroup and saw it listed in the tasks list of the cgroup.
So if RT tasks don't care about grouping (!RT_GROUP_SCHED), may be then
such tasks shoudn't be shown in the cgroup tasks list. And may be as Ingo
suggested they should be moved to init_task_group. Without that it makes one
think that a task is contributing to the cpu time of a group in which
it was started, but it in reality it is not.

Regards,
Bharata.
