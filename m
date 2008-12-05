Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYLEMUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYLEMUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYLEMUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:20:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33279 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbYLEMUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:20:39 -0500
Date: Fri, 5 Dec 2008 13:20:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rjw@sisk.pl,
       greg@kroah.com, jbarnes@virtuousgeek.org, lenb@kernel.org,
       linux-kernel@vger.kernel.org, tiwai@suse.de, akpm@linux-foundation.org,
       ink@jurassic.park.msu.ru, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: MSI changes in .28
Message-ID: <20081205122005.GC28662@elte.hu>
References: <200812020320.31876.rjw@sisk.pl> <200812020629.26714.elendil@planet.nl> <alpine.LFD.2.00.0812020735150.3256@nehalem.linux-foundation.org> <200812050953.12238.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812050953.12238.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> On Tuesday 02 December 2008, Linus Torvalds wrote:
> > So, it looks like you have MSI enabled in -rc6, and not in -rc3.
> 
> I've just compared dmesg for my *desktop* and there I see the following 
> between 2.6.28-rc6 and current 2.6.28-rc7:
> 
>  pcieport-driver 0000:00:1c.0: setting latency timer to 64
>  pcieport-driver 0000:00:1c.0: found MSI capability
> -pcieport-driver 0000:00:1c.0: irq 47 for MSI/MSI-X
> +pcieport-driver 0000:00:1c.0: irq 511 for MSI/MSI-X
>  pci_express 0000:00:1c.0:pcie00: allocate port service
>  pci_express 0000:00:1c.0:pcie02: allocate port service
>  pcieport-driver 0000:00:1c.2: setting latency timer to 64
>  pcieport-driver 0000:00:1c.2: found MSI capability
> -pcieport-driver 0000:00:1c.2: irq 46 for MSI/MSI-X
> +pcieport-driver 0000:00:1c.2: irq 510 for MSI/MSI-X
>  pci_express 0000:00:1c.2:pcie00: allocate port service
>  pci_express 0000:00:1c.2:pcie02: allocate port service
>  pcieport-driver 0000:00:1c.3: setting latency timer to 64
>  pcieport-driver 0000:00:1c.3: found MSI capability
> -pcieport-driver 0000:00:1c.3: irq 45 for MSI/MSI-X
> +pcieport-driver 0000:00:1c.3: irq 509 for MSI/MSI-X
>  pci_express 0000:00:1c.3:pcie00: allocate port service
>  pci_express 0000:00:1c.3:pcie02: allocate port service
>  pcieport-driver 0000:00:1c.4: setting latency timer to 64
>  pcieport-driver 0000:00:1c.4: found MSI capability
> -pcieport-driver 0000:00:1c.4: irq 44 for MSI/MSI-X
> +pcieport-driver 0000:00:1c.4: irq 508 for MSI/MSI-X
>  pci_express 0000:00:1c.4:pcie00: allocate port service
>  pci_express 0000:00:1c.4:pcie02: allocate port service
>  pcieport-driver 0000:00:1c.5: setting latency timer to 64
>  pcieport-driver 0000:00:1c.5: found MSI capability
> -pcieport-driver 0000:00:1c.5: irq 43 for MSI/MSI-X
> +pcieport-driver 0000:00:1c.5: irq 507 for MSI/MSI-X
> [...]
>  ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> -ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
> +ahci 0000:00:1f.2: irq 506 for MSI/MSI-X
>  ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
> [...]
>  e1000e 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>  e1000e 0000:01:00.0: setting latency timer to 64
> -e1000e 0000:01:00.0: irq 41 for MSI/MSI-X
> +e1000e 0000:01:00.0: irq 505 for MSI/MSI-X
> 
> I.e. very similar to the change between rc-3 and rc-7 you commented on 
> for my notebook.
> 
> Is this really MSI being (not) enabled, or just it using much higher 
> IRQ numbers?

The MSI IRQ number is a pure software detail that was already non-stable 
due to device detection ordering, etc. It's counted back from NR_IRQS, 
and the sizing of NR_IRQS changed (upwards) in 2.6.28 - that's what you 
see.

The fact that MSI numbers goes back from NR_IRQs i consider a (minor) 
misbehavior: it should not count down but should count up - and it should 
not go to unreasonably high numbers if possible - that is confusing to 
users when the sizing of NR_IRQS changes to to a higher NR_CPUS for 
example.

A better (because more human-compatible) numbering scheme is to start 
counting upwards from the high end of physical interrupt lines. We've 
done that in the for-.29 sparseirq tree - there we'll start counting from 
256 upwards in essence. (the first 256 IRQs are GSI interrupts)

Maybe it should be counted starting at 1000? That might be an even more 
human-friendly numbering scheme.

	Ingo
