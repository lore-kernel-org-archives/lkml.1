Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbXCTSKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbXCTSKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXCTSKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:10:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60600 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965589AbXCTSKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:10:14 -0400
Date: Tue, 20 Mar 2007 19:10:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070320181001.GD2593@elf.ucw.cz>
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz> <200703121219.12072.rjw@sisk.pl> <20070312223906.GA9749@elf.ucw.cz> <20070313005805.GB3666@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313005805.GB3666@linux.vnet.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-03-12 17:58:05, Paul E. McKenney wrote:
> On Mon, Mar 12, 2007 at 11:39:06PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > > > Looks good to me!  The other kthread_should_stop() calls in
> > > > > rcutorture.c should also become
> > > > > kthread_should_top_check_freeze().
> > 
> > > > Why is it useful?
> > > 
> > > Because we want to avoid repeating
> > > 
> > > while (!kthread_should_stop()) {
> > > 	try_to_freeze();
> > > 	...
> > > }
> > > 
> > > in many places?
> > 
> > Do not do it, then. Confusion it causes is not worth saving one line
> > of code. 
> > 
> > You do less typing, but the resulting code is _less_ readable, not
> > more.
> > 
> > NAK.
> 
> Another problem is people doing "kthread_should_stop()" and forgetting
> about freezing.  Then we continue ending up with situations where weare
> intermittently unable to freeze.  In the spirit of "Rusty Scale" interface

No, in such case we end up with situation when it is impossible to
freeze, and that's very easy to debug.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
