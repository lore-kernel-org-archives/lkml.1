Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbYKYUR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbYKYUR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 15:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYKYURR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 15:17:17 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:43892 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYKYURR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 15:17:17 -0500
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
In-Reply-To: <492C491B.8060103@nortel.com>
References: <20081120061854.GA4349@in.ibm.com>
	 <1227402676.7685.19942.camel@twins> <20081124035807.GA3278@in.ibm.com>
	 <1227515526.7685.21861.camel@twins>
	 <20081124084644.GA26526@linux.vnet.ibm.com>
	 <1227517575.7685.21906.camel@twins>  <492AC715.9080602@nortel.com>
	 <1227540990.4259.296.camel@twins>  <492C491B.8060103@nortel.com>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 21:17:02 +0100
Message-Id: <1227644222.4259.2054.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 12:51 -0600, Chris Friesen wrote:
> Peter Zijlstra wrote:
> > On Mon, 2008-11-24 at 09:24 -0600, Chris Friesen wrote:
> > 
> >>Peter Zijlstra wrote:
> 
> >>>Furthermore your statement shows another misconception, a group of
> >>>ungrouped tasks doesn't make sense.
> >>
> >>Arguably there is such a group, which is "the set of all RT tasks".
> > 
> > 
> > Sure, I understand that, and in fact that's how its implemented, no
> > group is still one group (which is how you can bootstrap math from
> > group/set theory).
> > 
> > But its not a manageable group in the cgroup sense, its just the
> > collection of RT tasks.
> 
> True, but it would be valuable to have statistics for how much cpu time 
> the RT tasks are consuming.

True, I have patches for that though, and this is unrelated to cgroups.

The more interesting thing is using that time to scale the sched_other
balancing.

