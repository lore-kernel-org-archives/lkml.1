Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388Ab0AYU6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0AYU6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326Ab0AYU6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:58:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab0AYU6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:58:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shawn Starr <shawn.starr@rogers.com>
Subject: Re: [Bug #14859] System timer firing too much without cause
Date: Mon, 25 Jan 2010 21:59:33 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jerome Glisse" <jglisse@redhat.com>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <alpine.LFD.2.00.1001251808480.5926@localhost.localdomain> <201001251230.23109.shawn.starr@rogers.com>
In-Reply-To: <201001251230.23109.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001252159.33120.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Shawn Starr wrote:
> On Monday 25 January 2010 12:20:38 Thomas Gleixner wrote:
> > On Mon, 25 Jan 2010, Shawn Starr wrote:
> > > On Monday 25 January 2010 05:35:50 Thomas Gleixner wrote:
> > > > Shawn, why can't you use dynamic ticks ? In the bugzilla I just see
> > > > that you worry about the IRQ0 interrupts (which are correct and
> > > > necessary when the system is in nohz mode) and the extra rescheduling
> > > > interrupts. How is the system misbehaving ?
> > > 
> > > Well, this all stems from trying to use Radeon KMS with IRQs
> > > on. Doing so I see system stalls and this is quite noticeable
> > > however, I am able to show this same stall on the quad core with the
> > 
> > x> same GPU.  Right now, it is unclear to me if there is a underlying
> > 
> > > irq issue or a bug in the radeon driver code that is showing these
> > > stalls. Since the radeon folks - at the moment - do not think it is
> > > a coding problem in their driver
> > 
> > Does the stall go away, when you disable dynticks ?
> > 
> 
> It does not, no. 
> 
> > > My impression was using dynamic ticks meant ticks were on demand and
> > 
> > Dynamic ticks are providing a continuous tick long as the machine is
> > busy. When a core becomes idle, we programm the timer to go off at the
> > next scheduled timer event, if the event is longer away than the next
> > tick. When the core goes out of idle (due to the timer or some other
> > event) we restart the tick.
> > 
> > So you see less timer interrupts (IRQ0 + Local timer interrupts)
> 
> With dynamic ticks on or off, LOC increments rapidly, but I assume that is 
> normal behavour.
> 
> So if none of this really is a kernel issue, I defer it to the radeon folks to 
> comment further.
> 
> Please remove from regression list, I'll close the original bug.

OK, closing it right now.

Rafael
