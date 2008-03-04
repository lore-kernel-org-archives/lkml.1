Return-Path: <linux-kernel-owner+w=401wt.eu-S932497AbYCDSf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbYCDSf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763197AbYCDSfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:35:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764418AbYCDSfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:35:32 -0500
Date: Tue, 4 Mar 2008 10:33:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@debian.org>
Subject: Re: [BUG] 2.6.25-rc3-mm1 kernel panic while bootup on powerpc ()
Message-Id: <20080304103350.12d26560.akpm@linux-foundation.org>
In-Reply-To: <20778.1204641656@neuling.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	<47CD4AB3.3080409@linux.vnet.ibm.com>
	<20778.1204641656@neuling.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Mar 2008 15:40:56 +0100 Michael Neuling <mikey@neuling.org> wrote:

> In message <47CD4AB3.3080409@linux.vnet.ibm.com> you wrote:
> > Hi Andrew,
> > 
> > The 2.6.25-rc3-mm1 kernel panics while bootup on power box. The machine boote
> d up
> > without the panic on the third attempt, but badness call trace were seen whil
> e running
> > tests
> > 
> > 1) The kernel panic on first attempt
> > 
> > Unable to handle kernel paging request for data at address 0x00000000
> > Faulting instruction address: 0xc00000000000cb2c
> > Oops: Kernel access of bad area, sig: 11 [#1]
> > SMP NR_CPUS=128 NUMA pSeries
> > Modules linked in:
> > NIP: c00000000000cb2c LR: c00000000000caf8 CTR: 0000000000000226
> > REGS: c00000000068f360 TRAP: 0300   Not tainted  (2.6.25-rc3-mm1-autotest)
> > MSR: 8000000000001032 <ME,IR,DR>  CR: 28000024  XER: 20000001
> > DAR: 0000000000000000, DSISR: 0000000040000000
> > TASK = c0000000005c8590[0] 'swapper' THREAD: c00000000068c000 CPU: 0
> > GPR00: c00000000068f5e0 c00000000068f5e0 c00000000068e690 0000000000000000 
> > GPR04: 00000000000035e0 000000000087264e c000000008011280 c000000000594000 
> > GPR08: c0000000005c9300 0000000000000000 c000000000591090 c00000000068c000 
> > GPR12: 8000000000009032 c0000000005c9300 0000000000000000 0000000000000000 
> > GPR16: 0000000000000000 0000000000000000 0000000000008000 0000000000000000 
> > GPR20: 0000000000000000 0000000000000000 000000000000007f 0000000000018000 
> > GPR24: 0000000000000001 0000000000000080 0000000000000018 0000000000000000 
> > GPR28: 0000000000000c00 c000000000588988 c000000000639be8 c000000008001c00 
> > NIP [c00000000000cb2c] .do_IRQ+0x74/0x1c4
> > LR [c00000000000caf8] .do_IRQ+0x40/0x1c4
> > Call Trace:
> > [c00000000068f5e0] [c00000000000caf8] .do_IRQ+0x40/0x1c4 (unreliable)
> > [c00000000068f680] [c000000000004790] hardware_interrupt_entry+0x18/0x1c
> > --- Exception: 501 at .memset+0x70/0xfc
> >     LR = .__alloc_bootmem_core+0x39c/0x3dc
> > [c00000000068f970] [c00000000068fa10] init_thread_union+0x3a10/0x4000 (unreli
> able)
> > [c00000000068fa30] [c00000000057237c] .__alloc_bootmem_node+0x38/0x8c
> > [c00000000068fad0] [c0000000003c477c] .zone_wait_table_init+0x74/0x108
> > [c00000000068fb60] [c0000000003d9058] .init_currently_empty_zone+0x40/0x11c
> > [c00000000068fc00] [c0000000003d94c8] .free_area_init_node+0x394/0x3fc
> > [c00000000068fcf0] [c00000000057314c] .free_area_init_nodes+0x2d8/0x364
> > [c00000000068fd90] [c00000000056682c] .paging_init+0x40/0x58
> > [c00000000068fe40] [c00000000055ba34] .setup_arch+0x20c/0x240
> > [c00000000068fee0] [c000000000552690] .start_kernel+0xdc/0x414
> > [c00000000068ff90] [c000000000008594] .start_here_common+0x54/0xc0
> > Instruction dump:
> > 7c200b78 780404a0 2ba408ff 41bd001c e87e80a8 3884ff00 48058d21 60000000 
> > 480054cd 60000000 e93e80b0 e92900b8 <e8090000> f8410028 e9690010 e8490008 
> 
> I'm not getting a crash but I am getting this:
> 
>    start_kernel(): bug: interrupts were enabled *very* early, fixing it
> 
> ...and you're getting a null pointer access here (in do_IRQ):
> 
> 	irq = ppc_md.get_irq();
> 
> Are we somehow enabling interrupts before we've setup ppc_md.get_irq?
> 

Yes, we are - it's the semaphore rewrite which is doing this in
start_kernel().  It's being discussed.

Enabling interrupts too early on powerpc was discovered to be fatal on
powerpc years ago.  It looks like that remains the case.

