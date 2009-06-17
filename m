Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbZFQU07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbZFQU07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbZFQU0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:26:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:33963 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbZFQU0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:26:51 -0400
Subject: Re: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, svaidy@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Nathan Lynch <ntl@pobox.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
In-Reply-To: <20090617150700.GB20345@elte.hu>
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
	 <20090615232318.74b099a6.akpm@linux-foundation.org>
	 <20090616080715.GB7961@dirshya.in.ibm.com>
	 <1245223977.13761.21576.camel@twins>
	 <20090617143804.GA6767@linux.vnet.ibm.com> <20090617150700.GB20345@elte.hu>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 22:26:27 +0200
Message-Id: <1245270387.6670.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 17:07 +0200, Ingo Molnar wrote:
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Wed, Jun 17, 2009 at 09:32:57AM +0200, Peter Zijlstra wrote:
> > > On Tue, 2009-06-16 at 13:37 +0530, Vaidyanathan Srinivasan wrote:
> > > > * Andrew Morton <akpm@linux-foundation.org> [2009-06-15 23:23:18]:
> > > > 
> > > > > On Tue, 16 Jun 2009 11:08:39 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
> > > > > 
> > > > > > Currently on a ppc64 box with 16 CPUs, the time taken for
> > > > > > a individual cpu-hotplug operation is as follows.
> > > > > > 
> > > > > >     # time echo 0 > /sys/devices/system/cpu/cpu2/online
> > > > > >     real    0m0.025s
> > > > > >     user    0m0.000s
> > > > > >     sys     0m0.002s
> > > > > > 
> > > > > >     # time echo 1 > /sys/devices/system/cpu/cpu2/online
> > > > > >     real    0m0.021s
> > > > > >     user    0m0.000s
> > > > > >     sys     0m0.000s
> > > > > 
> > > > > Surprised.  Do people really online and offline CPUs frequently enough
> > > > > for this to be a problem?
> > > > 
> > > > Certainly not for hardware faults or hardware replacement, but
> > > > cpu-hotplug interface is useful for changing system configuration to
> > > > meet different objectives like
> > > > 
> > > > * Reduce system capacity to reduce average power and reduce heat
> > > > 
> > > > * Increasing number of cores and threads in a CPU package is leading
> > > >   to multiple cpu offline/online operations for any perceivable effect
> > > > 
> > > > * Dynamically change CPU configurations in virtualized environments
> > > 
> > > I tend to agree with Andrew, if any of those things are done 
> > > frequent enough that the hotplug performance matter you're doing 
> > > something mighty odd.
> > 
> > Boot speedup?
> 
> Also, if it brings more attention (and more stability and more 
> bugfixes) to CPU hotplug that's only good.

Sure, but do we need the extra complexity?

I mean, sure bootup speed might be nice, but any of the scenarios given
should simply not require cpu hotplug actions of a frequent enough
nature that any performance matters.

If you want to switch off all SMT siblings you don't do that 50 times a
second, you do that once per bootup or something.

Furthermore we already established that cpu hotlpug is not the proper
interface for thermal management, and dynamically changing virtualized
muck isn't something you do at 100Hz either.

So what worries me is the justification for this work. It might be good
and nice, but if the reasons are wrong it still worries me.

So again, why? -- the bootup thing is the only sane answer so far.

