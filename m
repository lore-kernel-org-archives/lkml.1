Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbZLENIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbZLENIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 08:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZLENIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 08:08:37 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:42223 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbZLENIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 08:08:34 -0500
Date: Sat, 5 Dec 2009 18:38:28 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v4 PATCH 6/7] sched: Rebalance cfs runtimes
Message-ID: <20091205130828.GC6204@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20091117143306.GK17335@in.ibm.com> <20091117143718.GQ17335@in.ibm.com> <1259942998.17907.897.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259942998.17907.897.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 05:09:58PM +0100, Peter Zijlstra wrote:
> On Tue, 2009-11-17 at 20:07 +0530, Bharata B Rao wrote:
> > sched: CFS runtime borrowing
> > 
> > From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > 
> > Before throttling a group, try to borrow runtime from groups that have excess.
> > 
> > To start with, a group will get equal runtime on every cpu. If the group doesn't
> > have tasks on all cpus, it might get throttled on some cpus while it still has
> > runtime left on other cpus where it doesn't have any tasks to consume that
> > runtime. Hence there is a chance to borrow runtimes from such cpus/cfs_rqs to
> > cpus/cfs_rqs where it is required.
> > 
> > CHECK: RT seems to be handling runtime initialization/reclaim during hotplug
> > from multiple places (migration_call, update_runtime). Need to check if CFS
> > also needs to do the same.
> > 
> > Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > ---
> >  kernel/sched.c      |   26 ++++++++
> >  kernel/sched_fair.c |  172 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  kernel/sched_rt.c   |   26 +-------
> >  3 files changed, 202 insertions(+), 22 deletions(-)
> 
> I think that if we unify the se/rq bandwidth structures a lot of copy
> and paste can be avoided, resulting in an over-all much easier to
> maintain code-base.

As you note here and also in reply to 2/7, I could definetely unify some
of the bandwidth handling code b/n rt and cfs. In fact I already have patches
from Dhaval for this. I was holding them back till now since I wanted to
show how cfs hard limits looks like and what changes it involves and get
review feedback on them. As I have said in my earlier posts, I will eventually
merge code with rt. I shall do this starting from next post.

Regards,
Bharata.
