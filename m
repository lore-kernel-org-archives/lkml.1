Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbXD0WFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbXD0WFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757472AbXD0WFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:05:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbXD0WE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:04:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [PATCH -mm 2/2] Introduce freezer flags
Date: Sat, 28 Apr 2007 00:09:18 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
References: <200704271737.31192.rjw@sisk.pl> <20070427214047.GA21224@in.ibm.com> <200704272349.36736.rjw@sisk.pl>
In-Reply-To: <200704272349.36736.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704280009.19639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 23:49, Rafael J. Wysocki wrote:
> On Friday, 27 April 2007 23:40, Gautham R Shenoy wrote:
> > On Fri, Apr 27, 2007 at 05:40:16PM +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Move all of the freezer-related flags to a separate field in task_struct and
> > > introduce functions to operate them using set_bit() etc.
> > > 
> > > 
> > > Index: linux-2.6.21-rc7-mm2/include/linux/sched.h
> > > ===================================================================
> > > --- linux-2.6.21-rc7-mm2.orig/include/linux/sched.h
> > > +++ linux-2.6.21-rc7-mm2/include/linux/sched.h
> > > @@ -1006,7 +1006,10 @@ struct task_struct {
> > >  	/* Deadlock detection and priority inheritance handling */
> > >  	struct rt_mutex_waiter *pi_blocked_on;
> > >  #endif
> > > -
> > > +#ifdef CONFIG_FREEZER
> > > +	/* Used by the process freezer, defined in freezer.h */
> > > +	unsigned int freezer_flags;
> > 
> > unsigned long freezer_flags; ??
> 
> I guess so.

Still, on x86_64, for example, we'll waste 4 bytes by using 'unsigned long'
here, which I wouldn't like to do.

Is it acceptable to use explicit type casting in set_bit() and friends?

Rafael
