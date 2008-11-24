Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYKXRFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYKXRFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 12:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYKXRFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 12:05:47 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53157 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbYKXRFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:05:46 -0500
Date: Mon, 24 Nov 2008 22:35:35 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when
	the task doesn't belong to init_task_group and when
	CONFIG_RT_GROUP_SCHED isn't set
Message-ID: <20081124170535.GE5451@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20081120061854.GA4349@in.ibm.com> <1227402676.7685.19942.camel@twins> <20081124035807.GA3278@in.ibm.com> <1227515526.7685.21861.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227515526.7685.21861.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 09:32:06AM +0100, Peter Zijlstra wrote:
> >  And may be as Ingo
> > suggested they should be moved to init_task_group.
> 
> Bzzt, wrong! They should not be moved to any group, they cannot be moved
> to any group, as they are group invariant.

Though what you say makes sense, the confusion arises from existing
cgroup<->scheduler interface, which can end up showing the above
single-set of RT-tasks to be split into multiple sets.

RT Tasks -> {RT0, RT1}

can be shown as:

	/a/tasks {RT0, ...}
	/b/tasks {RT1, ...}

Does this cause any problems? Perhaps no, just seems odd ..

Fixing this oddity of representing single RT-tasks set as multiple is not a 
cgroup issue IMHO.

P.S :- If eventually RT_GROUP_SCHED will be merged with FAIR_GROUP_SCHED, then 
it may make sense for us to just ignore this oddity for timebeing and look 
forward to the options being merged.

- vatsa
