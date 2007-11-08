Return-Path: <linux-kernel-owner+w=401wt.eu-S1761400AbXKHWcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbXKHWcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758366AbXKHWcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:32:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbXKHWcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:32:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Grant Wilson <grant.wilson@zen.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc1-gb4f5550 oops
Date: Thu, 8 Nov 2007 23:49:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       netdev <netdev@vger.kernel.org>
References: <20071105061158.3174d24d@worthy.swandive.local> <200711082242.21869.rjw@sisk.pl> <20071108221951.71224bd8@worthy.swandive.local>
In-Reply-To: <20071108221951.71224bd8@worthy.swandive.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711082349.19344.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 8 of November 2007, Grant Wilson wrote:
> On Thu, 8 Nov 2007 22:42:21 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Thursday, 8 of November 2007, Grant Wilson wrote:
> > > On Thu, 8 Nov 2007 16:53:10 +0100
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > On Thursday, 8 of November 2007, Grant Wilson wrote:
> > > > > On Thu, 8 Nov 2007 01:06:21 +0100
> > > > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > 
> > > > > > On Monday, 5 of November 2007, Grant Wilson wrote:
> > > > > > > Hi,
> > > > > > > I got this oops on 2.6.24-rc1-641-gb4f5550:
> > > > > > 
> > > > > > (1) Is this reproducible?
> > > > > > (2) Did it happen previously on your system?
> > > > > >
> > > > > > [18073.371126] Unable to handle kernel NULL pointer dereference at 0000000000000120 RIP: 
> > > > > > [18073.371134]  [<ffffffff8023572e>] check_preempt_wakeup+0x6e/0x110
> > > > > 
> > > > > This has now happened twice - the second time was last night when
> > > > > running 2.6.24-rc2.
> > > > > 
> > > > > Here's that second occurrence:
> > > > > 
> > > [snip]
> > > > 
> > > > Hmm.
> > > > 
> > > > Please run "gdb vmlinux" and see what code corresponds to
> > > > check_preempt_wakeup+0x6e in your kernel.
> > >
> > > 
> > > Dump of assembler code for function check_preempt_wakeup:
> > 
> > Well, thanks, but I meant the source code.  Please do "gdb vmlinux" and then
> > "l *check_preempt_wakeup+0x6e" in gdb.
> 
> Here's the requested output:
> 
> (gdb) l *check_preempt_wakeup+0x6e
> 0xffffffff802329ae is in check_preempt_wakeup (kernel/sched_fair.c:668).
> 663
> 664     /* Do the two (enqueued) entities belong to the same group ? */
> 665     static inline int
> 666     is_same_group(struct sched_entity *se, struct sched_entity *pse)
> 667     {
> 668             if (se->cfs_rq == pse->cfs_rq)
> 669                     return 1;
> 670
> 671             return 0;
> 672     }

Well, it looks like either se or pse is NULL.

Ingo, can you please have a look?

Thanks,
Rafael
