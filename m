Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbXGKJyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbXGKJyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759077AbXGKJyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:54:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42461 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbXGKJyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:54:02 -0400
Date: Wed, 11 Jul 2007 15:33:23 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-ID: <20070711100323.GA23473@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710105240.GA20914@linux.vnet.ibm.com> <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com> <20070710115319.0bdaff34.akpm@linux-foundation.org> <20070711045516.GH2927@linux.vnet.ibm.com> <20070710222942.382fc9ba.akpm@linux-foundation.org> <20070711090423.GA6758@elte.hu> <20070711022352.71604404.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711022352.71604404.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 02:23:52AM -0700, Paul Jackson wrote:
> Ingo wrote:
> > another option would be to trivially hook up CONFIG_FAIR_GROUP_SCHED 
> > with cpusets, ...
> 
> ah ... you triggered my procmail filter for 'cpuset' ... ;).

:-)

> What would it mean to hook up CFS with cpusets?

CFS is the new cpu scheduler in Linus's tree (http://lwn.net/Articles/241085/).
It has some group scheduling capabilities added i.e the core scheduler
now recognizes the concept of a task-group and providing fair cpu time 
to each task-group (in addition to providing fair time to each task in a
group).

The core scheduler however is not concerned with how task groups are formed
and/or how tasks migrate between groups. Thats where a patch like Paul Menage's 
container infrastructure comes in hand - to provide a user-interface for 
managing task-groups (create/delete task groups, migrate task from one
group to another etc). Whatever the chosen user-interface is, cpu
scheduler needs to know about such task-group creation/destruction,
migration of tasks across groups etc.

Unfortunately, the group-scheduler bits will be ready in 2.6.23 while
Paul Menage's container patches aren't ready for 2.6.23 yet.

So Ingo was proposing we use cpuset as that user interface to manage
task-groups. This will be only for 2.6.23. In 2.6.24, when hopefully Paul
Menage's container patches will be ready and will be merged, the group
cpu scheduler will stop using cpuset as that interface and use the
container infrastructure instead.

If you recall, I have attempted to use cpuset for such an interface in
the past (metered cpusets - see [1]). It brings in some semantic changes
for cpusets, most notably:

	- metered cpusets cannot have grand-children
	- all cpusets under a metered cpuset need to share the same set
	  of cpus.

Is it fine if I introduce these semantic changes, only for 2.6.23 and
only when CONFIG_FAIR_GROUP_SCHED is enabled? This will let the group
cpu scheduler to receive some amount of testing.

The other alternative is to hook up group scheduler with user-id's
(again only for 2.6.23).

> I've a pretty
> good idea what a cpuset is, but don't know what kind of purpose
> you have in mind for such a hook.  Could you say a few words to
> that?  Thanks.

Reference:

1. http://marc.info/?l=linux-kernel&m=115946525811848&w=2


-- 
Regards,
vatsa
