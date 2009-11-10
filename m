Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZKJFU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZKJFU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 00:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZKJFU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 00:20:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZKJFUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 00:20:54 -0500
Date: Tue, 10 Nov 2009 06:20:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20091110052051.GJ7897@elte.hu>
References: <20091103171054.GB25437@redhat.com>
 <20091104114630.GA16993@elte.hu>
 <20091104151929.GH18613@redhat.com>
 <20091104155641.GA11444@elte.hu>
 <20091109200201.GT18613@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109200201.GT18613@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Aristeu Rozanski <aris@redhat.com> wrote:

> > > > > NMI_AUTO is a new nmi_watchdog option that makes LAPIC be tried first 
> > > > > and if the CPU isn't supported, IOAPIC will be used. It's useful in 
> > > > > cases where NMI watchdog is enabled by default in a kernel built for 
> > > > > different machines. It can be configured by default or selected with 
> > > > > nmi_watchdog=3 or nmi_watchdog=auto parameters.
> > > > 
> > > > What i'd like to see for the NMI watchdog is much more ambitious than 
> > > > this: the use of perf events to run a periodic NMI callback.
> > > > 
> > > > The NMI watchdog would cause the creation of a per-cpu perf_event 
> > > > structure (in-kernel). All x86 CPUs that have perf event support (the 
> > > > majority of them) will thus be able to have an NMI watchdog using a 
> > > > nice, generic piece of code and we'd be able to phase out the open-coded 
> > > > NMI watchdog code.
> > > > 
> > > > The user would not notice much from this: we'd still have the 
> > > > /proc/sys/kernel/nmi_watchdog toggle to turn it on/off, and we'd still 
> > > > have the nmi_watchog= boot parameter as well. But the underlying 
> > > > implementation would be far more generic and far more usable than the 
> > > > current code.
> > > > 
> > > > Would you be interested in moving the NMI watchdog code in this 
> > > > direction? Most of the perf events changes (callbacks, helpers for 
> > > > in-kernel event allocations, etc.) are in latest -tip already, so you 
> > > > could use that as a base.
> > >
> > > but that would work only for LAPIC. You're suggesting killing IOAPIC 
> > > mode too?
> > 
> > Would it be a big loss, with all modern systems expected to have a 
> > working lapic based NMI source? I wrote the IOAPIC mode originally but i 
> > dont feel too attached to it ;-)
>
> ok, fair enough. but since it'll be another implementation, do you 
> mind applying the patches I submitted so they can be used until the 
> new implementation is in place?

For that i need to see at least an RFC v1 version series of the new 
implementation - otherwise we might end up sitting on this interim 
version with no-one doing the better variant.

Thanks,

	Ingo
