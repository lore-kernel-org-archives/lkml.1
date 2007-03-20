Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbXCTSJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbXCTSJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXCTSJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:09:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60586 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752675AbXCTSJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:09:05 -0400
Date: Tue, 20 Mar 2007 19:08:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Anton Blanchard <anton@samba.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070320180857.GC2593@elf.ucw.cz>
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz> <200703121219.12072.rjw@sisk.pl> <20070312223906.GA9749@elf.ucw.cz> <20070312224524.GB807@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312224524.GB807@kryten>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Do not do it, then. Confusion it causes is not worth saving one line
> > of code. 
> > 
> > You do less typing, but the resulting code is _less_ readable, not
> > more.
> 
> Then please document it _clearly_ with the kthread code somewhere. The
> reason I brought this up is I had no idea we had to put the freezer gunk
> in all kernel thread loops and Ive been writing kernel threads for years.

This is in Doc*/power/kernel_threads.txt:

KERNEL THREADS


Freezer

Upon entering a suspended state the system will freeze all
tasks. This is done by delivering pseudosignals. This affects
kernel threads, too. To successfully freeze a kernel thread
the thread has to check for the pseudosignal and enter the
refrigerator. Code to do this looks like this:

        do {
                hub_events();
                wait_event_interruptible(khubd_wait,
!list_empty(&hub_event_list));
                try_to_freeze();
        } while (!signal_pending(current));


...do you know about better place?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
