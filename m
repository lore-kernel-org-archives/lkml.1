Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbXBOGee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbXBOGee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 01:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbXBOGee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 01:34:34 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:36029 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXBOGed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 01:34:33 -0500
Date: Thu, 15 Feb 2007 12:04:13 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070215063413.GA11950@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <200702142243.37189.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702142243.37189.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 10:43:35PM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> On Wednesday, 14 February 2007 15:40, Gautham R Shenoy wrote:
> > Hello Everybody,
> > 
> > This is an experiment towards process_freezer based implementation
> > of cpu-hotplug. This is mainly based on ideas of Andrew Morton, 
> > Ingo Molnar and Paul Mckenney featured in the discussion
> > http://lkml.org/lkml/2007/1/31/323.
> > 
> > This is an absolute bare-minimal implementation to check the feasibility
> > of using process freezer for cpu-hotplug. 
> > 
> > The patchset comprises of four patches.
> > o PATCH 1/4: Core implementation of freezer-based-hotplug.
> > o PATCH 2/4: Revert changes to workqueue to make it work with the
> >              freezer-cpu-hotplug.
> > o PATCH 3/4: Eliminate hotcpu subsystem mutexes from sched and slab.
> > o PATCH 4/4: Eliminate lock_cpu_hotplug from the kernel.
> 
> I think two things are missing:
> 
> 1) We should make sure there are not PF_NOFREEZE tasks running when a CPU
> is removed (when one is added probably too).  For this purpose we can add a
> parameter to freeze_processes() that will tell it to ignore PF_NOFREEZE, but
> at the same time we'll have to change all kernel threads that set PF_NOFREEZE
> to call try_to_freeze() anyway.  I can do that, but it will take me a couple of
> days.

Why should we make sure that PF_NOFREEZE tasks are also frozen for
cpu hotplug? Instead, we can create an infrastructure which allows threads to
specify for the scenarios they would want to be excempted from freeze.
Something like what Paul has suggested in
http://lkml.org/lkml/2007/1/31/323. That way, threads which have nothing
to do with the online_cpu_map or with handling of cpu-hotplug events can
mark themselves to be exempted from being frozen for cpu hotplug.

Once this is achieved, it's all about classifying the threads into
according to their NO_FREEZE needs :)

> 
> 2) We have to change the PM code to stop using CPU hotplug for disabling
> nonboot CPUs. ;-)

Just wondering, how hard is that ?

thanks
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
