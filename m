Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbXJBGT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbXJBGT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXJBGTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:19:19 -0400
Received: from www.tglx.de ([62.245.132.106]:41590 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbXJBGTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:19:18 -0400
Date: Tue, 2 Oct 2007 08:18:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: Arjan van de Ven <arjan@infradead.org>, David Bahi <dbahi@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
In-Reply-To: <200710020751.42994.ak@suse.de>
Message-ID: <alpine.LFD.0.9999.0710020815370.3348@localhost.localdomain>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <200710020007.09864.ak@suse.de> <alpine.LFD.0.9999.0710020043450.20478@localhost.localdomain> <200710020751.42994.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Andi Kleen wrote:
> > Agreed.
> > 
> > I just got a x8664-hrt report, where I found the following oddity:
> > 
> >  0:       1197     172881   IO-APIC-edge      timer
> > 
> > That's one of those infamous AMD C1E boxen. Strange, all my systems have 
> > IRQ#0 on CPU#0 and nowhere else. Any idea ?
> 
> Hmm, in lowestpriority mode it would be possible that the APIC changes
> the CPU to #1 once; but IRQ 0 is always set to fixed mode. Also even 
> if that happens you should have them all on 1.
> 
> Maybe the chipset is just ignoring the IO-APIC configuration in this case?
> 
> Is it always the same chipset? Is it seen on i386 too?
> 
> The problem is really that if this happens it's more than the NMI watchdog
> that is broken. If you don't run an additional APIC timer interrupt on CPU #0
> it's possible that CPU #0 won't schedule at all.
>
> The only workaround for chipsets ignoring IRQ affinity would be to keep
> track on which CPU irq 0 happens and then restart APIC timer interrupts
> on the others (or send IPIs) as needed. But that would be fairly ugly.

The clock events code does handle this already. The broadcast interrupt 
can come in on any cpu. It's just the nmi watchdog which would be affected 
by that.

	tglx
