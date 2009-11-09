Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbZKISuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbZKISuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZKISuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:50:37 -0500
Received: from www.tglx.de ([62.245.132.106]:45258 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZKISug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:50:36 -0500
Date: Mon, 9 Nov 2009 19:50:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to
 preempt_count leakage in keventd
In-Reply-To: <200911091836.30349.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0911091949500.2725@localhost.localdomain>
References: <200911091250.31626.rjw@sisk.pl> <200911091647.54171.rjw@sisk.pl> <1257783553.6408.6.camel@marge.simson.net> <200911091836.30349.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009, Rafael J. Wysocki wrote:

> On Monday 09 November 2009, Mike Galbraith wrote:
> > On Mon, 2009-11-09 at 16:47 +0100, Rafael J. Wysocki wrote:
> > > On Monday 09 November 2009, Mike Galbraith wrote:
> > 
> > > > > Very likely.  What did you do to fix it?
> > > > 
> > > > You don't really wanna know.  In 31 with newidle enabled, the below
> > > > fixed it.  It won't fix 32, though it might cure the resume problem.
> > > 
> > > OK, I'll give it a try.
> 
> It doesn't help.
> 
> Also, I can reproduce the issue with current -git and kernel preepmtion
> disabled.
> 
> > I just tried to trigger badness via high speed online/offline combined
> > with taskset with CONFIG_PREEMPT enabled, and couldn't make it explode.
> 
> I'm not able to do it this way too, so resume seems to be necessary to trigger
> it.  I'm going try with the suspend debug in the "core" mode.
> 
> > (damn, wish i could s2ram this box)
> 
> That need not suffice.  I have two other boxes that suspend and resume
> correctly with 2.6.32-rc, AFAICS.
> 
> However, there seems to be a systematic error somewhere, since the failure
> always happens at the same place, ie. list_del_init(cwq->worklist.next); in
> run_workqueue(), in preemptible as well as in non-preemptible kernels.
> 
> Which is kind of strange, given the !list_empty(&cwq->worklist) test right
> before it.

Does that happen before or after the secondary CPU has been brought up ?

Thanks,

	tglx
