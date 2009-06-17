Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbZFQHkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbZFQHkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZFQHkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:40:39 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49124 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbZFQHkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:40:39 -0400
Date: Wed, 17 Jun 2009 13:10:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
Message-ID: <20090617074035.GH7646@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com> <20090615232318.74b099a6.akpm@linux-foundation.org> <20090616080715.GB7961@dirshya.in.ibm.com> <1245223977.13761.21576.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1245223977.13761.21576.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-06-17 09:32:57]:

> On Tue, 2009-06-16 at 13:37 +0530, Vaidyanathan Srinivasan wrote:
> > * Andrew Morton <akpm@linux-foundation.org> [2009-06-15 23:23:18]:
> > 
> > > On Tue, 16 Jun 2009 11:08:39 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
> > > 
> > > > Currently on a ppc64 box with 16 CPUs, the time taken for
> > > > a individual cpu-hotplug operation is as follows.
> > > > 
> > > >     # time echo 0 > /sys/devices/system/cpu/cpu2/online
> > > >     real    0m0.025s
> > > >     user    0m0.000s
> > > >     sys     0m0.002s
> > > > 
> > > >     # time echo 1 > /sys/devices/system/cpu/cpu2/online
> > > >     real    0m0.021s
> > > >     user    0m0.000s
> > > >     sys     0m0.000s
> > > 
> > > Surprised.  Do people really online and offline CPUs frequently enough
> > > for this to be a problem?
> > 
> > Certainly not for hardware faults or hardware replacement, but
> > cpu-hotplug interface is useful for changing system configuration to
> > meet different objectives like
> > 
> > * Reduce system capacity to reduce average power and reduce heat
> > 
> > * Increasing number of cores and threads in a CPU package is leading
> >   to multiple cpu offline/online operations for any perceivable effect
> > 
> > * Dynamically change CPU configurations in virtualized environments
> 
> I tend to agree with Andrew, if any of those things are done frequent
> enough that the hotplug performance matter you're doing something mighty
> odd.
>

Peter, what Vaidy mentioned are very useful cases, to add to that

Consider for example the need to turn of all threads belonging to a
package or the system. I can basically give out the cpu ids of all
threads and hotplug them out at once depending on the workload. In
effect turning off hyper-threading on the package.

Doing it all together provides benefits of (not complete, but
better control) over rollback apart from the speed benefit.

The benefit mentioned by Paul of speed up is very useful as well on
large systems and on the boot up time of virtual machines as well.
 

-- 
	Balbir
