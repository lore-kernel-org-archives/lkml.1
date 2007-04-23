Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbXDWVS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbXDWVS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbXDWVS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:18:28 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52264 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbXDWVS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:18:27 -0400
Date: Tue, 24 Apr 2007 02:46:16 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com,
       pavel@ucw.cz
Subject: Re: [RFC][PATCH -mm 3/3] freezer: Fix problem with kthread_stop
Message-ID: <20070423211616.GA27214@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <200704222141.00680.rjw@sisk.pl> <20070423123558.GC25144@in.ibm.com> <200704232155.36820.rjw@sisk.pl> <20070423204637.GA441@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423204637.GA441@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 12:46:37AM +0400, Oleg Nesterov wrote:
> On 04/23, Rafael J. Wysocki wrote:
> >
> > On Monday, 23 April 2007 14:35, Gautham R Shenoy wrote:
> > > > +	if (!freezer_should_exempt(current)) {
> > > 		task_lock(k);
> > > > +		/* We are freezable, so we must make sure that the thread being
> > > > +		 * stopped is not frozen and will not be frozen until it dies
> > > > +		 */
> > > > +		freezer_exempt(k);
> > > > +		if (frozen(k))
> > > > +			clear_frozen_flag(k);
> > > 		task_unlock(k);
> > > > +	}
> > 
> > Yes, that's correct.  We need to take task_lock() to avoid the race with
> > refrigerator().
> 
> Even if we use thaw_task() ?

I don't think so. As you correctly pointed out, thaw_task() is race free
w.r.t the refrigerator(). 

> 
> Even if I am wrong, I think we should not use task_lock() for the freezing
> related code, except in freezer.[ch]
> 
> Note also that without CONFIG_FREEZER freezer_should_exempt() == 0, so we
> will do unneeded task_lock/task_unlock.
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
