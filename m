Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYJVKEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYJVKEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYJVKEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:04:24 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:51166 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYJVKEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:04:24 -0400
X-BigFish: VPS-34(zz1432R98dR4015M1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K94XAZ-01-ISK-01
Date: Wed, 22 Oct 2008 12:03:37 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove superfluous dmi_ignore_irq0_timer_override
	quirks
Message-ID: <20081022100337.GA13400@alberich.amd.com>
References: <20081016105706.GC29183@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081016105706.GC29183@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Oct 2008 10:04:11.0885 (UTC) FILETIME=[8821A9D0:01C9342D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 12:57:06PM +0200, Andreas Herrmann wrote:
> The problem should be solved with commits:
> 
> x86: SB600: skip IRQ0 override if it is not routed to INT2 of IOAPIC
> x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC
> 
> IMHO it does not make sense to check within a dmi-quirk
> whether an early-quirk was applied. Boot sequence is as follows:
> 
> acpi_boot_table_init()   (it applies dmi-quirks)
> ...
> early_quirks()           (detect bogus IRQ0 override)
> ...
> acpi_boot_init()         (setup IO APIC)
> 
> Thus with current code we will always get following warnings for
> Laptops that have this dmi_ignore_irq0_timer_override dmi quirk:
> 
>   WARNING: at arch/x86/kernel/acpi/boot.c:1410
>   dmi_ignore_irq0_timer_override+0x30/0x60()
>   ati_ixp4x0 quirk not complete.
> 
> ... just because the early-quirk (ati_ixp4x0) was not yet executed.
> 

Hi Ingo,

How are chances that this patch will go into tip-tree?
I'd like to see this fix in 2.6.28.


Thanks,

Andreas


