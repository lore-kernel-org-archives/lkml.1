Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbYHFNYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbYHFNYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbYHFNWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:22:52 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:49307 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYHFNWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:22:50 -0400
X-BigFish: VPS-17(z297cpz1432R98dR1805M936fQ8b9ck19c2kzz10d3izzz32i6bh41i61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K56L4K-01-NU7-01
Date: Wed, 6 Aug 2008 15:21:39 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Pavel Machek <pavel@suse.cz>
CC: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 0/6] AMD C1E aware idle support
Message-ID: <20080806132139.GA6713@alberich.amd.com>
References: <20080610171639.551369443@linutronix.de> <alpine.LFD.1.10.0806181834110.3074@localhost.localdomain> <20080704143536.GA21102@alberich.amd.com> <20080805174217.GC8380@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080805174217.GC8380@ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2008 13:21:43.0668 (UTC) FILETIME=[5E897B40:01C8F7C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 07:42:18PM +0200, Pavel Machek wrote:
> > > > AMD CPUs with C1E support are currently excluded from high resolution
> > > > timers and NOHZ support. The reason is that C1E is a BIOS controlled
> > > > C3 power state which switches off TSC and the local APIC timer. The
> > > > ACPI C-State control manages the TSC/local APIC timer wreckage, but
> > > > this does not include the C1 based ("halt" instruction) C1E mode. The
> > > > BIOS/SMM controlled C1E state works on most systems even without
> > > > enabling ACPI C-State control.
> > > 
> > > What a mess.
> 
> Yep, seems like AMD is breaking C1 semantics. Is it even valid from
> ACPI spec point of view?
>
> > > What is the measured power savings that justifies this effort?
> > 
> > IMHO the power savings are not that important when such a kernel runs
> > on bare metal:
> 
> Ok, so maybe we should disable C1E to work around its misdesign?

Disabling C1E is not an option. It saves the most power when you have
a multicore AMD CPU. Neither C2 nor C3 are declared here. AMD C1E is
hardware level power management if all cores are in the C1 state.

If you disable C1E and use a NOHZ kernel your power consumption is
higher than using C1E with a periodic timer (say 250 HZ).

> It would be certainly nice to have noc1e command line option...

The sane way to disable it is in the BIOS -- if your BIOS provides
such an option.
Thomas pointed already out that C1E might be enabled later during
boot. So you would have to reset the respective bits whenever you
enter idle. This is ugly and what would be the benefit of this?


Andreas


