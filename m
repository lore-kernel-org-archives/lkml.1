Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYKGSw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYKGSw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYKGSwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:52:20 -0500
Received: from smtp4.Stanford.EDU ([171.67.219.84]:50778 "EHLO
	smtp4.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYKGSwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:52:20 -0500
Subject: 2.6.26.6-rt11: BUGs (sleeping function called from invalid context)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 10:50:58 -0800
Message-Id: <1226083858.20569.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three BUGs while booting 2.6.26.7 + rt11 (same hardware: no problems
with 2.6.24.7-rt21):

Nov  7 10:31:19 host kernel: BUG: sleeping function called from invalid
context IRQ-22(540) at arch/x86/mm/highmem_32.c:8
Nov  7 10:31:19 host kernel: in_atomic():0 [00000000], irqs_disabled():1
Nov  7 10:31:19 host kernel: Pid: 540, comm: IRQ-22 Not tainted
2.6.26.7-1.rt11.1fc9.ccrma.i686.rt #1
Nov  7 10:31:19 host kernel: [<c041ff88>] __might_sleep+0xe8/0xed
Nov  7 10:31:19 host kernel: [<c041cd55>] kmap+0x42/0x55
Nov  7 10:31:19 host kernel: [<f88e9e1d>] ata_sff_hsm_move+0x3d3/0x66b
[libata]
Nov  7 10:31:19 host kernel: [<f88ea314>] ata_sff_interrupt+0x153/0x1eb
[libata]
Nov  7 10:31:19 host kernel: [<c0461730>] handle_IRQ_event+0x49/0xcd
Nov  7 10:31:19 host kernel: [<c0461a15>] thread_simple_irq+0x45/0x7c
Nov  7 10:31:19 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
Nov  7 10:31:19 host kernel: [<c0461afb>] do_irqd+0xaf/0x229
Nov  7 10:31:19 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
Nov  7 10:31:19 host kernel: [<c043b15f>] kthread+0x3b/0x61
Nov  7 10:31:19 host kernel: [<c043b124>] ? kthread+0x0/0x61
Nov  7 10:31:19 host kernel: [<c040581f>] kernel_thread_helper+0x7/0x10
Nov  7 10:31:19 host kernel: =======================


Nov  7 10:31:01 host kernel: BUG: sleeping function called from invalid
context IRQ-22(540) at arch/x86/mm/highmem_32.c:8
Nov  7 10:31:01 host kernel: in_atomic():0 [00000000], irqs_disabled():1
Nov  7 10:31:01 host kernel: Pid: 540, comm: IRQ-22 Not tainted
2.6.26.7-1.rt11.1fc9.ccrma.i686.rt #1
Nov  7 10:31:01 host kernel: [<c041ff88>] __might_sleep+0xe8/0xed
Nov  7 10:31:01 host kernel: [<c041cd55>] kmap+0x42/0x55
Nov  7 10:31:01 host kernel: [<f88e9e1d>] ata_sff_hsm_move+0x3d3/0x66b
[libata]
Nov  7 10:31:01 host kernel: [<f88ea314>] ata_sff_interrupt+0x153/0x1eb
[libata]
Nov  7 10:31:01 host kernel: [<c0461730>] handle_IRQ_event+0x49/0xcd
Nov  7 10:31:01 host kernel: [<c0461a15>] thread_simple_irq+0x45/0x7c
Nov  7 10:31:01 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
Nov  7 10:31:01 host kernel: [<c0461afb>] do_irqd+0xaf/0x229
Nov  7 10:31:01 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
Nov  7 10:31:01 host kernel: [<c043b15f>] kthread+0x3b/0x61
Nov  7 10:31:01 host kernel: [<c043b124>] ? kthread+0x0/0x61
Nov  7 10:31:01 host kernel: [<c040581f>] kernel_thread_helper+0x7/0x10
Nov  7 10:31:01 host kernel: =======================


Nov  7 10:30:58 host kernel: BUG: sleeping function called from invalid
context IRQ-22(540) at arch/x86/mm/highmem_32.c:8
Nov  7 10:30:58 host kernel: in_atomic():0 [00000000], irqs_disabled():1
Nov  7 10:30:58 host kernel: Pid: 540, comm: IRQ-22 Not tainted
2.6.26.7-1.rt11.1fc9.ccrma.i686.rt #1
Nov  7 10:30:58 host kernel: [<c041ff88>] __might_sleep+0xe8/0xed
Nov  7 10:30:58 host kernel: [<c041cd55>] kmap+0x42/0x55
Nov  7 10:30:58 host kernel: [<f88e9e1d>] ata_sff_hsm_move+0x3d3/0x66b
[libata]
Nov  7 10:30:58 host kernel: [<f88ea314>] ata_sff_interrupt+0x153/0x1eb
[libata]
Nov  7 10:30:58 host kernel: [<c0461730>] handle_IRQ_event+0x49/0xcd
Nov  7 10:30:58 host kernel: [<c0461a15>] thread_simple_irq+0x45/0x7c
Nov  7 10:30:58 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
Nov  7 10:30:58 host kernel: [<c0461afb>] do_irqd+0xaf/0x229
Nov  7 10:30:58 host kernel: [<c0461a4c>] ? do_irqd+0x0/0x229
Nov  7 10:30:58 host kernel: [<c043b15f>] kthread+0x3b/0x61
Nov  7 10:30:58 host kernel: [<c043b124>] ? kthread+0x0/0x61
Nov  7 10:30:58 host kernel: [<c040581f>] kernel_thread_helper+0x7/0x10
Nov  7 10:30:58 host kernel: =======================

-- Fernando


