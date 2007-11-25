Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbXKYVwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbXKYVwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 16:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXKYVwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 16:52:07 -0500
Received: from www.tglx.de ([62.245.132.106]:52589 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbXKYVwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 16:52:04 -0500
Date: Sun, 25 Nov 2007 22:51:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: nohz and strange sleep latencies
In-Reply-To: <200711250029.55461.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.9999.0711252243410.26417@localhost.localdomain>
References: <20071119203152.GA1772@elf.ucw.cz> <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain> <20071124224013.GB1544@elf.ucw.cz> <200711250029.55461.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007, Rafael J. Wysocki wrote:
> > Digging into process_32|64.c...
> > 
> > 64:
> >         while (1) {
> >                 while (!need_resched()) {
> >                         void (*idle)(void);
> > 
> >                         if (__get_cpu_var(cpu_idle_state))
> >                                 __get_cpu_var(cpu_idle_state) = 0;
> > 
> >                         tick_nohz_stop_sched_tick();
> > 
> > 32:
> >         while (1) {
> >                 tick_nohz_stop_sched_tick();
> >                 while (!need_resched()) {
> >                         void (*idle)(void);
> > 
> >                         if (__get_cpu_var(cpu_idle_state))
> >                                 __get_cpu_var(cpu_idle_state) = 0;
> > 
> > ...eek? Which one is wrong?
> 
> Hm, it looks like you should have quoted more lines ...
> 
> In the second case (32), the tick_nohz_stop_sched_tick() seems to be
> redundant, so I bet it's this one.

No. Both are fine. the 64bit version calls into
tick_nohz_stop_sched_tick() way to often. This is a leftover from the
old theory that we can have non-irq caused wakeups. Will fix it.

    tglx
