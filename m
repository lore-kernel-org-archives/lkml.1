Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbXEaOuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbXEaOuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXEaOud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:50:33 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57732 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbXEaOuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:50:32 -0400
Subject: Re: [BUG] futex_unlock_pi() hurts my brain and may cause
	application deadlock
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Sripathi Kodi <sripathik@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20070531142455.GA11310@elte.hu>
References: <1180572567.6126.44.camel@localhost.localdomain>
	 <20070531142455.GA11310@elte.hu>
Content-Type: text/plain
Date: Thu, 31 May 2007 07:50:27 -0700
Message-Id: <1180623027.17878.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-31 at 16:24 +0200, Ingo Molnar wrote:
> * john stultz <johnstul@us.ibm.com> wrote:
> 
> > 	So we've been seeing PI mutex deadlocks with a few of our 
> > applications using the -rt kernel. After narrowing things down, we 
> > were finding that the applications were indirectly calling 
> > futex_unlock_pi(), which on occasion would return -EFAULT, which is 
> > promptly ignored by glibc. This would cause the application to 
> > continue on as if it has unlocked the mutex, until it tried to 
> > reacquire it and deadlock.
> 
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -2011,6 +2011,7 @@ pi_faulted:
> >  					 attempt);
> >  		if (ret)
> >  			goto out_unlock;
> > +		uval = 0;
> >  		goto retry_locked;
> 
> this looks good to me. Oleg has posted a few more fixes as well - have 
> you tried those too?

Do you have a URL or subject line for the discussion? 
I'll take a look and give them a whirl.

thanks
-john

