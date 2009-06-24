Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZF0L11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZF0L11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZF0L1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:27:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40775 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbZF0L1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:27:05 -0400
Date: Wed, 24 Jun 2009 17:02:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Nathan Lynch <ntl@pobox.com>, Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
Message-ID: <20090624150240.GB1784@ucw.cz>
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com> <20090615232318.74b099a6.akpm@linux-foundation.org> <20090616080715.GB7961@dirshya.in.ibm.com> <20090616210059.GL6842@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616210059.GL6842@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-16 14:00:59, Paul E. McKenney wrote:
> On Tue, Jun 16, 2009 at 01:37:15PM +0530, Vaidyanathan Srinivasan wrote:
> > * Andrew Morton <akpm@linux-foundation.org> [2009-06-15 23:23:18]:
> > 
> > > On Tue, 16 Jun 2009 11:08:39 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
> > > 
> > > > Currently on a ppc64 box with 16 CPUs, the time taken for
> > > > a individual cpu-hotplug operation is as follows.
> > > > 
> > > > 	# time echo 0 > /sys/devices/system/cpu/cpu2/online
> > > > 	real    0m0.025s
> > > > 	user    0m0.000s
> > > > 	sys     0m0.002s
> > > > 
> > > > 	# time echo 1 > /sys/devices/system/cpu/cpu2/online
> > > > 	real    0m0.021s
> > > > 	user    0m0.000s
> > > > 	sys     0m0.000s
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
> Perhaps also reducing boot-up time?  If I am correctly interpreting the
> above numbers, an eight-CPU system would be consuming 175 milliseconds
> bringing up the seven non-boot CPUs.  Reducing this by 150 milliseconds
> might be of interest to some people.  ;-)

...also it should save 300msec from s2ram cycle. Actually maybe
suspend code should be modified first,  as it can demonstrate the
changes without kernel<-> user interface changing?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
