Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbXDWWgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbXDWWgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbXDWWgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:36:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34941 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbXDWWgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:36:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Date: Tue, 24 Apr 2007 00:40:17 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <200704222139.27128.rjw@sisk.pl> <20070423222358.GA627@tv-sign.ru>
In-Reply-To: <20070423222358.GA627@tv-sign.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704240040.18312.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 April 2007 00:23, Oleg Nesterov wrote:
> On 04/22, Rafael J. Wysocki wrote:
> > 
> > Move all of the freezer-related flags to a separate field in task_struct and
> > introduce functions to operate them using set_bit() etc.
> >
> > [...snip...]
> >
> > --- linux-2.6.21-rc6-mm1.orig/kernel/fork.c	2007-04-22 19:37:42.000000000 +0200
> > +++ linux-2.6.21-rc6-mm1/kernel/fork.c	2007-04-22 20:55:01.000000000 +0200
> > @@ -922,7 +922,7 @@ static inline void copy_flags(unsigned l
> >  {
> >  	unsigned long new_flags = p->flags;
> >  
> > -	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
> > +	new_flags &= ~PF_SUPERPRIV;
> >  	new_flags |= PF_FORKNOEXEC;
> >  	new_flags |= PF_STARTING;
> >  	p->flags = new_flags;
> 
> OK, but you forgot to clear p->freezer_flags on copy_process()->dup_task_struct()
> path ?

Yes, thanks for pointing that out.

Should I clear it in dup_task_struct() or is there a better place?
