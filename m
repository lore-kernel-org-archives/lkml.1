Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906Ab0AKTQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0AKTQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 14:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870Ab0AKTQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 14:16:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab0AKTQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 14:16:43 -0500
Date: Mon, 11 Jan 2010 14:16:33 -0500
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu
Cc: aris@redhat.com, linux-kernel@vger.kernel.org
Subject: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20100111191633.GT24885@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

To dig up an old thread last November:

======
* Aristeu Rozanski <aris@redhat.com> wrote:

> > > > > NMI_AUTO is a new nmi_watchdog option that makes LAPIC be tried
> > > > > first 
> > > > > and if the CPU isn't supported, IOAPIC will be used. It's useful
> > > > > in 
> > > > > cases where NMI watchdog is enabled by default in a kernel built
> > > > > for 
> > > > > different machines. It can be configured by default or selected
> > > > > with 
> > > > > nmi_watchdog=3 or nmi_watchdog=auto parameters.
> > > > 
> > > > What i'd like to see for the NMI watchdog is much more ambitious
> > > > than 
> > > > this: the use of perf events to run a periodic NMI callback.
> > > > 
> > > > The NMI watchdog would cause the creation of a per-cpu perf_event 
> > > > structure (in-kernel). All x86 CPUs that have perf event support
> > > > (the 
		> > > > majority of them) will thus be able to have an NMI
> > > > watchdog using a 
> > > > nice, generic piece of code and we'd be able to phase out the
> > > > open-coded 
> > > > NMI watchdog code.
> > > > 
> > > > The user would not notice much from this: we'd still have the 
> > > > /proc/sys/kernel/nmi_watchdog toggle to turn it on/off, and we'd
> > > > still 
> > > > have the nmi_watchog= boot parameter as well. But the underlying 
> > > > implementation would be far more generic and far more usable than
> > > > the 
> > > > current code.
> > > > 
> > > > Would you be interested in moving the NMI watchdog code in this 
> > > > direction? Most of the perf events changes (callbacks, helpers for 
		> > > > in-kernel event allocations, etc.) are in latest
> > > > -tip already, so you 
> > > > could use that as a base.
> > >
> > > but that would work only for LAPIC. You're suggesting killing IOAPIC 
> > > mode too?
> > 
> > Would it be a big loss, with all modern systems expected to have a 
> > working lapic based NMI source? I wrote the IOAPIC mode originally but
> > i 
> > dont feel too attached to it ;-)
>
> ok, fair enough. but since it'll be another implementation, do you 
> mind applying the patches I submitted so they can be used until the 
> new implementation is in place?

For that i need to see at least an RFC v1 version series of the new 
implementation - otherwise we might end up sitting on this interim 
version with no-one doing the better variant.

========

I was going to jump in and try to do this work.  I wanted to make sure
what you were looking for here.  When you say convert nmi watchdog to perf
events, I assume you mean merging over the bits of perfctr-watchdog.c to
perf_events.c, modify nmi.c to just register as a normal perf event and
probably cleanup the oprofile stuff to match, correct?

Cheers,
Don

