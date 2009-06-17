Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZFQPH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZFQPH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZFQPHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:07:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58054 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbZFQPHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:07:49 -0400
Date: Wed, 17 Jun 2009 17:07:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, svaidy@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Nathan Lynch <ntl@pobox.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
Message-ID: <20090617150700.GB20345@elte.hu>
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com> <20090615232318.74b099a6.akpm@linux-foundation.org> <20090616080715.GB7961@dirshya.in.ibm.com> <1245223977.13761.21576.camel@twins> <20090617143804.GA6767@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617143804.GA6767@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Jun 17, 2009 at 09:32:57AM +0200, Peter Zijlstra wrote:
> > On Tue, 2009-06-16 at 13:37 +0530, Vaidyanathan Srinivasan wrote:
> > > * Andrew Morton <akpm@linux-foundation.org> [2009-06-15 23:23:18]:
> > > 
> > > > On Tue, 16 Jun 2009 11:08:39 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
> > > > 
> > > > > Currently on a ppc64 box with 16 CPUs, the time taken for
> > > > > a individual cpu-hotplug operation is as follows.
> > > > > 
> > > > >     # time echo 0 > /sys/devices/system/cpu/cpu2/online
> > > > >     real    0m0.025s
> > > > >     user    0m0.000s
> > > > >     sys     0m0.002s
> > > > > 
> > > > >     # time echo 1 > /sys/devices/system/cpu/cpu2/online
> > > > >     real    0m0.021s
> > > > >     user    0m0.000s
> > > > >     sys     0m0.000s
> > > > 
> > > > Surprised.  Do people really online and offline CPUs frequently enough
> > > > for this to be a problem?
> > > 
> > > Certainly not for hardware faults or hardware replacement, but
> > > cpu-hotplug interface is useful for changing system configuration to
> > > meet different objectives like
> > > 
> > > * Reduce system capacity to reduce average power and reduce heat
> > > 
> > > * Increasing number of cores and threads in a CPU package is leading
> > >   to multiple cpu offline/online operations for any perceivable effect
> > > 
> > > * Dynamically change CPU configurations in virtualized environments
> > 
> > I tend to agree with Andrew, if any of those things are done 
> > frequent enough that the hotplug performance matter you're doing 
> > something mighty odd.
> 
> Boot speedup?

Also, if it brings more attention (and more stability and more 
bugfixes) to CPU hotplug that's only good.

	Ingo
