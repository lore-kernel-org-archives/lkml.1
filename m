Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbXCLWjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbXCLWjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbXCLWjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:39:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40651 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751592AbXCLWjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:39:19 -0400
Date: Mon, 12 Mar 2007 23:39:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070312223906.GA9749@elf.ucw.cz>
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz> <200703121219.12072.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703121219.12072.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Looks good to me!  The other kthread_should_stop() calls in
> > > rcutorture.c should also become
> > > kthread_should_top_check_freeze().

> > Why is it useful?
> 
> Because we want to avoid repeating
> 
> while (!kthread_should_stop()) {
> 	try_to_freeze();
> 	...
> }
> 
> in many places?

Do not do it, then. Confusion it causes is not worth saving one line
of code. 

You do less typing, but the resulting code is _less_ readable, not
more.

NAK.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
