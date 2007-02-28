Return-Path: <linux-kernel-owner+w=401wt.eu-S1751367AbXB1SHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbXB1SHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXB1SHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:07:51 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:39643 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXB1SHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:07:51 -0500
Date: Wed, 28 Feb 2007 23:36:57 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228180657.GB7021@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200702272251.28844.rjw@sisk.pl> <20070227232855.GA457@tv-sign.ru> <1172619412.3681.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172619412.3681.11.camel@johannes.berg>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 12:36:52AM +0100, Johannes Berg wrote:
> On Wed, 2007-02-28 at 02:28 +0300, Oleg Nesterov wrote:
> 
> > Ugh. I know nothing, nothing, nothing about suspend. I'll try to guess.
> > 
> >    Commit: ed746e3b18f4df18afa3763155972c5835f284c5
> 
> > Yes? with the patch above, _cpu_down() called _after_ freeze_processes() ???
> 
> perfect :)
> See also my original mail and the thread:
> http://thread.gmane.org/gmane.linux.power-management.general/4314
> 
> > How about other kthread_stop()s ? For example, kernel/softirq.c:cpu_callback() ?
> 
> I'd they should be affected as well. For me, I guess I haven't run into
> them because xfs is enough to freeze the box ;) As for Rafael, I don't
> know why he isn't seeing that... I haven't been able to test this patch
> on my quad powermac so far unfortunately, been sick and away from the
> machine. I'll probably be able to test tomorrow.

They will be affected. In our first implemetentation of 
general "cpu_down after freeze"(http://lkml.org/lkml/2007/2/14/107)
we had a new state known CPU_DEAD_KILL_THREADS, 
the notifications for which were being sent
*after* we thawed the processes in __cpu_down.

However, in the version which we are working on, we are thawing processes
individually in CPU_DEAD before cleaning/stopping them.

I haven't observed any bad lockups/freeze chills with this approach. 
But I need to test it a bit more before posting them.

regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
