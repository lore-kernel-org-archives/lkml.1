Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab0BMShp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 13:37:45 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55374 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab0BMSho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 13:37:44 -0500
Date: Sun, 14 Feb 2010 00:07:35 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
Message-ID: <20100213183735.GD5882@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
 <1266057388.557.59599.camel@twins>
 <1266057724.557.59610.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1266057724.557.59610.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-02-13 11:42:04]:

> On Sat, 2010-02-13 at 11:36 +0100, Peter Zijlstra wrote:
> > On Fri, 2010-02-12 at 17:31 -0800, Suresh Siddha wrote:
> > > 
> > > We have one more problem that Yanmin and Ling Ma reported. On a dual
> > > socket quad-core platforms (for example platforms based on NHM-EP), we
> > > are seeing scenarios where one socket is completely busy (with all the 4
> > > cores running with 4 tasks) and another socket is completely idle.
> > > 
> > > This causes performance issues as those 4 tasks share the memory
> > > controller, last-level cache bandwidth etc. Also we won't be taking
> > > advantage of turbo-mode as much as we like. We will have all these
> > > benefits if we move two of those tasks to the other socket. Now both the
> > > sockets can potentially go to turbo etc and improve performance.
> > > 
> > > In short, your recent change (shown below) broke this behavior. In the
> > > kernel summit you mentioned you made this change with out affecting the
> > > behavior of SMT/MC. And my testing immediately after kernel-summit also
> > > didn't show the problem (perhaps my test didn't hit this specific
> > > change). But apparently we are having performance issues with this patch
> > > (Ling Ma's bisect pointed to this patch). I will look more detailed into
> > > this after the long weekend (to see if we can catch this scenario in
> > > fix_small_imbalance() etc). But wanted to give you a quick heads up.
> > > Thanks.
> > 
> > Right, so the behaviour we want should be provided by SD_PREFER_SIBLING,
> > it provides the capacity==1 thing the cpu_power games used to provide.
> > 
> > Not saying it's not broken, but that's where the we should be looking to
> > fix it.
> 
> 
> BTW, do you think its possible to automate such test cases and put them
> in a test-suite?

Linux Test Project (LTP) has some test cases for sched_mc/smt
balancing.  They can be improved and generalized to include all basic
scheduler task placement checks.  

--Vaidy
