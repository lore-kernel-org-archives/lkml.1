Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZCHDxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZCHDxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 22:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZCHDxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 22:53:34 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45422 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752526AbZCHDxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 22:53:33 -0500
Date: Sat, 7 Mar 2009 22:53:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [linux-pm] [RFC][PATCH][1/8] PM: Rework handling of interrupts
 during suspend-resume (rev. 5)
In-Reply-To: <200903071856.36230.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0903072248030.8870-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Mar 2009, Rafael J. Wysocki wrote:

> > One thing about this isn't clear: the distinction between "wake-up" 
> > interrupts and other interrupts.
> > 
> > In an ideal world, the only pending interrupts during sysdev_suspend
> > would be wake-up interrupts, because drivers would have prevented their
> > devices from generating any other kind of IRQ and would have done all
> > the necessary synchronization as part of their suspend (_not_
> > suspend_late) methods.  Thus there would be no need to distinguish
> > between wake-up and non-wake-up interrupts.
> > 
> > So perhaps you're worried about drivers that aren't sufficiently
> > clever.  Or is something deeper going on?
> 
> Some drivers leave interrupts enabled during suspend on purpose and mark
> them as "wake-up interrupts" so that the platform can abort suspend if any
> of them is pending at the time the "enter suspend" hook is called (this doesn't
> happen on x86 AFAICS).
> 
> However, after the $subject patch the CPU will ACK those interrupts if they
> happen between suspend_device_irqs() and local_irq_disable(), so the platform
> won't see them as pending.  Instead, they will have IRQ_PENDING set in
> desc->status, so we check if this is the case.

You didn't answer my question.  Why bother to distinguish between 
"wake-up" interrupts and non-"wake-up" interrupts?

In other words, why not simply abort the suspend if IRQ_PENDING is set
for _any_ interrupt during sysdev_suspend()?

Alan Stern

