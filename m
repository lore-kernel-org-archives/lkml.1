Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbXDWUqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbXDWUqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXDWUqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:46:51 -0400
Received: from mail.screens.ru ([213.234.233.54]:52616 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXDWUqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:46:50 -0400
Date: Tue, 24 Apr 2007 00:46:37 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC][PATCH -mm 3/3] freezer: Fix problem with kthread_stop
Message-ID: <20070423204637.GA441@tv-sign.ru>
References: <20070419120131.GB13435@in.ibm.com> <200704222141.00680.rjw@sisk.pl> <20070423123558.GC25144@in.ibm.com> <200704232155.36820.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704232155.36820.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Rafael J. Wysocki wrote:
>
> On Monday, 23 April 2007 14:35, Gautham R Shenoy wrote:
> > > +	if (!freezer_should_exempt(current)) {
> > 		task_lock(k);
> > > +		/* We are freezable, so we must make sure that the thread being
> > > +		 * stopped is not frozen and will not be frozen until it dies
> > > +		 */
> > > +		freezer_exempt(k);
> > > +		if (frozen(k))
> > > +			clear_frozen_flag(k);
> > 		task_unlock(k);
> > > +	}
> 
> Yes, that's correct.  We need to take task_lock() to avoid the race with
> refrigerator().

Even if we use thaw_task() ?

Even if I am wrong, I think we should not use task_lock() for the freezing
related code, except in freezer.[ch]

Note also that without CONFIG_FREEZER freezer_should_exempt() == 0, so we
will do unneeded task_lock/task_unlock.

Oleg.

