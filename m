Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbXKLSad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbXKLSad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbXKLSaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:30:20 -0500
Received: from rutherford.zen.co.uk ([212.23.3.142]:52134 "EHLO
	rutherford.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbXKLSaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:30:17 -0500
Date: Mon, 12 Nov 2007 18:28:18 +0000
From: Grant Wilson <grant.wilson@zen.co.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       netdev <netdev@vger.kernel.org>, vatsa <vatsa@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc1-gb4f5550 oops
Message-ID: <20071112182818.182d739f@worthy.swandive.local>
In-Reply-To: <1194890749.9713.17.camel@twins>
References: <20071105061158.3174d24d@worthy.swandive.local>
	<200711082242.21869.rjw@sisk.pl>
	<20071108221951.71224bd8@worthy.swandive.local>
	<200711082349.19344.rjw@sisk.pl>
	<1194890749.9713.17.camel@twins>
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-Rutherford-IP: [82.71.45.175]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007 19:05:49 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> 
> On Thu, 2007-11-08 at 23:49 +0100, Rafael J. Wysocki wrote:
> > On Thursday, 8 of November 2007, Grant Wilson wrote:
> > > On Thu, 8 Nov 2007 22:42:21 +0100
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > On Thursday, 8 of November 2007, Grant Wilson wrote:
> > > > > On Thu, 8 Nov 2007 16:53:10 +0100
> > > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > 
> > > > > > On Thursday, 8 of November 2007, Grant Wilson wrote:
> > > > > > > On Thu, 8 Nov 2007 01:06:21 +0100
> > > > > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > > > 
> > > > > > > > On Monday, 5 of November 2007, Grant Wilson wrote:
> > > > > > > > > Hi,
> > > > > > > > > I got this oops on 2.6.24-rc1-641-gb4f5550:
> > > > > > > > 
> > > > > > > > (1) Is this reproducible?
> > > > > > > > (2) Did it happen previously on your system?
> > > > > > > >
> > > > > > > > [18073.371126] Unable to handle kernel NULL pointer dereference at 0000000000000120 RIP: 
> > > > > > > > [18073.371134]  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> > > > > > > 
> > > > > > > This has now happened twice - the second time was last night when
> > > > > > > running 2.6.24-rc2.
> > > > > > > 
> > > > > > > Here's that second occurrence:
> > > > > > > 
> > > > > [snip]
> > > > > > 
> > > > > > Hmm.
> > > > > > 
> > > > > > Please run "gdb vmlinux" and see what code corresponds to
> > > > > > check_preempt_wakeup+0x6e in your kernel.
> > > > >
> > > > > 
> > > > > Dump of assembler code for function check_preempt_wakeup:
> > > > 
> > > > Well, thanks, but I meant the source code.  Please do "gdb vmlinux" and then
> > > > "l *check_preempt_wakeup+0x6e" in gdb.
> > > 
> > > Here's the requested output:
> > > 
> > > (gdb) l *check_preempt_wakeup+0x6e
> > > 0xffffffff802329ae is in check_preempt_wakeup (kernel/sched_fair.c:668).
> > > 663
> > > 664     /* Do the two (enqueued) entities belong to the same group ? */
> > > 665     static inline int
> > > 666     is_same_group(struct sched_entity *se, struct sched_entity *pse)
> > > 667     {
> > > 668             if (se->cfs_rq == pse->cfs_rq)
> > > 669                     return 1;
> > > 670
> > > 671             return 0;
> > > 672     }
> > 
> > Well, it looks like either se or pse is NULL.
> > 
> > Ingo, can you please have a look?
> 
> Most puzzling this, it should be guaranteed that the top sched_entities
> are of the same group, therefore avoiding this loop into NULL. Obviously
> something has gone wrong.
> 
> Grant, is there anything specific you can tell us about how to reproduce
> this?

I'm afraid not.  It has only happened twice and both times I was away
from the box in question at the time of failure, so it wasn't doing a
great deal.

I'm running 2.6.24-rc2 on two boxes and both times it happened on the
box running a quad core processor.

Grant

