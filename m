Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbYFBNU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbYFBNU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYFBNUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:20:14 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:21989 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYFBNUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:20:13 -0400
Message-Id: <4843BB49.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 02 Jun 2008 07:20:09 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ankita Garg" <ankita@in.ibm.com>, "Peter Zijlstra" <peterz@infradead.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <rostedt@goodmis.org>,
       <suresh.b.siddha@intel.com>, <aneesh.kumar@linux.vnet.ibm.com>,
       <dhaval@linux.vnet.ibm.com>, <vatsa@linux.vnet.ibm.com>,
       "David Bahi" <DBahi@novell.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] sched: schedtop utility
References: <483545B4.BA47.005A.0@novell.com>
 <20080602124822.GA15410@in.ibm.com>
 <1212412051.6269.5.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1212412051.6269.5.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ankita,
  For some reason, I didn't get your original email.  I had to go find it on the lkml.org archives.

But anyway, see inline

>>> On Mon, Jun 2, 2008 at  9:07 AM, in message
<1212412051.6269.5.camel@lappy.programming.kicks-ass.net>, Peter Zijlstra
<peterz@infradead.org> wrote: 
> On Mon, 2008-06-02 at 18:18 +0530, Ankita Garg wrote:
>> Hi Gregory,
>> 
>> On Thu, May 22, 2008 at 08:06:44AM -0600, Gregory Haskins wrote:
>> > Hi all scheduler developers,
>> >   I had an itch to scratch w.r.t. watching the stats in /proc/schedstats, 
> and it appears that the perl scripts referenced in 
> Documentation/scheduler/sched-stats.txt do not support v14 from HEAD so I 
> whipped up a little utility I call "schedtop".
>> >
>> 
>> Nice tool! Helps in better visualization of the data in schedstats. 
>> 
>> Using the tool, realized that most of the timing related stats therein
>> might not be completely usable in many scenarios, as might already be
>> known.
>> 
>> Without any additional load on the system, all the stats are nice and
>> sane. But, as soon as I ran my particular testcase, the data
>> pertaining to the delta of run_delay/cpu_time went haywire! I understand
>> that all the values are based on top of rq->clock, which relies on tsc that 
>> is not synced across cpus and would result in skews/incorrect values.
>> But, turns out to be not so reliable data for debugging. This is
>> ofcourse nothing related to the tool, but for schedstat in
>> general...rather just adding on to the already existing woes with non-syned 
>> tscs :-)
> 
> Thing is, things runtime should be calculated by using per cpu deltas.
> You take a stamp when you get scheduled on the cpu and another one when
> you stop running, then the delta is added to runtime.
> 
> This is always on the same cpu - when you get migrated you're stopped
> and re-scheduled so that should work out nicely.
> 
> So in that sense it shouldn't matter that the rq->clock values can get
> skewed between cpus.
> 
> So I'm still a little puzzled by your observations; though it could be
> that the schedstat stuff got broken - I've never really looked too
> closely at it.

I suspect we must be talking about those stats that are always moving pretty fast.  I see that too, and I use the (potentially unknown) filtering feature of schedtop: "-i REGEX" will set the include filter, and "-x REGEX" will set the exclude filter.  By default, include allows everything, and exclude filters nothing.  Changing it to "-x sched_info" will exclude all those pesky stats that move fast and do not convey useful (to me, anyway) data.  I hope that helps!

Also, about your idea for the /proc/<pid>/schedstats, I was thinking the same thing while on my trip on Friday.  I will add this feature.  Thanks!

-Greg


