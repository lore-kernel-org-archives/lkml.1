Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZB1KHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZB1KHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 05:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZB1KHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 05:07:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47720 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbZB1KHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 05:07:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Sat, 28 Feb 2009 11:06:40 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0902270948540.2926-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0902271221360.3111@localhost.localdomain> <d6200be20902271954q16697282ia056d4f40ab49184@mail.gmail.com>
In-Reply-To: <d6200be20902271954q16697282ia056d4f40ab49184@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902281106.41793.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Arve Hjønnevåg wrote:
> On Fri, Feb 27, 2009 at 12:30 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Fri, 27 Feb 2009, Alan Stern wrote:
> >>
> >> Perhaps these aren't all the sort of usage you're talking about, but I
> >> bet most of them are.  It certainly looks like more than just ARM.
> >> Maybe not all that much more, but definitely more.  And the number will
> >> only grow in the future.
> >
> > Are you really sure? Because it can't be x86. I'm pretty sure that that is
> > simply not how x86 wake events _work_ - they're not interrupts.
> 
> They are not interrupts on every arm platform that implements set_wake
> either, but it is useful to pretend that they are. If the platform
> code reads the wakeup status and marks the corresponding interrupt
> pending, the driver does not need to know if the event occurred before
> or after the system entered the low power state. I don't know if this
> can be implemented on x86, but it might be worth looking into.

That would have been a new feature, no?  And I don't think anyone except for
you does it.  So, what you're saying boils down to "please don't break my new
feature that hasn't been merged yet".

> > And that's the big point that people seem to be missing here: the whole
> > "wake up interrupt" thing is not some generic model in the first place. I
> > strongly suspect that it literally only works on certain architectures.
> 
> My point was that it was not specific to our platform. I don't have a
> problem fixing our platform if this patch is merged, but this is case
> where a change to the generic code breaks some platforms.

Quite frankly, I don't really think it will break anything else than your
platform.

Still, if Linus agrees, I can put the loop suggested by him directly into
sysdev_suspend().  Linus?

> I don't think there is a good reason to make the fix arm specific, trivial or
> not, since any platform implementing set_wake may run into the race
> condition that this patch introduced. If the platform does not
> implement set_wake, IRQ_WAKEUP never gets set, and the fix should not
> have any effect.

The point is, if we put anything like this into the generic code, platforms
start to rely on this and it will become more and more difficult to change at
the generic level if need be.

The fact that your platform relies on the generic code to disable IRQs on
the CPU at a particular point shows the mechanism very well. :-)

Thanks,
Rafael
