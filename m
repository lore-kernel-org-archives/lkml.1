Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbZLKWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbZLKWBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761488AbZLKWBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:01:15 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33944 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761503AbZLKWBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:01:14 -0500
Date: Fri, 11 Dec 2009 14:01:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Vegard Nossum <vegardno@ifi.uio.no>
Subject: Re: [patch 8/9] Documentation: Fix invalid rcu assumptions
Message-ID: <20091211220117.GE6803@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091210001308.247025548@linutronix.de> <20091210004703.308396881@linutronix.de> <200912112128.25954.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912112128.25954.arnd@arndb.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 09:28:25PM +0000, Arnd Bergmann wrote:
> On Thursday 10 December 2009 00:53:26 Thomas Gleixner wrote:
> > Index: linux-2.6-tip/Documentation/credentials.txt
> > ===================================================================
> > --- linux-2.6-tip.orig/Documentation/credentials.txt
> > +++ linux-2.6-tip/Documentation/credentials.txt
> > @@ -408,9 +408,6 @@ This should be used inside the RCU read 
> >                 ...
> >         }
> >  
> > -A function need not get RCU read lock to use __task_cred() if it is holding a
> > -spinlock at the time as this implicitly holds the RCU read lock.
> > -
> >  Should it be necessary to hold another task's credentials for a long period of
> >  time, and possibly to sleep whilst doing so, then the caller should get a
> >  reference on them using:
> 
> How about changing the documentation to explain why you can't just use a spinlock
> or local_irq_disable instead of rcu_read_lock? You explained it well in your
> [patch 0/9], but that part had not occurred to me yet and having it in the kernel
> sources might prevent more people from getting it wrong in the future.

That does make a lot of sense...  Will add that in.

							Thanx, Paul
