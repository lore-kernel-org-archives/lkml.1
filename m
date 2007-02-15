Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbXBOO0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbXBOO0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965306AbXBOO0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:26:03 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:58818 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbXBOO0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:26:02 -0500
Date: Thu, 15 Feb 2007 19:55:42 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070215142542.GA14931@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <200702150909.53145.rjw@sisk.pl> <20070215122055.GA19155@in.ibm.com> <200702151431.10068.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702151431.10068.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 02:31:08PM +0100, Rafael J. Wysocki wrote:
> 
> So I think tonight I'll start adding try_to_freeze() to the kernel threads that
> set PF_NOFREEZE.

cool! While you are at it, let me try to enhance the freezer api's
to incorporate the PFE_* flags.

> > 
> > That would still mean going over the task list twice.
> 
> Yes, but I think this is inevitable anyway, because we have moved the
> disabling of nonboot CPUs after the suspending of devices (for
> ACPI-related reasons).
> 
> Currently, we have, roughly:
> 
> freeze_processes();
> shrink_memory(); (swsusp only)
> suspend_devices();
> disable_nonboot_cpus();
> suspend
> 
> and the reverse during the resume.
> 
> Still, the second pass will be quick, since the majority of tasks are frozen
> when disable_nonboot_cpus() is called.

Ok. That's fine by me. Lets get it working first. We can always optimize
it later :-)

> > 
> > Cool! Lets get started then ;-)
> 
> No problem with that. ;-)
> 
> Speaking of the classification, do you think it would be practical to use
> some kind of "freezing levels"?  I mean, for each task we can define the
> "freezing level" at which it should be frozen and each user of the freezer
> can call it with a specific "freezing level" as a parameter.  Of course for
> this purpose the tasks frozen at level 1 have to be a subset of the tasks
> frozen at level 2 etc. and I'm not sure if this requirement can be satisfied.

A freeze hierarchy! I hope this freeze_level parameter ain't an alternative
to the PFE_* flags because then a task would be in a dilemma as to
what freezing level it should be at, if it wants to be frozen for lets
say kprobes but not for cpu-hotplug. Cpu-hotplug and kprobes
may not have a dependency like the one that exists between cpu-hotplug
and suspend. So, at this moment, even I am not sure if there is a
need for the hierarchy.

> 
> Rafael

Thanks and Regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
