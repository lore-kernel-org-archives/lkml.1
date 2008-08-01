Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbYHAVKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbYHAVKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759965AbYHAVJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:09:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44259 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760616AbYHAVJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:09:21 -0400
Date: Fri, 1 Aug 2008 14:09:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       nickpiggin@yahoo.com.au, adobriyan@gmail.com
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080801210919.GD14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807060816070.3016@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 08:46:09AM -0700, Linus Torvalds wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
> > Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
> > Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> > Date		: 2008-05-27 09:23 (41 days old)
> > References	: http://lkml.org/lkml/2008/5/27/9
> > 		  http://lkml.org/lkml/2008/6/14/87
> > Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
> > 		  Linus Torvalds <torvalds@linux-foundation.org>
> > 		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Patch		: http://lkml.org/lkml/2008/5/28/16
> 
> This one is the same thing that is reported as unresolved, and no, I don't 
> think that existing patch was ever really tested to fix anything. Paul?

Alexey tested the above patch, and it did not fix his failure
(http://lkml.org/lkml/2008/6/15/93).  Neither did the patch
at http://lkml.org/lkml/2008/6/14/209.  I was never able to
reproduce Alexey's failure, whether by running LTP in parallel
with 170 kernel builds or by running either in parallel with
rcutorture.  Some enhancements to make rcutorture more vicious
were unable to provoke failures.

Alexey is able to provoke the failure on a maxcpus=1 configuration,
which should narrow things down quite a bit.  I dug through
assembly, and found no issues at that level.

Alexey, would you be willing to send along your vmlinux or disassembly
of the RCU functions?

In any case, I am working up additional diagnostics.

> I suspect SRCU will need to be simply marked BROKEN for now, because 
> nobody knows what the problem Alexey sees is. Apparently it's been seen by 
> a few other people too.

PREEMPT_RCU is already marked "default n" with a "Say N if you are
unsure.  Shouldn't that cover it?

I don't believe that SRCU is involved, please let me know if I missed
something.

Nick Piggin mentioned seeing failures similar to Alexey's, and I still
need his repeat-by.  Nick?

							Thanx, Paul
