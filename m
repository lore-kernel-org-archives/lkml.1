Return-Path: <linux-kernel-owner+w=401wt.eu-S938602AbZDJNjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938602AbZDJNjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936389AbZDJNiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:38:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:52036 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762743AbZDJNis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:38:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qq5j0OzBeXkivpddEQ8RlpICREailCtlSpTa6lCu0m409ZjnhIc2jGCCIlyp1mzeOd
         8z1dlyjc83QrdRlzk5p5TMGebyrqV4aZ34fiZBkKTRApdGNo28Cvj2NI8vIYHk2tH/jD
         /uvhPdx9x7sy4TxXoq9T6DI1zYbOG5WlCOLFE=
Date: Fri, 10 Apr 2009 15:38:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] lockdep: choose to continue lock debugging despite
	taint
Message-ID: <20090410133844.GD5988@nowhere>
References: <1239312460-13396-1-git-send-email-fweisbec@gmail.com> <1239312460-13396-2-git-send-email-fweisbec@gmail.com> <20090410121515.GP21506@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410121515.GP21506@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 02:15:15PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Lockdep is disabled after any kernel taints. This might be 
> > convenient to ignore bad locking issues which sources come from 
> > outside the kernel tree. Nevertheless, it might be a frustrating 
> > experience for the staging developers or anyone who might develop 
> > a kernel that happens to be tainted.
> 
> Good point. Not having lockdep coverage for drivers/staging/ just 
> prolongs their transition - not good.
> 
> But instead of this:
> 
> >  void add_taint(unsigned flag)
> >  {
> > +#ifndef CONFIG_LOCKDEP_IGNORE_TAINT
> >  	/*
> >  	 * Can't trust the integrity of the kernel anymore.
> >  	 * We don't call directly debug_locks_off() because the issue
> > @@ -220,6 +221,7 @@ void add_taint(unsigned flag)
> >  	 */
> >  	if (xchg(&debug_locks, 0))
> >  		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
> > +#endif
> 
> I'd suggest to not do the debug_locks_off() call if TAINT_CRAP. I.e. 
> something like:
> 
> 	if (!(flag & TAINT_CRAP) && debug_locks_off())
> 		printk(...);
> 
> will do the trick.
> 
> 	Ingo


Ok, but this is not only about staging. It's also about TAINT_WARN.
Just imagine that you report a warning to a maintainer, and while
you are waiting for it to be fixed, you can't use lockdep for your
own needs.

Hm?

Frederic.

