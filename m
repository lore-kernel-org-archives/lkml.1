Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbXDKNdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbXDKNdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 09:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXDKNdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 09:33:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55608 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbXDKNdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 09:33:11 -0400
Date: Wed, 11 Apr 2007 19:01:39 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com
Subject: Re: [PATCH] kthread: Don't depend on work queues
Message-ID: <20070411133139.GB10623@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070410185133.GA104@tv-sign.ru> <m13b37v517.fsf@ebiederm.dsl.xmission.com> <20070411000316.52f2551e.akpm@linux-foundation.org> <200704111213.35523.rjw@sisk.pl> <20070411112105.GA24813@in.ibm.com> <20070411114805.GA165@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411114805.GA165@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 03:48:05PM +0400, Oleg Nesterov wrote:
> On 04/11, Gautham R Shenoy wrote:
> >
> > On Wed, Apr 11, 2007 at 12:13:34PM +0200, Rafael J. Wysocki wrote:
> > > 
> > > It should be calling try_to_freeze() somewhere anyway.  We may need to freeze
> > > all tasks in some cases.
> > 
> > How about
> > for (;;) {
> > 	try_to_freeze();
> > 
> > ?
> 
> Why?

If some event (defintely NOT cpu hotplug) needs this thread frozen.

> 
> > This change allows us to make all the worker threads freezeable by default.
> > >From cpu-hotplug perspective, helper_wq was the only singlethreaded
> > non-freezeable workqueue.
> 
> I think Eric's patch is what you need. We should _not_ freeze kthreadd(), we
> need kthread_create() after freezing. Now it doesn't depend on workqueues, we
> can freeze them all, single-thread or not.
> 

These were my exact thoughts. 

> I like this patch.

Same here. 

> 
> Oleg.
> 

Thanks and Regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
