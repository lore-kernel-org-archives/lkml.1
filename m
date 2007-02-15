Return-Path: <linux-kernel-owner+w=401wt.eu-S932820AbXBOO21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbXBOO21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932818AbXBOO21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:28:27 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:51479 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820AbXBOO20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:28:26 -0500
Date: Thu, 15 Feb 2007 09:28:23 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1 [kernel BUG at mm/swap.c:442]
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702150926560.25081@d.namei>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hit a BUG() via lvm:


Scanning logical volumes
  Reading all physical volumes.  This may take a while...
  Found volume group "VolGroup00" using metadata type lvm2
Activating logical volumes
[   75.215078] ------------[ cut here ]------------
[   75.230165] kernel BUG at mm/swap.c:442!
[   75.244589] invalid opcode: 0000 [#1]
[   75.258693] PREEMPT SMP 
[   75.271894] last sysfs file: /block/ram0/dev
[   75.286734] Modules linked in:
[   75.300193] CPU:    0
[   75.300195] EIP:    0060:[<c0150303>]    Not tainted VLI
[   75.300197] EFLAGS: 00210006   (2.6.20-mm1 #1)
[   75.341750] EIP is at __pagevec_lru_add_active+0x76/0xcc
[   75.356722] eax: 80100060   ebx: c1bf9c48   ecx: c1e345bc   edx: 00000001
[   75.373139] esi: c03dc680   edi: c1c4e780   ebp: f7ce3f34   esp: f7ce3f24
[   75.389642] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[   75.405199] Process lvm (pid: 415, ti=f7ce2000 task=c1e34070 task.ti=f7ce2000)
[   75.421908] Stack: 00000000 00000000 c1e25548 f7d58ea0 f7ce3f40 c01504fc c1e25548 f7ce3f70 
[   75.451375]        c0157b22 c0579820 f7ce5478 00000000 f7d58420 f7d58f00 00000000 00000000 
[   75.481458]        c1e25548 f7d58420 f7d58420 f7ce3fa0 c0158539 b7fa1000 b7fa2000 b7fa1000 
[   75.512233] Call Trace:
[   75.536111]  [<c01039ca>] show_trace_log_lvl+0x1a/0x2f
[   75.552228]  [<c0103a7a>] show_stack_log_lvl+0x9b/0xaa
[   75.568329]  [<c0103c6f>] show_registers+0x1e6/0x325
[   75.584336]  [<c0103ed4>] die+0x126/0x225
[   75.599300]  [<c010404c>] do_trap+0x79/0x91
[   75.614358]  [<c0104951>] do_invalid_op+0x97/0xa1
[   75.629892]  [<c02f8a4c>] error_code+0x7c/0x84
[   75.645097]  [<c01504fc>] lru_add_drain+0x41/0x8d
[   75.660599]  [<c0157b22>] unmap_region+0x2a/0x129
[   75.676116]  [<c0158539>] do_munmap+0x153/0x1b4
[   75.691497]  [<c01585bf>] sys_munmap+0x25/0x34
[   75.706737]  [<c01029c0>] syscall_call+0x7/0xb
[   75.721913]  =======================
[   75.736054] Code: 54 80 1a 00 8b 03 a8 20 74 04 0f 0b eb fe f0 0f ba 2b 05 8b 03 a8 40 74 04 0f 0b eb fe f0 0f ba 2b 06 8b 03 a9 00 00 10 00 74 04 <0f> 0b eb fe 8d 96 a0 05 00 00 8d 43 30 e8 24 eb 08 00 ba 02 00 
[   75.799343] EIP: [<c0150303>] __pagevec_lru_add_active+0x76/0xcc SS:ESP 0068:f7ce3f24
[   75.831928] note: lvm[415] exited with preempt_count 2
[   75.849402] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[   75.881617] in_atomic():1, irqs_disabled():1
[   75.898063] 2 locks held by lvm/415:
[   75.913388]  #0:  (&mm->mmap_sem){----}, at: [<c01585b2>] sys_munmap+0x18/0x34
[   75.944378]  #1:  (&zone->lru_lock){....}, at: [<c01502dc>] __pagevec_lru_add_active+0x4f/0xcc
[   75.976490] irq event stamp: 69326
[   75.990962] hardirqs last  enabled at (69325): [<c0102b09>] syscall_exit_work+0x11/0x30
[   76.022168] hardirqs last disabled at (69326): [<c02f8348>] _spin_lock_irq+0x18/0x51
[   76.054169] softirqs last  enabled at (57904): [<c011ff6f>] __do_softirq+0xfa/0x100
[   76.087195] softirqs last disabled at (57889): [<c011ffbf>] do_softirq+0x4a/0x7a
[   76.121170]  [<c01039ca>] show_trace_log_lvl+0x1a/0x2f
[   76.139835]  [<c01040a5>] show_trace+0x12/0x14
[   76.157721]  [<c0104157>] dump_stack+0x16/0x18
[   76.175743]  [<c01155f7>] __might_sleep+0xe5/0xeb
[   76.194139]  [<c012e9e6>] down_read+0x18/0x4c
[   76.212190]  [<c011d1e0>] exit_mm+0x27/0xd1
[   76.230203]  [<c011e4a8>] do_exit+0x1e1/0x6f6
[   76.247845]  [<c0103fad>] die+0x1ff/0x225
[   76.264934]  [<c010404c>] do_trap+0x79/0x91
[   76.281212]  [<c0104951>] do_invalid_op+0x97/0xa1
[   76.297820]  [<c02f8a4c>] error_code+0x7c/0x84
[   76.313929]  [<c01504fc>] lru_add_drain+0x41/0x8d
[   76.330202]  [<c0157b22>] unmap_region+0x2a/0x129
[   76.346230]  [<c0158539>] do_munmap+0x153/0x1b4
[   76.361722]  [<c01585bf>] sys_munmap+0x25/0x34
[   76.377115]  [<c01029c0>] syscall_call+0x7/0xb
[   76.392529]  =======================
[   76.406713] BUG: scheduling while atomic: lvm/0x00000002/415
[   76.422805] 2 locks held by lvm/415:
[   76.436571]  #0:  (&mm->mmap_sem){----}, at: [<c01585b2>] sys_munmap+0x18/0x34
[   76.465007]  #1:  (&zone->lru_lock){....}, at: [<c01502dc>] __pagevec_lru_add_active+0x4f/0xcc
[   76.494996]  [<c01039ca>] show_trace_log_lvl+0x1a/0x2f
[   76.510283]  [<c01040a5>] show_trace+0x12/0x14
[   76.524538]  [<c0104157>] dump_stack+0x16/0x18
[   76.538603]  [<c02f5346>] __sched_text_start+0x76/0x98c
[   76.553174]  [<c01d029f>] rwsem_down_failed_common+0x16e/0x18d
[   76.568176]  [<c02f7cef>] rwsem_down_read_failed+0x1d/0x26
[   76.582508]  [<c02f7d73>] call_rwsem_down_read_failed+0x7/0xc
[   76.597197]  [<c011d1e0>] exit_mm+0x27/0xd1
[   76.610369]  [<c011e4a8>] do_exit+0x1e1/0x6f6
[   76.623618]  [<c0103fad>] die+0x1ff/0x225
[   76.636419]  [<c010404c>] do_trap+0x79/0x91
[   76.649413]  [<c0104951>] do_invalid_op+0x97/0xa1
[   76.662859]  [<c02f8a4c>] error_code+0x7c/0x84
[   76.676016]  [<c01504fc>] lru_add_drain+0x41/0x8d
[   76.689487]  [<c0157b22>] unmap_region+0x2a/0x129
[   76.702979]  [<c0158539>] do_munmap+0x153/0x1b4
[   76.716310]  [<c01585bf>] sys_munmap+0x25/0x34
[   76.729566]  [<c01029c0>] syscall_call+0x7/0xb
[   76.742688]  =======================
