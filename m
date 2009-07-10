Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZGJPYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZGJPYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZGJPYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:24:33 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:36361 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZGJPYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XRsV6KjaqVIeKqrFNq47nhpjTQajK8zWdQW4JUw53wHYB0KrmUfRm7fNJdIYIoNZb6
         ENBJyhuViqnW75rU7dMS/sUD3BWXCPMMkgvFXB26cT2fLNctMHuUWxxfsDU2xJr8wZ0Q
         eA/GyIiFpgz+padtkZyVjhluwPzwvEKjlhWjM=
Date: Fri, 10 Jul 2009 17:24:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] sched: Drop the need_resched() loop from
	cond_resched()
Message-ID: <20090710152425.GB5318@nowhere>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com> <200907101717.39460.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907101717.39460.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 05:17:38PM +0200, Arnd Bergmann wrote:
> On Friday 10 July 2009, Frederic Weisbecker wrote:
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -6613,11 +6613,9 @@ static void __cond_resched(void)
> >          * PREEMPT_ACTIVE, which could trigger a second
> >          * cond_resched() call.
> >          */
> > -       do {
> > -               add_preempt_count(PREEMPT_ACTIVE);
> > -               schedule();
> > -               sub_preempt_count(PREEMPT_ACTIVE);
> > -       } while (need_resched());
> > +       add_preempt_count(PREEMPT_ACTIVE);
> > +       schedule();
> > +       sub_preempt_count(PREEMPT_ACTIVE);
> >  }
> >  
> 
> If you drop the loop, then you should also remove the comment that
> explains why it was put there.
> 
> 	Arnd <><

Hmm, these comments seem to actually explain why we do the PREEMPT_ACTIVE
trick, which is to prevent from cond_resched() recursion, right?

