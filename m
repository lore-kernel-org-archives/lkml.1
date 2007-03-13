Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbXCQT3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbXCQT3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 15:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXCQT3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 15:29:53 -0400
Received: from pool-71-111-94-253.ptldor.dsl-w.verizon.net ([71.111.94.253]:29917
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753798AbXCQT3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 15:29:52 -0400
Date: Mon, 12 Mar 2007 17:58:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       Anton Blanchard <anton@samba.org>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH] kthread_should_stop_check_freeze (was: Re: [PATCH -mm 3/7] Freezer: Remove PF_NOFREEZE from rcutorture thread)
Message-ID: <20070313005805.GB3666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200702260800.49603.rjw@sisk.pl> <20070312043854.GA4124@linux.vnet.ibm.com> <20070312081459.GI5242@elf.ucw.cz> <200703121219.12072.rjw@sisk.pl> <20070312223906.GA9749@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312223906.GA9749@elf.ucw.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 11:39:06PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > Looks good to me!  The other kthread_should_stop() calls in
> > > > rcutorture.c should also become
> > > > kthread_should_top_check_freeze().
> 
> > > Why is it useful?
> > 
> > Because we want to avoid repeating
> > 
> > while (!kthread_should_stop()) {
> > 	try_to_freeze();
> > 	...
> > }
> > 
> > in many places?
> 
> Do not do it, then. Confusion it causes is not worth saving one line
> of code. 
> 
> You do less typing, but the resulting code is _less_ readable, not
> more.
> 
> NAK.

Another problem is people doing "kthread_should_stop()" and forgetting
about freezing.  Then we continue ending up with situations where we are
intermittently unable to freeze.  In the spirit of "Rusty Scale" interface
design, how do we make it difficult for people to misuse this interface?

						Thanx, Paul
