Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbYHAVKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbYHAVKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760424AbYHAVJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:09:29 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48454 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760743AbYHAVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:09:28 -0400
Date: Fri, 1 Aug 2008 14:09:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080801210924.GE14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org> <20080706165810.GA16189@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080706165810.GA16189@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 06:58:10PM +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
> > > Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
> > > Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> > > Date		: 2008-05-27 09:23 (41 days old)
> > > References	: http://lkml.org/lkml/2008/5/27/9
> > > 		  http://lkml.org/lkml/2008/6/14/87
> > > Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
> > > 		  Linus Torvalds <torvalds@linux-foundation.org>
> > > 		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Patch		: http://lkml.org/lkml/2008/5/28/16
> > 
> > This one is the same thing that is reported as unresolved, and no, I 
> > don't think that existing patch was ever really tested to fix 
> > anything. Paul?
> > 
> > I suspect SRCU will need to be simply marked BROKEN for now, because 
> > nobody knows what the problem Alexey sees is. Apparently it's been 
> > seen by a few other people too.
> 
> I'm not sure it's directly related to SRCU - it can change timings and 
> freeing patterns enough to tickle other bugs. Since Alexey Dobriyan has 
> reported it - are perhaps namespaces in use during this stress-test? 
> Maybe it's some namespaces related bug that is more easily reproduced 
> under SRCU - namespaces is not a commonly tested feature.

I have CONFIG_NAMESPACES=y.  Should I also set one or more of
CONFIG_UTS_NS, CONFIG_IPC_NS, CONFIG_USER_NS, or CONFIG_PID_NS?

What the heck, I will just set them all and pound away on kernbenchx170
and rcutorture.

							Thanx, Paul

> Also, i've been running rcutorture stress-tests on a number of 
> test-systems ever since this got reported (and they are running 
> currently as well) and cannot see it - neither could Paul reproduce it.
> 
> ( and Paul is very good in producing RCU related problems - he's
>   triggered and fixed many RCU related problems that no-one else saw
>   before. )
> 
> 	Ingo
