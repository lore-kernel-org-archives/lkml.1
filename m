Return-Path: <linux-kernel-owner+w=401wt.eu-S1423302AbXBHUOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423302AbXBHUOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423304AbXBHUOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:14:23 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:40060 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423302AbXBHUOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:14:22 -0500
To: jdike@addtoit.com
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
In-reply-to: <20070208195711.GA6607@ccure.user-mode-linux.org> (message from
	Jeff Dike on Thu, 8 Feb 2007 14:57:11 -0500)
Subject: Re: [uml-devel] UML hang with 100% CPU
References: <E1HFEIB-0000nJ-00@dorka.pomaz.szeredi.hu> <20070208195711.GA6607@ccure.user-mode-linux.org>
Message-Id: <E1HFFeC-0000wJ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 Feb 2007 21:13:36 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> No, it doesn't.  This is a strace on the host, I take it?

Yes.

> Can you get backtraces from the processes?

Here's one:

#0  0xffffe410 in __kernel_vsyscall ()
#1  0xb7f0fbc3 in write () from /lib/tls/i686/cmov/libc.so.6
#2  0x08066f52 in file_io (fd=10, buf=0x8a0fc8b, len=1,
    io_proc=0x8056a68 <write@plt>,
    copy_user_proc=0x8059826 <copy_to_user_proc>)
    at arch/um/os-Linux/file.c:337
#3  0x08067002 in os_write_file (fd=10, buf=0x8a0fc8b, len=1)
    at arch/um/os-Linux/file.c:359
#4  0x08069317 in update_thread () at arch/um/os-Linux/sigio.c:127
#5  0x080694eb in add_sigio_fd (fd=8) at arch/um/os-Linux/sigio.c:183
#6  0x080581b2 in reactivate_fd (fd=8, irqnum=11) at arch/um/kernel/irq.c:290
#7  0x08059f5f in sigio_interrupt (irq=11, data=0x0)
    at arch/um/kernel/sigio.c:25
#8  0x08094759 in handle_IRQ_event (irq=11, action=0x8798380)
    at kernel/irq/handle.c:141
#9  0x080947fb in __do_IRQ (irq=11) at kernel/irq/handle.c:233
#10 0x0805829c in do_IRQ (irq=11, regs=0x879c3b0) at arch/um/kernel/irq.c:361
#11 0x08057e58 in sigio_handler (sig=29, regs=0x879c3b0)
    at arch/um/kernel/irq.c:105
#12 0x0806d31e in sig_handler_common_skas (sig=29, sc_ptr=0x0)
    at arch/um/os-Linux/skas/trap.c:52
#13 0x08069c8a in unblock_signals () at arch/um/os-Linux/signal.c:217
#14 0x0810500c in __make_request (q=0x8799a94, bio=0x895f8c0)
---Type <return> to continue, or q <return> to quit---
    at block/ll_rw_blk.c:3016
#15 0x08105433 in generic_make_request (bio=0x895f8c0)
    at block/ll_rw_blk.c:3212
#16 0x08105509 in submit_bio (rw=1, bio=0x895f8c0) at block/ll_rw_blk.c:3251
#17 0x080d09cb in submit_bh (rw=1, bh=0x9d5a8c0) at fs/buffer.c:2681
#18 0x080f8fcd in journal_do_submit_data (wbuf=0x8759000, bufs=3)
    at fs/jbd/commit.c:170
#19 0x080f90e0 in journal_submit_data_buffers (journal=0x88ff580,
    commit_transaction=0x8c07500) at fs/jbd/commit.c:275
#20 0x080f935c in journal_commit_transaction (journal=0x88ff580)
    at fs/jbd/commit.c:432
#21 0x080fba41 in kjournald (arg=0x88ff580) at fs/jbd/journal.c:151
#22 0x0808905a in kthread (_create=0x889fc4c) at kernel/kthread.c:105
#23 0x080690f1 in run_kernel_thread (fn=0x8088fb3 <kthread>, arg=0x889fc4c,
    jmp_ptr=0x879c688) at arch/um/os-Linux/process.c:289
#24 0x0805c975 in new_thread_handler () at arch/um/kernel/skas/process.c:64
#25 0x00000000 in ?? ()

And the other doesn't seem to be so interesting:

#0  0xffffe410 in __kernel_vsyscall ()
#1  0xb7f157cb in poll () from /lib/tls/i686/cmov/libc.so.6
#2  0x0806913b in write_sigio_thread (unused=0x0)
    at arch/um/os-Linux/sigio.c:61
#3  0xb7f1f51e in clone () from /lib/tls/i686/cmov/libc.so.6

Strangely enough after continuing in gdb, UML is back to normal, and I
can't make it hang any more.  It must be something timing related.

Miklos

