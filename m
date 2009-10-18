Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZJRXQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZJRXQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 19:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZJRXQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 19:16:25 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:60647 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781AbZJRXQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 19:16:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEAL4720pMRK1g/2dsb2JhbACBU9dqhDEEhFA
Date: Sun, 18 Oct 2009 19:16:24 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
       ltt-dev@lists.casi.polymtl.ca, Jon Bernard <jbernard@debian.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [ltt-dev] [rp] Userspace RCU 0.2.3
Message-ID: <20091018231624.GC5946@Krystal>
References: <20091014223657.GC6458@Krystal> <20091015000225.GG6763@linux.vnet.ibm.com> <20091015023925.GA27959@Krystal> <20091015090042.GA7677@feather> <4AD75EA6.8080809@polymtl.ca> <20091017171615.GD1526@ucw.cz> <20091018220243.GA32405@Krystal> <20091018225234.GA9164@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091018225234.GA9164@elf.ucw.cz>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:15:59 up 61 days, 10:05,  3 users,  load average: 0.50, 0.66,
	0.57
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@ucw.cz) wrote:
> On Sun 2009-10-18 18:02:43, Mathieu Desnoyers wrote:
> > * Pavel Machek (pavel@ucw.cz) wrote:
> > > On Thu 2009-10-15 13:40:54, Pierre-Marc Fournier wrote:
> > > > Josh Triplett wrote:
> > > > > 
> > > > > Even Debian has given up on real 386 systems at this point, primarily
> > > > > because system libraries like glibc have; 486 and better represents the
> > > > > bare minimum required at this point.  I don't know of any distributions
> > > > > supporting real 386 systems at this point, and doing so would represent
> > > > > a major undertaking.
> > > > > 
> > > > 
> > > > What about embedded systems? Anyone know if some 386 chips, perhaps even
> > > > in smp configurations, are still in use in those?
> > > 
> > > smp 386: definitely not.
> > 
> > Hrm, so for UP 386, I wonder what's the best approach.
> > 
> > One would be to encapsulate all write accesses to the RCU pointers. If
> > we detect that the architecture lacks cmpxchg, _all_ update operations
> > (rcu_assign_pointer, rcu_xchg_pointer and rcu_cmpxchg_pointer) would
> > have to use the signal-disabled+mutex fall-back.
> > 
> > Does it make sense ?
> 
> Yep, but it sounds expensive. Another option is to ignore the issue
> and see how many people still have 386s :-). Few  embedded  systems
> may be affected, but...
> 

I can keep that as a special build option, e.g.

target: i386

Mathieu

> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
