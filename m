Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbYAFWeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbYAFWeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbYAFWdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:33:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33856 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbYAFWdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:33:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Date: Sun, 6 Jan 2008 23:36:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Mark Lord <lkml@rtr.ca>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
References: <200801052042.56042.rjw@sisk.pl> <20080106095501.GG26291@elte.hu> <20080106142333.7e7053e7@laptopd505.fenrus.org>
In-Reply-To: <20080106142333.7e7053e7@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801062336.18023.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of January 2008, Arjan van de Ven wrote:
> On Sun, 6 Jan 2008 10:55:01 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Mark Lord <lkml@rtr.ca> wrote:
> > 
> > > Rafael J. Wysocki wrote:
> > >> This message contains a list of some regressions from 2.6.23
> > >> reported since 2.6.24-rc1 was released, for which there are no
> > >> fixes in the mainline I know of.  If any of them have been fixed
> > >> already, please let me know.
> > > ..
> > >> Subject		: 20000+ wake-ups/second in 2.6.24
> > >> Submitter	: Mark Lord <lkml@rtr.ca>
> > >> Date		: 2007-12-02 04:23
> > >> References	: http://lkml.org/lkml/2007/12/1/141
> > >> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9489
> > >> Handled-By	: Arjan van de Ven <arjan@infradead.org>
> > >>
> > >
> > > I wonder if it's just a babbling IRQ on resume, before the driver
> > > has run it's resume code or something ?
> > 
> > i've read the discussions, and i cannot see it analyzed anywhere
> > _what_ causes the wakeups. And how are these wakeups counted? Is this
> > based on powertop output:
> > 
> >  Wakeups-from-idle per second : 20.4     interval: 1.8s
> > 
> > ? Somewhere i saw it mentioned that "the CPU throws out of C mode".
> > What does that mean - does it mean we try to idle again and again,
> > but we immediately return from C mode - while this all looks like
> > "idle" time to the scheduler (so 'top' will show lots of idle time),
> > but the ACPI wakeup counters are going up like mad? What
> > is /proc/interrupts doing when this happens - is any of the irq
> > sources going upwards?
> > 
> 
> what seems to happen (and this is based on seeing this on my own devel laptop, as well
> as several other reports; Mark is by far not the only one) is something hardware
> related, it's been seen on lots of different kernel versions.
> 
> It seems to mostly (but not 100%) happen with TI cardbus bridges, where for some reason,
> once the yenta driver is loaded (unloading it later makes no difference), once in a while
> we get into a mode where the CPU always immediately goes out of the C-state again.
> On a hardware level, there are only a few things that cause a CPU to exit a C-state,
> and one of them is a pending interrupt of some kind, which is the most likely thing going on here;
> some device or apic being stuck with interrupt high, but somehow the CPU isn't actually
> seeing the interrupt itself (or has it blocked!)
> 
> To call this a 2.6.24 regression is a mistake (as I've said before), it's not new to .24
> by any means.

Thanks for the explanation, I'm removing this from the regressions list, then.

Greetings,
Rafael
