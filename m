Return-Path: <linux-kernel-owner+w=401wt.eu-S2992555AbXDDDHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992555AbXDDDHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 23:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992557AbXDDDHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 23:07:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33956 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992555AbXDDDHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 23:07:41 -0400
Date: Wed, 4 Apr 2007 08:45:02 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070404031502.GA23591@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070402092818.GE2456@in.ibm.com> <20070402111828.GA14771@elte.hu> <20070402124200.GA9566@in.ibm.com> <20070402185607.GA2081@elte.hu> <20070403125619.GA32444@in.ibm.com> <20070403141516.GB14900@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403141516.GB14900@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 07:45:16PM +0530, Gautham R Shenoy wrote:
> > Should we ignore this for the timebeing and take up later as and when
> > users report problems?
> 
> In my case, the problem of freezer failing was due to the vfork freezer race
> in do_fork. The parent task was waiting_for_completion() while the child was
> frozen.

Good catch and ...

> Rafael has already sent out the fix for that, but for some reason I
> don't see it in the -mm.
> 
> With that fix, freezer and hence hotplug succeeds even when I am running
> a 'make -j' test.

Good to know that!

So Ingo/Rafael, should we ignore the problem of "TASK_UNINTERRUPTIBLE
sleepers can break freezer" for the timebeing? Mainly because its not
trivial to solve and we need to tackle it case by case basis as and when
users report specific problems.

-- 
Regards,
vatsa
