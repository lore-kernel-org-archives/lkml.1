Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbYKXPg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYKXPg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYKXPgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:36:48 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:58222 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYKXPgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:36:47 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when
 the task doesn't belong to init_task_group and when CONFIG_RT_GROUP_SCHED
 isn't set
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <492AC715.9080602@nortel.com>
References: <20081120061854.GA4349@in.ibm.com>
	 <1227402676.7685.19942.camel@twins> <20081124035807.GA3278@in.ibm.com>
	 <1227515526.7685.21861.camel@twins>
	 <20081124084644.GA26526@linux.vnet.ibm.com>
	 <1227517575.7685.21906.camel@twins>  <492AC715.9080602@nortel.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 16:36:30 +0100
Message-Id: <1227540990.4259.296.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 09:24 -0600, Chris Friesen wrote:
> Peter Zijlstra wrote:
> > On Mon, 2008-11-24 at 14:16 +0530, Dhaval Giani wrote:
> > 
> > 
> >>Which would mean the init_task_group becase it contains those tasks which are
> >>not grouped.
> > 
> > 
> > Only because of implementation details (we implement the !group case by
> > having them all part of a single group), conceptually they don't belong
> > to any group, hence talking about moving it to some group is just wrong.
> 
> > Furthermore your statement shows another misconception, a group of
> > ungrouped tasks doesn't make sense.
> 
> Arguably there is such a group, which is "the set of all RT tasks".

Sure, I understand that, and in fact that's how its implemented, no
group is still one group (which is how you can bootstrap math from
group/set theory).

But its not a manageable group in the cgroup sense, its just the
collection of RT tasks.

> Whether or not they should map to the top-level cgroup is a different 
> question.  Maybe in the !group case there should be a second top-level 
> "rt" cgroup?  We could even make the RT sched tuning knobs available there.

I'd rather just not display all that. We don't go make such 'unmanaged'
groups for other not configured controllers either.



