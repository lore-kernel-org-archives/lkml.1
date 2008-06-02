Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbYFBMsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbYFBMsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYFBMsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:48:45 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:49633 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757994AbYFBMso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:48:44 -0400
Date: Mon, 2 Jun 2008 18:18:22 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       rostedt@goodmis.org, Peter Zijlstra <peterz@infradead.org>,
       suresh.b.siddha@intel.com, aneesh.kumar@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       David Bahi <DBahi@novell.com>
Subject: Re: [ANNOUNCE] sched: schedtop utility
Message-ID: <20080602124822.GA15410@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <483545B4.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483545B4.BA47.005A.0@novell.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

On Thu, May 22, 2008 at 08:06:44AM -0600, Gregory Haskins wrote:
> Hi all scheduler developers,
>   I had an itch to scratch w.r.t. watching the stats in /proc/schedstats, and it appears that the perl scripts referenced in Documentation/scheduler/sched-stats.txt do not support v14 from HEAD so I whipped up a little utility I call "schedtop".
>

Nice tool! Helps in better visualization of the data in schedstats. 

Using the tool, realized that most of the timing related stats therein
might not be completely usable in many scenarios, as might already be
known.

Without any additional load on the system, all the stats are nice and
sane. But, as soon as I ran my particular testcase, the data
pertaining to the delta of run_delay/cpu_time went haywire! I understand
that all the values are based on top of rq->clock, which relies on tsc that 
is not synced across cpus and would result in skews/incorrect values.
But, turns out to be not so reliable data for debugging. This is
ofcourse nothing related to the tool, but for schedstat in
general...rather just adding on to the already existing woes with non-syned 
tscs :-)

> This utility will process statistics from /proc/schedstat such that the busiest stats will bubble up to the top.  It can alternately be sorted by the largest stat, or by name.  Stats can be included or excluded based on reg-ex pattern matching.
> 
> You can download the tarball here:
> 
> ftp://ftp.novell.com/dev/ghaskins/schedtop.tar.gz
> 
> I have also posted it to the opensuse build service for generating RPMS for a handful of 32/64-bit x86 distros for your convenience:
> 
> http://download.opensuse.org/repositories/home:/ghaskins/
> 
> (Note that the build is still in progress for some of the favors, so if you do not see the flavor you are looking for, check back in a little while)
> 
> Comments/feedback/bug-fixes welcome!

Maybe support for displaying process specific schedstat info might help? 
We already do capture it under /proc/<pid>/schedstat. So, a -p switch for 
pid maybe? Reason for this is when looking at the entire system stats, I 
might not be able to get lot of information specific to my particular
application...like when a particular thread suffers a lot of delay
waiting for the runqueue... just a thought!

> 
> Regards
> -Greg
> 

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
