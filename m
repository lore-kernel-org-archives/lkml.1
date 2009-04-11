Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZDKBiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZDKBiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 21:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZDKBh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 21:37:59 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:60807 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZDKBh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 21:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PXuammnUJXEXSQUfW423/HaeixjDZmEGOJ/wr28cd2/vKIMaaGjmz9xcQEs3gLmhUY
         yW3ZEa5Cd3cor9KDcD9vaco1QS/nGMKei6Hap41w3rAtIcu8YdUpnE6ED2aZkwHtqGtZ
         KQIIEOOdyNTygKIRXPinm6vAUHXUr+89FH6Yk=
Date: Sat, 11 Apr 2009 03:37:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] lockdep: choose to continue lock debugging despite
	taint
Message-ID: <20090411013753.GB5992@nowhere>
References: <1239312460-13396-1-git-send-email-fweisbec@gmail.com> <1239312460-13396-2-git-send-email-fweisbec@gmail.com> <20090410121515.GP21506@elte.hu> <20090410133844.GD5988@nowhere> <20090410134520.GC17878@elte.hu> <20090411011505.GA5992@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411011505.GA5992@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 03:15:06AM +0200, Frederic Weisbecker wrote:
> On Fri, Apr 10, 2009 at 03:45:20PM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Fri, Apr 10, 2009 at 02:15:15PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > 
> > > > > Lockdep is disabled after any kernel taints. This might be 
> > > > > convenient to ignore bad locking issues which sources come from 
> > > > > outside the kernel tree. Nevertheless, it might be a frustrating 
> > > > > experience for the staging developers or anyone who might develop 
> > > > > a kernel that happens to be tainted.
> > > > 
> > > > Good point. Not having lockdep coverage for drivers/staging/ just 
> > > > prolongs their transition - not good.
> > > > 
> > > > But instead of this:
> > > > 
> > > > >  void add_taint(unsigned flag)
> > > > >  {
> > > > > +#ifndef CONFIG_LOCKDEP_IGNORE_TAINT
> > > > >  	/*
> > > > >  	 * Can't trust the integrity of the kernel anymore.
> > > > >  	 * We don't call directly debug_locks_off() because the issue
> > > > > @@ -220,6 +221,7 @@ void add_taint(unsigned flag)
> > > > >  	 */
> > > > >  	if (xchg(&debug_locks, 0))
> > > > >  		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
> > > > > +#endif
> > > > 
> > > > I'd suggest to not do the debug_locks_off() call if TAINT_CRAP. I.e. 
> > > > something like:
> > > > 
> > > > 	if (!(flag & TAINT_CRAP) && debug_locks_off())
> > > > 		printk(...);
> > > > 
> > > > will do the trick.
> > > > 
> > > > 	Ingo
> > > 
> > > 
> > > Ok, but this is not only about staging. It's also about 
> > > TAINT_WARN. Just imagine that you report a warning to a 
> > > maintainer, and while you are waiting for it to be fixed, you 
> > > can't use lockdep for your own needs.
> > > 
> > > Hm?
> > 
> > We can exclude TAINT_WARN too - i.e. (TAINT_CRAP|TAINT_WARN).
> > 
> > 	Ingo
> 
> 
> Fine :-)
> 
> See the v2 on further mails in this thread.
> 
> Side request: do you think you could merge them on kill-the-BKL tree?


Sorry, forget about this side request. I thought merging tip:master
into tip:core/kill-the-BKL would make me suffer a rain of conflicts
but actually I've just tried and I only encountered a very simple
conflict in sched.c so it's very easy to manage it locally. Then
we can keep the history of kill-the-BKL, for now it's good as is.

Frederic.


> Thanks!
> 

