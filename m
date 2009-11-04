Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZKDPT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZKDPT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZKDPT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:19:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbZKDPT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:19:27 -0500
Date: Wed, 4 Nov 2009 10:19:29 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20091104151929.GH18613@redhat.com>
References: <20091103171054.GB25437@redhat.com> <20091104114630.GA16993@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104114630.GA16993@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > NMI_AUTO is a new nmi_watchdog option that makes LAPIC be tried first 
> > and if the CPU isn't supported, IOAPIC will be used. It's useful in 
> > cases where NMI watchdog is enabled by default in a kernel built for 
> > different machines. It can be configured by default or selected with 
> > nmi_watchdog=3 or nmi_watchdog=auto parameters.
> 
> What i'd like to see for the NMI watchdog is much more ambitious than 
> this: the use of perf events to run a periodic NMI callback.
> 
> The NMI watchdog would cause the creation of a per-cpu perf_event 
> structure (in-kernel). All x86 CPUs that have perf event support (the 
> majority of them) will thus be able to have an NMI watchdog using a 
> nice, generic piece of code and we'd be able to phase out the open-coded 
> NMI watchdog code.
> 
> The user would not notice much from this: we'd still have the 
> /proc/sys/kernel/nmi_watchdog toggle to turn it on/off, and we'd still 
> have the nmi_watchog= boot parameter as well. But the underlying 
> implementation would be far more generic and far more usable than the 
> current code.
> 
> Would you be interested in moving the NMI watchdog code in this 
> direction? Most of the perf events changes (callbacks, helpers for 
> in-kernel event allocations, etc.) are in latest -tip already, so you 
> could use that as a base.
but that would work only for LAPIC. You're suggesting killing IOAPIC mode too?

-- 
Aristeu

