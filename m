Return-Path: <linux-kernel-owner+w=401wt.eu-S1751374AbXB0EKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbXB0EKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXB0EKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:10:32 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:44309 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbXB0EKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:10:30 -0500
Date: Sat, 24 Feb 2007 00:33:34 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       oleg@tv-sign.ru, linux-kernel@vger.kernel.org
Subject: Re: freezer problems
Message-ID: <20070223190334.GA23599@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <200702231041.17136.rjw@sisk.pl> <20070223100817.GA10973@in.ibm.com> <200702231115.00718.rjw@sisk.pl> <20070223104723.GB10973@in.ibm.com> <20070223110201.GC10973@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223110201.GC10973@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 04:32:01PM +0530, Srivatsa Vaddagiri wrote:
> On Fri, Feb 23, 2007 at 04:17:23PM +0530, Srivatsa Vaddagiri wrote:
> > Ok that was my point of concern. For hotplug we would ideally like
> > everyone to be frozen. If we are not freezing some (like vfork parents),
> > (rather if we dont -wait- for them to get frozen) before offlining a
> > cpu, then it may expose some hotplug unsafe code in the caller of vfork
> > in kernel - hopefully that is not a issue practically speaking.
> 
> I notice that __call_usermodehelper() work function calls kernel_thread with
> CLONE_VFORK set. __call_usermodehelper() is usualled called in the
> context of a worker thread (kevent).

But I see __call_usermodehelper being called from the context of
khelper_wq which is a singlethreaded workqueue.

I thought we were not planning to freeze singlethreaded workqueue's for
hotplug, since we are not kthread_stopping them anywhere.

So this kthread_stop waiting for parent(khelper_wq) which is blocked on
wait_for_complete(child->vfork_done) shouldn't occur. No?

Thanks and Regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
