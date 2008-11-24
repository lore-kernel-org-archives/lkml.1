Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbYKXSqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbYKXSqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYKXSqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:46:42 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:59178 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYKXSql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:46:41 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when
 the task doesn't belong to init_task_group and when CONFIG_RT_GROUP_SCHED
 isn't set
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@in.ibm.com
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <20081124170535.GE5451@linux.vnet.ibm.com>
References: <20081120061854.GA4349@in.ibm.com>
	 <1227402676.7685.19942.camel@twins> <20081124035807.GA3278@in.ibm.com>
	 <1227515526.7685.21861.camel@twins>
	 <20081124170535.GE5451@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 19:46:37 +0100
Message-Id: <1227552397.4259.504.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 22:35 +0530, Srivatsa Vaddagiri wrote:
> On Mon, Nov 24, 2008 at 09:32:06AM +0100, Peter Zijlstra wrote:
> > >  And may be as Ingo
> > > suggested they should be moved to init_task_group.
> > 
> > Bzzt, wrong! They should not be moved to any group, they cannot be moved
> > to any group, as they are group invariant.
> 
> Though what you say makes sense, the confusion arises from existing
> cgroup<->scheduler interface, which can end up showing the above
> single-set of RT-tasks to be split into multiple sets.
> 
> RT Tasks -> {RT0, RT1}
> 
> can be shown as:
> 
> 	/a/tasks {RT0, ...}
> 	/b/tasks {RT1, ...}
> 
> Does this cause any problems? Perhaps no, just seems odd ..
> 
> Fixing this oddity of representing single RT-tasks set as multiple is not a 
> cgroup issue IMHO.

I'm fine with just not showing RT tasks in cgroup:cpu/tasks.

> P.S :- If eventually RT_GROUP_SCHED will be merged with FAIR_GROUP_SCHED, then 
> it may make sense for us to just ignore this oddity for timebeing and look 
> forward to the options being merged.

Right, that might take a bit of time still as RT_GROUP needs a deadline
scheduler to be complete.

