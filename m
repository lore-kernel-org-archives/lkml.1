Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbZDKBP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbZDKBP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 21:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZDKBPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 21:15:13 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:38019 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbZDKBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 21:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U7saM15EPBbboiW5RqdKrIK6tqsuxG6sTNP/aRbx4mSQ1SeJV5Xx8ZQKZY/EPI7gAn
         OhjjIH6ass5FgezZZ/LMCWTrxCLba3oB2W/IaDMs2YnJijqVW0L+Lt3YY1KRv6aA6Cqo
         zCiWrbvvZpr6iWUmO8FTgIQJ27IN9onNuWaE8=
Date: Sat, 11 Apr 2009 03:15:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] lockdep: choose to continue lock debugging despite
	taint
Message-ID: <20090411011505.GA5992@nowhere>
References: <1239312460-13396-1-git-send-email-fweisbec@gmail.com> <1239312460-13396-2-git-send-email-fweisbec@gmail.com> <20090410121515.GP21506@elte.hu> <20090410133844.GD5988@nowhere> <20090410134520.GC17878@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410134520.GC17878@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 03:45:20PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, Apr 10, 2009 at 02:15:15PM +0200, Ingo Molnar wrote:
> > > 
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > Lockdep is disabled after any kernel taints. This might be 
> > > > convenient to ignore bad locking issues which sources come from 
> > > > outside the kernel tree. Nevertheless, it might be a frustrating 
> > > > experience for the staging developers or anyone who might develop 
> > > > a kernel that happens to be tainted.
> > > 
> > > Good point. Not having lockdep coverage for drivers/staging/ just 
> > > prolongs their transition - not good.
> > > 
> > > But instead of this:
> > > 
> > > >  void add_taint(unsigned flag)
> > > >  {
> > > > +#ifndef CONFIG_LOCKDEP_IGNORE_TAINT
> > > >  	/*
> > > >  	 * Can't trust the integrity of the kernel anymore.
> > > >  	 * We don't call directly debug_locks_off() because the issue
> > > > @@ -220,6 +221,7 @@ void add_taint(unsigned flag)
> > > >  	 */
> > > >  	if (xchg(&debug_locks, 0))
> > > >  		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
> > > > +#endif
> > > 
> > > I'd suggest to not do the debug_locks_off() call if TAINT_CRAP. I.e. 
> > > something like:
> > > 
> > > 	if (!(flag & TAINT_CRAP) && debug_locks_off())
> > > 		printk(...);
> > > 
> > > will do the trick.
> > > 
> > > 	Ingo
> > 
> > 
> > Ok, but this is not only about staging. It's also about 
> > TAINT_WARN. Just imagine that you report a warning to a 
> > maintainer, and while you are waiting for it to be fixed, you 
> > can't use lockdep for your own needs.
> > 
> > Hm?
> 
> We can exclude TAINT_WARN too - i.e. (TAINT_CRAP|TAINT_WARN).
> 
> 	Ingo


Fine :-)

See the v2 on further mails in this thread.

Side request: do you think you could merge them on kill-the-BKL tree?

Thanks!

