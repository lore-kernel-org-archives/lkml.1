Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZERPJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZERPJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZERPJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:09:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45285 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZERPJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:09:51 -0400
Date: Mon, 18 May 2009 17:09:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jack Steiner <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: tip: patches in git for irq and numa
Message-ID: <20090518150903.GA5678@elte.hu>
References: <20090511163158.c4e4d334.akpm@linux-foundation.org> <20090512090704.GC18004@elte.hu> <4A0A6700.3070100@kernel.org> <20090513133635.GB7384@elte.hu> <4A0AFA6E.5050200@kernel.org> <20090515173521.GA29647@elte.hu> <4A0DE0ED.6090402@kernel.org> <20090518072952.GA12460@elte.hu> <1242654650.26820.429.camel@twins> <4A1178D5.5050900@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1178D5.5050900@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Peter Zijlstra wrote:
> > On Mon, 2009-05-18 at 09:29 +0200, Ingo Molnar wrote:
> >> * Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >>> irq related:
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git irq
> >>> need to on top of tip/irq/numa
> >> ok, these were nicely structured. the pci_routeirq patch had a build 
> >> bug for !CONFIG_PCI.
> >>
> >> ( I added an #ifdef for now, it might make sense to send a clean-up 
> >>   patch in the next merge window (not now) to factor out a 
> >>   pci_routeirq_enable() method that does all this cleanly. )
> >>
> >> Also, please add appropriate Cc: lines to the commit logs in the 
> >> future, beyond the LKML-Reference tgs.
> >>
> >>> for memoryless node support: 
> >>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git numa
> >>> and it is on top of tip/master
> >> small note: you could have based these on x86/mm btw. - that's where 
> >> these patches go, typically.
> >>
> >> regarding subject lines:
> >>
> >>  d03a6a4: mm: clear N_HIGH_MEMORY map before se set it again -v2
> >>  02ce039: x86: fix system without memory on node0 -v2
> >>  8c1aec8: x86: fix node_possible_map logic -v2
> >>  44a633c: x86: remove MEMORY_HOTPLUG_RESERVE related code -v2
> >>
> >> please never put '-v2' type of tags into the title of commits. In 
> >> the title of patches they can be put here:
> >>
> >>   [PATCH, v2] x86: fix system without memory on node0
> >>
> >> that saves maintainers a bit of typing work.
> >>
> >> Also, you included:
> >>
> >>  d03a6a4: mm: clear N_HIGH_MEMORY map before se set it again -v2
> >>
> >> with no Acks from MM folks yet. So i skipped that one and will 
> >> follow up about it.
> > 
> > The below seems to wreck my opteron, ata1 interrupts fail to get
> > through.
> > 
> > 
> > [    6.951257] ata1.00: qc timeout (cmd 0x27)
> > [    6.955354] ata1.00: failed to read native max address (err_mask=0x4)
> > [    6.961781] ata1.00: HPA support seems broken, skipping HPA handling
> > [    7.273044] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > [    7.285159] ata1.00: configured for UDMA/133
> > [    7.290052] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1200JS-00N 10.0 PQ: 0 ANSI: 5
> > [    7.299294] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
> > [    7.306968] sd 0:0:0:0: [sda] Write Protect is off
> > [    7.311754] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > [    7.316839] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [    7.326312]  sda:<6>ata2: SATA link down (SStatus 4 SControl 300)
> > [    7.938372] ata3: SATA link down (SStatus 4 SControl 300)
> > [    8.258372] ata4: SATA link down (SStatus 4 SControl 300)
> > [    8.264357] scsi 4:0:0:0: CD-ROM            TEAC     DV-516G          F4S7 PQ: 0 ANSI: 5
> > [   37.704234] ata1: lost interrupt (Status 0x50)
> > [   37.708695] sd 0:0:0:0: [sda] Unhandled error code
> > [   37.713479] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
> > [   37.720791] end_request: I/O error, dev sda, sector 0
> > [   37.725848] Buffer I/O error on device sda, logical block 0
> > 
> > ---
> > 
> > 
> > commit b9c61b70075c87a8612624736faf4a2de5b1ed30
> > Author: Yinghai Lu <yinghai@kernel.org>
> > Date:   Wed May 6 10:10:06 2009 -0700
> > 
> >     x86/pci: update pirq_enable_irq() to setup io apic routing
> >     
> >     So we can set io apic routing only when enabling the device irq.
> >     
> >     This is advantageous for IRQ descriptor allocation affinity: if we set up
> >     the IO-APIC entry later, we have a chance to allocate the IRQ descriptor
> >     later and know which device it is on and can set affinity accordingly.
> >     
> >     [ Impact: standardize/enhance irq-enabling sequence for mptable irqs ]
> 
> can you post whole bootlog?
> need to figure out 32bit/64bit? ACPI is disabled? MPtable is used?
> 
> also please check if pci=routeirq help to fix the problem.

The thing is ... this again is a _WAY TOO LARGE_ patch from you - 
250 lines of flux. Peter already did a bisection and if that's not 
enough to tell what the bug is, then frankly the splitup was way 
wrong.

You really need to learn how to create small gradual patches that 
are obviously correct - and if they are buggy it's obvious _why_ 
they are incorrect.

	Ingo
