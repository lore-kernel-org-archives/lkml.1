Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYJFRNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYJFRNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYJFRNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:13:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54129 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbYJFRNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:13:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes (Re: 2.6.27-rc8+ - first impressions)
Date: Mon, 6 Oct 2008 19:17:35 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jason Vas Dias <jason.vas.dias@gmail.com>
References: <20081005183603.GA3263@amd.corenet.prv> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu>
In-Reply-To: <20081006150055.GA16930@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810061917.36279.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 of October 2008, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, 6 Oct 2008, Rafael J. Wysocki wrote:
> > > 
> > > Unfortunately some of the recent IO-APIC changes made the bug show 
> > > up.  To prevent this from happening, blacklist machines that are 
> > > known to be affected (nx6115 and 6715b in this particular case).
> > 
> > Can you point to exactly _which_ recent change made it show up? I'd 
> > really like to know. _What_ was it that made us suddenly need this 
> > quirk when it wasn't necessary before? I'd like to understand the root 
> > cause here.
> > 
> > And how did you even start looking at that strange ACPI override?
> 
> i think it was caused by this stream of IO-APIC changes:
> 
>  49a66a0: x86: I/O APIC: Always report how the timer has been set up
>  17c4469: x86: I/O APIC: Include <asm/i8259.h> required by some code
>  593f4a7: x86: APIC: remove apic_write_around(); use alternatives
>  ce8b06b: x86: I/O APIC: remove an IRQ2-mask hack
>  af17478: x86: I/O APIC: Never configure IRQ2
>  c88ac1d: x86: L-APIC: Always fully configure IRQ0
>  1baea6e: x86: L-APIC: Set IRQ0 as edge-triggered
> 
> Rafael/Maciej, which of these is causing it? ce8b06b ("x86: I/O APIC: 
> remove an IRQ2-mask hack")?

As I wrote to Linus, on my machine it was

commit 691874fa96d6349a8b60f8ea9c2bae52ece79941
Author: Maciej W. Rozycki <macro@linux-mips.org>
Date:   Tue May 27 21:19:51 2008 +0100

    x86: I/O APIC: timer through 8259A second-chance

> Current theory is that this specific flavor of BIOS on HP / AMD / Turion 
> laptops (no other type is known to be affected at the moment) somehow 
> detects the IO-APIC masking patterns and uses an SMI quirk to change the 
> ACPI thermal trip point to very low settings, and thus confusing cpufreq 
> to (correctly) go into a very slow frequency.
> 
> Activating the quirk works this around. Should we perhaps default to 
> this 'quirk' enabled by default?

Well, I don't know.

Thanks,
Rafael
