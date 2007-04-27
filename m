Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbXD0Vpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbXD0Vpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbXD0Vpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:45:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58783 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXD0Vpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:45:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [PATCH -mm 2/2] Introduce freezer flags
Date: Fri, 27 Apr 2007 23:49:35 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
References: <200704271737.31192.rjw@sisk.pl> <200704271740.17972.rjw@sisk.pl> <20070427214047.GA21224@in.ibm.com>
In-Reply-To: <20070427214047.GA21224@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704272349.36736.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 23:40, Gautham R Shenoy wrote:
> On Fri, Apr 27, 2007 at 05:40:16PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Move all of the freezer-related flags to a separate field in task_struct and
> > introduce functions to operate them using set_bit() etc.
> > 
> > 
> > Index: linux-2.6.21-rc7-mm2/include/linux/sched.h
> > ===================================================================
> > --- linux-2.6.21-rc7-mm2.orig/include/linux/sched.h
> > +++ linux-2.6.21-rc7-mm2/include/linux/sched.h
> > @@ -1006,7 +1006,10 @@ struct task_struct {
> >  	/* Deadlock detection and priority inheritance handling */
> >  	struct rt_mutex_waiter *pi_blocked_on;
> >  #endif
> > -
> > +#ifdef CONFIG_FREEZER
> > +	/* Used by the process freezer, defined in freezer.h */
> > +	unsigned int freezer_flags;
> 
> unsigned long freezer_flags; ??

I guess so.

> Else it throws the following warnings.

On which arch is that?  I've tested on x86_64 ...

> include/linux/freezer.h: In function `frozen':
> include/linux/freezer.h:22: warning: passing arg 2 of
> `constant_test_bit' from incompatible pointer type
> include/linux/freezer.h:22: warning: passing arg 2 of
> `variable_test_bit' from incompatible pointer type
> include/linux/freezer.h: In function `set_frozen_flag':
> include/linux/freezer.h:27: warning: passing arg 2 of `set_bit' from
> incompatible pointer type
> include/linux/freezer.h: In function `clear_frozen_flag':
> include/linux/freezer.h:32: warning: passing arg 2 of `clear_bit' from
> incompatible pointer type
> include/linux/freezer.h: In function `freezing':
> include/linux/freezer.h:40: warning: passing arg 2 of
> `constant_test_bit' from incompatible pointer type
> include/linux/freezer.h:40: warning: passing arg 2 of
> `variable_test_bit' from incompatible pointer type
> include/linux/freezer.h: In function `freeze':
> include/linux/freezer.h:48: warning: passing arg 2 of `set_bit' from
> incompatible pointer type
> include/linux/freezer.h: In function `clear_freeze_flag':
> include/linux/freezer.h:56: warning: passing arg 2 of `clear_bit' from
> incompatible pointer type
> include/linux/freezer.h: In function `freezer_should_exempt':
> include/linux/freezer.h:64: warning: passing arg 2 of
> `constant_test_bit' from incompatible pointer type
> include/linux/freezer.h:64: warning: passing arg 2 of
> `variable_test_bit' from incompatible pointer type
> include/linux/freezer.h: In function `freezer_exempt':
> include/linux/freezer.h:72: warning: passing arg 2 of `set_bit' from
> incompatible pointer type
> include/linux/freezer.h: In function `freezer_do_not_count':
> include/linux/freezer.h:132: warning: passing arg 2 of `set_bit' from
> incompatible pointer type
> include/linux/freezer.h: In function `freezer_count':
> include/linux/freezer.h:142: warning: passing arg 2 of `clear_bit' from
> incompatible pointer type
> include/linux/freezer.h: In function `freezer_should_skip':
> include/linux/freezer.h:152: warning: passing arg 2 of
> `constant_test_bit' from incompatible pointer type
> include/linux/freezer.h:152: warning: passing arg 2 of
> `variable_test_bit' from incompatible pointer type

Greetings,
Rafael
