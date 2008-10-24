Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYJXKCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYJXKCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYJXKBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 06:01:43 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:60553 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbYJXKBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 06:01:40 -0400
Date: Fri, 24 Oct 2008 15:34:58 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Gregory Haskins <ghaskins@novell.com>, arjan <arjan@infradead.org>
Subject: Re: [RFC PATCH v2 0/5] sched: modular find_busiest_group()
Message-ID: <20081024100458.GA6230@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Gregory Haskins <ghaskins@novell.com>, arjan <arjan@infradead.org>
References: <20081009120705.27010.12857.stgit@drishya.in.ibm.com> <1223561968.7382.42.camel@lappy.programming.kicks-ass.net> <1223986153.9557.4.camel@twins> <20081014130754.GD3995@dirshya.in.ibm.com> <1223990703.9557.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1223990703.9557.25.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2008-10-14 15:25:03]:

> On Tue, 2008-10-14 at 18:37 +0530, Vaidyanathan Srinivasan wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2008-10-14 14:09:13]:
> > 
> > > 
> > > Hi,
> > > 
> > > So the basic issue is sched_group::cpu_power should become more dynamic.
> > 
> > Hi Peter,
> > 
> > This is a good idea.  Dynamically increasing cpu power to some groups
> > will automatically help power savings when we want to consolidate
> > better to one cpu package when overall system utilisation is very low.  
> 
> Ah, yes another use case of this ;-)
> 
> > > Dynamic Speed Technology
> > > ------------------------
> > > 
> > > With cpus actively fiddling with their processing capacity we get into
> > > similar issues. Again we can measure this, but this would require the
> > > addition of a clock that measures work instead of time.
> > > 
> > > Having that, we can even acturately measure the old SMT case, which has
> > > always been approximated by a static percentage - even though the actual
> > > gain is very workload dependent.
> > > 
> > > The idea is to introduce sched_work_clock() so that:
> > > 
> > >         work_delta / time_delta gives the power for a cpu. <1 means we
> > >         did less work than a dedicated pipeline, >1 means we did more.
> > 
> > The challenge here is measurement of 'work'.  What will be the
> > parameter that will be fair for most workloads and easy to measure on
> > most systems?
> > 
> > * Instructions completion count
> > * APERF or similar CPU specific counter on x86
> > * POWER has PURR and SPURR to have a measure of relative work done  
> 
> Right - I was hoping for some feedback from the arch folks (maybe I
> should have CC'ed linux-arch) on this issue.

Hi Peter,

Do you want to post this RFD again to get more feedback? 

--Vaidy
