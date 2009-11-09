Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbZKIUCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbZKIUCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZKIUCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:02:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52302 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZKIUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:02:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd
Date: Mon, 9 Nov 2009 21:03:54 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200911091250.31626.rjw@sisk.pl> <200911091836.30349.rjw@sisk.pl> <alpine.LFD.2.00.0911092012340.2725@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911092012340.2725@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911092103.54083.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Thomas Gleixner wrote:
> On Mon, 9 Nov 2009, Rafael J. Wysocki wrote:
> > On Monday 09 November 2009, Mike Galbraith wrote:
> > > On Mon, 2009-11-09 at 16:47 +0100, Rafael J. Wysocki wrote:
> > > > On Monday 09 November 2009, Mike Galbraith wrote:
> > > 
> > > > > > Very likely.  What did you do to fix it?
> > > > > 
> > > > > You don't really wanna know.  In 31 with newidle enabled, the below
> > > > > fixed it.  It won't fix 32, though it might cure the resume problem.
> > > > 
> > > > OK, I'll give it a try.
> > 
> > It doesn't help.
> > 
> > Also, I can reproduce the issue with current -git and kernel preepmtion
> > disabled.
> > 
> > > I just tried to trigger badness via high speed online/offline combined
> > > with taskset with CONFIG_PREEMPT enabled, and couldn't make it explode.
> > 
> > I'm not able to do it this way too, so resume seems to be necessary to trigger
> > it.  I'm going try with the suspend debug in the "core" mode.
> > 
> > > (damn, wish i could s2ram this box)
> > 
> > That need not suffice.  I have two other boxes that suspend and resume
> > correctly with 2.6.32-rc, AFAICS.
> > 
> > However, there seems to be a systematic error somewhere, since the failure
> > always happens at the same place, ie. list_del_init(cwq->worklist.next); in
> > run_workqueue(), in preemptible as well as in non-preemptible kernels.
> > 
> > Which is kind of strange, given the !list_empty(&cwq->worklist) test right
> > before it.
> 
> Hmm, no. list_empty() just tells you whether the list is empty or
> not. It does not care whether the list is corrupted or not. Have you
> tried to run with list debugging enabled ?

I did, but the result was exactly the same as without it.

Also, I don't seem to be able to reproduce the issue without actually
suspending the box.  I tried with offlining/onlining CPU1 and with
the /sys/power/pm_test "core" test and it didn't show up.

Thanks,
Rafael
