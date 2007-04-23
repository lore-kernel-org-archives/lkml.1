Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbXDWWy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbXDWWy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbXDWWy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:54:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34999 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbXDWWy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:54:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Date: Tue, 24 Apr 2007 00:55:00 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <200704240040.18312.rjw@sisk.pl> <20070423224142.GA30024@in.ibm.com>
In-Reply-To: <20070423224142.GA30024@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704240055.01581.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 April 2007 00:41, Gautham R Shenoy wrote:
> On Tue, Apr 24, 2007 at 12:40:17AM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 24 April 2007 00:23, Oleg Nesterov wrote:
> > > On 04/22, Rafael J. Wysocki wrote:
> > > > 
> > > > Move all of the freezer-related flags to a separate field in task_struct and
> > > > introduce functions to operate them using set_bit() etc.
> > > >
> > > > [...snip...]
> > > >
> > > > --- linux-2.6.21-rc6-mm1.orig/kernel/fork.c	2007-04-22 19:37:42.000000000 +0200
> > > > +++ linux-2.6.21-rc6-mm1/kernel/fork.c	2007-04-22 20:55:01.000000000 +0200
> > > > @@ -922,7 +922,7 @@ static inline void copy_flags(unsigned l
> > > >  {
> > > >  	unsigned long new_flags = p->flags;
> > > >  
> > > > -	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
> > > > +	new_flags &= ~PF_SUPERPRIV;
> > > >  	new_flags |= PF_FORKNOEXEC;
> > > >  	new_flags |= PF_STARTING;
> > > >  	p->flags = new_flags;
> > > 
> > > OK, but you forgot to clear p->freezer_flags on copy_process()->dup_task_struct()
> > > path ?
> > 
> > Yes, thanks for pointing that out.
> 
> That reminds me, shouldn't we set the child's TFF_FREEZE flag if the parent
> is freezing or frozen? 

Well, usually we'll want to freeze the child too in such cases, but I'm not
sure if that's always true.

Greetings,
Rafael
