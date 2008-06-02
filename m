Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbYFBNJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbYFBNJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYFBNI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:08:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYFBNI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:08:56 -0400
Subject: Re: [ANNOUNCE] sched: schedtop utility
From: Peter Zijlstra <peterz@infradead.org>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       suresh.b.siddha@intel.com, aneesh.kumar@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       David Bahi <DBahi@novell.com>
In-Reply-To: <20080602124822.GA15410@in.ibm.com>
References: <483545B4.BA47.005A.0@novell.com>
	 <20080602124822.GA15410@in.ibm.com>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 15:07:31 +0200
Message-Id: <1212412051.6269.5.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 18:18 +0530, Ankita Garg wrote:
> Hi Gregory,
> 
> On Thu, May 22, 2008 at 08:06:44AM -0600, Gregory Haskins wrote:
> > Hi all scheduler developers,
> >   I had an itch to scratch w.r.t. watching the stats in /proc/schedstats, and it appears that the perl scripts referenced in Documentation/scheduler/sched-stats.txt do not support v14 from HEAD so I whipped up a little utility I call "schedtop".
> >
> 
> Nice tool! Helps in better visualization of the data in schedstats. 
> 
> Using the tool, realized that most of the timing related stats therein
> might not be completely usable in many scenarios, as might already be
> known.
> 
> Without any additional load on the system, all the stats are nice and
> sane. But, as soon as I ran my particular testcase, the data
> pertaining to the delta of run_delay/cpu_time went haywire! I understand
> that all the values are based on top of rq->clock, which relies on tsc that 
> is not synced across cpus and would result in skews/incorrect values.
> But, turns out to be not so reliable data for debugging. This is
> ofcourse nothing related to the tool, but for schedstat in
> general...rather just adding on to the already existing woes with non-syned 
> tscs :-)

Thing is, things runtime should be calculated by using per cpu deltas.
You take a stamp when you get scheduled on the cpu and another one when
you stop running, then the delta is added to runtime.

This is always on the same cpu - when you get migrated you're stopped
and re-scheduled so that should work out nicely.

So in that sense it shouldn't matter that the rq->clock values can get
skewed between cpus.

So I'm still a little puzzled by your observations; though it could be
that the schedstat stuff got broken - I've never really looked too
closely at it.



