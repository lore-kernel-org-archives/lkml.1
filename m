Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZCHVhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZCHVhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbZCHVhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:37:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34976 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbZCHVhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:37:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [RFC][PATCH][1/8] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Sun, 8 Mar 2009 22:37:07 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <Pine.LNX.4.44L0.0903081629010.9313-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0903081629010.9313-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903082237.08843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 March 2009, Alan Stern wrote:
> On Sun, 8 Mar 2009, Linus Torvalds wrote:
> 
> > On Sat, 7 Mar 2009, Alan Stern wrote:
> > > 
> > > You didn't answer my question.  Why bother to distinguish between 
> > > "wake-up" interrupts and non-"wake-up" interrupts?
> > > 
> > > In other words, why not simply abort the suspend if IRQ_PENDING is set
> > > for _any_ interrupt during sysdev_suspend()?
> > 
> > .. because some drivers might not actually shut down the hardware until 
> > they get to "suspend_late"? If even then, for that matter - a driver may 
> > simply not care, knowing that the hardware will be powered off, and will 
> > be re-initialized at resume.
> > 
> > The thinking that you have to shut your hardware down at "->suspend()" 
> > time is a _disease_. There are literally classes of hardware out there 
> > where that would be an outright _bug_, like for a PCI bridge device. For 
> > many devices, "suspend()" has to be the phase where you shut down the 
> > _external_ stuff (eg for a disk controller, it's when you'd flush and stop 
> > your disks), but the controller itself may well be alive until later.
> 
> Yes, certainly.  I agree completely.
> 
> But there is a difference between shutting down the hardware and merely
> preventing it from generating interrupt requests.  If a device remains
> capable of generating IRQs after its driver's suspend method has run,
> the driver runs the risk of having its handler called at a time when it
> isn't prepared to cope correctly.  Of course, this will depend on the
> details of how the driver is written.
> 
> There have been examples in the past of devices that, for one reason or
> another, _did_ generate IRQs at inconvenient times.  The hardware or
> the BIOS may have done improper initialization, for example.  On a
> shared IRQ this led to interrupt storms.

Well, we're now trying to fix exactly this problem. :-)

>  IIRC, the solution was to add a PCI quirk routine to disable IRQ generation
>  at an early stage.   Didn't e100 have this problem?

I don't remember, sorry.

Thanks,
Rafael
