Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZLDQKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZLDQKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZLDQKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:10:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:54256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZLDQKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:10:41 -0500
Subject: Re: [RFC v4 PATCH 6/7] sched: Rebalance cfs runtimes
From: Peter Zijlstra <peterz@infradead.org>
To: bharata@linux.vnet.ibm.com
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
In-Reply-To: <20091117143718.GQ17335@in.ibm.com>
References: <20091117143306.GK17335@in.ibm.com>
	 <20091117143718.GQ17335@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 17:09:58 +0100
Message-ID: <1259942998.17907.897.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 20:07 +0530, Bharata B Rao wrote:
> sched: CFS runtime borrowing
> 
> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> 
> Before throttling a group, try to borrow runtime from groups that have excess.
> 
> To start with, a group will get equal runtime on every cpu. If the group doesn't
> have tasks on all cpus, it might get throttled on some cpus while it still has
> runtime left on other cpus where it doesn't have any tasks to consume that
> runtime. Hence there is a chance to borrow runtimes from such cpus/cfs_rqs to
> cpus/cfs_rqs where it is required.
> 
> CHECK: RT seems to be handling runtime initialization/reclaim during hotplug
> from multiple places (migration_call, update_runtime). Need to check if CFS
> also needs to do the same.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
>  kernel/sched.c      |   26 ++++++++
>  kernel/sched_fair.c |  172 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched_rt.c   |   26 +-------
>  3 files changed, 202 insertions(+), 22 deletions(-)

I think that if we unify the se/rq bandwidth structures a lot of copy
and paste can be avoided, resulting in an over-all much easier to
maintain code-base.

