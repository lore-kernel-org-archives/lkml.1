Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZIUVs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZIUVs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZIUVsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:48:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbZIUVsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:48:54 -0400
Date: Mon, 21 Sep 2009 17:48:36 -0400 (EDT)
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, tglx@linutronix.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Message-ID: <688625294.427351253569716504.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1253567867.2935.4.camel@frodo>
Subject: Re: [PATCH] ib-release-locks-in-the-proper-order
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Steven Rostedt" <rostedt@goodmis.org> wrote:

> On Mon, 2009-09-21 at 21:35 +0200, John Kacur wrote:
> > Please consider the following patch - originally from Steven
> Rostedt. 
> > It solves a problem for rt which is very sensitive to the lock
> ordering. 
> > It should have a no impact on non-rt.
> > 
> > The patch applies to current tip/master - but it is fine with me if
> it 
> > would be more appropriate for one of the infiniband people to take
> it.
> > 
> > Thanks
> > 
> > >From e533f2b9ee9b0bd95aaa4c3369e79b350c9895d3 Mon Sep 17 00:00:00
> 2001
> > From: Steven Rostedt <srostedt@redhat.com>
> > Date: Mon, 21 Sep 2009 21:23:46 +0200
> > Subject: [PATCH] ib: release locks in the proper order
> > 
> > RT is very sensitive to the order locks are taken and released
> > wrt read write locks. We must do
> > 
> >   lock(a);
> >   lock(b);
> >   lock(c);
> > 
> >   [...]
> > 
> >   unlock(c);
> >   unlock(b);
> >   unlock(a);
> > 
> > otherwise bad things can happen.
> > 
> > Signed-off-by: Ken Cox <jkc@redhat.com>
> > Signed-off-by: Clark Williams <williams@redhat.com>
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> 
> The -rt patch doesn't use the multi rwlock code anymore (the reason
> for
> the first patch), and the last revision of that code was able to
> handle
> that too.
> 
> Linus totally ripped into this idea. A lock must be able to handle
> any
> order of unlocking. There should be no technical reason a lock must
> be
> unlocked in reverse order they were locked.
> 
> What exactly is sensitive about this?
> 

Thanks Steve!
I hereby withdraw this patch!!!!
