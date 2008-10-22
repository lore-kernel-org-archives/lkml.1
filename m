Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYJVKKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYJVKKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbYJVKKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:10:13 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4486 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYJVKKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:10:11 -0400
X-BigFish: VPS-32(zz3b49K1432R98dR1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K94XKL-02-EQU-01
Date: Wed, 22 Oct 2008 12:09:24 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove superfluous dmi_ignore_irq0_timer_override
	quirks
Message-ID: <20081022100924.GC13400@alberich.amd.com>
References: <20081016105706.GC29183@alberich.amd.com> <20081022100253.GB29744@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081022100253.GB29744@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Oct 2008 10:09:58.0946 (UTC) FILETIME=[56FEF820:01C9342E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 12:02:54PM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > The problem should be solved with commits:
> > 
> > x86: SB600: skip IRQ0 override if it is not routed to INT2 of IOAPIC
> > x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC
> > 
> > IMHO it does not make sense to check within a dmi-quirk
> > whether an early-quirk was applied. Boot sequence is as follows:
> > 
> > acpi_boot_table_init()   (it applies dmi-quirks)
> > ...
> > early_quirks()           (detect bogus IRQ0 override)
> > ...
> > acpi_boot_init()         (setup IO APIC)
> > 
> > Thus with current code we will always get following warnings for
> > Laptops that have this dmi_ignore_irq0_timer_override dmi quirk:
> > 
> >   WARNING: at arch/x86/kernel/acpi/boot.c:1410
> >   dmi_ignore_irq0_timer_override+0x30/0x60()
> >   ati_ixp4x0 quirk not complete.
> > 
> > ... just because the early-quirk (ati_ixp4x0) was not yet executed.
> 
> could we move the DMI check to after the early quicks stage? It would be 
> nice to have this double check, for at least one kernel cycle.

Ok, I'll have a look at that.

Andreas


