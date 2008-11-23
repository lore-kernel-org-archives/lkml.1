Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYKWBLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYKWBLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 20:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYKWBLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 20:11:22 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:15840 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbYKWBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 20:11:21 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when
 the task doesn't belong to init_task_group and when CONFIG_RT_GROUP_SCHED
 isn't set
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <20081120061854.GA4349@in.ibm.com>
References: <20081120061854.GA4349@in.ibm.com>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 02:11:16 +0100
Message-Id: <1227402676.7685.19942.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 11:48 +0530, Bharata B Rao wrote:
> Applies on 2.6.28-rc5.
> 
> With CONFIG_RT_GROUP_SCHED not set, don't allow a task's priority switch
> to realtime if the task isn't part of init_task_group.
> 
> A task belonging to a fair group could use sched_setscheduler/sched_setparam
> to become a realtime task. If such a task belongs to one of the
> child groups of init_task_group and if CONFIG_RT_GROUP_SCHED is not set,
> then it ends up getting queued in init_task_group's runqueue.
> So we have a situation where, a task belongs to one group (child)
> but ends in the runqueue of another group (init_task_group).
> This does not look correct.
> 
> Fix this by failing such priority change requests in sched_setscheduler()
> and sched_setparam().

NAK

!RT_GROUP means the RT tasks should be fully invariant to any grouping
configuration. This patch breaks that.

Furthermore your justification for this is plain wrong, you write as if
an RT tasks can belong to any grouping (in the !RT_GROUP case), by the
above this is untrue and shows a fundamental mis-understanding of the
concepts involved.

