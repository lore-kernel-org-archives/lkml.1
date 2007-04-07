Return-Path: <linux-kernel-owner+w=401wt.eu-S965679AbXDGJru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965679AbXDGJru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965650AbXDGJrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:47:49 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:52338 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965679AbXDGJrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:47:48 -0400
Subject: Re: [PATCH 1/8] Enhance process freezer interface for usage beyond
	software suspend
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
In-Reply-To: <200704071133.42269.rjw@sisk.pl>
References: <20070402053457.GA9076@in.ibm.com>
	 <200704061634.51046.rjw@sisk.pl>
	 <1175898055.6481.83.camel@nigel.suspend2.net>
	 <200704071133.42269.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 19:47:45 +1000
Message-Id: <1175939265.3894.1.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2007-04-07 at 11:33 +0200, Rafael J. Wysocki wrote:
> On Saturday, 7 April 2007 00:20, Nigel Cunningham wrote:
> > > > > > > -	current->flags |= PF_NOFREEZE;
> > > > > > > +	freezer_exempt(FE_ALL);
> > > > > > >  	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
> > > > > > >  	if (pid > 0) {
> > > > > > >  		while (pid != sys_wait4(-1, NULL, 0, NULL))
> > > > > > 
> > > > > > Does this mean we have userland /linuxrc running with PF_NOFREEZE?
> > > > > > That would be very bad...
> > > > > 
> > > > > No, actually it is _required_ for the userland resume to work.  Well, perhaps
> > > > > I should place a comment in there so that I don't have to explain this again
> > > > > and again. :-)
> > > > 
> > > > Can you put big bold comment there?
> > > >
> > > > Why is it needed? Freezer never freezes _current_ task.
> > > 
> > > No, it doesn't, but this task spawns linuxrc and then calls sys_wait4() in a
> > > loop.
> > > 
> > > Well, actually, I'll try to plant try_to_freeze() in this loop and see if that
> > > works.  If it doesn't, I'll add a comment.
> > 
> > It works. I've had:
> > 
> >                 while (pid != sys_wait4(-1, NULL, 0, NULL)) {
> >                         yield();
> >                         try_to_freeze();
> >                 }
> > 
> > there for ages for Suspend2.
> 
> OK, thanks.  Is there any particular reason to place try_to_freeze() after
> yield()?

Not that I remember. I haven't touched that for years :)

Nigel

