Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYKGTBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYKGTBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYKGTBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:01:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYKGTBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:01:33 -0500
Date: Fri, 7 Nov 2008 14:01:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.26.6-rt11: BUGs (sleeping function called from invalid
 context)
In-Reply-To: <1226083858.20569.14.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0811071400570.3711@gandalf.stny.rr.com>
References: <1226083858.20569.14.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter, I think we've seen this before. It is the highmem code sleeping.

On Fri, 7 Nov 2008, Fernando Lopez-Lezcano wrote:

> Three BUGs while booting 2.6.26.7 + rt11 (same hardware: no problems
> with 2.6.24.7-rt21):
> 
> Nov  7 10:31:19 host kernel: BUG: sleeping function called from invalid
> context IRQ-22(540) at arch/x86/mm/highmem_32.c:8
> Nov  7 10:31:19 host kernel: in_atomic():0 [00000000], irqs_disabled():1
> Nov  7 10:31:19 host kernel: Pid: 540, comm: IRQ-22 Not tainted
> 2.6.26.7-1.rt11.1fc9.ccrma.i686.rt #1
> Nov  7 10:31:19 host kernel: [<c041ff88>] __might_sleep+0xe8/0xed
> Nov  7 10:31:19 host kernel: [<c041cd55>] kmap+0x42/0x55

As here.

-- Steve

> Nov  7 10:31:19 host kernel: [<f88e9e1d>] ata_sff_hsm_move+0x3d3/0x66b
> [libata]
> Nov  7 10:31:19 host kernel: [<f88ea314>] ata_sff_interrupt+0x153/0x1eb
> [libata]
> Nov  7 10:31:19 host kernel: [<c0461730>] handle_IRQ_event+0x49/0xcd
> Nov  7 10:31:19 host kernel: [<c0461a15>] thread_simple_irq+0x45/0x7c
> Nov  7 10:31:19 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
> Nov  7 10:31:19 host kernel: [<c0461afb>] do_irqd+0xaf/0x229
> Nov  7 10:31:19 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
> Nov  7 10:31:19 host kernel: [<c043b15f>] kthread+0x3b/0x61
> Nov  7 10:31:19 host kernel: [<c043b124>] ? kthread+0x0/0x61
> Nov  7 10:31:19 host kernel: [<c040581f>] kernel_thread_helper+0x7/0x10
> Nov  7 10:31:19 host kernel: =======================
> 
> 
> Nov  7 10:31:01 host kernel: BUG: sleeping function called from invalid
> context IRQ-22(540) at arch/x86/mm/highmem_32.c:8
> Nov  7 10:31:01 host kernel: in_atomic():0 [00000000], irqs_disabled():1
> Nov  7 10:31:01 host kernel: Pid: 540, comm: IRQ-22 Not tainted
> 2.6.26.7-1.rt11.1fc9.ccrma.i686.rt #1
> Nov  7 10:31:01 host kernel: [<c041ff88>] __might_sleep+0xe8/0xed
> Nov  7 10:31:01 host kernel: [<c041cd55>] kmap+0x42/0x55
> Nov  7 10:31:01 host kernel: [<f88e9e1d>] ata_sff_hsm_move+0x3d3/0x66b
> [libata]
> Nov  7 10:31:01 host kernel: [<f88ea314>] ata_sff_interrupt+0x153/0x1eb
> [libata]
> Nov  7 10:31:01 host kernel: [<c0461730>] handle_IRQ_event+0x49/0xcd
> Nov  7 10:31:01 host kernel: [<c0461a15>] thread_simple_irq+0x45/0x7c
> Nov  7 10:31:01 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
> Nov  7 10:31:01 host kernel: [<c0461afb>] do_irqd+0xaf/0x229
> Nov  7 10:31:01 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
> Nov  7 10:31:01 host kernel: [<c043b15f>] kthread+0x3b/0x61
> Nov  7 10:31:01 host kernel: [<c043b124>] ? kthread+0x0/0x61
> Nov  7 10:31:01 host kernel: [<c040581f>] kernel_thread_helper+0x7/0x10
> Nov  7 10:31:01 host kernel: =======================
> 
> 
> Nov  7 10:30:58 host kernel: BUG: sleeping function called from invalid
> context IRQ-22(540) at arch/x86/mm/highmem_32.c:8
> Nov  7 10:30:58 host kernel: in_atomic():0 [00000000], irqs_disabled():1
> Nov  7 10:30:58 host kernel: Pid: 540, comm: IRQ-22 Not tainted
> 2.6.26.7-1.rt11.1fc9.ccrma.i686.rt #1
> Nov  7 10:30:58 host kernel: [<c041ff88>] __might_sleep+0xe8/0xed
> Nov  7 10:30:58 host kernel: [<c041cd55>] kmap+0x42/0x55
> Nov  7 10:30:58 host kernel: [<f88e9e1d>] ata_sff_hsm_move+0x3d3/0x66b
> [libata]
> Nov  7 10:30:58 host kernel: [<f88ea314>] ata_sff_interrupt+0x153/0x1eb
> [libata]
> Nov  7 10:30:58 host kernel: [<c0461730>] handle_IRQ_event+0x49/0xcd
> Nov  7 10:30:58 host kernel: [<c0461a15>] thread_simple_irq+0x45/0x7c
> Nov  7 10:30:58 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
> Nov  7 10:30:58 host kernel: [<c0461afb>] do_irqd+0xaf/0x229
> Nov  7 10:30:58 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
> Nov  7 10:30:58 host kernel: [<c043b15f>] kthread+0x3b/0x61
> Nov  7 10:30:58 host kernel: [<c043b124>] ? kthread+0x0/0x61
> Nov  7 10:30:58 host kernel: [<c040581f>] kernel_thread_helper+0x7/0x10
> Nov  7 10:30:58 host kernel: =======================
> 
> -- Fernando
> 
> 
> 
> 
