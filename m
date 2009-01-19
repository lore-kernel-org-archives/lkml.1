Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbZASUgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbZASUgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZASUgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:36:15 -0500
Received: from smtp2.Stanford.EDU ([171.67.219.82]:55058 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZASUgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:36:13 -0500
Subject: Re: 2.6.26.6-rt11: BUGs (sleeping function called from invalid
	context)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: nando@ccrma.Stanford.EDU, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.1.10.0901161935130.9232@gandalf.stny.rr.com>
References: <1226083858.20569.14.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0811071400570.3711@gandalf.stny.rr.com>
	 <1232136975.6326.32.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0901161548290.8586@gandalf.stny.rr.com>
	 <1232147180.3081.4.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0901161935130.9232@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 12:36:04 -0800
Message-Id: <1232397364.17106.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 19:37 -0500, Steven Rostedt wrote:
> On Fri, 16 Jan 2009, Fernando Lopez-Lezcano wrote:
> 
> > On Fri, 2009-01-16 at 15:49 -0500, Steven Rostedt wrote:
> > > On Fri, 16 Jan 2009, Fernando Lopez-Lezcano wrote:
> > > 
> > > > On Fri, 2008-11-07 at 14:01 -0500, Steven Rostedt wrote:
> > > > > Peter, I think we've seen this before. It is the highmem code sleeping.
> > > > > 
> > > > > On Fri, 7 Nov 2008, Fernando Lopez-Lezcano wrote:
> > > > > 
> > > > > > Three BUGs while booting 2.6.26.7 + rt11 (same hardware: no problems
> > > > > > with 2.6.24.7-rt21):
> > > > > > 
> > > > > > Nov  7 10:31:19 host kernel: BUG: sleeping function called from invalid
> > > > > > context IRQ-22(540) at arch/x86/mm/highmem_32.c:8
> > > > > > Nov  7 10:31:19 host kernel: in_atomic():0 [00000000], irqs_disabled():1
> > > > > > Nov  7 10:31:19 host kernel: Pid: 540, comm: IRQ-22 Not tainted
> > > > > > 2.6.26.7-1.rt11.1fc9.ccrma.i686.rt #1
> > > > > > Nov  7 10:31:19 host kernel: [<c041ff88>] __might_sleep+0xe8/0xed
> > > > > > Nov  7 10:31:19 host kernel: [<c041cd55>] kmap+0x42/0x55
> > > > > 
> > > > > As here.
> > > > 
> > > > Still happening in 2.6.26.8-rt13...
> > > 
> > > Could you try this patch and see if it fixes your issue.
> > 
> > That particular BUG seems to be gone, so far with no side effects (no
> > hard disk explosions or anything like that, hopefully). Thanks!!!
> 
> Great to hear!

Hmmm, it is not happening on my laptop but on different hardware I see
this:

Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
BUG: sleeping function called from invalid context IRQ-14(959) at
arch/x86/mm/highmem_32.c:8
in_atomic():0 [00000000], irqs_disabled():1
Pid: 959, comm: IRQ-14 Not tainted 2.6.26.8-1.rt13.2.fc9.ccrma.i686.rt
#1
 [<c041ff73>] __might_sleep+0xe8/0xed
 [<c041cd55>] kmap+0x42/0x55
 [<c0504830>] sg_copy_buffer+0xa6/0x16c
 [<c0504903>] sg_copy_to_buffer+0xd/0xf
 [<f88cd46f>] atapi_qc_complete+0x25c/0x2b6 [libata]
 [<f88c75e5>] __ata_qc_complete+0x8e/0x93 [libata]
 [<f88c8241>] ata_qc_complete+0x197/0x19d [libata]
 [<f88d3a01>] ata_hsm_qc_complete+0x9b/0xb3 [libata]
 [<f88d401b>] ata_sff_hsm_move+0x602/0x64e [libata]
 [<c04248d4>] ? hrtick_set+0x80/0xe5
 [<c0643921>] ? __rt_spin_lock+0x24/0x61
 [<f88d42c6>] ata_sff_interrupt+0x153/0x1eb [libata]
 [<c0460fbc>] handle_IRQ_event+0x49/0xe6
 [<c046141b>] do_irqd+0x12b/0x229
 [<c04612f0>] ? do_irqd+0x0/0x229
 [<c043b073>] kthread+0x3b/0x61
 [<c043b038>] ? kthread+0x0/0x61
 [<c040581f>] kernel_thread_helper+0x7/0x10
 =======================
ata6: SATA link down (SStatus 0 SControl 310)
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [APC3] -> GSI 18 (level,
low) -> IRQ 18
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]
MMIO=[f5118000-f51187ff]  Max Packet=[4096]  IR/IT contexts=[
4/8]

-- Fernando


