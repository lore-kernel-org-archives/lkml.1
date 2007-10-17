Return-Path: <linux-kernel-owner+w=401wt.eu-S936344AbXJQRz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936344AbXJQRz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763751AbXJQRzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:55:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:7422 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762691AbXJQRzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:55:17 -0400
Date: Wed, 17 Oct 2007 19:55:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017175512.GO15552@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017175337.GN15552@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Jens Axboe wrote:
> On Wed, Oct 17 2007, Ingo Molnar wrote:
> > 
> > ok, here's a different but similar crash that triggers on the testbox:
> > 
> > [  233.438890] BUG: unable to handle kernel paging request at virtual address 7d93e000
> > [  233.446390] printing eip: 784e9480 *pde = 01000067 *pte = 0593e000 
> > [  233.452630] Oops: 0000 [#1] DEBUG_PAGEALLOC
> > [  233.456790] 
> > [  233.458264] Pid: 0, comm: swapper Not tainted (2.6.23 #5)
> > [  233.463637] EIP: 0060:[<784e9480>] EFLAGS: 00010087 CPU: 0
> > [  233.469101] EIP is at ata_qc_issue+0x90/0x380
> > [  233.473429] EAX: 7d93dff0 EBX: 0000001f ECX: 7d93dff0 EDX: 798daf80
> > [  233.479668] ESI: 00000020 EDI: 7d93de00 EBP: 7b54007c ESP: 78a13e14
> > [  233.485908]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> > [  233.491282] Process swapper (pid: 0, ti=78a12000 task=789753e0 task.ti=78a12000)
> > [  233.498473] Stack: 7d93de00 7b540000 7b540000 00000000 7d93dfe0 7b54007c 7d93db00 7b5417a4 
> > [  233.506793]        784c2490 784ef69e 784f21f3 7b52de98 7d93db00 7b540000 7b5417a4 7d93db00 
> > [  233.515112]        7b540000 7b524004 784f22e0 784ef380 784c2490 7d93db00 00000202 7b524004 
> > [  233.523432] Call Trace:
> > [  233.526033]  [<784c2490>] scsi_done+0x0/0x20
> > [  233.530279]  [<784ef69e>] ata_scsi_translate+0xbe/0x140
> > [  233.535478]  [<784f21f3>] ata_scsi_queuecmd+0x33/0x200
> > [  233.540591]  [<784f22e0>] ata_scsi_queuecmd+0x120/0x200
> > [  233.545791]  [<784ef380>] ata_scsi_rw_xlat+0x0/0x220
> > [  233.550730]  [<784c2490>] scsi_done+0x0/0x20
> > [  233.554976]  [<784c2d12>] scsi_dispatch_cmd+0x152/0x290
> > [  233.560177]  [<78135c67>] trace_hardirqs_on+0x67/0xb0
> > [  233.565202]  [<784c8c7e>] scsi_request_fn+0x1be/0x370
> > [  233.570229]  [<78408086>] blk_run_queue+0x36/0x80
> > [  233.574909]  [<784c7520>] scsi_next_command+0x30/0x50
> > [  233.579935]  [<784c76ab>] scsi_end_request+0xab/0xe0
> > [  233.584875]  [<784c83f9>] scsi_io_completion+0xa9/0x3d0
> > [  233.590075]  [<78135c67>] trace_hardirqs_on+0x67/0xb0
> > [  233.595100]  [<78405125>] blk_done_softirq+0x45/0x80
> > [  233.600040]  [<78405153>] blk_done_softirq+0x73/0x80
> > [  233.604981]  [<7811d4c3>] __do_softirq+0x53/0xb0
> > [  233.609573]  [<7811d588>] do_softirq+0x68/0x70
> > [  233.613993]  [<78105351>] do_IRQ+0x51/0x90
> > [  233.618066]  [<78135c9c>] trace_hardirqs_on+0x9c/0xb0
> > [  233.623092]  [<7810f2d0>] pgd_dtor+0x0/0x50
> > [  233.627252]  [<7810388e>] common_interrupt+0x2e/0x40
> > [  233.632192]  [<7810f2d0>] pgd_dtor+0x0/0x50
> > [  233.636352]  [<7815f3be>] quicklist_trim+0x5e/0x90
> > [  233.641118]  [<7810f2cb>] check_pgt_cache+0x1b/0x20
> > [  233.645971]  [<78100c52>] cpu_idle+0x32/0x60
> > [  233.650217]  [<78a14b35>] start_kernel+0x265/0x300
> > [  233.654983]  [<78a14380>] unknown_bootoption+0x0/0x1e0
> > [  233.660097]  =======================
> > [  233.663649] Code: 00 00 00 8b 45 34 a8 02 0f 84 ed 00 00 00 8b bd 88 00 00 00 31 db 89 3c 24 8b 75 3c 89 f8 c7 44 24 10 00 00 00 00 eb 1b 8d 76 00 <8b> 50 10 8d 48 10 f6 c2 01 0f 85 be 02 00 00 89 44 24 10 83 c3 
> > [  233.682455] EIP: [<784e9480>] ata_qc_issue+0x90/0x380 SS:ESP 0068:78a13e14
> > [  233.689302] Kernel panic - not syncing: Fatal exception in interrupt
> > 
> > (gdb) list *0x784e9480
> > 0x784e9480 is in ata_qc_issue (include/linux/scatterlist.h:48).
> > 43       */
> > 44      static inline struct scatterlist *sg_next(struct scatterlist *sg)
> > 45      {
> > 46              sg++;
> > 47
> > 48              if (unlikely(sg_is_chain(sg)))
> > 49                      sg = sg_chain_ptr(sg);
> > 50
> > 51              return sg;
> > 52      }
> > (gdb)
> > 
> > so there's sg_next() involvement too. Below is the disassembly.
> 
> You must have a magic test box :-)
> 
> Will investigate... libata doesn't actually enable chaining, but since
> i386 supports it, it ends up using the chain helpers anyway.
> 
> There seems to be some automatic inlining involved here, it must be
> dying inside ata_sg_setup().

Also, can you send a dmesg from that system so I can see which libata
drivers are involved?

-- 
Jens Axboe

